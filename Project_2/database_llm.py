import os
import re
import getpass
import paramiko
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

ILAB_HOST   = "ilab.cs.rutgers.edu"
ILAB_PYTHON = "~/cs336env/bin/python3"
ILAB_SCRIPT = "~/ilab_script.py"
MODEL_NAME  = "Qwen/Qwen2.5-3B-Instruct"


# ── SSH ───────────────────────────────────────────────────────────────────────

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
    error  = stderr.read().decode()
    if error.strip():
        print(f"[ilab stderr]: {error.strip()}")
    return output


# ── LLM ───────────────────────────────────────────────────────────────────────

def load_model():
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_NAME,
        torch_dtype=torch.float32,
        device_map="auto",
    )
    return tokenizer, model


def generate_sql(tokenizer, model, schema, user_question):
    prompt = (
        "You are a PostgreSQL expert. Given the database context below, write only a "
        "single valid PostgreSQL SELECT query to answer the question. Do not include "
        "any explanation or markdown, just the raw SQL query.\n\n"
        "IMPORTANT RULES:\n"
        "1. All table names are lowercase in the database — never quote them.\n"
        "2. loanapplication has NO race columns. To query applicant race, join through "
        "applicantrace and race. Example: "
        "SELECT COUNT(*) FROM loanapplication la "
        "JOIN applicantrace ar ON ar.application_id = la.id "
        "JOIN race r ON r.race_code = ar.race_code "
        "WHERE r.race_name = 'White';\n"
        "3. loanapplication has NO denial_reason columns. Use applicationdenialreason "
        "and denialreason to query denial reasons.\n"
        "4. loanapplication has NO location columns. Use the location table via "
        "location_id for geographic queries.\n\n"
        f"Database context:\n{schema}\n\n"
        f"Question: {user_question}\n\n"
        "SQL:"
    )
    inputs  = tokenizer(prompt, return_tensors="pt").to(model.device)
    outputs = model.generate(
        **inputs, max_new_tokens=200, do_sample=True, temperature=0.7
    )
    return tokenizer.decode(outputs[0], skip_special_tokens=True)


# ── SQL extraction ────────────────────────────────────────────────────────────

def extract_sql(llm_output):
    match = re.search(r'```(?:\w+)?\s*(.*?)```', llm_output, re.DOTALL)
    if match:
        return match.group(1).strip()

    if "SQL:" in llm_output:
        candidate = llm_output.split("SQL:")[-1].strip()
        if ";" in candidate:
            candidate = candidate[:candidate.index(";") + 1].strip()
        if candidate.upper().startswith("SELECT"):
            return candidate

    return None


# ── CLI entry point ───────────────────────────────────────────────────────────

def main():
    ssh_client = connect_ssh()

    print("Loading LLM (this may take a moment)...")
    tokenizer, model = load_model()
    print("LLM ready.\n")

    schema_path = os.path.join(os.path.dirname(__file__), 'llm_context.sql')
    with open(schema_path, 'r') as f:
        schema = f.read()

    while True:
        user_question = input("Ask a question (or type 'exit' to quit): ")
        if user_question == "exit":
            print("Exiting program.")
            break

        print("Processing...")
        raw = generate_sql(tokenizer, model, schema, user_question)

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
