library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.float_type_pkg.all;

package ieee754_conversion_pkg is

  function get_mantissa ( number : real)
    return unsigned;

  function get_exponent ( number : real)
    return unsigned;

  function get_sign ( number : real)
    return std_logic;

  function real_to_float ( real_number : real)
    return float_ieee_754;

  function float_to_vector( float_number : float_ieee_754)
    return std_logic_vector;
  
  function vector_to_float( vector : std_logic_vector)
    return float_ieee_754;
  
  function float_to_real( float_number : float_ieee_754)
    return real;
    
end package ieee754_conversion_pkg;


package body ieee754_conversion_pkg is

  function real_to_float
  (
    real_number : real
  )
  return float_ieee_754
  is
    variable float_number : float_ieee_754;
  begin
    float_number.sign := get_sign(real_number);
    float_number.exponent := get_exponent(real_number);
    float_number.mantissa := get_mantissa(real_number); 
    return float_number;
  end real_to_float;

  function float_to_real
  (
    float_number : float_ieee_754
  )
  return real
  is
    variable real_number : real;
    variable fractional_part : real;
  begin
    fractional_part := 0.0;
    for i in 0 to mantissa_high - 1 loop
      if float_number.mantissa(mantissa_high - 1 - i) = '1' then
          fractional_part := fractional_part +  2.0**(- (i + 1));
      end if;
    end loop;
    if float_number.sign = '0' then 
        real_number := 2.0**(to_integer(float_number.exponent) - 127) * (1.0 + fractional_part);
    else 
        real_number := -2.0**(to_integer(float_number.exponent) - 127) * (1.0 + fractional_part);
    end if; 
    return real_number;
  end float_to_real;

  function get_mantissa
  (
    number : real
  )
  return unsigned
  is
    variable mantissa : real;
  begin
    mantissa := abs(number) / 2**(floor(log2(abs(number)))) * 2.0**(mantissa_high);
    return to_unsigned(integer(mantissa), mantissa_length);
  end get_mantissa;

  function get_exponent
  (
    number : real
  )
  return unsigned
  is
    variable exponent : integer;
  begin
    if number = 0.0 then
        exponent := 0;
    else
        exponent := integer(floor(log2(abs(number)))) + 127;
    end if;
    return to_unsigned(exponent,exponent_length);
  end get_exponent;

  function get_sign
  (
    number : real
  )
  return std_logic
  is
    variable result : std_logic;
  begin
    if number >= 0.0 then
      result := '0';
    else
      result := '1';
    end if;
    return result;  
  end get_sign;

  function float_to_vector
  (
    float_number : float_record
  )
  return std_logic_vector
  is
    variable vector : std_logic_vector(31 downto 0);
  begin
    vector(31) := float_number.sign;
    vector(30 downto 23) := std_logic_vector(float_number.exponent);
    vector(22 downto 0) := std_logic_vector(float_number.mantissa(22 downto 0));
    return vector;  
  end float_to_vector;

  function vector_to_float
  (
    vector : std_logic_vector
  )
  return float_record
  is
    variable float_number : float_record;
  begin
    float_number.sign := vector(31);
    float_number.exponent := unsigned(vector(30 downto 23));
    float_number.mantissa := unsigned(vector(22 downto 0)) + "100000000000000000000000";
    return float_number;  
  end vector_to_float;
        
end package body ieee754_conversion_pkg;
