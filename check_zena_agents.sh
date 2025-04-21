#!/bin/bash

# Function to check if a process with a specific LOG_NAME is running.
check_process() {
  local log_name="$1"

  if pgrep -f "LOG_NAME=$log_name" > /dev/null; then
    return 0 # Process found
  else
    return 1 # Process not found
  fi
}

# Check for agent_1
if ! check_process "agent_1"; then
  echo "ERROR: Process with LOG_NAME=agent_1 is NOT running."
  exit 1
fi

# Check for agent_2
if ! check_process "agent_2"; then
  echo "ERROR: Process with LOG_NAME=agent_2 is NOT running."
  exit 1
fi

# If both processes are running, exit with success.
echo "Processes with LOG_NAME=agent_1 and LOG_NAME=agent_2 are running."
exit 0