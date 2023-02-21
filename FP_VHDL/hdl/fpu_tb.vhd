--------------------------------------------------------------------------------
-- this file was generated automatically by Vertigo Ruby utility
-- date : (d/m/y h:m) 09/02/2023 10:26
-- author : Jean-Christophe Le Lann - 2014
--------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library fpu_lib;
use fpu_lib.float_type_pkg.all;
use fpu_lib.ieee754_conversion_pkg.all;
 
entity fpu_tb is
end entity;
 
architecture bhv of fpu_tb is
  constant HALF_PERIOD : time :=5 ns;
 
  signal clk : std_logic := '0';
  signal reset_n : std_logic := '0';
 
  signal running : boolean := true;
 
  procedure wait_cycles(n : natural) is 
  begin
    for i in 0 to n-1 loop
      wait until rising_edge(clk);
    end loop;
  end procedure;
 
  procedure toggle(signal s : inout std_logic) is
  begin
    wait until rising_edge(clk);
    s <=not(s);
    wait until rising_edge(clk);
    s <=not(s);
  end procedure;
 
  signal enable   : std_logic;
  signal op_valid : std_logic;
  signal op_code  : std_logic_vector(1 downto 0);
  signal number_1 : std_logic_vector(31 downto 0);
  signal number_2 : std_logic_vector(31 downto 0);
  signal result   : std_logic_vector(31 downto 0);
  signal real_number_1        : real;
  signal real_number_2        : real;
  signal real_result_practice : real;
  signal real_result_theory   : real;

begin
  --------------------------------------------------------------------------------
  -- clock and reset
  --------------------------------------------------------------------------------
  reset_n <= '0','1' after 1 ns;
   
  clk <= not(clk) after HALF_PERIOD when running else clk;
  --------------------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------------------
  dut : entity fpu_lib.fpu(rtl)
    port map (
      reset_n  => reset_n ,
      clk      => clk     ,
      enable   => enable  ,
      op_valid => op_valid,
      op_code  => op_code ,
      number_1 => number_1,
      number_2 => number_2,
      result   => result  
    );
  --------------------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------------------
  stim : process
  begin
    report "running testbench for fpu(rtl)";
    report "waiting for asynchronous reset";
    wait until reset_n='1';
    real_number_1 <= -20.254;
    real_number_2 <= 21.1255;
    wait_cycles(1);
    number_1 <= float_to_vector(real_to_float(real_number_1));
    number_2 <= float_to_vector(real_to_float(real_number_2));
    enable <= '1';
    op_code <="00";
    wait until op_valid='1';
    real_result_practice <= float_to_real(vector_to_float(result));
    real_result_theory <= real_number_1 + real_number_2;
    wait_cycles(1);
    op_code <="01";
    wait until op_valid='1';
    real_result_practice <= float_to_real(vector_to_float(result));
    real_result_theory <= real_number_1 - real_number_2;
    wait_cycles(1);
    op_code <="10";
    wait until op_valid='1';
    real_result_practice <= float_to_real(vector_to_float(result));
    real_result_theory <= real_number_1 * real_number_2;
    wait_cycles(1);
    op_code <="11";
    wait until op_valid='1';
    real_result_practice <= float_to_real(vector_to_float(result));
    real_result_theory <= real_number_1 / real_number_2;
    wait_cycles(1);
    enable <= '0';
    report "end of simulation";
    running <= false;
    wait;
  end process;
end bhv;
