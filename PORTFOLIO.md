# 8-bit APB Timer Verification using SystemVerilog
 SystemVerilog Testbench to verify 8-bit Timer with APB Transaction

--------------------------------------------Project Portfolio-----------------------------------------------------------------

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
- More details of the components description are explained in the "tb" folder. 

-------------------------------------------------------------------------------------------------------
Section 3: Testcases Implementation

3.1/ Verification Plan development:
- The Verification Plan is a crucial sheet for every large Design Verification project, where it lists out all the items, possible testcase scenarios that need to be verified, with detail descriptions such as milestone, passed/failed condition, status, etc. While it is highly understandable that there might be some potential conrner cases that are missed, the verification plan should help ensure that most of the cases are reviewed and exercised adequetely.
- Particular in this project, the Verification strategy should be analyized as followed:
+ Test the system behavior with default transaction for either read and write transfer.
+ Test particular register's behavior based on associated APB bus, which is count up/down, clock division, load data from TDR, underflow/overflow polling and interrupt trigger. It is highly recommended that the tests should be created directly, rather randomization since the direct cases are addressed.
+ Perform some directed combined tests, in which the DUT will receive 2 to 3 different instruction sets from register to exercise some combination of behavior in one performance. For instance, users can apply TDR loading data to TCR, then set the clock division to 8, then perform count up from the TDR data, with overflow interrupt enable so that as the count up data exceeds 255 as a 8-bit scale, the interrupt should be triggered the same as overflow polling signal.
+ Lastly, it is crucial to perform a preferrable amount of randomized test with appropriate constraints, this help the system to perform randomly so that potential hidden bugs can be detected if it is occered, either from RTL or the testbench itself. However, perform randomized tests require a high level of knowledge and understand of not only the testbench structure but also the specification of the RTL design, as well as adaptable experiences to troubleshooting unexpected bugs.
- Details of testcases needed for testing the behavior of the 8-bit Timer system is shown in "8-bit Timer Vplan_Le Quang Duy.csv" file.
- See folder testcases to see the description of specific testcases.

-------------------------------------------------------------------------------------------------------
Section 4: Simulation performance and Results observation

4.1/ Simulation results:
- The simulation results for every defined testcases listed in the Verification Plan can be obeserved in the waveforms in the result folder. The waveforms are created using Questa simulation tool.
- To perform specific testcases, type "make TESTNAME="test_name"" in the sim directory, this will request the operating system environment to compile all of the codes within the environment and run the defined test name with vsim tool.
- To perform specific testcases without recompile the code, perform "make build" to compile the environment once, and then perform "make run TESTNAME="test_name"" to execute the performance of specific test scenarios.
- See Makefile for more details.

4.2/ Regression running:
- To increase the effectiveness of the simulation process, the regression concept is introduced by perform the same strategy: compiling once, run multiple times. In this regression running, as user run the regress.pl Perl script, the system will compile the environment and run all the listed testcases in the regress.cfg file (the tc_list{}).
- In addition, the user can view the status of the tests as the script also generates the report file regress.rpt show the details of simulation and its result at the end of the simulation.
- See regress.cfg and regress.pl for more details.
- The report file should show the results same as below:
![image](https://github.com/user-attachments/assets/86f20194-f376-4e85-ac3b-655a20062d7c)

-------------------------------------------------------------------------------------------------------
Section 5: Project reflection and improvement

5.1/ Project reflection:
- Overall, the project is designed to help understand how the 8-bit Timer DUT works, how the testbench structure in SystemVerilog should be built to verify the system, how testcases can be created to address all of the scenarios can be occured during real-life operation with the assistance of verification plan, and additionally the APB protocol knowledge.

5.2/ Improvement:
- Using the pure SystemVerilog testbench is limited by its flexibility, and more importantly, the reusability. This testbench environment is unable to be reused in future project or need many adjustments, where the 8-bit Timer DUT might be inserted into another Subsystem or SoC.
- To address that problem, the UVM is introducted, with the advancement in creating effective and resuable testbench environment.
