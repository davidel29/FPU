library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity float_multiplication is
  port (
    reset_n         : in std_logic;
    clk             : in std_logic;
    enable          : in std_logic;
    float_mul_valid : out std_logic;
    number_1        : in std_logic_vector(31 downto 0);
    number_2        : in std_logic_vector(31 downto 0);
    result_mul      : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of float_multiplication is
  signal en_bin_mul        : std_logic;
  signal bin_mul_valid     : std_logic;
  signal sign_1, sign_2    : std_logic;
  signal exponent_result_r : unsigned(7 downto 0);
  signal product_r         : unsigned(47 downto 0);
  signal mantissa_1_r      : unsigned(47 downto 0);
  signal mantissa_2_r      : unsigned(47 downto 0);
  signal mantissa_result_r : unsigned(47 downto 0);
  signal result_mul_r      : std_logic_vector(31 downto 0);
  type state_t is (IDLE, WAIT_MUL_MANTISSA, NORMALIZE, TO_VECTOR, END_MUL);
  signal state_r : state_t;

begin

  binary_multiplication : entity work.binary_multiplication(rtl)
  port map(
    reset_n       => reset_n,
    clk           => clk,
    en_bin_mul    => en_bin_mul,
    v1            => mantissa_1_r,
    v2            => mantissa_2_r,
    product       => product_r,
    bin_mul_valid => bin_mul_valid
  );

  process(reset_n, clk)
  begin
    if reset_n = '0' then
      state_r           <= IDLE;
      exponent_result_r <= to_unsigned(0,8);
      mantissa_1_r      <= to_unsigned(0,48);
      mantissa_2_r      <= to_unsigned(0,48);
      mantissa_result_r <= to_unsigned(0,48);
      result_mul_r      <= (others => '0');
      en_bin_mul        <= '0';

    elsif rising_edge(clk) then

      case state_r is

        when IDLE =>
          sign_1                     <= number_1(31);
          sign_2                     <= number_2(31);
          exponent_result_r          <= unsigned(number_1(30 downto 23)) + unsigned(number_2(30 downto 23)) - 127;
          mantissa_1_r(22 downto 0 ) <= unsigned(number_1(22 downto 0));
          mantissa_1_r(23)           <= '1';
          mantissa_2_r(22 downto 0 ) <= unsigned(number_2(22 downto 0));
          mantissa_2_r(23)           <= '1';
          mantissa_result_r          <= to_unsigned(0,48);
          result_mul_r               <= (others => '0') ;
          en_bin_mul                 <= '0';
          if enable = '1' then
            state_r     <= WAIT_MUL_MANTISSA;
            en_bin_mul  <= '1';
          end if;
  
        when WAIT_MUL_MANTISSA =>
          if bin_mul_valid = '1' then
            mantissa_result_r <= product_r;
            en_bin_mul        <= '0';
            state_r           <= NORMALIZE;
          end if;

        when NORMALIZE =>
          if mantissa_result_r(47) = '1' then
            exponent_result_r <= exponent_result_r + 1;
            if mantissa_result_r(23) = '1' then
              mantissa_result_r(22 downto 0) <= mantissa_result_r(46 downto 24);
              mantissa_result_r(0) <= '1';
            else
              mantissa_result_r(22 downto 0) <= mantissa_result_r(46 downto 24);
            end if;
          else
            if mantissa_result_r(22) = '1' then
              mantissa_result_r(22 downto 0) <= mantissa_result_r(45 downto 23);
				mantissa_result_r(0) <= '1';
            else
              mantissa_result_r(22 downto 0) <= mantissa_result_r(45 downto 23);
            end if;
          end if;
          state_r <= TO_VECTOR;
        
        when TO_VECTOR =>
          result_mul_r(30 downto 23) <= std_logic_vector(exponent_result_r(7 downto 0));
          result_mul_r(22 downto 0)  <= std_logic_vector(mantissa_result_r(22 downto 0));
          result_mul_r(31)           <= sign_1 xor sign_2;
          state_r                    <= END_MUL;

        when END_MUL =>
        state_r <= IDLE;
        
        when others =>
         null;
      end case;
    end if;
  end process;

  result_mul <= result_mul_r;

  output_logic : process(state_r)
  begin
    if state_r = END_MUL then
      float_mul_valid <= '1';
    else
      float_mul_valid <= '0';
    end if;
  end process;

end architecture;
