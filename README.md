# log-gen

A Bash-based interactive tool that lets you search through one or more log files using specified keywords.  
This script helps you quickly extract important log entries and optionally save them into a timestamped report.

---

## 🚀 Features

- Accepts **single/multiple log file paths**
- Accepts **single/multiple search keywords**
- Validates:
  - File existence
  - Read permissions
  - Directory write permissions (when saving results)
- Supports two output modes:
  - **READ** — display results in the terminal
  - **SAVE** — output results into an automatically timestamped `.txt` log file
- Prevents overwriting by generating unique log filenames
- Provides clean formatting for easy reading

---

## 📦 Requirements

- **Linux** or **macOS**
- Read permissions for log files you want to analyze
- Write permissions (only if saving output)

---

## 📂 Installation

Clone or download this script to your machine.

Make the script executable:

```bash
chmod +x log_search_generator.sh

---

## 🔥 Usage
- ./gen.sh
- Enter the absolute paths of the file/files you want analyzed.
    - The script checks if the file exists and is readable.
    - If not, the program exits.
    - If no file paths are provided, the program exits.
- Next, enter the keywords you want to search for.
    - One keyword per line.
    - Case-sensitive.
- Choose output mode.
    - "READ" will display the results on the terminal.
    - "SAVE" will write the resutls to a file in a directory that you choose.
- If you choose "SAVE", you will be prompted for a directory path.
    - The script verifies that the directory exists and that the directory is writable.
    - If all conditions are met, a file will be created with the search results.


## ⚠️  Notes
- Keywords are Case-Sensitive
- Searching extremely large log files may take additional time.


## Author
- Created by Vihanga Yaddehige
