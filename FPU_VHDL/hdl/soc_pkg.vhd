library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package soc_pkg is

  type peripherals_names is (
    IP_FPU
  );

  type peripheral_location is record
    address_start : unsigned(31 downto 0);
    address_end   : unsigned(31 downto 0);
  end record;

  type memory_map_t is array(peripherals_names) of peripheral_location;

  constant MEMORY_MAP : memory_map_t :=(
    IP_FPU => (x"00000000", x"00000003")
  );
  
end package;
