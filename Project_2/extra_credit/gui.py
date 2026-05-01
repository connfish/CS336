import os
import sys
import threading
import tkinter as tk
from tkinter import ttk, messagebox

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from database_llm import load_model, generate_sql, extract_sql, connect_ssh, run_on_ilab

# ── colours ──────────────────────────────────────────────────────────────────
BG       = "#0f1117"
CARD     = "#1e2130"
BORDER   = "#2d3348"
ACCENT   = "#6366f1"
FG       = "#e2e8f0"
FG_DIM   = "#64748b"
SQL_COL  = "#a5f3fc"
RES_COL  = "#bbf7d0"
ERR_COL  = "#fca5a5"
ERR_BG   = "#2d1515"

FONT      = ("Segoe UI", 10)
FONT_BOLD = ("Segoe UI", 10, "bold")
MONO      = ("Courier New", 9)


class LoginDialog(tk.Toplevel):
    """Modal dialog that collects ilab username + password."""

    def __init__(self, parent):
        super().__init__(parent)
        self.title("ilab Login")
        self.resizable(False, False)
        self.configure(bg=BG)
        self.grab_set()

        self.username = tk.StringVar()
        self.password = tk.StringVar()
        self.result = None

        pad = {"padx": 16, "pady": 6}

        tk.Label(self, text="ilab SSH Login", bg=BG, fg=FG,
                 font=("Segoe UI", 12, "bold")).grid(row=0, column=0,
                 columnspan=2, pady=(18, 10))

        tk.Label(self, text="Username", bg=BG, fg=FG_DIM,
                 font=FONT).grid(row=1, column=0, sticky="e", **pad)
        tk.Entry(self, textvariable=self.username, bg=CARD, fg=FG,
                 insertbackground=FG, relief="flat",
                 font=FONT, width=24).grid(row=1, column=1, **pad)

        tk.Label(self, text="Password", bg=BG, fg=FG_DIM,
                 font=FONT).grid(row=2, column=0, sticky="e", **pad)
        tk.Entry(self, textvariable=self.password, show="•", bg=CARD, fg=FG,
                 insertbackground=FG, relief="flat",
                 font=FONT, width=24).grid(row=2, column=1, **pad)

        btn = tk.Button(self, text="Connect", bg=ACCENT, fg="white",
                        relief="flat", font=FONT_BOLD, cursor="hand2",
                        command=self._submit, padx=14, pady=6)
        btn.grid(row=3, column=0, columnspan=2, pady=(8, 18))

        self.bind("<Return>", lambda _: self._submit())
        self._center(parent)

    def _submit(self):
        u = self.username.get().strip()
        p = self.password.get()
        if u and p:
            self.result = (u, p)
            self.destroy()

    def _center(self, parent):
        self.update_idletasks()
        pw = parent.winfo_x() + parent.winfo_width() // 2
        ph = parent.winfo_y() + parent.winfo_height() // 2
        w, h = self.winfo_width(), self.winfo_height()
        self.geometry(f"+{pw - w // 2}+{ph - h // 2}")


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("CS336 SQL Query Interface")
        self.configure(bg=BG)
        self.geometry("780x600")
        self.minsize(600, 480)

        self.ssh_client = None
        self.tokenizer   = None
        self.model       = None
        self.schema      = None

        self._build_ui()
        self.after(100, self._startup)   # let window render first

    # ── UI construction ───────────────────────────────────────────────────────

    def _build_ui(self):
        HPAD = 24

        # Title
        tk.Label(self, text="CS336 SQL Query Interface", bg=BG, fg=FG,
                 font=("Segoe UI", 14, "bold")).pack(pady=(22, 2))
        tk.Label(self, text="Natural language → PostgreSQL via LLM + ilab",
                 bg=BG, fg=FG_DIM, font=("Segoe UI", 9)).pack(pady=(0, 18))

        # Question card
        q_frame = tk.Frame(self, bg=CARD, highlightbackground=BORDER,
                           highlightthickness=1)
        q_frame.pack(fill="x", padx=HPAD, pady=(0, 12))

        tk.Label(q_frame, text="YOUR QUESTION", bg=CARD, fg=FG_DIM,
                 font=("Segoe UI", 8, "bold")).pack(anchor="w", padx=14, pady=(12, 4))

        self.question_box = tk.Text(q_frame, bg=BG, fg=FG, insertbackground=FG,
                                    relief="flat", font=FONT, height=3,
                                    wrap="word", padx=8, pady=6,
                                    highlightthickness=0)
        self.question_box.pack(fill="x", padx=10, pady=(0, 4))
        self.question_box.bind("<Control-Return>", lambda _: self._run_query())
        self.question_box.bind("<Command-Return>", lambda _: self._run_query())

        btn_row = tk.Frame(q_frame, bg=CARD)
        btn_row.pack(fill="x", padx=10, pady=(0, 12))

        self.run_btn = tk.Button(btn_row, text="Run Query", bg=ACCENT, fg="white",
                                 relief="flat", font=FONT_BOLD, cursor="hand2",
                                 command=self._run_query, padx=16, pady=6)
        self.run_btn.pack(side="left")

        self.status_lbl = tk.Label(btn_row, text="", bg=CARD, fg=FG_DIM,
                                   font=("Segoe UI", 9))
        self.status_lbl.pack(side="left", padx=12)

        # Output card
        out_frame = tk.Frame(self, bg=CARD, highlightbackground=BORDER,
                             highlightthickness=1)
        out_frame.pack(fill="both", expand=True, padx=HPAD, pady=(0, 20))

        # SQL pane
        tk.Label(out_frame, text="GENERATED SQL", bg=CARD, fg=FG_DIM,
                 font=("Segoe UI", 8, "bold")).pack(anchor="w", padx=14, pady=(12, 4))

        self.sql_box = tk.Text(out_frame, bg=BG, fg=SQL_COL, relief="flat",
                               font=MONO, height=4, state="disabled",
                               padx=8, pady=6, highlightthickness=0)
        self.sql_box.pack(fill="x", padx=10)

        ttk.Separator(out_frame, orient="horizontal").pack(fill="x",
                       padx=10, pady=8)

        # Results pane
        tk.Label(out_frame, text="RESULTS", bg=CARD, fg=FG_DIM,
                 font=("Segoe UI", 8, "bold")).pack(anchor="w", padx=14, pady=(0, 4))

        res_wrap = tk.Frame(out_frame, bg=BG)
        res_wrap.pack(fill="both", expand=True, padx=10, pady=(0, 12))

        scrollbar = tk.Scrollbar(res_wrap)
        scrollbar.pack(side="right", fill="y")

        self.results_box = tk.Text(res_wrap, bg=BG, fg=RES_COL, relief="flat",
                                   font=MONO, state="disabled", padx=8, pady=6,
                                   highlightthickness=0,
                                   yscrollcommand=scrollbar.set)
        self.results_box.pack(fill="both", expand=True)
        scrollbar.config(command=self.results_box.yview)

    # ── startup sequence (runs in background thread) ──────────────────────────

    def _startup(self):
        dialog = LoginDialog(self)
        self.wait_window(dialog)

        if dialog.result is None:
            self.destroy()
            return

        username, password = dialog.result
        self._set_status("Connecting to ilab…")
        self.run_btn.config(state="disabled")

        threading.Thread(target=self._do_startup,
                         args=(username, password), daemon=True).start()

    def _do_startup(self, username, password):
        try:
            import paramiko
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect("ilab.cs.rutgers.edu", username=username, password=password)
            self.ssh_client = client

            self.after(0, self._set_status, "Loading LLM…")
            tok, mdl = load_model()
            self.tokenizer = tok
            self.model     = mdl

            schema_path = os.path.join(os.path.dirname(__file__), '..', 'llm_context.sql')
            with open(schema_path) as f:
                self.schema = f.read()

            self.after(0, self._ready)
        except Exception as e:
            self.after(0, self._startup_error, str(e))

    def _ready(self):
        self._set_status("Ready")
        self.run_btn.config(state="normal")

    def _startup_error(self, msg):
        messagebox.showerror("Startup failed", msg)
        self.destroy()

    # ── query execution ───────────────────────────────────────────────────────

    def _run_query(self):
        question = self.question_box.get("1.0", "end").strip()
        if not question:
            return
        self.run_btn.config(state="disabled")
        self._set_status("Processing…")
        self._write(self.sql_box, "")
        self._write(self.results_box, "")
        threading.Thread(target=self._do_query,
                         args=(question,), daemon=True).start()

    def _do_query(self, question):
        try:
            raw = generate_sql(self.tokenizer, self.model, self.schema, question)
            sql = extract_sql(raw)

            if not sql:
                self.after(0, self._show_error,
                           "Could not extract a valid SQL query.\n\nRaw output:\n" + raw)
                return

            self.after(0, self._write, self.sql_box, sql)
            self.after(0, self._set_status, "Running on ilab…")

            result = run_on_ilab(sql, self.ssh_client)
            output = result.strip() if result.strip() else "(no rows returned)"
            self.after(0, self._write, self.results_box, output)
            self.after(0, self._set_status, "Done")
        except Exception as e:
            self.after(0, self._show_error, str(e))
        finally:
            self.after(0, self.run_btn.config, {"state": "normal"})

    # ── helpers ───────────────────────────────────────────────────────────────

    def _set_status(self, text):
        self.status_lbl.config(text=text)

    def _write(self, widget, text):
        widget.config(state="normal")
        widget.delete("1.0", "end")
        widget.insert("1.0", text)
        widget.config(state="disabled")

    def _show_error(self, msg):
        self._set_status("Error")
        self._write(self.results_box, msg)
        self.results_box.config(fg=ERR_COL)
        self.run_btn.config(state="normal")


if __name__ == "__main__":
    App().mainloop()
