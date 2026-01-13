# Setup Instructions

Complete guide for setting up and running the Natural Language Database Query System.

## Prerequisites

- Python 3.7 or higher
- SSH access to remote database server
- Minimum 4GB RAM for LLM inference
- ~2GB disk space for the model file

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/database-nlp-query.git
cd database-nlp-query
```

### 2. Install Python Dependencies
```bash
pip3 install llama-cpp-python paramiko psycopg2-binary
```

**Package Details:**
- `llama-cpp-python`: Efficient CPU inference for GGUF format models
- `paramiko`: SSH client for secure remote connections
- `psycopg2-binary`: PostgreSQL database adapter

### 3. Download the LLM Model
```bash
mkdir -p models
cd models
curl -L -o phi-3-mini.gguf "https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf"
cd ..
```

This downloads the 4-bit quantized Phi-3 mini model (~2.3GB). The download may take several minutes depending on your connection speed.

### 4. Configure Database Connection

Edit [database_llm.py](database_llm.py) if you need to change the default server:
```python
ILAB_HOST = "your-server.example.com"  # Default: ilab1.cs.rutgers.edu
ILAB_SCRIPT_PATH = "~/path/to/ilab_script.py"
```

## Running the Application

### Start the Interactive Query System
```bash
python3 database_llm.py
```

You'll be prompted for SSH credentials to connect to the remote database server:
- **Username**: Your SSH username
- **Password**: Your SSH password (input hidden)

### First Run
The first run will:
1. Establish SSH connection to remote server (~2-5 seconds)
2. Load the LLM model into memory (~30-60 seconds)
3. Initialize the interactive prompt

### Example Session
```
Your question: How many applications are in the database?
  Generating SQL query...
  Generated SQL: SELECT COUNT(*) FROM application
  Executing query on ilab...

---------------------
count
---------------------
500000
---------------------

Your question: What is the average income of owner occupied applications?
  Generating SQL query...
  Generated SQL: SELECT AVG(a.applicant_income_000s) FROM application a
                 JOIN owner_occupancy o ON a.owner_occupancy=o.owner_occupancy
                 WHERE o.owner_occupancy_name ILIKE '%owner%'
  Executing query on ilab...

---------------------
avg
---------------------
145.67
---------------------
```

Type `exit` to quit the program.

## System Architecture

```
┌──────────────────────┐
│   Local Machine      │
│                      │
│  ┌────────────────┐  │
│  │ database_llm.py│  │
│  │ - User Input   │  │
│  │ - LLM Inference│  │
│  └────────┬───────┘  │
│           │          │
│       SSH Tunnel     │
└───────────┼──────────┘
            │
            ▼
┌──────────────────────┐
│   Remote Server      │
│                      │
│  ┌────────────────┐  │
│  │ ilab_script.py │  │
│  │ - SQL Exec     │  │
│  └────────┬───────┘  │
│           │          │
│      PostgreSQL      │
└──────────────────────┘
```

## Sample Queries to Try

Once the system is running, try these example questions:

1. **Simple Aggregation:**
   - "How many applications are in the database?"
   - "What is the total loan amount?"

2. **Filtering:**
   - "How many mortgages have loan value greater than income?"
   - "How many applications were denied?"

3. **Joins and Aggregation:**
   - "What is the average income of owner occupied applications?"
   - "What is the most common denial reason?"

4. **Grouping:**
   - "Show loan counts by property type"
   - "Average loan amount by state"

## Troubleshooting

### "No module named llama_cpp"
**Solution:** Install the required package:
```bash
pip3 install llama-cpp-python
```

### "Model path does not exist"
**Solution:** Ensure the model was downloaded correctly:
```bash
ls -lh models/phi-3-mini.gguf
```
The file should be approximately 2.3GB.

### SSH Connection Fails
**Solution:** Verify your credentials and network access:
```bash
ssh your_username@your-server.example.com
```

### Database Connection Errors
**Solution:** Ensure:
- You have access to the remote database
- The database name in `ilab_script.py` is correct
- GSSAPI authentication is configured (if applicable)

### Slow Response Times
**Possible causes:**
- First query is slower due to model initialization
- Complex queries may take 5-10 seconds for generation
- Network latency for remote database execution

**Tips:**
- LLM inference time: ~2-5 seconds per query
- Use a machine with adequate RAM (4GB+ recommended)

## Advanced Configuration

### Custom Database Setup
To use with your own database:

1. Deploy `ilab_script.py` on the server with database access
2. Update connection parameters in `ilab_script.py`:
   ```python
   DB_HOST = "your-postgres-host"
   DB_NAME = "your-database-name"
   ```
3. Update `schema.sql` with your database schema
4. Adjust the prompt in `database_llm.py` to match your schema

### Performance Tuning
Adjust these parameters in `database_llm.py` for different performance characteristics:

```python
llm = Llama(
    model_path="./models/phi-3-mini.gguf",
    n_ctx=2048,        # Context window size
    n_threads=4,       # CPU threads (increase for faster inference)
    verbose=False
)
```

## Security Notes

- SSH credentials are handled securely using `getpass` (password not echoed)
- Only SELECT queries are allowed (validation in `ilab_script.py`)
- GSSAPI authentication provides passwordless database access when configured
- SQL injection is prevented through parameterized execution
