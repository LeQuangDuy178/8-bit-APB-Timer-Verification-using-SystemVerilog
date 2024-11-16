##############################################################################
# Makefile: Compile all of the neccessary files in the testbench environment
# Create neccessary files for simulation execution
##############################################################################

# Define variables 
# ?= is followed by default set value if not being manually defined
TESTNAME 			?= count_up_without_clk_div
TB_NAME				?= testbench
RADIX				?= hexadecimal
SEED				?= 1
COV					?= OFF

#########################################################
# Enable Systemverilog Functional Coverage
ifeq ($(COV), ON)
  CMP_COV_OPT = -coveropt 3 +cover=bcestf
  SIM1_COV_OPT = -coveropt -coveranalysis
  SIM2_COV_OPT = coverage save -codeAll -cvg -onexit $(TESTNAME).ucdb;
endif

# Shell command: random SEED value for each running testcase
ifeq ($(strip $(SEED)), random)
  SEED = $(shell /bin/data +%s)
endif

#########################################################
all: build run

build:
      mkdir -p log
      vlib work
      vmap work work
      vlog ${CMP_COV_OPT} -sv -f compile.f | tee compile.log

run:
      vsim -sv_seed $(SEED) ${SIM1_COV_OPT} -debugDB -l $(TESTNAME)_$(SEED).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "${SIM2_COV_OPT} log -r /*; run -all;" +$(TESTNAME)
      mv $(TESTNAME)_$(SEED).log log
      cp -rf vsim.wlf log/$(TESTNAME)_$(SEED).wlf
      ln -sf log/$(TESTNAME)_$(SEED).log run.log

wave:
      vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix $(RADIX)" &

cov_gui:
      vsim -i -viewcov ${TESTNAME}.ucdb &

cov_merge:
      vcover merge IP_MERGE.ucdb *.ucdb

clean:
      rm -rf work
      rm -rf vsim.dbg
      rm -rf *.ini
      rm -rf *.log
      rm -rf log
      rm -rf tmp_report
      rm -rf *.rpt
      rm -rf *.wlf
      rm -rf *.ucdb
      rm -rf transcript

help:
      @echo ""
      @echo "**********************************************"
      @echo "** make build: compile the design and testbench"
      @echo "** make run: run simulation"
      @echo "** make all: compile and run simulation"
      @echo "** make wave: open waveform"
      @echo "** make clean: clean all compiled data"
      @echo "**********************************************"
      @echo ""