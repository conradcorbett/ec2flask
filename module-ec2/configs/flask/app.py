from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL
import yaml
import os
import psycopg2

app = Flask(__name__)

# Configure mysqldb
dbconfig = yaml.safe_load(open('db.yaml'))
#app.config['MYSQL_HOST'] = dbconfig['mysql_host']
#app.config['MYSQL_USER'] = dbconfig['mysql_user']
#app.config['MYSQL_PASSWORD'] = dbconfig['mysql_password']
#app.config['MYSQL_DB'] = dbconfig['mysql_db']

# Configure postgressql
def get_db_connection():
    conn = psycopg2.connect(host=dbconfig['mysql_host'],
                            database=dbconfig['mysql_db'],
                            user=dbconfig['mysql_user'],
                            password=dbconfig['mysql_password'])
    return conn

#mysql = MySQL(app)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        conn = get_db_connection()
        # Fetch form data
        userDetails = request.form
        name = userDetails['name']
        email = userDetails['email']
        cur = conn.cursor()
#        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO users (name, email) VALUES(%s, %s);',(name, email))
#        mysql.connection.commit()
        conn.commit()
        cur.close()
        conn.close()
        return redirect('/users')
    return render_template('index.html')

@app.route('/users')
def users():
    conn = get_db_connection()
    cur = conn.cursor()
#    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM users;')
    userDetails = cur.fetchall()
    cur.close()
    cur = conn.cursor()
    cur.execute('SELECT current_user;')
    dbUser = cur.fetchall()
#    if resultValue:
#        userDetails = cur.fetchall()
    return render_template('users.html', userDetails=userDetails)
#    return render_template('users.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')