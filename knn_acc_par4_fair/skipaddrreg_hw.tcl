# TCL File Generated by Component Editor 12.1
# Thu Jul 10 20:19:51 CEST 2014
# DO NOT MODIFY


# 
# skipaddrreg "skipaddrreg" v1.0
# null 2014.07.10.20:19:51
# 
# 

# 
# request TCL package from ACDS 12.1
# 
package require -exact qsys 12.1


# 
# module skipaddrreg
# 
set_module_property NAME skipaddrreg
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME skipaddrreg
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL SkipAddrReg
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file skipaddrreg.vhd VHDL PATH synthesis/submodules/skipaddrreg.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true

add_interface_port avalon_slave_0 read read Input 1
add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 chipselect chipselect Input 1
add_interface_port avalon_slave_0 address address Input 2
add_interface_port avalon_slave_0 readdata readdata Output 32
add_interface_port avalon_slave_0 writedata writedata Input 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point SkipAddr0
# 
add_interface SkipAddr0 conduit end
set_interface_property SkipAddr0 associatedClock clock
set_interface_property SkipAddr0 associatedReset ""
set_interface_property SkipAddr0 ENABLED true

add_interface_port SkipAddr0 SkipAddr0 export Output 16


# 
# connection point SkipAddr1
# 
add_interface SkipAddr1 conduit end
set_interface_property SkipAddr1 associatedClock clock
set_interface_property SkipAddr1 associatedReset ""
set_interface_property SkipAddr1 ENABLED true

add_interface_port SkipAddr1 SkipAddr1 export Output 16


# 
# connection point SkipAddr2
# 
add_interface SkipAddr2 conduit end
set_interface_property SkipAddr2 associatedClock clock
set_interface_property SkipAddr2 associatedReset ""
set_interface_property SkipAddr2 ENABLED true

add_interface_port SkipAddr2 SkipAddr2 export Output 16


# 
# connection point SkipAddr3
# 
add_interface SkipAddr3 conduit end
set_interface_property SkipAddr3 associatedClock clock
set_interface_property SkipAddr3 associatedReset ""
set_interface_property SkipAddr3 ENABLED true

add_interface_port SkipAddr3 SkipAddr3 export Output 16

