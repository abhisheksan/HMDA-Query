#!/usr/bin/env python3
"""
ilab_script.py - Executes SQL SELECT queries on the mortgage database
Usage: python3 ilab_script.py 'SELECT query here'
"""

import sys
import psycopg2
from psycopg2 import sql

def execute_query(query):
    """Execute SQL query and return results as formatted table"""

    # Database connection parameters
    # TODO: Replace these with YOUR database credentials from Project 1
    DB_HOST = "postgres.cs.rutgers.edu"
    DB_NAME = "aas517"  # CHANGE THIS - usually something like aas517
    DB_USER = "aas517"        # CHANGE THIS - usually your netid
    DB_PASSWORD = "Redbud$2025"    # CHANGE THIS - your database password

    try:
        # Connect to database
        print(f"Connecting to database {DB_NAME}...", file=sys.stderr)
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )

        # Create cursor
        cur = conn.cursor()

        # Execute query
        print(f"Executing query...", file=sys.stderr)
        cur.execute(query)

        # Fetch results
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]

        # Print table header
        header = " | ".join(colnames)
        separator = "-" * len(header)
        print(separator)
        print(header)
        print(separator)

        # Print rows
        if rows:
            for row in rows:
                print(" | ".join(str(val) if val is not None else "NULL" for val in row))
        else:
            print("(No rows returned)")

        print(separator)
        print(f"\nTotal rows: {len(rows)}", file=sys.stderr)

        # Close connection
        cur.close()
        conn.close()

    except psycopg2.Error as e:
        print(f"Database error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error executing query: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 ilab_script.py 'SELECT query'", file=sys.stderr)
        print("Example: python3 ilab_script.py 'SELECT COUNT(*) FROM application'", file=sys.stderr)
        sys.exit(1)

    query = sys.argv[1]

    # Basic validation - only allow SELECT queries
    if not query.strip().upper().startswith('SELECT'):
        print("Error: Only SELECT queries are allowed", file=sys.stderr)
        sys.exit(1)

    execute_query(query)
