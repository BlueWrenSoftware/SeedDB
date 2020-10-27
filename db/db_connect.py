import sqlite3
import sys
from sqlite3 import Error

def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print(e)
    return conn

def select_view(conn):
    cur = conn.cursor()
    cur.execute("SELECT * FROM ViewSeedList2")
    rows = cur.fetchall()
    for row in rows:
        print(row)

conn = sqlite3.connect('seed.db')
select_view(conn)
conn.close()
