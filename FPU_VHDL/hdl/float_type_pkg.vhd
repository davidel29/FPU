library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package float_type_pkg is

  constant mantissa_length : integer := 24;
  constant exponent_length : integer := 8;
  constant mantissa_high : integer := mantissa_length - 1;
  constant exponent_high : integer := exponent_length - 1;
  subtype t_mantissa is unsigned(mantissa_high downto 0);
  subtype t_exponent is unsigned(exponent_high downto 0);

  type float_ieee_754 is record
    sign     : std_logic;
    exponent : t_exponent;
    mantissa : t_mantissa;
  end record;

end package float_type_pkg;
