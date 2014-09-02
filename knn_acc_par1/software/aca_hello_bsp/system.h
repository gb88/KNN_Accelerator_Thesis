/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu_0' in SOPC Builder design 'nios_sys'
 * SOPC Builder design path: ../../nios_sys.sopcinfo
 *
 * Generated: Thu Jul 10 22:13:09 CEST 2014
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x2004020
#define ALT_CPU_CPU_FREQ 144000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1a
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x2004020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 144000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 0
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x1a
#define ALT_CPU_NAME "cpu_0"
#define ALT_CPU_RESET_ADDR 0x2004000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x2004020
#define NIOS2_CPU_FREQ 144000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x1a
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x2004020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 0
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x1a
#define NIOS2_RESET_ADDR 0x2004000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_DMA
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PERFORMANCE_COUNTER
#define __ALTERA_AVALON_PIO
#define __ALTERA_NIOS2_QSYS
#define __BASEQADDR
#define __EMPTYREG
#define __ENDTSETREG
#define __FULLREG
#define __KNNCLASS
#define __NDIMREG
#define __NTRREG
#define __SKIPADDRREG
#define __USBFIFOCTRL


/*
 * EndTSetReg_0 configuration
 *
 */

#define ALT_MODULE_CLASS_EndTSetReg_0 endtsetreg
#define ENDTSETREG_0_BASE 0x2008190
#define ENDTSETREG_0_IRQ -1
#define ENDTSETREG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ENDTSETREG_0_NAME "/dev/EndTSetReg_0"
#define ENDTSETREG_0_SPAN 16
#define ENDTSETREG_0_TYPE "endtsetreg"


/*
 * FullReg_0 configuration
 *
 */

#define ALT_MODULE_CLASS_FullReg_0 fullreg
#define FULLREG_0_BASE 0x2008180
#define FULLREG_0_IRQ -1
#define FULLREG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define FULLREG_0_NAME "/dev/FullReg_0"
#define FULLREG_0_SPAN 16
#define FULLREG_0_TYPE "fullreg"


/*
 * NDimReg configuration
 *
 */

#define ALT_MODULE_CLASS_NDimReg NDimReg
#define NDIMREG_BASE 0x20081a0
#define NDIMREG_IRQ -1
#define NDIMREG_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NDIMREG_NAME "/dev/NDimReg"
#define NDIMREG_SPAN 16
#define NDIMREG_TYPE "NDimReg"


/*
 * NTrReg_0 configuration
 *
 */

#define ALT_MODULE_CLASS_NTrReg_0 ntrreg
#define NTRREG_0_BASE 0x2008160
#define NTRREG_0_IRQ -1
#define NTRREG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NTRREG_0_NAME "/dev/NTrReg_0"
#define NTRREG_0_SPAN 16
#define NTRREG_0_TYPE "ntrreg"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone II"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/null"
#define ALT_STDERR_BASE 0x0
#define ALT_STDERR_DEV null
#define ALT_STDERR_TYPE ""
#define ALT_STDIN "/dev/null"
#define ALT_STDIN_BASE 0x0
#define ALT_STDIN_DEV null
#define ALT_STDIN_TYPE ""
#define ALT_STDOUT "/dev/null"
#define ALT_STDOUT_BASE 0x0
#define ALT_STDOUT_DEV null
#define ALT_STDOUT_TYPE ""
#define ALT_SYSTEM_NAME "nios_sys"


/*
 * baseqaddr_0 configuration
 *
 */

#define ALT_MODULE_CLASS_baseqaddr_0 baseqaddr
#define BASEQADDR_0_BASE 0x2008110
#define BASEQADDR_0_IRQ -1
#define BASEQADDR_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BASEQADDR_0_NAME "/dev/baseqaddr_0"
#define BASEQADDR_0_SPAN 16
#define BASEQADDR_0_TYPE "baseqaddr"


/*
 * cache_0 configuration as viewed by dma_write_master
 *
 */

#define DMA_WRITE_MASTER_CACHE_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define DMA_WRITE_MASTER_CACHE_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define DMA_WRITE_MASTER_CACHE_0_BASE 0x1000
#define DMA_WRITE_MASTER_CACHE_0_CONTENTS_INFO ""
#define DMA_WRITE_MASTER_CACHE_0_DUAL_PORT 1
#define DMA_WRITE_MASTER_CACHE_0_GUI_RAM_BLOCK_TYPE "M4K"
#define DMA_WRITE_MASTER_CACHE_0_INIT_CONTENTS_FILE "cache_0"
#define DMA_WRITE_MASTER_CACHE_0_INIT_MEM_CONTENT 0
#define DMA_WRITE_MASTER_CACHE_0_INSTANCE_ID "NONE"
#define DMA_WRITE_MASTER_CACHE_0_IRQ -1
#define DMA_WRITE_MASTER_CACHE_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DMA_WRITE_MASTER_CACHE_0_NAME "/dev/cache_0"
#define DMA_WRITE_MASTER_CACHE_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define DMA_WRITE_MASTER_CACHE_0_RAM_BLOCK_TYPE "M4K"
#define DMA_WRITE_MASTER_CACHE_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define DMA_WRITE_MASTER_CACHE_0_SINGLE_CLOCK_OP 0
#define DMA_WRITE_MASTER_CACHE_0_SIZE_MULTIPLE 1
#define DMA_WRITE_MASTER_CACHE_0_SIZE_VALUE 2048u
#define DMA_WRITE_MASTER_CACHE_0_SPAN 2048
#define DMA_WRITE_MASTER_CACHE_0_TYPE "altera_avalon_onchip_memory2"
#define DMA_WRITE_MASTER_CACHE_0_WRITABLE 1


/*
 * dma configuration
 *
 */

#define ALT_MODULE_CLASS_dma altera_avalon_dma
#define DMA_ALLOW_BYTE_TRANSACTIONS 0
#define DMA_ALLOW_DOUBLEWORD_TRANSACTIONS 0
#define DMA_ALLOW_HW_TRANSACTIONS 0
#define DMA_ALLOW_QUADWORD_TRANSACTIONS 0
#define DMA_ALLOW_WORD_TRANSACTIONS 1
#define DMA_BASE 0x20080e0
#define DMA_IRQ 1
#define DMA_IRQ_INTERRUPT_CONTROLLER_ID 0
#define DMA_LENGTHWIDTH 32
#define DMA_MAX_BURST_SIZE 8
#define DMA_NAME "/dev/dma"
#define DMA_SPAN 32
#define DMA_TYPE "altera_avalon_dma"


/*
 * emptyreg_0 configuration
 *
 */

#define ALT_MODULE_CLASS_emptyreg_0 emptyreg
#define EMPTYREG_0_BASE 0x2008140
#define EMPTYREG_0_IRQ -1
#define EMPTYREG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define EMPTYREG_0_NAME "/dev/emptyreg_0"
#define EMPTYREG_0_SPAN 16
#define EMPTYREG_0_TYPE "emptyreg"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK TIMER_0
#define ALT_TIMESTAMP_CLK TIMER_0


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x20081c8
#define JTAG_UART_0_IRQ 0
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * knnclasscore configuration
 *
 */

#define ALT_MODULE_CLASS_knnclasscore knnclass
#define KNNCLASSCORE_BASE 0x2008000
#define KNNCLASSCORE_IRQ -1
#define KNNCLASSCORE_IRQ_INTERRUPT_CONTROLLER_ID -1
#define KNNCLASSCORE_NAME "/dev/knnclasscore"
#define KNNCLASSCORE_SPAN 128
#define KNNCLASSCORE_TYPE "knnclass"


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x2004000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "Automatic"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "Auto"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 10496u
#define ONCHIP_MEMORY2_0_SPAN 10496
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * performance_counter_0 configuration
 *
 */

#define ALT_MODULE_CLASS_performance_counter_0 altera_avalon_performance_counter
#define PERFORMANCE_COUNTER_0_BASE 0x2008080
#define PERFORMANCE_COUNTER_0_HOW_MANY_SECTIONS 2
#define PERFORMANCE_COUNTER_0_IRQ -1
#define PERFORMANCE_COUNTER_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PERFORMANCE_COUNTER_0_NAME "/dev/performance_counter_0"
#define PERFORMANCE_COUNTER_0_SPAN 64
#define PERFORMANCE_COUNTER_0_TYPE "altera_avalon_performance_counter"


/*
 * pio_0 configuration
 *
 */

#define ALT_MODULE_CLASS_pio_0 altera_avalon_pio
#define PIO_0_BASE 0x20081b0
#define PIO_0_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_0_CAPTURE 0
#define PIO_0_DATA_WIDTH 8
#define PIO_0_DO_TEST_BENCH_WIRING 0
#define PIO_0_DRIVEN_SIM_VALUE 0x0
#define PIO_0_EDGE_TYPE "NONE"
#define PIO_0_FREQ 144000000u
#define PIO_0_HAS_IN 0
#define PIO_0_HAS_OUT 1
#define PIO_0_HAS_TRI 0
#define PIO_0_IRQ -1
#define PIO_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_0_IRQ_TYPE "NONE"
#define PIO_0_NAME "/dev/pio_0"
#define PIO_0_RESET_VALUE 0x0
#define PIO_0_SPAN 16
#define PIO_0_TYPE "altera_avalon_pio"


/*
 * sdram_controller configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_controller altera_avalon_new_sdram_controller
#define SDRAM_CONTROLLER_BASE 0x0
#define SDRAM_CONTROLLER_CAS_LATENCY 2
#define SDRAM_CONTROLLER_CONTENTS_INFO ""
#define SDRAM_CONTROLLER_INIT_NOP_DELAY 0.0
#define SDRAM_CONTROLLER_INIT_REFRESH_COMMANDS 2
#define SDRAM_CONTROLLER_IRQ -1
#define SDRAM_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_CONTROLLER_IS_INITIALIZED 1
#define SDRAM_CONTROLLER_NAME "/dev/sdram_controller"
#define SDRAM_CONTROLLER_POWERUP_DELAY 100.0
#define SDRAM_CONTROLLER_REFRESH_PERIOD 15.625
#define SDRAM_CONTROLLER_REGISTER_DATA_IN 1
#define SDRAM_CONTROLLER_SDRAM_ADDR_WIDTH 0x17
#define SDRAM_CONTROLLER_SDRAM_BANK_WIDTH 2
#define SDRAM_CONTROLLER_SDRAM_COL_WIDTH 9
#define SDRAM_CONTROLLER_SDRAM_DATA_WIDTH 32
#define SDRAM_CONTROLLER_SDRAM_NUM_BANKS 4
#define SDRAM_CONTROLLER_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_CONTROLLER_SDRAM_ROW_WIDTH 12
#define SDRAM_CONTROLLER_SHARED_DATA 0
#define SDRAM_CONTROLLER_SIM_MODEL_BASE 0
#define SDRAM_CONTROLLER_SPAN 33554432
#define SDRAM_CONTROLLER_STARVATION_INDICATOR 0
#define SDRAM_CONTROLLER_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_CONTROLLER_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_CONTROLLER_T_AC 5.5
#define SDRAM_CONTROLLER_T_MRD 3
#define SDRAM_CONTROLLER_T_RCD 20.0
#define SDRAM_CONTROLLER_T_RFC 70.0
#define SDRAM_CONTROLLER_T_RP 20.0
#define SDRAM_CONTROLLER_T_WR 14.0


/*
 * sdram_controller configuration as viewed by dma_read_master
 *
 */

#define DMA_READ_MASTER_SDRAM_CONTROLLER_BASE 0x0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_CAS_LATENCY 2
#define DMA_READ_MASTER_SDRAM_CONTROLLER_CONTENTS_INFO ""
#define DMA_READ_MASTER_SDRAM_CONTROLLER_INIT_NOP_DELAY 0.0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_INIT_REFRESH_COMMANDS 2
#define DMA_READ_MASTER_SDRAM_CONTROLLER_IRQ -1
#define DMA_READ_MASTER_SDRAM_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DMA_READ_MASTER_SDRAM_CONTROLLER_IS_INITIALIZED 1
#define DMA_READ_MASTER_SDRAM_CONTROLLER_NAME "/dev/sdram_controller"
#define DMA_READ_MASTER_SDRAM_CONTROLLER_POWERUP_DELAY 100.0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_REFRESH_PERIOD 15.625
#define DMA_READ_MASTER_SDRAM_CONTROLLER_REGISTER_DATA_IN 1
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_ADDR_WIDTH 0x17
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_BANK_WIDTH 2
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_COL_WIDTH 9
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_DATA_WIDTH 32
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_NUM_BANKS 4
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_NUM_CHIPSELECTS 1
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SDRAM_ROW_WIDTH 12
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SHARED_DATA 0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SIM_MODEL_BASE 0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_SPAN 33554432
#define DMA_READ_MASTER_SDRAM_CONTROLLER_STARVATION_INDICATOR 0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_TRISTATE_BRIDGE_SLAVE ""
#define DMA_READ_MASTER_SDRAM_CONTROLLER_TYPE "altera_avalon_new_sdram_controller"
#define DMA_READ_MASTER_SDRAM_CONTROLLER_T_AC 5.5
#define DMA_READ_MASTER_SDRAM_CONTROLLER_T_MRD 3
#define DMA_READ_MASTER_SDRAM_CONTROLLER_T_RCD 20.0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_T_RFC 70.0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_T_RP 20.0
#define DMA_READ_MASTER_SDRAM_CONTROLLER_T_WR 14.0


/*
 * skipaddrreg_0 configuration
 *
 */

#define ALT_MODULE_CLASS_skipaddrreg_0 skipaddrreg
#define SKIPADDRREG_0_BASE 0x2008100
#define SKIPADDRREG_0_IRQ -1
#define SKIPADDRREG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SKIPADDRREG_0_NAME "/dev/skipaddrreg_0"
#define SKIPADDRREG_0_SPAN 16
#define SKIPADDRREG_0_TYPE "skipaddrreg"


/*
 * usbFIFOCtrl_0 configuration
 *
 */

#define ALT_MODULE_CLASS_usbFIFOCtrl_0 usbFIFOCtrl
#define USBFIFOCTRL_0_BASE 0x20081c0
#define USBFIFOCTRL_0_IRQ -1
#define USBFIFOCTRL_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USBFIFOCTRL_0_NAME "/dev/usbFIFOCtrl_0"
#define USBFIFOCTRL_0_SPAN 8
#define USBFIFOCTRL_0_TYPE "usbFIFOCtrl"

#endif /* __SYSTEM_H_ */
