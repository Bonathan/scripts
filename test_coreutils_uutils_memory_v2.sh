#!/bin/bash

output_file="memory_usage.txt"

function record_memory_usage() {
    command=$1
    eval $command &
    pid=$!
    wait $pid
    memory_usage=$(pmap -x $pid | tail -n 1 | awk '{print $3}')
    echo $memory_usage
}

cargo_command="$HOME/.cargo/bin/coreutils ls /etc/ca-certificates/extracted/cadir"
usr_command="/usr/bin/ls /etc/ca-certificates/extracted/cadir"

cargo_memory_usage=$(record_memory_usage "$cargo_command")
usr_memory_usage=$(record_memory_usage "$usr_command")

echo "Memory Usage for $cargo_command: $cargo_memory_usage KB" >> "$output_file"
echo "Memory Usage for $usr_command: $usr_memory_usage KB" >> "$output_file"

echo "Memory usage data written to $output_file"
