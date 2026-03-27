#!/usr/bin/env bash
# Lesson: tmux Commands from Shell

lesson_info() {
    LESSON_TITLE="Running tmux Commands from Shell"
    LESSON_MODULE="04-scripting"
    LESSON_DESCRIPTION="Learn to control tmux programmatically from the command line and scripts."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="03-customization/04-colors-and-themes"
}

lesson_run() {
    engine_section "tmux as a Scriptable Tool"

    engine_teach "Everything you do with key bindings can also be done with
commands. This makes tmux fully scriptable - you can automate
any workflow with shell scripts."
    echo ""

    engine_teach "The basic pattern is: tmux <command> [arguments]"

    engine_pause

    engine_section "Session Commands"

    engine_teach "Create and manage sessions programmatically:"
    echo ""
    ui_command "tmux new-session -d -s work" "Create detached session"
    ui_command "tmux new-session -d -s work -x 200 -y 50" "With specific size"
    ui_command "tmux kill-session -t work" "Kill a session"
    ui_command "tmux has-session -t work 2>/dev/null" "Check if session exists"
    ui_command "tmux rename-session -t old new" "Rename a session"
    ui_command "tmux switch-client -t work" "Switch to session"
    echo ""

    engine_pause

    engine_section "Window Commands"

    engine_teach "Create and manage windows:"
    echo ""
    ui_command "tmux new-window -t work" "New window in session 'work'"
    ui_command "tmux new-window -t work -n editor" "New window with name"
    ui_command "tmux select-window -t work:0" "Switch to window 0"
    ui_command "tmux rename-window -t work:0 main" "Rename window"
    ui_command "tmux kill-window -t work:2" "Kill window 2"
    echo ""

    engine_pause

    engine_section "Pane Commands"

    engine_teach "Split and manage panes:"
    echo ""
    ui_command "tmux split-window -h -t work" "Vertical split"
    ui_command "tmux split-window -v -t work" "Horizontal split"
    ui_command "tmux split-window -h -p 30" "Split with 30% width"
    ui_command "tmux select-pane -t work:0.1" "Select pane 1 in window 0"
    ui_command "tmux resize-pane -t work -R 10" "Resize pane right"
    ui_command "tmux select-layout -t work tiled" "Apply tiled layout"
    echo ""

    engine_pause

    engine_section "Target Syntax"

    engine_teach "tmux uses a specific syntax for targeting sessions, windows, and panes:"
    echo ""
    printf "  ${C_BOLD}session${C_RESET}           Target a session\n"
    printf "  ${C_BOLD}session:window${C_RESET}     Target a window in a session\n"
    printf "  ${C_BOLD}session:window.pane${C_RESET} Target a specific pane\n"
    echo ""

    engine_teach "Examples:"
    echo ""
    ui_command "tmux send-keys -t work:0.1 'ls' Enter" "Type 'ls' in work, window 0, pane 1"
    ui_command "tmux select-pane -t :0.0" "Pane 0 in window 0 (current session)"
    ui_command "tmux select-window -t :+" "Next window (current session)"
    echo ""

    engine_pause

    engine_section "Querying tmux State"

    engine_teach "Get information about the current tmux environment:"
    echo ""
    ui_command "tmux display-message -p '#{session_name}'" "Current session name"
    ui_command "tmux display-message -p '#{window_index}'" "Current window index"
    ui_command "tmux display-message -p '#{pane_id}'" "Current pane ID"
    ui_command "tmux list-sessions -F '#{session_name}'" "All session names"
    ui_command "tmux list-windows -F '#{window_name}'" "All window names"
    ui_command "tmux list-panes -F '#{pane_index}:#{pane_width}x#{pane_height}'" "Pane details"
    echo ""

    engine_teach "The -F flag lets you specify a format string for the output.
This is essential for parsing tmux state in scripts."

    engine_pause

    engine_section "Chaining Commands"

    engine_teach "Run multiple tmux commands in sequence:"
    echo ""
    printf "  ${C_WHITE}# Using shell chaining${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-window -n logs \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  && tmux split-window -h \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  && tmux send-keys 'tail -f app.log' Enter${C_RESET}\n"
    echo ""
    printf "  ${C_WHITE}# Using tmux command chaining (in tmux.conf or command mode)${C_RESET}\n"
    printf "  ${C_WHITE}new-window -n logs \\; split-window -h \\; send-keys 'tail -f app.log' Enter${C_RESET}\n"
    echo ""

    engine_teach "The \\; separator chains commands within a single tmux invocation.
This is faster than running tmux multiple times."

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "tmux-commands-1" \
        "Create a Session with Commands" \
        "Using tmux commands, create:
1. A detached session named 'scripted'
2. With a window named 'main'

Use this command:
  tmux new-session -d -s scripted -n main

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux new-session -d -s scripted -n main" \
        "none"

    # Cleanup
    tmux kill-session -t scripted 2>/dev/null || true

    engine_teach "You now know how to drive tmux from the command line. This is
the foundation for building automated tmux scripts."
}

verify_exercise_1() {
    verify_reset
    if ! tmux has-session -t "scripted" 2>/dev/null; then
        VERIFY_MESSAGE="Session 'scripted' not found"
        VERIFY_HINT="Run: tmux new-session -d -s scripted -n main"
        return 1
    fi

    local win_name
    win_name=$(tmux list-windows -t "scripted" -F '#{window_name}' 2>/dev/null | head -1)

    if [[ "$win_name" == "main" ]]; then
        VERIFY_MESSAGE="Session 'scripted' with window 'main' exists"
        return 0
    else
        VERIFY_MESSAGE="Window name is '$win_name', expected 'main'"
        VERIFY_HINT="Kill and recreate: tmux kill-session -t scripted && tmux new-session -d -s scripted -n main"
        return 1
    fi
}
