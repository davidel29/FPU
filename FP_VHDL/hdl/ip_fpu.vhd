library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library fpu_lib;

entity ip_fpu is
  generic (
    ADDRESS_START  : unsigned(31 downto 0) := x"00000000";
    ADDRESS_END    : unsigned(31 downto 0) := x"00000003"
  );
  port (
    reset_n : in std_logic;
    clk     : in std_logic;
    -- bus side
    bus_to_slave_en   : in  std_logic;
    bus_to_slave_wr   : in  std_logic;
    bus_to_slave_addr : in  unsigned(31 downto 0);
    bus_to_slave_data : in  std_logic_vector(31 downto 0);
    slave_to_bus_data : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of ip_fpu is
  signal ctrl_reg     : std_logic_vector(2 downto 0);
  signal op_valid     : std_logic;
  signal number_1_reg : std_logic_vector(31 downto 0);
  signal number_2_reg : std_logic_vector(31 downto 0);
  signal result_reg   : std_logic_vector(31 downto 0);
  signal result       : std_logic_vector(31 downto 0);
begin

  fpu : entity fpu_lib.fpu(rtl)
  port map(
    reset_n => reset_n,
    clk      => clk,
    enable   => ctrl_reg(0),
    op_valid => op_valid,
    op_code  => ctrl_reg(2 downto 1),
    number_1 => number_1_reg,
    number_2 => number_2_reg,
    result   => result
  );

  process(reset_n,clk)
  begin
    if reset_n='0' then
      number_1_reg <= (others=>'0');
      number_2_reg <= (others=>'0');
      ctrl_reg     <= (others=>'0');
      slave_to_bus_data <= x"00000000";
    elsif rising_edge(clk) then
      if op_valid = '1' then
        result_reg <= result;
      end if;
      if bus_to_slave_en ='1' then
        if bus_to_slave_wr ='1' then
          if bus_to_slave_addr = 0 then
            ctrl_reg <= bus_to_slave_data(2 downto 0);
          elsif bus_to_slave_addr = 1 then
            number_1_reg <= bus_to_slave_data;
          elsif bus_to_slave_addr = 2 then
            number_2_reg <= bus_to_slave_data;
          end if;
        else
          if bus_to_slave_addr = 0 then
            slave_to_bus_data(2 downto 0) <= ctrl_reg;
          elsif bus_to_slave_addr = 1 then
            slave_to_bus_data <= number_1_reg;
          elsif bus_to_slave_addr = 2 then
            slave_to_bus_data <= number_2_reg;
          elsif bus_to_slave_addr = 3 then
            slave_to_bus_data <= result_reg;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;