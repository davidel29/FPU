echo "cleaning"
rm -rf *.cf *.o soc_tb.ghw soc_tb

echo "compiling"

ghdl -a --work=fpu_lib --std=08 ../hdl/binary_addition.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_subtraction.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_multiplication.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/binary_division.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/float_add_sub.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/float_multiplication.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/float_division.vhd
ghdl -a --work=fpu_lib --std=08 ../hdl/fpu.vhd

ghdl -a --work=ip_lib --std=08 ../hdl/fifo.vhd
ghdl -a --work=ip_lib --std=08 ../hdl/ip_fpu.vhd

echo "warning uart_cst_SIM used"
ghdl -a --work=uart_lib --std=08 ../hdl/uart_cst_SIM.vhd
ghdl -a --work=uart_lib --std=08 ../hdl/receiver.vhd
ghdl -a --work=uart_lib --std=08 ../hdl/sender.vhd
ghdl -a --work=uart_lib --std=08 ../hdl/tick_gen.vhd
ghdl -a --work=uart_lib --std=08 ../hdl/uart.vhd
ghdl -a --work=uart_lib --std=08 ../hdl/uart_api.vhd

ghdl -a --work=uart_bus_master_lib --std=08 ../hdl/uart_bus_master_fsm.vhd
ghdl -a --work=uart_bus_master_lib --std=08 ../hdl/uart_bus_master.vhd

ghdl -a --std=08 --work=soc_lib ../hdl/soc_pkg.vhd
ghdl -a --std=08 --work=soc_lib ../hdl/soc.vhd

echo "OLD tb"
ghdl -a --std=08 ../sim/soc_tb.vhd

echo "elaborating"
ghdl -e --std=08 soc_tb

echo "simulating"
ghdl -r --std=08 soc_tb --wave=soc_tb.ghw

echo "viewing"
gtkwave soc_tb.ghw soc_tb.sav
