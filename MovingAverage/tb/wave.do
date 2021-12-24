onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fir_moving_avg_tb/clk
add wave -noupdate /fir_moving_avg_tb/rst
add wave -noupdate -radix unsigned /fir_moving_avg_tb/sample_in
add wave -noupdate /fir_moving_avg_tb/sample_ready_puls
add wave -noupdate -radix unsigned /fir_moving_avg_tb/filtered_sample
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5675240 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 252
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {6755470 ps}
