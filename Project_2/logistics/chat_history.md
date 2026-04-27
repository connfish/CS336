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
 