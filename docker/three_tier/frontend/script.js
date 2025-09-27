// API Configuration
const API_BASE_URL = 'http://backend:5001';

// DOM Elements
const userForm = document.getElementById('userForm');
const usersList = document.getElementById('usersList');
const refreshBtn = document.getElementById('refreshBtn');
const backendStatus = document.getElementById('backendStatus');
const dbStatus = document.getElementById('dbStatus');

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    loadUsers();
    checkSystemStatus();
    
    // Set up event listeners
    userForm.addEventListener('submit', handleUserSubmit);
    refreshBtn.addEventListener('click', loadUsers);
    
    // Check status every 30 seconds
    setInterval(checkSystemStatus, 30000);
});

// Handle user form submission
async function handleUserSubmit(event) {
    event.preventDefault();
    
    const formData = new FormData(userForm);
    const userData = {
        name: formData.get('name'),
        email: formData.get('email')
    };
    
    try {
        const response = await fetch(`${API_BASE_URL}/users`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(userData)
        });
        
        if (response.ok) {
            const newUser = await response.json();
            showMessage('User added successfully!', 'success');
            userForm.reset();
            loadUsers(); // Refresh the users list
        } else {
            const error = await response.json();
            showMessage(`Error: ${error.error}`, 'error');
        }
    } catch (error) {
        console.error('Error adding user:', error);
        showMessage('Failed to add user. Please try again.', 'error');
    }
}

// Load users from the API
async function loadUsers() {
    try {
        usersList.innerHTML = '<div class="loading">Loading users...</div>';
        
        const response = await fetch(`${API_BASE_URL}/users`);
        
        if (response.ok) {
            const data = await response.json();
            displayUsers(data.users);
        } else {
            usersList.innerHTML = '<div class="error">Failed to load users</div>';
        }
    } catch (error) {
        console.error('Error loading users:', error);
        usersList.innerHTML = '<div class="error">Failed to connect to backend</div>';
    }
}

// Display users in the UI
function displayUsers(users) {
    if (users.length === 0) {
        usersList.innerHTML = '<div class="loading">No users found</div>';
        return;
    }
    
    const usersHTML = users.map(user => `
        <div class="user-item">
            <h4>${escapeHtml(user.name)}</h4>
            <p><strong>Email:</strong> ${escapeHtml(user.email)}</p>
            <p><strong>Created:</strong> ${formatDate(user.created_at)}</p>
            <p class="user-id">ID: ${user.id}</p>
        </div>
    `).join('');
    
    usersList.innerHTML = usersHTML;
}

// Check system status
async function checkSystemStatus() {
    // Check backend status
    try {
        const response = await fetch(`${API_BASE_URL}/health`);
        if (response.ok) {
            backendStatus.textContent = 'Healthy';
            backendStatus.className = 'status-value healthy';
        } else {
            backendStatus.textContent = 'Unhealthy';
            backendStatus.className = 'status-value unhealthy';
        }
    } catch (error) {
        backendStatus.textContent = 'Unreachable';
        backendStatus.className = 'status-value unhealthy';
    }
    
    // Check database status through backend
    try {
        const response = await fetch(`${API_BASE_URL}/users`);
        if (response.ok) {
            dbStatus.textContent = 'Connected';
            dbStatus.className = 'status-value healthy';
        } else {
            dbStatus.textContent = 'Error';
            dbStatus.className = 'status-value unhealthy';
        }
    } catch (error) {
        dbStatus.textContent = 'Unreachable';
        dbStatus.className = 'status-value unhealthy';
    }
}

// Show message to user
function showMessage(message, type) {
    // Remove existing messages
    const existingMessages = document.querySelectorAll('.success, .error');
    existingMessages.forEach(msg => msg.remove());
    
    // Create new message
    const messageDiv = document.createElement('div');
    messageDiv.className = type;
    messageDiv.textContent = message;
    
    // Insert at the top of the user section
    const userSection = document.querySelector('.user-section');
    userSection.insertBefore(messageDiv, userSection.firstChild);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        messageDiv.remove();
    }, 5000);
}

// Utility functions
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatDate(dateString) {
    if (!dateString) return 'Unknown';
    
    const date = new Date(dateString);
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
}
