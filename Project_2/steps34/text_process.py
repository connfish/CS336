from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

# Load model once before the loop
model_name = "Qwen/Qwen2.5-3B-Instruct"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    dtype=torch.float32,
    device_map="cpu"
)

#3. Do very basic text proccessing to make a prompt it will include instructons (e.g. write an SQL query) the entire file that you
#wrote, and the user's question
#- Instructions may be along the lines of "Write an SQL query in response to the following schema and question" But you will need to experiment to see what works best.
#- The better your prompt the less text processing you will need todo, be sure to ask the other llms what good prompts might be.
with open('../steps12/subset.sql', 'r') as file:
    sql_read = file.read()

while True:
    input_from_user = input("Enter a question or type 'exit' to close: ")
    if input_from_user != "exit":
        # Build the prompt
        prompt = f"""You are a PostgreSQL expert. Given the schema below, write only a single valid PostgreSQL SELECT query to answer the question. Do not include any explanation or markdown, just the raw SQL query.
Schema:
{sql_read}

Question: {input_from_user}

SQL:"""

        print("Processing...")
        inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
        outputs = model.generate(**inputs, max_new_tokens=200, do_sample=True, temperature=0.7)
        result = tokenizer.decode(outputs[0], skip_special_tokens=True)
        sql_output = result.split("SQL:")[-1].strip()
        print("\nResponse:\n")
        print(sql_output)
    else:
        print("Exiting Program.")
        break
