# Script to initialize Windows OpenSSH agent

# Check for running agent
ssh-add -l | Out-Null
$agent_agent_run_state = $?
if ( -not $agent_agent_run_state ) {
    # Start agent
    ssh-agent
    $agent_agent_run_state = $?
}

# Load keys if the agent is running
if ( $agent_agent_run_state ) {
    ssh-add
    ssh-add @(Get-ChildItem $env:USERPROFILE\.ssh\*-id_* -Exclude *.pub)
}
