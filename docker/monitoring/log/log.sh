#!/bin/bash

# Port for the web UI
PORT=8080

# Docker socket
DOCKER_SOCKET="/var/run/docker.sock"

# Temporary HTML file
HTML_FILE="/tmp/docker_logs.html"

# Generate HTML page
generate_html() {
cat <<EOF > "$HTML_FILE"
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Docker Container Logs</title>
<style>
body { font-family: Arial; margin: 20px; }
h2 { margin-top: 30px; }
select, pre { width: 100%; margin-top: 10px; }
pre { background: #f4f4f4; padding: 10px; border: 1px solid #ccc; overflow-x: auto; max-height: 500px; }
</style>
<script>
async function fetchLogs() {
    let containerId = document.getElementById('containerSelect').value;
    if(!containerId) return;
    let response = await fetch('/logs?container=' + containerId);
    let text = await response.text();
    document.getElementById('logs').textContent = text;
}
</script>
</head>
<body>
<h1>Docker Container Logs</h1>
<label for="containerSelect">Select Container:</label>
<select id="containerSelect" onchange="fetchLogs()">
<option value="">--Select--</option>
EOF

# List containers from Docker API
curl -s --unix-socket $DOCKER_SOCKET http://v1.41/containers/json | \
jq -r '.[] | "<option value=\"" + .Id + "\">" + .Names[0] + " (" + .Id[:12] + ")</option>"' >> "$HTML_FILE"

cat <<EOF >> "$HTML_FILE"
</select>
<pre id="logs">Select a container to view logs...</pre>
</body>
</html>
EOF
}

# Simple web server using netcat
start_server() {
    while true; do
        { 
            # Read request
            read request
            container=$(echo $request | grep -oP 'GET /logs\?container=\K[^ ]*')
            
            if [ "$container" ]; then
                # Fetch logs from Docker API
                logs=$(curl -s --unix-socket $DOCKER_SOCKET http://v1.41/containers/$container/logs?stdout=true&stderr=true&tail=100)
                echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n$logs"
            else
                generate_html
                echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n$(cat $HTML_FILE)"
            fi
        } | nc -l -p $PORT -q 1
    done
}

echo "Starting Docker Logs UI on http://localhost:$PORT"
start_server

