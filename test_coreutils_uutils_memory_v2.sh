#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

# Output file to save results
output_file="$1"

# Function to run the tool and record memory usage
run_tool() {
    local tool="$1"
    local output_file="$2"

    # Run the tool using time command to capture memory usage
    /usr/bin/time -v $tool 2>&1 | tee "$output_file"
}

# Specify the commands for the two tools
tool1_command="your_tool1_command_here"
tool2_command="your_tool2_command_here"

# Run and record memory usage of tool 1
echo "Running tool 1 and recording memory usage..."
run_tool "$tool1_command" "$output_file.tool1"

# Run and record memory usage of tool 2
echo "Running tool 2 and recording memory usage..."
run_tool "$tool2_command" "$output_file.tool2"

# Extract memory usage from the output files
memory_tool1=$(grep "Maximum resident set size (kbytes)" "$output_file.tool1" | awk '{print $NF}')
memory_tool2=$(grep "Maximum resident set size (kbytes)" "$output_file.tool2" | awk '{print $NF}')

# Compare memory usage and print the result
if [ "$memory_tool1" -lt "$memory_tool2" ]; then
    echo "Tool 1 uses less memory than Tool 2"
elif [ "$memory_tool1" -gt "$memory_tool2" ]; then
    echo "Tool 2 uses less memory than Tool 1"
else
    echo "Tool 1 and Tool 2 use the same amount of memory"
fi
