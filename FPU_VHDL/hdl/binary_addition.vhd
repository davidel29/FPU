library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_addition is
  port(
    reset_n       : in std_logic;
    clk           : in std_logic;
    en_bin_add    : in std_logic;
    v1            : in  unsigned(47 downto 0);
    v2            : in  unsigned(47 downto 0);
    sum           : out unsigned(47 downto 0);
    bin_add_valid : out std_logic
  );
end entity;

architecture rtl of binary_addition is
  signal carry : std_logic := '0';
  signal sum_r : unsigned(47 downto 0);
  signal index : integer := 0;
begin
  process (reset_n,clk)
  begin
    if reset_n = '0' then
      sum_r         <= to_unsigned(0,48);
      index         <= 0;
      carry         <= '0';
      bin_add_valid <= '0';
    elsif rising_edge(clk) then
      if en_bin_add = '1' then
        if index = 47 then
          bin_add_valid <= '1';
          sum_r(47)     <= carry;
        else
          sum_r(index) <= (v1(index) xor v2(index)) xor carry;
          carry        <= (v1(index) and v2(index)) or (v1(index) and carry) or (v2(index) and carry);
          index        <= index + 1;
        end if;
      else
        bin_add_valid <= '0';
        carry         <= '0';
        index         <= 0;
        sum_r         <= to_unsigned(0,48);
      end if;
    end if;
  end process;
  sum <= sum_r;
end architecture;
