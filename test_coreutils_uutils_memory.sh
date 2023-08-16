#!/bin/bash

# Specify the paths to GNU Coreutils and uutils versions of the ls command
coreutils_ls="/home/bittn/.cargo/bin/coreutils ls"
uutils_ls="/usr/bin/ls"

# Specify the directory you want to list
benchmark_directory="/etc/ca-certificates/extracted/cadir"

# Specify the number of trials to run
num_trials=50

# CSV header
echo "Trial,Coreutils RSS (KB),Coreutils VSZ (KB),Uutils RSS (KB),Uutils VSZ (KB)" > memory_comparison_results_script_2.csv

for ((trial=1; trial<=$num_trials; trial++))
do
    # Run Coreutils ls and capture RSS and VSZ
    coreutils_rss=$(ps -p $$ -o rss | tail -1)
    coreutils_vsz=$(ps -p $$ -o vsz | tail -1)
    $coreutils_ls -l $benchmark_directory >/dev/null

    # Wait for a brief moment before capturing uutils memory usage
    sleep 1

    # Run uutils ls and capture RSS and VSZ
    uutils_rss=$(ps -p $$ -o rss | tail -1)
    uutils_vsz=$(ps -p $$ -o vsz | tail -1)
    $uutils_ls -l $benchmark_directory >/dev/null

    # Append results to CSV file
    echo "$trial,$coreutils_rss,$coreutils_vsz,$uutils_rss,$uutils_vsz" >> memory_comparison_results_script_2.csv
done

echo "Memory comparison completed. Results saved to memory_comparison_results_script_2.csv"
