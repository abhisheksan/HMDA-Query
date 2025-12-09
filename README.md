# Database LLM Project - Project 2

Natural language interface for querying mortgage loan database using a local LLM.

## Team Members
- Person 1: [Your name] - ilab script, database connection
- Person 2: [Their name] - LLM setup, integration

## Files
- `ilab_script.py` - Runs on ilab, executes SQL queries on postgres database
- `database_llm.py` - Main program, runs locally with LLM
- `schema.sql` - Database schema fed to LLM
- `test_llm.py` - Test script for LLM

## Setup Instructions

### On ilab (Person 1)
1. Copy `ilab_script.py` to ilab
2. Install: `pip3 install --user --break-system-packages psycopg2-binary`
3. Update database credentials in script
4. Test: `python3 ilab_script.py "SELECT COUNT(*) FROM application"`

### Locally (Person 2)
1. Install: `pip3 install llama-cpp-python paramiko`
2. Download LLM model to `models/` folder
3. Test: `python3 test_llm.py`

## Progress
- [x] ilab_script.py created
- [x] schema.sql created
- [ ] LLM setup complete
- [ ] SSH tunnel working
- [ ] Full integration complete

## Challenges
(To be filled in)

## Interesting Findings
(To be filled in)

## Extra Credit
- [ ] stdin support implemented
