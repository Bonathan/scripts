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
    command_set_a = [
        "ls /etc/ca-certificates/extracted/cadir",
        "cat /etc/passwd",
        "mkdir /tmp/test",
        # Add more commands here...
    ]

    command_set_b = [
        "ls /etc/ca-certificates/extracted/cadir",
        "cat /etc/passwd",
        "mkdir /tmp/test2",
        # Add more commands here...
    ]

    with open('memory_usage_comparison.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        header = ['Command', 'Cargo Memory Usage (KB)', 'Usr Memory Usage (KB)']
        csvwriter.writerow(header)

        cargo_bin = os.path.expanduser("~/.cargo/bin/coreutils")

        for command in command_set_a:
            cargo_command = f"{cargo_bin} {command_set_a[command]}"
            usr_command = f"/usr/bin/{command_set_b[command]}"

            cargo_process = subprocess.Popen(cargo_command, shell=True)
            usr_process = subprocess.Popen(usr_command, shell=True)

            cargo_memory_usage = record_memory_usage(cargo_process.pid)
            usr_memory_usage = record_memory_usage(usr_process.pid)

            row_data = [command, cargo_memory_usage, usr_memory_usage]
            csvwriter.writerow(row_data)

    print("Memory usage comparison data written to memory_usage_comparison.csv")

if __name__ == "__main__":
    main()
