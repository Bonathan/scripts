#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <output_directory>"
    exit 1
fi

# Output directory to save results
output_dir="$1"

# Function to run the tool and record memory usage and runtime
run_tool() {
    local tool="$1"
    local output_file="$2"
    local mem_file="$3"

    # Run the tool using time command to capture memory usage and runtime
    /usr/bin/time -v $tool 2>&1 | tee "$output_file" > /dev/null
    
    # Extract memory usage from the output file and save it
    memory=$(grep "Maximum resident set size (kbytes)" "$output_file" | awk '{print $NF}')
    echo "$memory" > "$mem_file"
}

# Specify the commands for the two tools
tool1_command="$HOME/.cargo/bin/coreutils ls /etc/ca-certificates/extracted/cadir"
tool2_command="/usr/bin/ls /etc/ca-certificates/extracted/cadir"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Run and record memory usage and runtime of tool 1
echo "Running tool 1 and recording memory usage and runtime..."
tool1_output="$output_dir/output.tool1"
tool1_mem="$output_dir/memory.tool1"
run_tool "$tool1_command" "$tool1_output" "$tool1_mem"

# Run and record memory usage and runtime of tool 2
echo "Running tool 2 and recording memory usage and runtime..."
tool2_output="$output_dir/output.tool2"
tool2_mem="$output_dir/memory.tool2"
run_tool "$tool2_command" "$tool2_output" "$tool2_mem"

# Read memory usage from the memory files
memory_tool1=$(cat "$tool1_mem")
memory_tool2=$(cat "$tool2_mem")

# Compare memory usage and print the result
if [ "$memory_tool1" -lt "$memory_tool2" ]; then
    echo "Tool 1 uses less memory than Tool 2"
elif [ "$memory_tool1" -gt "$memory_tool2" ]; then
    echo "Tool 2 uses less memory than Tool 1"
else
    echo "Tool 1 and Tool 2 use the same amount of memory"
fi
