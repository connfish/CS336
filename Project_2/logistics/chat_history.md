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
