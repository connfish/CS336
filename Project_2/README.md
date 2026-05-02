# CS336 Project 3 — Natural Language Database Interface

## Team Members & Contributions

| Name | Contributions |
|------|--------------|
| Connor Fisher | Ilab Scripts and ssh tunnel |
| Matthew Ko | Query Extraction from LLM output (Regular Expressions) |
| Alexandra Domanski | text proccessing and logic writing |
| [Name] | [Contributions] |

---

## How to Run

### Prerequisites
Install required packages:
```bash
pip install paramiko torch transformers
```

### Running the CLI
```bash
python database_llm.py
```
You will be prompted for your ilab username and password (password is hidden via `getpass`). The LLM will load locally, then you can ask natural language questions in a loop. Type `exit` to quit.

### Running the GUI (Extra Credit)
```bash
python extra_credit/gui.py
```
A login popup will appear, then the main window opens once the LLM is ready.

### ilab Script
`ilab_script.py` must be present on your ilab home directory at `~/ilab_script.py`. It requires `psycopg2` and `pandas` installed in a virtual environment at `~/cs336env/`:
```bash
python3 -m venv ~/cs336env
source ~/cs336env/bin/activate
pip install psycopg2-binary pandas
```

---

## File Descriptions

| File | Description |
|------|-------------|
| `database_llm.py` | Main local script — SSH connection, LLM loading, SQL generation, result display |
| `ilab_script.py` | ilab-side script — takes a SELECT query via stdin and prints results from PostgreSQL |
| `setup_prelim.sql` | DB creation script 1 — creates and loads the Preliminary staging table from CSV |
| `step_3.sql` | DB creation script 2 — builds the normalized schema from Preliminary |
| `llm_context.sql` | Trimmed schema fed to the LLM as context |
| `extra_credit/gui.py` | Tkinter desktop GUI frontend (extra credit) |

---

## What We Found Challenging

Connor: Figuring out paramiko and how to connect the python script to the ilab machine to make the ssh tunnel connection

Matthew: Figuring out how to accurately and consistently extract the query without knowing all of the different possible queries in advance. 

Alexandra: I found it challenging how to write the logic to make the loop running where it asks
questions from the user and feeding it to the llm, it was defintley a lot of trial and error. 
Additionally, it was difficult me to run it on my laptop, it might just be me specifically. 

## What We Found Interesting

Connor: Configuring the llm and how to give it context so it doesn't mess up some of the sql queries so I kind of hardcoded a bit of it's prompt messaging for better output for a specific query

Matthew: Using regular expressions to extract the query was much more clean than trying to manually loop through the output for specific words or characters

Alexandra: I found the whole concept of the assignment very interesting, being able to ask an llm a question about a data set and recieve a corresponding SQL statement that can derive that prompt.

---

## Extra Credit

Yes — we implemented the desktop GUI frontend using Python's `tkinter` library. It provides:
- A login popup for ilab SSH credentials
- A question input box with Ctrl+Enter shortcut
- Separate output panels for the generated SQL and query results
- Background threading so the UI stays responsive during LLM inference

---

## Citations & AI Transcripts

AI chat transcripts are included in `transcripts.md`.

LLM model used locally: [Qwen/Qwen2.5-3B-Instruct](https://huggingface.co/Qwen/Qwen2.5-3B-Instruct)
