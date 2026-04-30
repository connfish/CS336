# Steps 2 & 3 - load the LLM and build/run prompts
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM


def load_model():
    model_name = "Qwen/Qwen2.5-3B-Instruct"
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        dtype=torch.float32,
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
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    outputs = model.generate(
        **inputs, max_new_tokens=200, do_sample=True, temperature=0.7
    )
    return tokenizer.decode(outputs[0], skip_special_tokens=True)
