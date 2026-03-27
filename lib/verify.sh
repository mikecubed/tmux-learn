#!/usr/bin/env bash
# verify.sh - Exercise verification framework

VERIFY_MESSAGE=""
VERIFY_HINT=""

# Reset verification state
verify_reset() {
    VERIFY_MESSAGE=""
    VERIFY_HINT=""
}

# Check if a session exists
verify_session_exists() {
    local name="$1"
    verify_reset
    if tmux has-session -t "$name" 2>/dev/null; then
        VERIFY_MESSAGE="Session '$name' exists"
        return 0
    else
        VERIFY_MESSAGE="Session '$name' not found"
        VERIFY_HINT="Create a session with: tmux new-session -s $name"
        return 1
    fi
}

# Check if a session does NOT exist (for kill exercises)
verify_session_not_exists() {
    local name="$1"
    verify_reset
    if ! tmux has-session -t "$name" 2>/dev/null; then
        VERIFY_MESSAGE="Session '$name' has been removed"
        return 0
    else
        VERIFY_MESSAGE="Session '$name' still exists"
        VERIFY_HINT="Kill the session with: tmux kill-session -t $name"
        return 1
    fi
}

# Check number of sessions (excluding tutorial sessions)
verify_session_count() {
    local expected="$1"
    verify_reset
    local count
    count=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -cv '^tmux-learn' || echo 0)

    if ((count >= expected)); then
        VERIFY_MESSAGE="Found $count session(s) (expected at least $expected)"
        return 0
    else
        VERIFY_MESSAGE="Found $count session(s), but expected at least $expected"
        VERIFY_HINT="Create more sessions with: tmux new-session -d -s <name>"
        return 1
    fi
}

# Check window count in a session
verify_window_count() {
    local session="$1" expected="$2"
    verify_reset
    local count
    count=$(tmux list-windows -t "$session" 2>/dev/null | wc -l | tr -d ' ')

    if ((count >= expected)); then
        VERIFY_MESSAGE="Session '$session' has $count window(s) (expected at least $expected)"
        return 0
    else
        VERIFY_MESSAGE="Session '$session' has $count window(s), but expected at least $expected"
        VERIFY_HINT="Create windows with Prefix + c or: tmux new-window -t $session"
        return 1
    fi
}

# Check exact window count
verify_window_count_exact() {
    local session="$1" expected="$2"
    verify_reset
    local count
    count=$(tmux list-windows -t "$session" 2>/dev/null | wc -l | tr -d ' ')

    if ((count == expected)); then
        VERIFY_MESSAGE="Session '$session' has exactly $count window(s)"
        return 0
    else
        VERIFY_MESSAGE="Session '$session' has $count window(s), expected exactly $expected"
        return 1
    fi
}

# Check if a window has a specific name
verify_window_name() {
    local session="$1" index="$2" expected_name="$3"
    verify_reset
    local actual_name
    actual_name=$(tmux display-message -t "${session}:${index}" -p '#{window_name}' 2>/dev/null)

    if [[ "$actual_name" == "$expected_name" ]]; then
        VERIFY_MESSAGE="Window ${index} is named '$expected_name'"
        return 0
    else
        VERIFY_MESSAGE="Window ${index} is named '$actual_name', expected '$expected_name'"
        VERIFY_HINT="Rename with Prefix + , or: tmux rename-window -t ${session}:${index} $expected_name"
        return 1
    fi
}

# Check if any window has a specific name
verify_window_name_exists() {
    local session="$1" expected_name="$2"
    verify_reset
    local names
    names=$(tmux list-windows -t "$session" -F '#{window_name}' 2>/dev/null)

    if echo "$names" | grep -qx "$expected_name"; then
        VERIFY_MESSAGE="Found window named '$expected_name'"
        return 0
    else
        VERIFY_MESSAGE="No window named '$expected_name' found"
        VERIFY_HINT="Rename a window with Prefix + , or: tmux rename-window '$expected_name'"
        return 1
    fi
}

# Check pane count in current window or specific target
verify_pane_count() {
    local target="$1" expected="$2"
    verify_reset
    local count
    count=$(tmux list-panes -t "$target" 2>/dev/null | wc -l | tr -d ' ')

    if ((count >= expected)); then
        VERIFY_MESSAGE="Found $count pane(s) (expected at least $expected)"
        return 0
    else
        VERIFY_MESSAGE="Found $count pane(s), but expected at least $expected"
        VERIFY_HINT="Split panes with Prefix + % (vertical) or Prefix + \" (horizontal)"
        return 1
    fi
}

# Check exact pane count
verify_pane_count_exact() {
    local target="$1" expected="$2"
    verify_reset
    local count
    count=$(tmux list-panes -t "$target" 2>/dev/null | wc -l | tr -d ' ')

    if ((count == expected)); then
        VERIFY_MESSAGE="Found exactly $count pane(s)"
        return 0
    else
        VERIFY_MESSAGE="Found $count pane(s), expected exactly $expected"
        return 1
    fi
}

# Check if a tmux option has a specific value
verify_option_set() {
    local option="$1" expected_value="$2" scope="${3:-global}"
    verify_reset
    local actual_value
    case "$scope" in
        global)  actual_value=$(tmux show-options -gv "$option" 2>/dev/null) ;;
        session) actual_value=$(tmux show-options -v "$option" 2>/dev/null) ;;
        window)  actual_value=$(tmux show-window-options -v "$option" 2>/dev/null) ;;
    esac

    if [[ "$actual_value" == "$expected_value" ]]; then
        VERIFY_MESSAGE="Option '$option' is set to '$expected_value'"
        return 0
    else
        VERIFY_MESSAGE="Option '$option' is '$actual_value', expected '$expected_value'"
        VERIFY_HINT="Set it with: tmux set-option -g $option $expected_value"
        return 1
    fi
}

# Check if a keybinding exists
verify_keybinding() {
    local key="$1" command_pattern="$2"
    verify_reset

    if tmux list-keys 2>/dev/null | grep -q "$key.*$command_pattern"; then
        VERIFY_MESSAGE="Keybinding for '$key' is configured"
        return 0
    else
        VERIFY_MESSAGE="Keybinding for '$key' not found or doesn't match expected command"
        VERIFY_HINT="Bind with: tmux bind-key $key $command_pattern"
        return 1
    fi
}

# Check if pane content contains a pattern
verify_pane_content() {
    local target="$1" pattern="$2"
    verify_reset
    local content
    content=$(tmux capture-pane -t "$target" -p 2>/dev/null)

    if echo "$content" | grep -q "$pattern"; then
        VERIFY_MESSAGE="Found expected content in pane"
        return 0
    else
        VERIFY_MESSAGE="Expected content not found in pane"
        return 1
    fi
}

# Check if the pane layout matches a pattern (even-horizontal, even-vertical, tiled, etc.)
verify_pane_layout_type() {
    local target="$1" expected_type="$2"
    verify_reset

    local pane_count
    pane_count=$(tmux list-panes -t "$target" 2>/dev/null | wc -l | tr -d ' ')

    # Get pane dimensions to determine layout
    local widths heights
    widths=$(tmux list-panes -t "$target" -F '#{pane_width}' 2>/dev/null | sort -u | wc -l | tr -d ' ')
    heights=$(tmux list-panes -t "$target" -F '#{pane_height}' 2>/dev/null | sort -u | wc -l | tr -d ' ')

    case "$expected_type" in
        "even-horizontal")
            if ((heights == 1 && pane_count > 1)); then
                VERIFY_MESSAGE="Layout is even-horizontal"
                return 0
            fi
            ;;
        "even-vertical")
            if ((widths == 1 && pane_count > 1)); then
                VERIFY_MESSAGE="Layout is even-vertical"
                return 0
            fi
            ;;
        "tiled")
            if ((pane_count >= 4)); then
                VERIFY_MESSAGE="Layout appears to be tiled"
                return 0
            fi
            ;;
    esac

    VERIFY_MESSAGE="Layout doesn't match expected type '$expected_type'"
    VERIFY_HINT="Select layout with: tmux select-layout $expected_type"
    return 1
}

# Check tmux paste buffer content
verify_buffer_content() {
    local pattern="$1"
    verify_reset
    local content
    content=$(tmux show-buffer 2>/dev/null || echo "")

    if echo "$content" | grep -q "$pattern"; then
        VERIFY_MESSAGE="Buffer contains expected content"
        return 0
    else
        VERIFY_MESSAGE="Buffer doesn't contain expected content"
        VERIFY_HINT="Copy text in copy mode (Prefix + [), navigate, press Space to start selection, Enter to copy"
        return 1
    fi
}
