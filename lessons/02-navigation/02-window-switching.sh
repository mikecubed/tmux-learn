#!/usr/bin/env bash
# Lesson: Advanced Window Switching

lesson_info() {
    LESSON_TITLE="Advanced Window Switching"
    LESSON_MODULE="02-navigation"
    LESSON_DESCRIPTION="Master window navigation with search, direct jumps, and activity monitoring."
    LESSON_TIME="7 minutes"
    LESSON_PREREQUISITES="02-navigation/01-pane-movement"
}

lesson_run() {
    engine_section "Finding Windows"

    engine_teach "When you have many windows, finding the right one quickly matters:"
    echo ""
    ui_keybinding "Prefix" "w" "Interactive tree view of all sessions and windows"
    ui_keybinding "Prefix" "f" "Find window by name (search)"
    echo ""

    engine_teach "The tree view (Prefix + w) shows ALL sessions and their windows.
Use arrow keys to navigate, Enter to select, and type to filter."

    engine_pause

    engine_section "Direct Window Access"

    engine_teach "Jump directly to any window by its index:"
    echo ""
    ui_keybinding "Prefix" "0" "Go to window 0"
    ui_keybinding "Prefix" "1" "Go to window 1"
    ui_keybinding "Prefix" "'" "Prompt for window index (for 10+)"
    echo ""

    engine_teach "For windows beyond 9, use Prefix + ' which prompts for the index.
This is useful when you have 10+ windows."

    engine_pause

    engine_section "Last Window Toggle"

    engine_teach "Quickly toggle between two windows (like Alt+Tab):"
    echo ""
    ui_keybinding "Prefix" "l" "Switch to last active window"
    echo ""

    engine_teach "This is one of the most useful shortcuts for bouncing between
your editor and terminal, or between two related tasks."

    engine_pause

    engine_section "Window Activity Monitoring"

    engine_teach "Get notified when something happens in another window:"
    echo ""
    ui_command "tmux setw -g monitor-activity on" "Monitor for activity"
    ui_command "tmux set -g visual-activity on" "Show activity alerts"
    echo ""

    engine_teach "When activity occurs in a monitored window, its name will be
highlighted in the status bar. You can also monitor for silence:"
    echo ""
    ui_command "tmux setw monitor-silence 30" "Alert after 30s of silence"
    echo ""

    engine_teach "This is great for watching log files or waiting for long builds."

    engine_pause

    engine_section "Moving Windows Between Sessions"

    engine_teach "You can move windows between sessions:"
    echo ""
    ui_command "tmux move-window -t other_session:" "Move to another session"
    ui_command "tmux link-window -t other_session:" "Link (share) to another session"
    echo ""

    engine_teach "A linked window appears in both sessions - changes in one are
reflected in the other. Unlink with: tmux unlink-window"

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "window-switching-1" \
        "Create Named Windows" \
        "In the sandbox session 'tmux-learn-sandbox':

1. Create 3 windows total
2. Name them: 'editor', 'server', 'logs'

Use Prefix + c to create, Prefix + , to rename.

Switch to sandbox with Prefix + s" \
        verify_exercise_1 \
        "Create windows with Prefix+c, rename with Prefix+, to 'editor', 'server', and 'logs'" \
        "session"

    engine_teach "You're now an expert at navigating windows. Quick window switching
is a major productivity boost in tmux."
}

verify_exercise_1() {
    verify_reset
    local names
    names=$(tmux list-windows -t "$SANDBOX_SESSION" -F '#{window_name}' 2>/dev/null)

    local has_editor has_server has_logs
    has_editor=$(echo "$names" | grep -c "^editor$" || echo 0)
    has_server=$(echo "$names" | grep -c "^server$" || echo 0)
    has_logs=$(echo "$names" | grep -c "^logs$" || echo 0)

    local missing=""
    ((has_editor == 0)) && missing+="editor "
    ((has_server == 0)) && missing+="server "
    ((has_logs == 0)) && missing+="logs "

    if [[ -z "$missing" ]]; then
        VERIFY_MESSAGE="All three windows found: editor, server, logs"
        return 0
    else
        VERIFY_MESSAGE="Missing window(s): ${missing}"
        VERIFY_HINT="Create and rename windows. Use Prefix+c then Prefix+, to rename"
        return 1
    fi
}
