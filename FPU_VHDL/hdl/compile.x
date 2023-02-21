echo "cleaning"
rm -rf *.cf *.o soc_tb.ghw soc_tb

echo "compiling"

ghdl -a --work=fpu_lib --std=08 binary_addition.vhd
ghdl -a --work=fpu_lib --std=08 binary_subtraction.vhd
ghdl -a --work=fpu_lib --std=08 binary_multiplication.vhd
ghdl -a --work=fpu_lib --std=08 binary_division.vhd
ghdl -a --work=fpu_lib --std=08 float_add_sub.vhd
ghdl -a --work=fpu_lib --std=08 float_multiplication.vhd
ghdl -a --work=fpu_lib --std=08 float_division.vhd
ghdl -a --work=fpu_lib --std=08 fpu.vhd

ghdl -a --work=ip_lib --std=08 fifo.vhd
ghdl -a --work=ip_lib --std=08 ip_fpu.vhd

echo "warning uart_cst_SIM used"
ghdl -a --work=uart_lib --std=08 uart_cst_SIM.vhd
ghdl -a --work=uart_lib --std=08 receiver.vhd
ghdl -a --work=uart_lib --std=08 sender.vhd
ghdl -a --work=uart_lib --std=08 tick_gen.vhd
ghdl -a --work=uart_lib --std=08 uart.vhd
ghdl -a --work=uart_lib --std=08 uart_api.vhd

ghdl -a --work=uart_bus_master_lib --std=08 uart_bus_master_fsm.vhd
ghdl -a --work=uart_bus_master_lib --std=08 uart_bus_master.vhd

ghdl -a --std=08 --work=soc_lib soc_pkg.vhd
ghdl -a --std=08 --work=soc_lib soc.vhd

echo "OLD tb"
ghdl -a --std=08 soc_tb.vhd

echo "elaborating"
ghdl -e --std=08 soc_tb

echo "simulating"
ghdl -r --std=08 soc_tb --wave=soc_tb.ghw

echo "viewing"
gtkwave soc_tb.ghw soc_tb.sav