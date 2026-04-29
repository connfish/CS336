import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

from database_llm import connect_ssh, run_on_ilab   # Step 6
from text_process import load_model, generate_sql   # Steps 2 & 3
from extract_sql import extract_sql                  # Step 5


def main():
    # Step 6 
    ssh_client = connect_ssh()

    # Step 2 - load the LLM
    print("Loading LLM (this may take a moment)...")
    tokenizer, model = load_model()
    print("LLM ready.\n")

    # Step 1 (local) 
    schema_path = os.path.join(os.path.dirname(__file__), 'src', 'subset.sql')
    with open(schema_path, 'r') as f:
        schema = f.read()

    # Step 4 
    while True:
        user_question = input("Ask a question (or type 'exit' to quit): ")
        if user_question == "exit":
            print("Exiting program.")
            break

        # Step 3
        print("Processing...")
        raw = generate_sql(tokenizer, model, schema, user_question)

        # Step 5
        sql_query = extract_sql(raw)
        if not sql_query:
            print("Could not extract a valid SQL query from the LLM output.")
            print("Raw output:", raw)
            continue

        print(f"\nGenerated SQL:\n{sql_query}\n")

        # Step 7
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
