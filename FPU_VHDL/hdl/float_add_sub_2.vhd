library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity float_add_sub is
  port (
    reset_n             : in std_logic;
    clk                 : in std_logic;
    enable              : in std_logic;
    op                  : in std_logic;
    float_add_sub_valid : out std_logic;
    number_1            : in std_logic_vector(31 downto 0);
    number_2            : in std_logic_vector(31 downto 0);
    result_add_sub      : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of float_add_sub is
  signal sign_1, sign_2, sign_result : std_logic;
  signal exponent_1_r      : unsigned(7 downto 0);
  signal exponent_2_r      : unsigned(7 downto 0);
  signal mantissa_1_r      : unsigned(47 downto 0);
  signal mantissa_2_r      : unsigned(47 downto 0);
  signal mantissa_result_r : unsigned(47 downto 0);
  signal result_add_sub_r  : std_logic_vector(31 downto 0);
  type state_t is (IDLE, ALIGN_MANTISSAS, ADD_MANTISSA, SUB_MANTISSA, NORMALIZE, END_ADD_SUB);
  signal state_r : state_t;

begin

  registers : process(reset_n, clk)
  begin
    if reset_n = '0' then
      state_r <= IDLE;
      exponent_1_r      <= to_unsigned(0,8);
      exponent_2_r      <= to_unsigned(0,8);
      mantissa_1_r      <= to_unsigned(0,48);
      mantissa_2_r      <= to_unsigned(0,48);
      mantissa_result_r <= to_unsigned(0,48);
      result_add_sub_r  <= (others => '0');
    elsif rising_edge(clk) then
      case state_r is

        when IDLE =>
          if enable = '1' then
            sign_1                     <= number_1(31);
            sign_2                     <= number_2(31);
            exponent_1_r              <= unsigned(number_1(30 downto 23));
            exponent_2_r              <= unsigned(number_2(30 downto 23));
            mantissa_1_r(22 downto 0) <= unsigned(number_1(22 downto 0));
            mantissa_1_r(23)           <= '1';
            mantissa_2_r(22 downto 0)  <= unsigned(number_2(22 downto 0));
            mantissa_2_r(23)           <= '1';
            mantissa_result_r          <= to_unsigned(0,48);
            state_r                    <= ALIGN_MANTISSAS;
          end if;

        when ALIGN_MANTISSAS =>
          if exponent_1_r = exponent_2_r then
            if op = '1' then
              state_r <= SUB_MANTISSA;
            else
              state_r <= ADD_MANTISSA;
            end if;
          elsif exponent_1_r > exponent_2_r then
            exponent_2_r              <= exponent_2_r + 1;
            mantissa_2_r(22 downto 0) <= mantissa_2_r(23 downto 1);
            mantissa_2_r(23)          <= '0';
          elsif exponent_1_r < exponent_2_r then
            exponent_1_r              <= exponent_1_r + 1;
            mantissa_1_r(22 downto 0) <= mantissa_1_r(23 downto 1);
            mantissa_1_r(23)          <= '0';
          end if;

        when ADD_MANTISSA =>
          if sign_1 = sign_2 then
            mantissa_result_r <= mantissa_1_r + mantissa_2_r;
            sign_result       <= sign_1;
          elsif (sign_1 = '0') and (sign_2 = '1') then
            if mantissa_1_r > mantissa_2_r then
                mantissa_result_r <= mantissa_1_r - mantissa_2_r;
                sign_result       <= sign_1;
            else
                mantissa_result_r <= mantissa_2_r - mantissa_1_r;
                sign_result       <= sign_2;
            end if;
          elsif (sign_1 = '1') and (sign_2 = '0') then
            if mantissa_1_r < mantissa_2_r then
                mantissa_result_r <= mantissa_2_r - mantissa_1_r;
                sign_result       <= sign_2;
            else
                mantissa_result_r <= mantissa_1_r - mantissa_2_r;
                sign_result       <= sign_1;
            end if;
          end if;
          state_r <= NORMALIZE;

        when SUB_MANTISSA =>
          if sign_1 /= sign_2 then
            mantissa_result_r <= mantissa_1_r + mantissa_2_r;
            sign_result       <= sign_1;
          elsif (sign_1 = '0') and (sign_2 = '0') then
            if mantissa_1_r > mantissa_2_r then
                mantissa_result_r <= mantissa_1_r - mantissa_2_r;
                sign_result       <= sign_1;
            else
                mantissa_result_r <= mantissa_2_r - mantissa_1_r;
                sign_result       <= '1';
            end if;
          elsif (sign_1 = '1') and (sign_2 = '1') then
            if mantissa_1_r < mantissa_2_r then
                mantissa_result_r <= mantissa_2_r - mantissa_1_r;
                sign_result       <= '0';
            else
                mantissa_result_r <= mantissa_1_r - mantissa_2_r;
                sign_result       <= sign_1;
            end if;
          end if;
          state_r <= NORMALIZE;
          
        when NORMALIZE =>
          if mantissa_result_r(24) = '1' then
            mantissa_result_r(23 downto 0) <= mantissa_result_r(24 downto 1);
            exponent_1_r                   <= exponent_1_r + 1;
            state_r <= END_ADD_SUB;
          elsif mantissa_result_r(23) = '1' then
            state_r <= END_ADD_SUB;
          else
            mantissa_result_r(24 downto 1) <= mantissa_result_r(23 downto 0);
            mantissa_result_r(0)           <= '0';
            exponent_1_r                   <= exponent_1_r - 1;
          end if;
        
        when END_ADD_SUB =>
          result_add_sub_r(30 downto 23) <= std_logic_vector(exponent_1_r(7 downto 0));
          result_add_sub_r(22 downto 0)  <= std_logic_vector(mantissa_result_r(22 downto 0));
          result_add_sub_r(31)           <= sign_result;
          state_r                        <= IDLE;

        when others =>
          null;
      end case;
    end if;
  end process;

  result_add_sub <= result_add_sub_r;

  output_logic : process(state_r)
  begin
    if state_r = END_ADD_SUB then
      float_add_sub_valid <= '1';
    else
      float_add_sub_valid <= '0';
    end if;
  end process;

end architecture;
