import subprocess
import psutil

def record_memory_usage(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    process.wait()

    # Get memory usage of the process
    pid = process.pid
    memory_info = psutil.Process(pid).memory_info()

    return memory_info.rss  # Resident Set Size (memory usage in bytes)

def profile_memory_usage(command, label):
    print(f"Profiling memory usage for '{label}'...")
    memory_usage = record_memory_usage(command)
    print(f"Memory Usage for '{label}': {memory_usage} bytes")

def main():
    cargo_command = "$HOME/.cargo/bin/coreutils ls /etc/ca-certificates/extracted/cadir"
    usr_command = "/usr/bin/ls /etc/ca-certificates/extracted/cadir"

    profile_memory_usage(cargo_command, "Cargo ls")
    profile_memory_usage(usr_command, "Usr ls")

if __name__ == "__main__":
    main()
