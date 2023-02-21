library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_division is
  port(
    reset_n       : in std_logic;
    clk           : in std_logic;
    en_bin_div    : in std_logic;
    v1            : in  unsigned(47 downto 0);
    v2            : in  unsigned(47 downto 0);
    quotient      : out unsigned(47 downto 0);
    bin_div_valid : out std_logic
  );
end entity;

architecture rtl of binary_division is
  signal en_bin_sub    : std_logic;
  signal bin_sub_valid : std_logic;
  signal quotient_r    : unsigned(47 downto 0);
  signal dividend_in   : unsigned(47 downto 0);
  signal dividend_out  : unsigned(47 downto 0);
  signal index         : integer := 0;
  type state_t is (IDLE, WAIT_SUB, VECTOR_SHIFT, END_DIV);
  signal state_r : state_t;
begin
  
  bin_sub : entity work.binary_subtraction(rtl)
  port map(
    reset_n       => reset_n,
    clk           => clk,
    en_bin_sub    => en_bin_sub,
    v1            => dividend_in,
    v2            => v2,
    different     => dividend_out,
    bin_sub_valid => bin_sub_valid
  );

  process (reset_n,clk)
  begin
    if reset_n = '0' then
      dividend_in   <= to_unsigned(0,48);
      quotient_r    <= to_unsigned(0,48);
      en_bin_sub    <= '0';
      index         <= 0;
      bin_div_valid <= '0';
      state_r       <= IDLE;
    elsif rising_edge(clk) then
      case state_r is

        when IDLE =>
          dividend_in   <= to_unsigned(0,48);
          quotient_r    <= to_unsigned(0,48);
          bin_div_valid <= '0';
          index         <= 0;
          en_bin_sub    <= '0';
          if en_bin_div = '1' then
              state_r <= VECTOR_SHIFT;
          end if;

        when VECTOR_SHIFT =>
          if index = 47 then
            bin_div_valid <= '1';
            state_r       <= END_DIV;
            index         <= 0;
          else
              dividend_in(47 downto 1) <= dividend_in(46 downto 0);
              dividend_in(0)           <= v1(46 - index);
              quotient_r(47 downto 1)  <= quotient_r(46 downto 0);
              quotient_r(0)            <= '0';
              index                    <= index + 1;
              en_bin_sub               <= '1';
              state_r                  <= WAIT_SUB;
          end if;

        when WAIT_SUB =>
            if bin_sub_valid = '1' then
                en_bin_sub  <= '0';
                state_r <= VECTOR_SHIFT;
                if dividend_out(47) = '0' then
                    dividend_in   <= dividend_out;
                    quotient_r(0) <= '1';
                end if;
            end if;

        when END_DIV =>
            state_r       <= IDLE;
            bin_div_valid <= '0';

        when others =>
            null;
    end case;
      end if;
  end process;
  quotient <= quotient_r;
end architecture;
