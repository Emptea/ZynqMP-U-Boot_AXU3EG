#Disable Security gates to view PMU MB target
targets -set -filter {name =~ "PSU"}

#By default, JTAGsecurity gates are enabled
#This disables security gates for DAP, PLTAP and PMU.
mwr 0xffca0038 0x1ff
after 500

#Load and run PMU FW
targets -set -filter {name =~ "MicroBlaze PMU"}
dow ./output/zynqmp_pmufw.elf
con
after 500

#Reset A53, load and run FSBL
targets -set -filter {name =~ "Cortex-A53 #0"}
rst -processor
dow ./output/zynqmp_fsbl.elf
con

#Give FSBL time to run
after 5000
stop

#Other SW...
dow ./output/u-boot.elf
dow ./output/bl31.elf
con

#по желанию можно так же загрузить битстрим
#Targets -set -nocase -filter {name =~ "*PL*"}
#fpga simple-linux.bit