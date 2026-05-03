import os
import sys
import threading
import tkinter as tk
from tkinter import messagebox

import paramiko



sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from database_llm import load_model, generate_sql, extract_sql, run_on_ilab, ILAB_HOST


state = {"tokenizer": None, "model": None, "schema": None, "ssh": None}


def make_button(parent, text, command, **kwargs):
    btn = tk.Label(parent, text=text, bg="#0c82ff", fg="black",
                   cursor="hand2", relief="flat", padx=10, pady=6, **kwargs)
    btn.bind("<Button-1>", lambda e: command())
    btn.bind("<Enter>", lambda e: btn.config(bg="#3a9aff"))
    btn.bind("<Leave>", lambda e: btn.config(bg="#0c82ff"))
    return btn


def center_over(win, parent, w, h):
    parent.update_idletasks()
    px, py = parent.winfo_rootx(), parent.winfo_rooty()
    pw, ph = parent.winfo_width(), parent.winfo_height()
    if pw <= 1 or ph <= 1:
        x = (win.winfo_screenwidth() - w) // 2
        y = (win.winfo_screenheight() - h) // 2
    else:
        x = px + (pw - w) // 2
        y = py + (ph - h) // 2
    win.geometry(f"{w}x{h}+{x}+{y}")


def ilab_login(parent):
    win = tk.Toplevel(parent)
    win.title("ilab Login")
    win.configure(bg="white")
    win.transient(parent)
    win.resizable(False, False)
    center_over(win, parent, 380, 360)

    win.protocol("WM_DELETE_WINDOW", lambda: (win.destroy(), root.destroy()))

    win.lift()
    win.attributes("-topmost", True)
    win.after(50, lambda: win.attributes("-topmost", False))
    win.focus_force()
    win.grab_set()

    body = tk.Frame(win, bg="white")
    body.pack(fill="both", expand=True, padx=24, pady=20)
    body.grid_columnconfigure(0, weight=1)

    tk.Label(body, text="ilab Login", bg="white", fg="#0c82ff",
             font=("Arial", 14, "bold")).grid(row=0, column=0, pady=(0, 14))

    tk.Label(body, text="Username", bg="white", anchor="w").grid(row=1, column=0, sticky="w")
    user_entry = tk.Entry(body, bg="white", fg="black", insertbackground="black")
    user_entry.grid(row=2, column=0, sticky="ew", pady=(2, 10))

    tk.Label(body, text="Password", bg="white", anchor="w").grid(row=3, column=0, sticky="w")
    pass_entry = tk.Entry(body, show="*", bg="white", fg="black", insertbackground="black")
    pass_entry.grid(row=4, column=0, sticky="ew", pady=(2, 6))

    def attempt(event=None):
        user = user_entry.get().strip()
        pw = pass_entry.get()
        if not user or not pw:
            messagebox.showerror("Login Error", "Please enter both username and password.", parent=win)
            return
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(ILAB_HOST, username=user, password=pw)
            state["ssh"] = client
            win.destroy()
        except Exception as e:
            messagebox.showerror("Login Failed", f"Wrong username or password:\n{e}", parent=win)

    make_button(body, "Login", attempt,
                width=14, font=("Arial", 11, "bold")).grid(row=5, column=0, pady=(14, 0))

    win.bind("<Return>", attempt)
    user_entry.focus_set()

    parent.wait_window(win)


def set_box(box, text):
    box.config(state="normal")
    box.delete("1.0", tk.END)
    box.insert(tk.END, text)
    box.config(state="disabled")


def run_sql_async(sql_query):
    set_box(results_box, "Running...")

    def worker():
        try:
            result = run_on_ilab(sql_query, state["ssh"])
        except Exception as e:
            result = f"Error: {e}"
        root.after(0, lambda: set_box(results_box, result if result.strip() else "(no results)"))

    threading.Thread(target=worker, daemon=True).start()


def on_go():
    question = question_entry.get("1.0", tk.END).strip()
    if not question:
        return
    if state["model"] is None:
        messagebox.showinfo("Loading", "Model is still loading, try again shortly.")
        return
    if state["ssh"] is None:
        messagebox.showerror("Error", "Not connected to ilab.")
        return

    set_box(sql_box, "Generating...")
    set_box(results_box, "")

    def worker():
        text = generate_sql(state["tokenizer"], state["model"], state["schema"], question)
        sql_query = extract_sql(text)

        def update():
            if sql_query:
                set_box(sql_box, sql_query)
                run_sql_async(sql_query)
            else:
                set_box(sql_box, "")
                messagebox.showerror("Error", "Could not extract a valid SQL query.")
        root.after(0, update)

    threading.Thread(target=worker, daemon=True).start()


def on_enter(event):
    on_go()
    return "break"


def background_load():
    tokenizer, model = load_model()
    schema_path = os.path.join(os.path.dirname(__file__), '..', 'llm_context.sql')
    with open(schema_path, 'r') as f:
        schema = f.read()
    state["tokenizer"] = tokenizer
    state["model"] = model
    state["schema"] = schema


def show_login():
    ilab_login(root)
    if state["ssh"] is None:
        return
    if state["model"] is None:
        threading.Thread(target=background_load, daemon=True).start()


def on_clear():
    question_entry.delete("1.0", tk.END)
    set_box(sql_box, "")
    set_box(results_box, "")
    question_entry.focus_set()


root = tk.Tk()
root.title("SQL Query Generator")
root.geometry("800x850")
root.minsize(600, 700)
root.configure(bg="white")

root.grid_rowconfigure(6, weight=1)
root.grid_columnconfigure(0, weight=1)

tk.Label(root, text="Enter your question:", bg="white", fg="#0c82ff",
         font=("Arial", 16, "bold")).grid(row=0, column=0, sticky="w", padx=20, pady=(15, 4))

question_entry = tk.Text(root, height=3, wrap="word", bg="white", fg="black", insertbackground="black")
question_entry.grid(row=1, column=0, sticky="ew", padx=20, pady=4)

button_row = tk.Frame(root, bg="white")
button_row.grid(row=2, column=0, pady=10)
make_button(button_row, "Generate SQL and Run Query", on_go,
            width=28).pack(padx=6)

tk.Label(root, text="SQL:", bg="white").grid(row=3, column=0, sticky="w", padx=20)
sql_box = tk.Text(root, height=6, wrap="word", state="disabled", bg="white", fg="black")
sql_box.grid(row=4, column=0, sticky="ew", padx=20, pady=(2, 8))

tk.Label(root, text="Results:", bg="white").grid(row=5, column=0, sticky="w", padx=20)
results_box = tk.Text(root, height=10, wrap="word", state="disabled", bg="white", fg="black")
results_box.grid(row=6, column=0, sticky="nsew", padx=20, pady=(2, 8))

make_button(root, "Clear", on_clear,
            width=12).grid(row=7, column=0, pady=(0, 20))

root.bind("<Return>", on_enter)
question_entry.bind("<Return>", on_enter)
sql_box.bind("<Return>", on_enter)

root.after(150, show_login)
root.mainloop()
