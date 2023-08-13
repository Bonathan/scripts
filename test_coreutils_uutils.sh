#!/bin/bash

# Specify the paths to GNU Coreutils and uutils versions of the ls command
coreutils_ls="/path/to/gnu/ls"
uutils_ls="/path/to/uutils/ls"

# Specify the directory you want to list
benchmark_directory="/path/to/benchmark/directory"

# Specify the number of trials to run
num_trials=5

# CSV header
echo "Trial,Coreutils Time (s),Uutils Time (s),Coreutils Memory (KB),Uutils Memory (KB)" > benchmark_results.csv

for ((trial=1; trial<=$num_trials; trial++))
do
    # Run Coreutils ls and capture execution time and memory usage
    coreutils_start_time=$(date +%s.%N)
    $coreutils_ls -l $benchmark_directory >/dev/null
    coreutils_end_time=$(date +%s.%N)
    coreutils_time=$(echo "$coreutils_end_time - $coreutils_start_time" | bc)

    coreutils_memory=$(ps -p $$ -o rss | tail -1)

    # Run uutils ls and capture execution time and memory usage
    uutils_start_time=$(date +%s.%N)
    $uutils_ls -l $benchmark_directory >/dev/null
    uutils_end_time=$(date +%s.%N)
    uutils_time=$(echo "$uutils_end_time - $uutils_start_time" | bc)

    uutils_memory=$(ps -p $$ -o rss | tail -1)

    # Append results to CSV file
    echo "$trial,$coreutils_time,$uutils_time,$coreutils_memory,$uutils_memory" >> benchmark_results.csv
done

echo "Benchmarking completed. Results saved to benchmark_results.csv"
