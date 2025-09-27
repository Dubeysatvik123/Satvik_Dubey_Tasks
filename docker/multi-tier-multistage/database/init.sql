-- Initialize the database with sample data
-- This script will be executed when the PostgreSQL container starts

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample users
INSERT INTO users (name, email, role) VALUES 
    ('John Doe', 'john.doe@example.com', 'Admin'),
    ('Jane Smith', 'jane.smith@example.com', 'User'),
    ('Bob Johnson', 'bob.johnson@example.com', 'Manager'),
    ('Alice Brown', 'alice.brown@example.com', 'User'),
    ('Charlie Wilson', 'charlie.wilson@example.com', 'Developer')
ON CONFLICT (email) DO NOTHING;

-- Create an index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Display the inserted data
SELECT 'Database initialized successfully!' as message;
SELECT COUNT(*) as total_users FROM users;
