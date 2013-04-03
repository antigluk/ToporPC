#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom reg48.vhd ./MicroROMHolder.vhd;
vsim -quiet work.MicroROMHolder;


add wave -position end  sim:/microromholder/clock
force -freeze sim:/microromholder/clock 1 0, 0 {50 ps} -r 100
add wave -position end  -radix hexadecimal sim:/microromholder/addr
add wave -position end  -radix hexadecimal sim:/microromholder/enable_next
add wave -position end  -radix hexadecimal  sim:/microromholder/cmd

add wave -position end -radix hexadecimal  sim:/microromholder/b2v_rom_keeper/data
add wave -position end -radix hexadecimal  sim:/microromholder/b2v_rom_keeper/q


force -freeze sim:/microromholder/enable_next 1 0

proc check_addr {addr data} {
    force -freeze sim:/microromholder/addr 10#$addr 0
    run 10 ns

    #uncomment to see data
    # puts [examine -radix hexadecimal sim:/microromholder/cmd]
    return [expr [string compare [examine -radix hexadecimal sim:/microromholder/cmd] $data] != 0]
}

set result 0
set result [expr $result + [check_addr 0 "FE0600000016"]]
set result [expr $result + [check_addr 1 "FE0600078005"]]
set result [expr $result + [check_addr 2 "FE060001D080"]]
set result [expr $result + [check_addr 15 "FE0600000016"]]

puts "$result"

quit
