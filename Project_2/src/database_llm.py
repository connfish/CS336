import getpass
import sys
import os
import paramiko
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'steps34'))
from extract_sql import extract_sql

ILAB_HOST = "ilab.cs.rutgers.edu"
ILAB_PYTHON = "~/cs336env/bin/python3"
ILAB_SCRIPT = "~/ilab_script.py"


def connect_ssh():
    print("=== ilab SSH Login ===")
    username = input("ilab username: ")
    password = getpass.getpass("ilab password: ") #securely get password input without echoing

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


def main():
    ssh_client = connect_ssh()

    print("Loading LLM (this may take a moment)...")
    model_name = "Qwen/Qwen2.5-3B-Instruct"
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        dtype=torch.float32,
        device_map="cpu",
    )
    print("LLM ready.\n")

    schema_path = os.path.join(os.path.dirname(__file__), '..', 'steps12', 'subset.sql')
    with open(schema_path, 'r') as f:
        schema = f.read()

    while True:
        user_question = input("Ask a question (or type 'exit' to quit): ")
        if user_question == "exit":
            print("Exiting program.")
            break

        prompt = (
            "You are a PostgreSQL expert. Given the schema below, write only a single "
            "valid PostgreSQL SELECT query to answer the question. Do not include any "
            "explanation or markdown, just the raw SQL query.\n\n"
            f"Schema:\n{schema}\n\n"
            f"Question: {user_question}\n\n"
            "SQL:"
        )

        print("Processing...")
        inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
        outputs = model.generate(
            **inputs, max_new_tokens=200, do_sample=True, temperature=0.7
        )
        raw = tokenizer.decode(outputs[0], skip_special_tokens=True)
        sql_query = extract_sql(raw)

        if not sql_query:
            print("Could not extract a valid SQL query from the LLM output.")
            print("Raw output:", raw)
            continue

        print(f"\nGenerated SQL:\n{sql_query}\n")

        print("Running query on ilab...")
        result = run_on_ilab(sql_query, ssh_client)
        if result.strip():
            print("\nResults:")
            print(result)
        else:
            print("Query returned no results.")

    ssh_client.close()


if __name__ == "__main__":
    main()
