# Steps 2 & 3 - load the LLM and build/run prompts
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM


def load_model():
    model_name = "Qwen/Qwen2.5-3B-Instruct"
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        dtype=torch.float32,
        device_map="cpu",
    )
    return tokenizer, model


def generate_sql(tokenizer, model, schema, user_question):
    prompt = (
        "You are a PostgreSQL expert. Given the schema below, write only a single "
        "valid PostgreSQL SELECT query to answer the question. Do not include any "
        "explanation or markdown, just the raw SQL query.\n\n"
        f"Schema:\n{schema}\n\n"
        f"Question: {user_question}\n\n"
        "SQL:"
    )
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    outputs = model.generate(
        **inputs, max_new_tokens=200, do_sample=True, temperature=0.7
    )
    return tokenizer.decode(outputs[0], skip_special_tokens=True)
