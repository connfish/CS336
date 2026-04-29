from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

def main():
    model_name = "microsoft/Phi-4-mini-instruct"

    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        torch_dtype=torch.float32,
        device_map="auto"
    )

    prompt = input("Enter a prompt: ")

    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)

    outputs = model.generate(
        **inputs,
        max_new_tokens=100,
        do_sample=True,
        temperature=0.7
    )

    result = tokenizer.decode(outputs[0], skip_special_tokens=True)
    print("\nResponse:\n")
    print(result)


if __name__ == "__main__":
    main()
