#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <tool1> <tool2> <output_file>"
    exit 1
fi

# Command-line tool names
tool1="~/.cargo/bin/coreutils ls /ect/ca-certificates/extracted/cadir"
tool2="/usr/bin/ls /ect/ca-certificates/extracted/cadir"

# Output file to save results
output_file="memory_comparison_results_script_3.csv"

# Function to run the tool and record memory usage
run_tool() {
    local tool="$1"
    local output_file="$2"

    # Run the tool using time command to capture memory usage
    /usr/bin/time -v $tool 2>&1 | tee "$output_file"
}

# Run and record memory usage of tool 1
echo "Running $tool1 and recording memory usage..."
run_tool "$tool1" "$output_file.tool1"

# Run and record memory usage of tool 2
echo "Running $tool2 and recording memory usage..."
run_tool "$tool2" "$output_file.tool2"

# Extract memory usage from the output files
memory_tool1=$(grep "Maximum resident set size (kbytes)" "$output_file.tool1" | awk '{print $NF}')
memory_tool2=$(grep "Maximum resident set size (kbytes)" "$output_file.tool2" | awk '{print $NF}')

# Compare memory usage and print the result
if [ "$memory_tool1" -lt "$memory_tool2" ]; then
    echo "$tool1 uses less memory than $tool2"
elif [ "$memory_tool1" -gt "$memory_tool2" ]; then
    echo "$tool2 uses less memory than $tool1"
else
    echo "$tool1 and $tool2 use the same amount of memory"
fi
