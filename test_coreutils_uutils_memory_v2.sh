#!/bin/bash

function record_memory_usage() {
    command=$1
    output=$(eval $command)
    pid=$!
    memory_usage=$(ps -o rss= -p $pid)
    echo $memory_usage
}

cargo_command="$HOME/.cargo/bin/coreutils ls /etc/ca-certificates/extracted/cadir"
usr_command="/usr/bin/ls /etc/ca-certificates/extracted/cadir"

cargo_memory_usage=$(record_memory_usage "$cargo_command")
usr_memory_usage=$(record_memory_usage "$usr_command")

echo "Memory Usage for $cargo_command: $cargo_memory_usage KB"
echo "Memory Usage for $usr_command: $usr_memory_usage KB"
