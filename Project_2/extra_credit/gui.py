import os
import sys
import threading
import tkinter as tk
from tkinter import ttk, messagebox

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from database_llm import load_model, generate_sql, extract_sql, connect_ssh, run_on_ilab

#set up window for GUI
root = tk.Tk()
root.title("SQL Query Generator")
root.geometry("800x600")
root.configure(bg="white")

#question with input generate SQL query
tk.Label(root, text="Enter your question:", bg="white", fg="#0c82ff", font=("Arial", 20, "bold")).pack(pady=10)
question_entry = tk.Text(root, width=50, height=3, bg="white", fg="#0c82ff")
question_entry.pack(pady=5)

#button to generate SQL query
def on_click():
    question = question_entry.get("1.0", tk.END).strip()
    if not question:
        return
    
    text = generate_sql(tokenizer, model, schema, question)
    sql_query = extract_sql(text)
    if sql_query:
        output_text.delete("1.0", tk.END)
        output_text.insert(tk.END, sql_query)
    else:
        messagebox.showerror("Error", "Could not extract a valid SQL query from the LLM output.")
    output_text.config(state="disabled")



tk.Button(root, text="Generate SQL", bg="#0c82ff", fg="black", relief="flat", borderwidth=2, command=on_click).pack(pady=10)
#output box
output_text = tk.Text(root, height=10, width=50, bg="#ffffff", fg="#0c82ff")
output_text.pack(pady=10)

root.mainloop()