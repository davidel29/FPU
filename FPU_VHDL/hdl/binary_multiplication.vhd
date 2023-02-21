library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_multiplication is
  port(
    reset_n       : in std_logic;
    clk           : in std_logic;
    en_bin_mul    : in std_logic;
    v1            : in  unsigned(47 downto 0);
    v2            : in  unsigned(47 downto 0);
    product       : out unsigned(47 downto 0);
    bin_mul_valid : out std_logic
  );
end entity;

architecture rtl of binary_multiplication is
  signal en_bin_add    : std_logic;
  signal bin_add_valid : std_logic;
  signal product_r     : unsigned(47 downto 0);
  signal sum_in        : unsigned(47 downto 0);
  signal sum_out       : unsigned(47 downto 0);
  signal index         : integer := 0;
  type state_t is (IDLE, WAIT_SUM, VECTOR_SHIFT, END_MUL);
  signal state_r : state_t;
begin

  binary_addition : entity work.binary_addition(rtl)
  port map(
    reset_n       => reset_n,
    clk           => clk,
    en_bin_add    => en_bin_add,
    v1            => sum_in,
    v2            => product_r,
    sum           => sum_out,
    bin_add_valid => bin_add_valid
  );

  process (reset_n,clk)
  begin
    if reset_n = '0' then
      sum_in        <= to_unsigned(0,48);
      product_r     <= to_unsigned(0,48);
      en_bin_add    <= '0';
      index         <= 0;
      bin_mul_valid <= '0';
      state_r       <= IDLE;
    elsif rising_edge(clk) then
      case state_r is
          
        when IDLE =>
          sum_in        <= to_unsigned(0,48);
          product_r     <= to_unsigned(0,48);
          bin_mul_valid <= '0';
          index         <= 0;
          en_bin_add    <= '0';
          if en_bin_mul = '1' then
              state_r <= VECTOR_SHIFT;
          end if;
          
        when VECTOR_SHIFT =>
          if index = 24 then
              state_r       <= END_MUL;
              bin_mul_valid <= '1';
              index         <= 0;
          elsif v2(index) = '1' then
              product_r((index + 23) downto index) <= v1(23 downto 0);
              en_bin_add                           <= '1';
              state_r                              <= WAIT_SUM;
          end if;
          index <= index + 1;
          
          when WAIT_SUM =>
            if bin_add_valid = '1' then
                sum_in     <= sum_out;
                en_bin_add <= '0';
                state_r    <= VECTOR_SHIFT;
                product_r  <= to_unsigned(0,48);
            end if;
          
          when END_MUL =>
            state_r       <= IDLE;
            bin_mul_valid <= '0';

          when others =>
            null;
      end case;
    end if;
  end process;
  product <= sum_in;
end architecture;
