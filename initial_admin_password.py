from passlib.context import CryptContext
import psycopg2
import os
import time

# Wait max 2 minutes for initialization
MAX_RETRIES = 60 

def wait_for_admin_user_to_be_ready():
    connection = None
    retries = 0
    while (not connection) and retries < MAX_RETRIES:
        try:
            connection_string = "dbname='" + os.environ['POSTGRES_DB'] + "' user='" + os.environ['POSTGRES_USER'] + "' host='" + os.environ['POSTGRES_HOST'] + "' password='" + os.environ['POSTGRES_PASSWORD'] + "'"
            connection = psycopg2.connect(connection_string)
            cursor = connection.cursor()
            cursor.execute("SELECT * FROM res_users WHERE login = 'admin'")
            result = cursor.fetchone()
            if result:
              print(result)
              return connection
            else:
              connection = None;
              raise Exception("Admin user not yet found")
        except Exception as e:
            retries += 1
            print(f"Waiting for database... {e}")
            print(f"Retrying ({retries}/{MAX_RETRIES})...")
            time.sleep(2)
    return None

# Wait for database and admin table to be initialized
connection = wait_for_admin_user_to_be_ready();
if (not connection):
  print("Unable to fix admin password")
  exit(1)

# Update admin password if not already done
try:
  cursor = connection.cursor()
  cursor.execute("CREATE TABLE IF NOT EXISTS diploi_parameters(key TEXT PRIMARY KEY, value TEXT)");
  cursor.execute("SELECT * FROM diploi_parameters WHERE key = 'admin_password_fix'")
  result = cursor.fetchone()
  if (not result):
    password_hash = CryptContext(['pbkdf2_sha512']).hash(os.environ['INITIAL_ADMIN_PASSWORD'])
    cursor.execute("UPDATE res_users SET password = '" + password_hash + "' WHERE login = 'admin'")
    cursor.execute("INSERT INTO diploi_parameters (key, value) VALUES ('admin_password_fix', 'done')")
    print("Admin password set")
  else:
    print("Admin password already fixed")
except Exception as e:
  retries += 1
  print(f"Waiting for database... {e}")
  print(f"Retrying ({retries}/{MAX_RETRIES})...")
  exit(1)

connection.commit()
connection.close()

exit(0)
