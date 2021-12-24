# Quit previous simulation session
quit -sim
vlib work

# Compile files
vcom -2008 -work work ..//FIR_moving_avg.vhd
vcom -2008 -work work FIR_moving_avg_tb.vhd

# Start simulation
vsim work.FIR_moving_avg_tb

# Display and run waves
do wave.do
run 8 us

# resize zoom
wave zoom full