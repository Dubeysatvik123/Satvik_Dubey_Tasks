import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await axios.get('http://localhost:5000/api/users');
        setUsers(response.data);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch users. Make sure the backend is running.');
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) {
    return (
      <div className="container">
        <div className="header">
          <h1>3-Tier Web Application</h1>
          <p>Frontend (React) → Backend (Node.js) → Database (PostgreSQL)</p>
        </div>
        <div className="loading">Loading users...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container">
        <div className="header">
          <h1>3-Tier Web Application</h1>
          <p>Frontend (React) → Backend (Node.js) → Database (PostgreSQL)</p>
        </div>
        <div className="error">{error}</div>
      </div>
    );
  }

  return (
    <div className="container">
      <div className="header">
        <h1>3-Tier Web Application</h1>
        <p>Frontend (React) → Backend (Node.js) → Database (PostgreSQL)</p>
      </div>
      
      <div className="user-list">
        {users.map(user => (
          <div key={user.id} className="user-card">
            <h3>{user.name}</h3>
            <p><strong>Email:</strong> {user.email}</p>
            <p><strong>Role:</strong> {user.role}</p>
            <p><strong>ID:</strong> {user.id}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
