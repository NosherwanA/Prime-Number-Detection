----------------------------------------------------------------------------
-- Montgomery Exponenciator (Montgomery_esponenciator_msb.vhd)
--
-- Calculate x**y mod M
-- Most Significant Bit first

-- Code From: www.arithmetic-circuits.org/finite-field/vhdl_Models/chapter3_codes/
----------------------------------------------------------------------------



library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.Montgomery_exponentiator_parameters.all;

entity Montgomery_exponentiator_msb is
port (
  x, y: in std_logic_vector(K-1 downto 0);
  clk, reset, start: in std_logic;
  z: out std_logic_vector(K-1 downto 0);
  done: out std_logic
);
end Montgomery_exponentiator_msb;

architecture rtl of Montgomery_exponentiator_msb is

  signal operand1, operand2, result, e, ty, int_x: std_logic_vector(k-1 downto 0);
  signal start_mp, mp_done, ce_e, ce_ty, load, update, xkminusi, equal_zero: std_logic;
  signal control: std_logic_vector(1 downto 0);

  type states is range 0 to 16;
  signal current_state: states;
  signal count: std_logic_vector(logK-1 downto 0);

  component Montgomery_multiplier_modif is
  port (
    x, y: in std_logic_vector(K-1 downto 0);
    clk, reset, start: in std_logic;
    z: out std_logic_vector(K-1 downto 0);
    done: out std_logic
  );
  end component;

begin

  with control select operand1 <= y when "00", e when others;
  with control select operand2 <= exp_2k when "00", e when "01", ty when "10", one when others;

  main_component: Montgomery_multiplier_modif port map(operand1, operand2, clk, reset, start_mp, result, mp_done);

  z <= result;

  register_e: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' then 
      e <= exp_k; 
    elsif ce_e = '1' then 
      e <= result; 
    end if;
  end if;
  end process register_e;

  register_ty: process(clk)
  begin
  if clk'event and clk = '1' then
    if ce_ty = '1' then 
      ty <= result; 
    end if;
  end if;
  end process register_ty;


  shift_register: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' 
      then int_x <= x;
    elsif update = '1' then
      int_x <= int_x(K-2 downto 0)&'0';
    end if;
  end if;
  end process shift_register;

  xkminusi <= int_x(K-1);

  counter: process(clk)
  begin
  if clk'event and clk = '1' then
    if load = '1' then 
      count <= conv_std_logic_vector(k, logk);
    elsif update= '1' then 
      count <= count - 1;
    end if;
  end if;
  end process;
  equal_zero <= '1' when count = 0 else '0';

  control_unit: process(clk, reset, current_state)
  begin
  case current_state is
    when 0 to 1 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "00"; done <= '1';
    when 2 => ce_e <= '0'; ce_ty <= '0'; load <= '1'; update <= '0'; start_mp <= '0'; control <= "00"; done <= '0';
    when 3 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '1'; control <= "00"; done <= '0';
    when 4 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "00"; done <= '0';
    when 5 => ce_e <= '0'; ce_ty <= '1'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "00"; done <= '0';
    when 6 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '1'; control <= "01"; done <= '0';
    when 7 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "01"; done <= '0';
    when 8 => ce_e <= '1'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "01"; done <= '0';
    when 9 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '1'; control <= "10"; done <= '0';
    when 10 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "10"; done <= '0';
    when 11 => ce_e <= '1'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "10"; done <= '0';
    when 12 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '1'; start_mp <= '0'; control <= "00"; done <= '0';
    when 13 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "00"; done <= '0';
    when 14 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '1'; control <= "11"; done <= '0';
    when 15 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "11"; done <= '0';
    when 16 => ce_e <= '0'; ce_ty <= '0'; load <= '0'; update <= '0'; start_mp <= '0'; control <= "11"; done <= '0';
  end case;

  if reset = '1' then 
    current_state <= 0;
  elsif clk'event and clk = '1' then
    case current_state is
      when 0 => if start = '0' then current_state <= 1; end if;
      when 1 => if start = '1' then current_state <= 2; end if;
      when 2 => current_state <= 3;
      when 3 => current_state <= 4;
      when 4 => if mp_done= '1' then current_state <= 5; end if;
      when 5 => current_state <= 6;
      when 6 => current_state <= 7;
      when 7 => if mp_done= '1' then current_state <= 8; end if;
      when 8 => if xkminusi = '1' then current_state <= 9; else current_state <= 12; end if;
      when 9 => current_state <= 10;
      when 10 => if mp_done= '1' then current_state <= 11; end if;
      when 11 => current_state <= 12;
      when 12 => current_state <= 13;
      when 13 => if equal_zero = '1' then current_state <= 14; else current_state <= 6; end if;
      when 14 => current_state <= 15;
      when 15 => if mp_done= '1' then current_state <= 16; end if;
      when 16 => current_state <= 0;
    end case;
  end if;
  end process;

end rtl;
