# CS336 Project 2 - LLM Chat History

---

## Session: 2026-04-20

### Q: How should I run this python script on the Ilab machine?

**Context:** Part 1 (ON ILAB) requires a stub Python program that takes a SELECT SQL query as an argument and prints results from the CS336 PostgreSQL database.

**Response:**
`ilab_script.py` was already written correctly. Steps to run it:

1. Copy to ilab: `scp ilab_script.py cjf192@ilab.cs.rutgers.edu:~/`
2. SSH in: `ssh cjf192@ilab.cs.rutgers.edu`
3. Install deps: `pip3 install --user psycopg2-binary pandas`
4. Test: `python3 ilab_script.py "SELECT * FROM loanapplication LIMIT 5;"`

---

### Q: Getting error: externally-managed-environment when running pip3 install

**Error:** Debian/ilab blocks direct pip installs due to PEP 668.

**Response:** Use a virtual environment:

```bash
python3 -m venv ~/cs336env
source ~/cs336env/bin/activate
pip install psycopg2-binary pandas
python3 ilab_script.py "SELECT * FROM loanapplication LIMIT 5;"
```

Next time you SSH in, run `source ~/cs336env/bin/activate` before running the script.

---
## Session: 2026-04-26
 
### Q: Does the llm_test have anything to do with the text processing?
 
**Context:** Text processing in steps 3 requires usage of an llm call and was wondering if it was necessary for this step 3 and 4.
 
**Response:** Nothing! You're done with it. It was just a test file to make sure the LLM worked — think of it as a practice run.
 
---
 
### Q: If I were to write questions to prompt the user, such as "Write an SQL query in response to the following schema and question" what would be the best prompts to do less text processing, what would good prompts be?
 
**Context:** Step 3 requires building a prompt that combines instructions, the schema file, and the user's question. A better prompt means less text cleanup needed in step 5.
 
**Response:**
 
The key tricks to get clean SQL output with minimal post-processing:
 
1. **End your prompt with `SQL:`** — the assignment hints at this directly. It forces the LLM to immediately start writing SQL instead of explaining things first.
2. **Be explicit that you only want the query:**
```
You are a SQL expert. Only return a single SQL SELECT query, no explanation.
 
Schema:
{schema}
 
Question: {user_question}
 
SQL:
```
 
3. **Specify the database type** to get more accurate syntax:
```
Write a single PostgreSQL SELECT query...
```
 
The worst thing that happens is the LLM starts with "Sure! Here is your query..." — a direct prompt avoids that. Ending with `SQL:` is the most reliable trick to make the LLM immediately output the query.
 
---
 
### Q: If I were to write questions to prompt the user, such as "Write an SQL query in response to the following schema and question" what would be the best prompts to do less text processing, what would good prompts be?
 
**Context:** Step 3 requires building a prompt that combines instructions, the schema file, and the user's question. A better prompt means less text cleanup needed in step 5.
 
**Response:**
 
The key tricks to get clean SQL output with minimal post-processing:
 
1. **End your prompt with `SQL:`** — the assignment hints at this directly. It forces the LLM to immediately start writing SQL instead of explaining things first.
2. **Be explicit that you only want the query:**
```
You are a SQL expert. Only return a single SQL SELECT query, no explanation.
 
Schema:
{schema}
 
Question: {user_question}
 
SQL:
```
 
3. **Specify the database type** to get more accurate syntax:
```
Write a single PostgreSQL SELECT query...
```
 
The worst thing that happens is the LLM starts with "Sure! Here is your query..." — a direct prompt avoids that. Ending with `SQL:` is the most reliable trick to make the LLM immediately output the query.
 
---
 
## Session: 2026-04-28

### Q: I'm on windows, how do I run this? What do I need to change? 

#### Create virtual environment
#### python3 -m venv llm_env

#### Activate it
#### source llm_env/bin/activate

#### Install CPU-only PyTorch
#### pip install torch --index-url https://download.pytorch.org/whl/cpu

#### Install remaining packages
#### pip install transformers accelerate

#### to run model use this inside the virtual environment
#### python3 llm_test.py


**Context** Using a Windows computer and needed to set up virtual environment

**Response**

On Windows, you need a few changes:
batch# Create virtual environment
python -m venv llm_env

#### Activate it  (Windows uses a different activation script)
llm_env\Scripts\activate

#### Install CPU-only PyTorch
pip install torch --index-url https://download.pytorch.org/whl/cpu

#### Install remaining packages
pip install transformers accelerate

#### Run your script
python llm_test.py
The two things that change on Windows are:
python3 → python — Windows typically uses python rather than python3 in the command prompt or PowerShell.
source llm_env/bin/activate → llm_env\Scripts\activate — On Windows the activation script lives in Scripts\ (not bin/) and you don't use source to run it. Just call it directly.
Everything else (the pip installs, the PyTorch index URL) stays the same.

Tip: Run these commands in Command Prompt or PowerShell. If you're using PowerShell and get an error about script execution being disabled, run Set-ExecutionPolicy -Scope CurrentUser RemoteSigned first, then try activating again.

---

### Q: I am now using an LLM and I want to extract the SQL query only. Can you help me? This is what is printed into the terminal:

#### SELECT COUNT(*) 
#### FROM LoanApplication 
#### WHERE loan_amount_000s > applicant_income_000s;

**Context** Step 5 requires text cleanup of the output from the llm from previous steps and I would like to use regex.

**Response** 

Sure! You can extract just the SQL query from the output by stripping the markdown code fences. Here's a simple utility function:

````
python

import re

def extract_sql(text):
    # Match content inside ```...``` blocks (with optional language tag)
    match = re.search(r'```(?:\w+)?\s*(.*?)```', text, re.DOTALL)
    if match:
        return match.group(1).strip()
    return text.strip()  # fallback: return as-is if no code fences found
````

Then use it on whatever your LLM returns:
python
raw_output = llm_response  # whatever your model generates
sql = extract_sql(raw_output)
print(sql)
This will give you just:
SELECT COUNT(*) 
FROM LoanApplication 
WHERE loan_amount_000s > applicant_income_000s;
The regex works by:

 ```(?:\w+)? — matches the opening fence and optional language tag (like sql)
\s*(.*?) — captures everything after it (non-greedy)
``` — stops at the closing fence
re.DOTALL — makes . match newlines so multi-line queries are captured

If your LLM sometimes returns queries without code fences, the fallback return text.strip() handles that case too.

---

## Session: 2026-04-28 (continued)

### Q: I need to do step 6 — use an SSH tunnel to call ilab_script.py with the SQL output from the LLM.

**Context:** Step 6 requires connecting to ilab via SSH using paramiko and getpass, sending the extracted SQL to ilab_script.py, and printing the results back to the user.

**Response:**

Created `step6/database_llm.py` which:
1. Prompts for ilab username (visible) and password via `getpass.getpass()` (hidden)
2. Opens an SSH connection to `ilab.cs.rutgers.edu` using paramiko
3. Sends the extracted SQL to `ilab_script.py` via stdin over the tunnel
4. Prints the returned table to the user

Install paramiko before running:
```bash
pip install paramiko
```

Run with:
```bash
python step6/database_llm.py
```

---

### Q: Is database_llm.py taking passwords in a visible way?

**Context:** The assignment requires passwords not be taken visibly and to use the getpass library.

**Response:** No — the password is already secure. `getpass.getpass("ilab password: ")` hides input so nothing is echoed to the terminal. The username uses `input()` which is visible, but that is intentional since usernames are not sensitive. The assignment requirement is already satisfied.

---
