#!/usr/bin/env bash
# sandbox.sh - Sandbox session management for exercises

SANDBOX_SESSION="tmux-learn-sandbox"
TUTORIAL_SESSION="tmux-learn"

# Create a fresh sandbox session
sandbox_create() {
    # Kill existing sandbox if any
    tmux kill-session -t "$SANDBOX_SESSION" 2>/dev/null || true

    # Create new sandbox session (detached)
    tmux new-session -d -s "$SANDBOX_SESSION"
}

# Destroy the sandbox session
sandbox_destroy() {
    tmux kill-session -t "$SANDBOX_SESSION" 2>/dev/null || true
}

# Switch user to sandbox session
sandbox_switch_to() {
    tmux switch-client -t "$SANDBOX_SESSION"
}

# Switch user back to tutorial session
sandbox_switch_back() {
    tmux switch-client -t "$TUTORIAL_SESSION"
}

# Create a sandbox as a split pane in the current window
# The left pane stays with the tutorial, right pane is the sandbox
sandbox_create_split() {
    local sandbox_pane
    # Split horizontally: current pane becomes left, new pane on right
    sandbox_pane=$(tmux split-window -h -P -F '#{pane_id}')
    echo "$sandbox_pane"
}

# Close the sandbox split pane
sandbox_close_split() {
    local pane_id="$1"
    tmux kill-pane -t "$pane_id" 2>/dev/null || true
}

# Reset sandbox to clean state (kill all windows/panes, back to single window)
sandbox_reset() {
    sandbox_destroy
    sandbox_create
}

# Create sandbox with a specific number of windows
sandbox_create_with_windows() {
    local num_windows="$1"
    sandbox_create

    for ((i = 1; i < num_windows; i++)); do
        tmux new-window -t "$SANDBOX_SESSION"
    done

    # Go back to first window
    tmux select-window -t "${SANDBOX_SESSION}:0" 2>/dev/null || \
    tmux select-window -t "${SANDBOX_SESSION}:1" 2>/dev/null
}

# Send text to the sandbox (useful for setting up scenarios)
sandbox_send_text() {
    local text="$1" target="${2:-${SANDBOX_SESSION}}"
    tmux send-keys -t "$target" "$text" Enter
}

# Put a marker in a specific sandbox pane
sandbox_mark_pane() {
    local target="$1" marker="$2"
    tmux send-keys -t "$target" "echo '${marker}'" Enter
}
