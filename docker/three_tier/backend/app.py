from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
    'database': os.getenv('DB_NAME', 'appdb'),
    'user': os.getenv('DB_USER', 'appuser'),
    'password': os.getenv('DB_PASSWORD', 'apppass')
}

def get_db_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except:
        return None

@app.route('/')
def home():
    return jsonify({'message': '3-Tier App Backend', 'status': 'running'})

@app.route('/users')
def get_users():
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor()
        cursor.execute("SELECT id, name, email FROM users")
        users = cursor.fetchall()
        
        user_list = []
        for user in users:
            user_list.append({
                'id': user[0],
                'name': user[1],
                'email': user[2]
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({'users': user_list})
    
    except Exception as e:
        return jsonify({'error': 'Failed to fetch users'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)