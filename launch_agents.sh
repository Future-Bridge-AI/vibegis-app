#!/bin/bash

# VibeGIS Multi-Agent System Launcher
# This script launches all 6 specialized Claude Code agents for the VibeGIS project

echo "Starting VibeGIS Multi-Agent System..."

# Create log directory if it doesn't exist
mkdir -p ./logs

# Function to launch an agent and redirect output to a log file
launch_agent() {
    local agent_name=$1
    local config_file=$2
    local log_file="./logs/${agent_name}.log"
    
    echo "Launching ${agent_name} agent..."
    claude-code --agent-mode "${agent_name}" --config-file "${config_file}" > "${log_file}" 2>&1 &
    echo "${agent_name} agent started with PID $! (logs: ${log_file})"
}

# Launch all agents
launch_agent "product-owner" "product_owner_agent_config.md"
launch_agent "architecture" "architecture_agent_config.md"
launch_agent "backend-dev" "backend_development_agent_config.md"
launch_agent "frontend-dev" "frontend_development_agent_config.md"
launch_agent "devops" "devops_agent_config.md"
launch_agent "qa" "qa_agent_config.md"

echo "All agents launched successfully!"
echo "Use 'ps aux | grep claude-code' to check running agents"
echo "Check the ./logs directory for agent output"