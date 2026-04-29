# Step 6 - SSH tunnel to ilab, password hidden via getpass
import getpass
import paramiko

ILAB_HOST = "ilab.cs.rutgers.edu"
ILAB_PYTHON = "~/cs336env/bin/python3"
ILAB_SCRIPT = "~/ilab_script.py"


def connect_ssh():
    print("=== ilab SSH Login ===")
    username = input("ilab username: ")
    password = getpass.getpass("ilab password: ")

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(ILAB_HOST, username=username, password=password)
    print("Connected to ilab.\n")
    return client


def run_on_ilab(sql_query, ssh_client):
    command = f"{ILAB_PYTHON} {ILAB_SCRIPT}"
    stdin, stdout, stderr = ssh_client.exec_command(command)
    stdin.write(sql_query)
    stdin.channel.shutdown_write()

    output = stdout.read().decode()
    error = stderr.read().decode()
    if error.strip():
        print(f"[ilab stderr]: {error.strip()}")
    return output
