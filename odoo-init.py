from passlib.context import CryptContext
import psycopg2
import os
import time
import subprocess

MAX_RETRIES = 60

def get_connection():
  connection = None
  retries = 0
  while not connection and retries < MAX_RETRIES:
    try:
        connection_string = "dbname='" + os.environ['POSTGRES_DB'] + "' user='" + os.environ['POSTGRES_USER'] + "' host='" + os.environ['POSTGRES_HOST'] + "' password='" + os.environ['POSTGRES_PASSWORD'] + "'"
        return psycopg2.connect(connection_string) 
    except Exception as e:
        retries += 1
        print(f"Waiting for database... {e}")
        print(f"Retrying ({retries}/{MAX_RETRIES})...")
        time.sleep(2)
  return None

try:

  # Wait for database and admin table to be initialized
  connection = get_connection();
  if (not connection):
    print("Unable to connect to database")
    exit(1)

  # Check if initialization already done
  cursor = connection.cursor()
  cursor.execute("CREATE TABLE IF NOT EXISTS diploi_parameters(key TEXT PRIMARY KEY, value TEXT)");
  cursor.execute("SELECT * FROM diploi_parameters WHERE key = 'initialization'")
  result = cursor.fetchone()

  # Initialize odoo if not already done
  if (not result):
    print("Initializing odoo database")
    return_code = subprocess.call("/odoo-init.sh", shell=True)
    print(return_code);
    if (return_code != 0):
      print("Error initializing odoo.. bailing out")
      exit(1)
    cursor.execute("INSERT INTO diploi_parameters (key, value) VALUES ('initialization', 'done')")
  
  connection.commit()
  connection.close()

  connection = get_connection();
  if (not connection):
    print("Unable to connect to database(2)")
    exit(1)

  cursor = connection.cursor()
  cursor.execute("SELECT * FROM diploi_parameters WHERE key = 'admin_password_fix'")
  result = cursor.fetchone()
  if (not result):
    password_hash = CryptContext(['pbkdf2_sha512']).hash(os.environ['INITIAL_ADMIN_PASSWORD'])
    cursor.execute("UPDATE res_users SET password = '" + password_hash + "' WHERE login = 'admin'")
    cursor.execute("INSERT INTO diploi_parameters (key, value) VALUES ('admin_password_fix', 'done')")
    print("Admin password set")
  
  connection.commit()
  connection.close()

except Exception as e:
  print("Error", e)
  exit(1)

exit(0)

