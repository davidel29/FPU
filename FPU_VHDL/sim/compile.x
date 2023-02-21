echo "cleaning"
rm -rf *.cf *.o fpu_tb.ghw fpu_tb

echo "compiling"
ghdl -a --work=fpu_lib --std=08 ../hdl/float_type_pkg.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/ieee754_conversion_pkg.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_addition.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_subtraction.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_multiplication.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_division.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/float_add_sub.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/float_multiplication.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/float_division.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/fpu.vhd

echo "OLD tb"
ghdl -a --std=08 ../hdl/fpu_tb.vhd

echo "elaborating"
ghdl -e --std=08 fpu_tb

echo "simulating"
ghdl -r --std=08 fpu_tb --wave=fpu_tb.ghw

echo "viewing"
gtkwave fpu_tb.ghw fpu_tb.sav
