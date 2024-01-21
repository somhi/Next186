# Add ZXTRES DeMiSTify target into an already demistified core

### Example: https://github.com/somhi/MSX_deMiSTified 

(forked from  https://github.com/DeMistified/MSX_deMiSTified)

```sh
#Clone repository
git clone https://github.com/somhi/MSX_deMiSTified
cd MSX_deMiSTified/
#[OPTIONAL step] Checkout to DeMiSTify branch if not in main/master
git branch -a
git checkout demistified
#[OPTIONAL step] Replace DeMiSTify URL with https://github.com/somhi/DeMiSTify. Needed until zxtres target is not uploaded into robinsonb5's official DeMiSTify repo
gedit .gitmodules
#[submodule "DeMiSTify"]
#	path = DeMiSTify
#	url = https://github.com/somhi/DeMiSTify

#Download missing submodules 
git submodule update --init --recursive
#Create file site.mk in DeMiSTify folder 
cd DeMiSTify
cp site.template site.mk
#[OPTIONAL step to bump DeMiSTify to get latest commits with ZXTRES target]
git config pull.rebase true
git pull origin main
git submodule update
#Edit site.mk and modify with your Quartus PATH Q18=/opt/intelFPGA_lite/18.1/quartus/bin/
gedit site.mk
#Go back to the root folder
cd ..
#Copy board folder template
cp -r DeMiSTify/templates/zxtres/ .
#Look at another target like neptuno to adapt zxtres target accordingly
#Check mist top module name instantiated at neptuno_top.sv/vhd (e.g. guest_top)
#Set the Mist guest core module name in defs_demistify.v 
cp DeMiSTify/templates/demistify/defs_demistify.v .
gedit defs_demistify.v 
#`define GUEST_TOP guest_top      // in this example doesn't change

#Check in neptuno/top.qip which additional files are needed and adapt zxtres/top.qip
#In this example there is only needed the pll.v apart from the target's top file. 
#PLL files need to be adapted for Vivado. There is a pll.v template already in zxtres folder but need to be adapted with same module name and frecuencies.
# Open neptuno/pll.v in Quartus and take note of PLL outputs
# inclk0 port
# c0 port, 21.48 MHz, phase 0
# c1 port, 85.91 MHz, phase 0
# areset and locked ports
cd zxtres
./pll-calc.py -i 50 -o 21.48
./pll-calc.py -i 50 -o 85.91
#Find a comon multiplicator for all pll outputs
#Change in pll.v the CLKFBOUT_MULT_F with the common 'mult' value (e.g. 24)
#Change for each PLL output the CLKOUTx_DIVIDE_F 'div' value (e.g. c0=56, c1=14 )
#Adapt name of ports as the same from Quartus PLL
gedit pll.v

#Run demist_zxtres.sh in zxtres folder with the appropiate arguments
./demist_zxtres.sh Next186 demist_zx3a200 3

#Open generated Vivado project to better debug errors
#Use RTL analysis > Open Eleborated Design to check for RTL errors before Run Synthesis
```



## Vivado common errors when porting from Quartus 

```sh
[Synth 8-2577] procedural assignment to a non-register VGA_VS is not permitted, left-hand side should be reg/integer/time/genvar 
# edit file and change VGA_VS to reg type





```

