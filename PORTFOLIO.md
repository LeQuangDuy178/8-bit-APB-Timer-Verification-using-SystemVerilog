# 8-bit APB Timer Verification using SystemVerilog
 SystemVerilog Testbench to verify 8-bit Timer with APB Transaction

--------------------------------------------Project Portfolio-------------------------------------------------------

Section 1: Project Specification
1.1/ Understand the 8-bit Timer system block diagram:
- The 8-bit Timer system in this project consists of 4 different functional design under test (DUT) blocks, which are Register, Clock Divisor, Interrupt, and Counter.
- The 8-bit Timer's main block, the Counter DUT, receiving the specific instruction set from Register DUT is mainly capable of counting the time value in the 8-bit data scale, each counting period is synchronized through its own system clock received via Clock Divisor DUT (in this project is clk_in).
- The Register block main task is   
