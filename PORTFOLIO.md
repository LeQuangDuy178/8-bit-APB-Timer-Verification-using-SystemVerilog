# 8-bit APB Timer Verification using SystemVerilog
 SystemVerilog Testbench to verify 8-bit Timer with APB Transaction

--------------------------------------------Project Portfolio-------------------------------------------------------------
This project is part of the preserved ICTC course "Design Verification - SystemVerilog UVM" instructed by Mr. Huy Nguyen

Section 1: Project Specification
1.1/ Understand the 8-bit Timer system block diagram:
- The 8-bit Timer system in this project consists of 4 different functional design under test (DUT) blocks, which are Register, Clock Divisor, Interrupt, and Counter. The overview of the system is provided as the figure below:
 ![image](https://github.com/user-attachments/assets/0f8796af-03d5-49a4-b693-ef99c34ce643)
- The 8-bit Timer's main block, the Counter DUT, receiving the specific instruction set from Register DUT is mainly capable of counting the time value in the 8-bit data scale, each counting period is synchronized through its own system clock received via Clock Divisor DUT (in this project is clk_in).
- The Register block main task is to get the APB bus transaction and control the instruction sets based on the APB appropraite data and address. The Clock Divisor and Interrupt are simple the blocks with specific features based on the register instruction to control the clock division of counter and the interrupt trigger when the counter finish. More details about the instruction set of the register is shown in the figures below, totally 4 registers are accessed in this project:
![image](https://github.com/user-attachments/assets/9e1a33ee-e5cb-4b24-bafa-3a22f1d98442)
![image](https://github.com/user-attachments/assets/4ca8a00d-c61b-42c7-8374-6786f4e45880)
![image](https://github.com/user-attachments/assets/a9396a0e-2261-4add-950c-cca6c0e7d9c9)

