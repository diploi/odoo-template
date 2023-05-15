from passlib.context import CryptContext
import psycopg2
import os

password_hash = CryptContext(['pbkdf2_sha512']).hash(os.environ['INITIAL_ADMIN_PASSWORD'])

try:
    connstring = "dbname='" + os.environ['POSTGRES_DB'] + "' user='" + os.environ['POSTGRES_USER'] + "' host='" + os.environ['POSTGRES_HOST'] + "' password='" + os.environ['POSTGRES_PASSWORD'] + "'";
    conn = psycopg2.connect(connstring)
    cur = conn.cursor()
    cur.execute("UPDATE res_users SET password = '" + password_hash + "' WHERE login = 'admin'")
    conn.commit()
    conn.close()
except Exception as e:
    print("Error" + str(e))