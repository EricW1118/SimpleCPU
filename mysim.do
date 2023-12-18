
quit -sim;
project compileall;
vsim -voptargs=+acc work.scpu_tb;

add wave -position insertpoint  \
sim:/scpu_tb/clk;
add wave -position insertpoint  \
sim:/scpu_tb/mycpu/slow_clk;

add wave -position insertpoint  \
sim:/scpu_tb/mycpu/inner_cpu/mrf/regis;

add wave -position insertpoint  \
sim:/scpu_tb/mycpu/inner_cpu/dm/memory \

add wave -position insertpoint  \
sim:/scpu_tb/mycpu/inner_cpu/alu/ZN\

add wave -position insertpoint  \
sim:/scpu_tb/out
run 10000




