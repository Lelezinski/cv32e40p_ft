#!/bin/sh

ROOT_DIR="/home/s313207/cv32e40p_ft/"

BASELINE_EVCD_FILE="./results/baseline/cv32e40p_top.evcd"
EVCD_FILE="./run/questasim/cv32e40p_top.evcd"
BASELINE_SAF_LIST_FILE="./results/baseline/cv32e40p_top_saf.rpt"
SAF_LIST_FILE="./run/zoix/cv32e40p_top_saf.rpt"
REPORT_FILE="./results/hardened/report.rpt"

RUN_RPT_FILE=$BASELINE_SAF_LIST_FILE".fsim"

## INIT ##

cd $ROOT_DIR

# Functions to print colored messages
print_green() {
    local message=$1
    echo -e "\e[1;32m${message}\e[0m"
}
print_red() {
    local message=$1
    echo -e "\e[1;31m${message}\e[0m"
}

## RUN ##

# SBST
print_green "\nStarting SBST Compilation"
make compile_sbst

# Check for the -nosyn argument
if [ "$1" != "-nosyn" ]; then
    # Synthesis
    print_green "\nStarting Synthesis"
    make synthesis/nangate45
fi

# Logic Simulation
print_green "\nStarting Questa Logic Simulation"
make questa/compile
make zoix/clean
make zoix/compile
make questa/lsim/gate/shell

# Replace eVCD file and zoix lsim
print_green "\nStarting Z01X Logic Simulation"
mv "$BASELINE_EVCD_FILE" "$EVCD_FILE"
zoix_lsim_output=$(make zoix/lsim 2>&1)
if ! echo "$zoix_lsim_output" | grep -q "Info:    VCD stimulus completed with 0 mismatches."; then
    print_red "\n[ERROR] Mismatches found in the logic simulation."
    exit 1
fi

# Fault Simulation
print_green "\nStarting Fault Simulation"
make zoix/fgen/saf
make zoix/fsim FAULT_LIST=$BASELINE_SAF_LIST_FILE

# Generate Report
print_green "\nGenerating Report"
grep '^#' "$RUN_RPT_FILE" >"$REPORT_FILE"

# Print Relevant Results
awk '/# Total Faults/ { faults=$NF } /# Fault Coverage/ { coverage=$(NF-1) } END { printf "• Number of faults: \033[1;35m%s\033[0m\n", faults; printf "• Test coverage: \033[1;35m%s\033[0m\n", coverage }' "$RUN_RPT_FILE"
print_green "\n[DONE]\n"
