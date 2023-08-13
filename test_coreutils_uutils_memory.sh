#!/bin/bash

# Specify the paths to GNU Coreutils and uutils versions of the ls command
coreutils_ls="/path/to/gnu/ls"
uutils_ls="/path/to/uutils/ls"

# Specify the directory you want to list
benchmark_directory="/path/to/benchmark/directory"

# Specify the number of trials to run
num_trials=5

# CSV header
echo "Trial,Coreutils Memory (KB),Uutils Memory (KB)" > memory_usage_results.csv

for ((trial=1; trial<=$num_trials; trial++))
do
    # Run Coreutils ls and capture memory usage
    coreutils_memory=$(ps -p $$ -o rss | tail -1)
    $coreutils_ls -l $benchmark_directory >/dev/null

    # Wait for a brief moment before capturing uutils memory usage
    sleep 1

    # Run uutils ls and capture memory usage
    uutils_memory=$(ps -p $$ -o rss | tail -1)
    $uutils_ls -l $benchmark_directory >/dev/null

    # Append results to CSV file
    echo "$trial,$coreutils_memory,$uutils_memory" >> memory_usage_results.csv
done

echo "Memory usage benchmarking completed. Results saved to memory_usage_results.csv"
