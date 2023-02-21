library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_subtraction is
  port(
    reset_n       : in std_logic;
    clk           : in std_logic;
    en_bin_sub    : in std_logic;
    v1            : in  unsigned(47 downto 0);
    v2            : in  unsigned(47 downto 0);
    different     : out unsigned(47 downto 0);
    bin_sub_valid : out std_logic
  );
end entity;

architecture rtl of binary_subtraction is
  signal carry       : std_logic := '0';
  signal different_r : unsigned(47 downto 0);
  signal index       : integer := 0;
begin
  process (reset_n,clk)
  begin
    if reset_n = '0' then
      different_r   <= to_unsigned(0,48);
      index         <= 0;
      carry         <= '0';
      bin_sub_valid <= '0';
    elsif rising_edge(clk) then
      if en_bin_sub = '1' then
        if index = 48 then   
            bin_sub_valid <= '1';
        else
            different_r(index) <= ((v1(index) xor v2(index)) xor carry) or (v1(index) and v2(index) and carry);
            carry              <= (v2(index) and carry) or (not v1(index) and (carry xor v2(index)));
            index              <= index + 1;
        end if;
      else
        bin_sub_valid <= '0';
        carry         <= '0';
        index         <= 0;
        different_r   <= to_unsigned(0,48);
      end if;
    end if;
  end process;
  different <= different_r;
end architecture;