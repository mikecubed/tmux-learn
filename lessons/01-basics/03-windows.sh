#!/usr/bin/env bash
# Lesson: Windows

lesson_info() {
    LESSON_TITLE="Working with Windows"
    LESSON_MODULE="01-basics"
    LESSON_DESCRIPTION="Learn to create, navigate, rename, and manage tmux windows."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="01-basics/02-sessions"
}

lesson_run() {
    engine_section "What are Windows?"

    engine_teach "Windows in tmux are like tabs in a web browser. Each window takes
up the full screen and can contain one or more panes.

Every session starts with one window. You can create as many
additional windows as you need."

    engine_pause

    engine_section "Creating Windows"

    engine_teach "Create a new window in the current session:"
    echo ""
    ui_keybinding "Prefix" "c" "Create a new window"
    echo ""
    ui_command "tmux new-window" "Command form"
    ui_command "tmux new-window -n editor" "Create with a name"
    echo ""

    engine_teach "New windows appear in the status bar at the bottom of the screen.
The current window is marked with an asterisk (*)."

    engine_pause

    engine_section "Navigating Windows"

    engine_teach "Several ways to switch between windows:"
    echo ""
    ui_keybinding "Prefix" "n" "Next window"
    ui_keybinding "Prefix" "p" "Previous window"
    ui_keybinding "Prefix" "0-9" "Jump to window by number"
    ui_keybinding "Prefix" "l" "Last (previously active) window"
    ui_keybinding "Prefix" "w" "Interactive window list"
    echo ""

    engine_teach "The window list (Prefix + w) is especially useful when you have
many windows. You can navigate it with arrow keys and Enter."

    engine_pause

    engine_section "Renaming Windows"

    engine_teach "Give your windows meaningful names to stay organized:"
    echo ""
    ui_keybinding "Prefix" "," "Rename current window (interactive)"
    echo ""
    ui_command "tmux rename-window editor" "Command form"
    echo ""

    engine_teach "By default, tmux automatically renames windows based on the
running program. You can disable this with:
  set-option -g allow-rename off"

    engine_pause

    engine_section "Closing Windows"

    engine_teach "Close windows when you're done with them:"
    echo ""
    ui_keybinding "Prefix" "&" "Kill current window (with confirmation)"
    echo ""
    ui_command "tmux kill-window -t 2" "Kill window number 2"
    echo ""

    engine_teach "Closing all panes in a window also closes the window."

    engine_pause

    engine_section "Moving and Swapping Windows"

    engine_teach "Rearrange your windows:"
    echo ""
    ui_command "tmux swap-window -s 2 -t 1" "Swap windows 2 and 1"
    ui_command "tmux move-window -t 5" "Move current window to position 5"
    echo ""

    engine_pause

    # ── Exercise 1 ──
    engine_teach "Time to practice! We'll create a sandbox session for you to work in."

    engine_exercise \
        "windows-1" \
        "Create Multiple Windows" \
        "In the sandbox session 'tmux-learn-sandbox':
1. Create at least 3 windows total

Switch to the sandbox with Prefix + s and select
'tmux-learn-sandbox', then use Prefix + c to
create new windows.

Switch back here with Prefix + s when done." \
        verify_exercise_1 \
        "Switch to sandbox (Prefix+s), then press Prefix+c twice to create 2 more windows (3 total)" \
        "session"

    # ── Exercise 2 ──
    engine_exercise \
        "windows-2" \
        "Rename a Window" \
        "In the sandbox session 'tmux-learn-sandbox':
Rename any window to 'editor'

Switch to sandbox, navigate to a window, then
press Prefix + , and type 'editor'.

Switch back here with Prefix + s when done." \
        verify_exercise_2 \
        "In the sandbox: Press Prefix + , then type 'editor' and press Enter" \
        "session"

    engine_teach "Excellent! You can now manage windows like a pro. Windows help
you organize different tasks within a single session."
}

verify_exercise_1() {
    verify_window_count "$SANDBOX_SESSION" 3
}

verify_exercise_2() {
    verify_window_name_exists "$SANDBOX_SESSION" "editor"
}
