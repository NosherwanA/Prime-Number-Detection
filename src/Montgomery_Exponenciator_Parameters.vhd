-- Coded from www.arithmetic-circuits.org/finite-field/vhdl_Models/chapter3_codes/

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package Montgomery_exponentiator_parameters is
  constant K: integer := 8;
  constant logK: integer := 3;
  constant M: std_logic_vector(K-1 downto 0) := X"ef"; --239d
  --minus_m = 2**k - m
  constant minus_M: std_logic_vector(K downto 0) := '0' & X"F1";
  constant one: std_logic_vector(K-1 downto 0) := conv_std_logic_vector(1, K);
  --exp_k = 2**k mod m
  constant exp_K: std_logic_vector(K-1 downto 0) := X"11"; --17d
  --exp_2k = 2**(2*k) mod m
  constant exp_2K: std_logic_vector(K-1 downto 0) := X"32"; --50d
  
end Montgomery_exponentiator_parameters;