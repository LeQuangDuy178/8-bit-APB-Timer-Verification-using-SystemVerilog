# 8-bit APB Timer Verification using SystemVerilog
 SystemVerilog Testbench to verify 8-bit Timer with APB Transaction

--------------------------------------------Project Portfolio-------------------------------------------------------------
This project is part of the preserved ICTC course "Design Verification - SystemVerilog UVM" instructed by Mr. Huy Nguyen

-------------------------------------------------------------------------------------------------------
Section 1: Project Specification

1.1/ Understand the 8-bit Timer system block diagram:
- The 8-bit Timer system in this project consists of 4 different functional design under test (DUT) blocks, which are Register, Clock Divisor, Interrupt, and Counter. The overview of the system is provided as the figure below:
 ![image](https://github.com/user-attachments/assets/0f8796af-03d5-49a4-b693-ef99c34ce643)
- The 8-bit Timer's main block, the Counter DUT, receiving the specific instruction set from Register DUT is mainly capable of counting the time value in the 8-bit data scale, each counting period is synchronized through its own system clock received via Clock Divisor DUT (in this project is clk_in).
- The Register block main task is to get the APB bus transaction and control the instruction sets based on the APB appropraite data and address. The Clock Divisor and Interrupt are simple the blocks with specific features based on the register instruction to control the clock division of counter and the interrupt trigger when the counter finish. More details about the instruction set of the register is shown in the figures below, totally 4 registers are accessed in this project:
![image](https://github.com/user-attachments/assets/9e1a33ee-e5cb-4b24-bafa-3a22f1d98442)
![image](https://github.com/user-attachments/assets/4ca8a00d-c61b-42c7-8374-6786f4e45880)
![image](https://github.com/user-attachments/assets/a9396a0e-2261-4add-950c-cca6c0e7d9c9)

1.2/ Understand the APB bus transaction:
- The main protocol use for the transaction packet sending to and getting from the DUT is the APB bus, consisting of its global signals pclk and presetn; the set of control signals psel, penable and pwrite; actual transfer data paddr, pwdata for write transfer and output prdata from the slave for read transfer. Details of the signals are shown as below:
![image](https://github.com/user-attachments/assets/3e6e71c2-0e2e-493b-81b3-ac8cd9900c7b)
- In this project, the single APB transaction will require 2 completed periods of pclk (excluding wait state), in which the 1st phase asserts the psel and pwrite depending on transfer type, and the 2nd phase asserts the penable such that the system is ready to access the data. It is highly required that the address and write/read data should be kept stable during the entire transfer. The APB transaction prototype on waveform is illustrated as below:
![image](https://github.com/user-attachments/assets/cb675786-a80c-4215-b49b-4ef8f32a7196)

-------------------------------------------------------------------------------------------------------
Section 2: Building Testbench Environment

2.1/ Overview of the environment:
- To make the most effective testbench environment to verify the 8-bit Timer system, it is important to prioritize the structure of the testbench as well as the flow where our transaction should travel. To achieve that, the crucial components performing specific tasks are created, and later being connected together inside a larger environment. The overall testbench structure in this project is illustrated as below:
![image](https://github.com/user-attachments/assets/594601e8-cc00-43d6-83e6-1cb60b2127ff)

2.2/ Components description and testbench working flow:
- Observed the structure from top-down perspective, it can be viewed that the testbench is constructed with a DUT - the 8-bit TImer, an interface controlling the pin-level behavior of the block, and the test environment where different tests are created to observe the behavior of the system.
- Inside the test is the enviroment holding all of the needed components for data handling and an virtual interface virtually controlling the pin-level signals of the system dynamically as this environment receives the transaction.
- Inside the environment, 4 main components are the stimulus, driver, monitor and scoreboard:
+ The stimulus will depends on the transaction buffer defined in packet (mainly APB transaction) to create the proper transaction data and control signals, and forward the packet to driver through the mailbox.
+ In driver, the packet are extracted for the driver to drive the appropriate pin-level signals to the DUT via the virtual interface received from test environment.
+ The actual pin-level behaviors of the system are then captured and observed by the monitor which then translate them to the transaction level data packet to send to the scoreboard through mailbox.
+ In scoreboard, it performs various task to analyze the received transaction defined by the user such as data integrity check, error check, data comparison, or functional coverage analysis.
