library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpu is
  port (
    reset_n  : in std_logic;
    clk      : in std_logic;
    enable   : in std_logic;
    op_valid : out std_logic;
    op_code  : in std_logic_vector(1 downto 0);
    number_1 : in std_logic_vector(31 downto 0);
    number_2 : in std_logic_vector(31 downto 0);
    result   : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of fpu is
  signal float_mul_valid     : std_logic;
  signal float_div_valid     : std_logic;
  signal float_add_sub_valid : std_logic;
  signal result_add_sub      : std_logic_vector(31 downto 0);
  signal result_mul          : std_logic_vector(31 downto 0);
  signal result_div          : std_logic_vector(31 downto 0);
  signal result_r            : std_logic_vector(31 downto 0);
  type state_t is (IDLE, WAIT_ADD_SUB, WAIT_MUL, WAIT_DIV, END_OP);
  signal state_r : state_t;

begin

  float_add_sub : entity work.float_add_sub(rtl)
  port map(
    reset_n             => reset_n,
    clk                 => clk, 
    enable              => enable,
    op                  => op_code(0),
    float_add_sub_valid => float_add_sub_valid,
    number_1            => number_1,
    number_2            => number_2,
    result_add_sub      => result_add_sub
  );

  float_mul : entity work.float_multiplication(rtl)
  port map(
    reset_n         => reset_n,
    clk             => clk, 
    enable          => enable,
    float_mul_valid => float_mul_valid,
    number_1        => number_1,
    number_2        => number_2,
    result_mul      => result_mul
  );

  float_div : entity work.float_division(rtl)
  port map(
    reset_n         => reset_n,
    clk             => clk, 
    enable          => enable,
    float_div_valid => float_div_valid,
    number_1        => number_1,
    number_2        => number_2,
    result_div      => result_div
  );

  process(reset_n, clk)
  begin
    if reset_n = '0' then
      state_r <= IDLE;
    elsif rising_edge(clk) then
      case state_r is

        when IDLE =>
          if enable = '1' then
            case op_code is
              when "00" =>
                state_r <= WAIT_ADD_SUB;
              when "01" =>
                state_r <= WAIT_ADD_SUB;
              when "10" =>
                state_r <= WAIT_MUL;
              when "11" =>
              state_r <= WAIT_DIV;
              when others =>
                null; 
            end case;
          end if;
        
        when WAIT_ADD_SUB =>
          if float_add_sub_valid = '1' then 
            state_r  <= END_OP;
            result_r <= result_add_sub;
          end if;

        when WAIT_MUL =>
          if float_mul_valid = '1' then
            state_r  <= END_OP;
            result_r <= result_mul;
          end if;

        when WAIT_DIV =>
          if float_div_valid = '1' then 
            state_r  <= END_OP;
            result_r <= result_div;
          end if;

        when END_OP =>
          state_r <= IDLE;

        when others =>
         null;     
      end case;
    end if;
  end process;

  result <= result_r;

  output_logic : process(state_r)
  begin
    if state_r = END_OP then
      op_valid <= '1';
    else
      op_valid <= '0';
    end if;
  end process;

end architecture;