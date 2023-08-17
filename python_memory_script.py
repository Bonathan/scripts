import subprocess
import os
import csv

def record_memory_usage(pid):
    try:
        process = subprocess.Popen(['pmap', '-x', str(pid)], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()
        memory_info = stdout.decode('utf-8').strip().split('\n')[-1].split()
        return memory_info[2]
    except Exception as e:
        return str(e)

def main():
    cargo_command = "$HOME/.cargo/bin/coreutils ls /etc/ca-certificates/extracted/cadir"
    usr_command = "/usr/bin/ls /etc/ca-certificates/extracted/cadir"
    cycles = 50

    with open('memory_usage_output.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(['Cycle', 'Cargo Memory Usage (KB)', 'Usr Memory Usage (KB)'])

        for cycle in range(cycles):
            cargo_process = subprocess.Popen(cargo_command, shell=True)
            usr_process = subprocess.Popen(usr_command, shell=True)

            cargo_memory_usage = record_memory_usage(cargo_process.pid)
            usr_memory_usage = record_memory_usage(usr_process.pid)

            csvwriter.writerow([cycle + 1, cargo_memory_usage, usr_memory_usage])

    print("Memory usage data written to memory_usage_output.csv")

if __name__ == "__main__":
    main()
