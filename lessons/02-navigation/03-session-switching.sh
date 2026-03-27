#!/usr/bin/env bash
# Lesson: Session Switching

lesson_info() {
    LESSON_TITLE="Session Management and Switching"
    LESSON_MODULE="02-navigation"
    LESSON_DESCRIPTION="Master switching between sessions, the session tree, and session grouping."
    LESSON_TIME="7 minutes"
    LESSON_PREREQUISITES="02-navigation/02-window-switching"
}

lesson_run() {
    engine_section "The Session Tree"

    engine_teach "The session tree gives you a bird's eye view of everything:"
    echo ""
    ui_keybinding "Prefix" "s" "Open session tree"
    echo ""

    engine_teach "In the session tree:
  - Arrow keys to navigate
  - Enter to select
  - Right arrow to expand a session (see its windows)
  - Type to filter
  - x to kill the highlighted session/window"

    engine_pause

    engine_section "Quick Session Switching"

    engine_teach "Navigate between sessions without the tree:"
    echo ""
    ui_keybinding "Prefix" "(" "Switch to previous session"
    ui_keybinding "Prefix" ")" "Switch to next session"
    ui_keybinding "Prefix" "L" "Switch to last session"
    echo ""

    engine_teach "The 'last session' toggle (Prefix + L) works just like
'last window' (Prefix + l) but for sessions. Capital L for
sessions, lowercase l for windows."

    engine_pause

    engine_section "Command-Line Session Switching"

    engine_teach "Switch sessions from the command line or command mode:"
    echo ""
    ui_command "tmux switch-client -t mysession" "Switch to named session"
    ui_command "tmux switch-client -n" "Next session"
    ui_command "tmux switch-client -p" "Previous session"
    echo ""

    engine_pause

    engine_section "Session Groups"

    engine_teach "Session groups let multiple clients view the same session
independently (each can look at different windows):"
    echo ""
    ui_command "tmux new-session -t existing_session" "Join a session group"
    echo ""

    engine_teach "This is different from attaching:
  - Attach: Both clients see the SAME window at the SAME time
  - Group: Each client independently navigates windows

Session groups are perfect for pair programming where each person
wants to look at different files."

    engine_pause

    engine_section "Detach Other Clients"

    engine_teach "If another client is attached and you want exclusive access:"
    echo ""
    ui_command "tmux attach -d -t mysession" "Attach and detach others"
    ui_keybinding "Prefix" "D" "Choose which client to detach"
    echo ""

    engine_pause

    engine_section "Session Environment"

    engine_teach "Sessions can have their own environment variables:"
    echo ""
    ui_command "tmux set-environment -t mysession MY_VAR value" "Set env var"
    ui_command "tmux show-environment -t mysession" "Show env vars"
    echo ""

    engine_teach "This is useful for setting different configurations per project
session (like different AWS profiles or database connections)."

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "session-switching-1" \
        "Create and Navigate Sessions" \
        "Create two new sessions (detached):
  - 'project-a'
  - 'project-b'

Use: tmux new-session -d -s <name>

Then verify they exist." \
        verify_exercise_1 \
        "Run: tmux new-session -d -s project-a && tmux new-session -d -s project-b" \
        "none"

    # Cleanup
    tmux kill-session -t "project-a" 2>/dev/null || true
    tmux kill-session -t "project-b" 2>/dev/null || true

    engine_teach "You now understand the full session management toolkit. Sessions
let you organize your work into separate, persistent workspaces."
}

verify_exercise_1() {
    verify_reset
    local has_a has_b
    has_a=false
    has_b=false

    tmux has-session -t "project-a" 2>/dev/null && has_a=true
    tmux has-session -t "project-b" 2>/dev/null && has_b=true

    if $has_a && $has_b; then
        VERIFY_MESSAGE="Both sessions 'project-a' and 'project-b' exist"
        return 0
    else
        local missing=""
        $has_a || missing+="project-a "
        $has_b || missing+="project-b "
        VERIFY_MESSAGE="Missing session(s): ${missing}"
        VERIFY_HINT="Run: tmux new-session -d -s project-a && tmux new-session -d -s project-b"
        return 1
    fi
}
