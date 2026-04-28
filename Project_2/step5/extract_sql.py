import re

def extract_sql(llm_output):

    # Match content inside ```...``` blocks (with optional language tag)
    match = re.search(r'```(?:\w+)?\s*(.*?)```', llm_output, re.DOTALL)

    if match:
        return match.group(1).strip()
    
    # Allie's method if mine fails
    if "SQL:" in llm_output:
        candidate = llm_output.split("SQL:")[-1].strip()
        if ";" in candidate:
            candidate = candidate[:candidate.index(";") + 1].strip()
        if candidate.upper().startswith("SELECT"):
            return candidate
    
    return None