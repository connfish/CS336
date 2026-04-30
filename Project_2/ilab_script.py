# Step 1 (ON ILAB): Takes a SELECT query as an argument (or stdin) and prints the results from the Postgres database.

"""
First Time Running:
    python3 -m venv ~/cs336env
    source ~/cs336env/bin/activate
    pip install psycopg2-binary pandas

How to run
    source ~/cs336env/bin/activate
    python3 ilab_script.py "SELECT * FROM loanapplication LIMIT 5;"
    echo "SELECT COUNT(*) FROM loanapplication;" | python3 ilab_script.py
"""


import sys
import psycopg2
import pandas as pd

DB_HOST = "postgres.cs.rutgers.edu"
DB_NAME = "cjf192"     
DB_USER = "cjf192"       
DB_PORT = 5432

def run_query(query: str) -> None:
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            dbname=DB_NAME,
            user=DB_USER,
            port=DB_PORT,
        )
        cursor = conn.cursor()
        cursor.execute(query)

        rows = cursor.fetchall()
        col_names = [desc[0] for desc in cursor.description]

        df = pd.DataFrame(rows, columns=col_names)
        print(df.to_string(index=False))

        cursor.close()
        conn.close()
    except psycopg2.Error as e:
        print(f"Database error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        query = " ".join(sys.argv[1:])
    elif not sys.stdin.isatty():
        query = sys.stdin.read().strip()
    else:
        #run the scripts format
        print("Usage: python3 ilab_script.py \"<SELECT query>\"", file=sys.stderr)
        sys.exit(1)

    if not query:
        print("Error: empty query.", file=sys.stderr)
        sys.exit(1)

    run_query(query)
