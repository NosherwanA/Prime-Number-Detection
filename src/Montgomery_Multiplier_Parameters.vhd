-- Code From: www.arithmetic-circuits.org/finite-field/vhdl_Models/chapter3_codes/

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package Montgomery_multiplier_parameters is
  
  constant K: integer := 8;
  constant logK: integer := 3;
  constant int_M: integer := 239;
  constant M: std_logic_vector(K-1 downto 0) := conv_std_logic_vector(int_m, K);
  constant minus_M: std_logic_vector(K downto 0) := conv_std_logic_vector(2**K - int_M, K+1);  
  constant ZERO: std_logic_vector(logK-1 downto 0) := (others => '0');
  constant DELAY: std_logic_vector(logK-1 downto 0) := conv_std_logic_vector(K/2, logK);
  
end Montgomery_multiplier_parameters;