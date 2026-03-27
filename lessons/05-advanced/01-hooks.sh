#!/usr/bin/env bash
# Lesson: Hooks

lesson_info() {
    LESSON_TITLE="tmux Hooks and Events"
    LESSON_MODULE="05-advanced"
    LESSON_DESCRIPTION="Automate actions with tmux hooks that trigger on events."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="04-scripting/04-session-scripts"
}

lesson_run() {
    engine_section "What are Hooks?"

    engine_teach "Hooks let you run commands automatically when specific events
happen in tmux. For example:
  - Run a script when a new session is created
  - Adjust layout when a window is resized
  - Log when a pane is closed

This enables powerful automation without user interaction."

    engine_pause

    engine_section "Setting Hooks"

    engine_teach "Use set-hook to register a hook:"
    echo ""
    ui_command "tmux set-hook -g after-new-session 'display-message \"New session!\"'" ""
    ui_command "tmux set-hook -g after-new-window 'setw automatic-rename on'" ""
    echo ""

    engine_teach "The -g flag sets a global hook. Without it, the hook applies only
to the current session."

    engine_pause

    engine_section "Common Hook Events"

    engine_teach "Session events:"
    echo ""
    printf "  ${C_BOLD}after-new-session${C_RESET}       After a session is created\n"
    printf "  ${C_BOLD}session-closed${C_RESET}          When a session is destroyed\n"
    printf "  ${C_BOLD}client-attached${C_RESET}         When a client attaches\n"
    printf "  ${C_BOLD}client-detached${C_RESET}         When a client detaches\n"
    printf "  ${C_BOLD}client-resized${C_RESET}          When the terminal is resized\n"
    echo ""

    engine_teach "Window and pane events:"
    echo ""
    printf "  ${C_BOLD}after-new-window${C_RESET}        After a window is created\n"
    printf "  ${C_BOLD}window-linked${C_RESET}           When a window is linked\n"
    printf "  ${C_BOLD}after-split-window${C_RESET}      After a pane split\n"
    printf "  ${C_BOLD}pane-exited${C_RESET}             When a pane process exits\n"
    printf "  ${C_BOLD}after-select-pane${C_RESET}       After switching panes\n"
    printf "  ${C_BOLD}after-select-window${C_RESET}     After switching windows\n"
    printf "  ${C_BOLD}after-resize-pane${C_RESET}       After a pane is resized\n"
    echo ""

    engine_pause

    engine_section "Practical Hook Examples"

    engine_teach "Auto-rename windows based on the current directory:"
    echo ""
    printf "  ${C_WHITE}set-hook -g after-select-pane \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  'run-shell \"tmux rename-window \\\"#(basename #{pane_current_path})\\\"\"'${C_RESET}\n"
    echo ""

    engine_teach "Log session activity:"
    echo ""
    printf "  ${C_WHITE}set-hook -g client-attached \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  'run-shell \"echo \\\"attached: #{session_name}\\\" >> ~/tmux.log\"'${C_RESET}\n"
    echo ""

    engine_teach "Auto-rebalance panes after split:"
    echo ""
    printf "  ${C_WHITE}set-hook -g after-split-window 'select-layout tiled'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Managing Hooks"

    engine_teach "View and remove hooks:"
    echo ""
    ui_command "tmux show-hooks -g" "Show all global hooks"
    ui_command "tmux show-hooks" "Show session hooks"
    ui_command "tmux set-hook -gu after-new-session" "Remove a global hook"
    echo ""

    engine_teach "The -u flag unsets (removes) a hook."

    engine_pause

    engine_section "Run-Shell"

    engine_teach "Hooks often use run-shell to execute external commands:"
    echo ""
    ui_command "tmux run-shell 'echo hello'" "Run a shell command"
    ui_command "tmux run-shell -b 'sleep 5 && notify-send done'" "Run in background"
    echo ""

    engine_teach "The -b flag runs the command in the background so it doesn't
block tmux. Important for commands that take time."

    engine_pause

    engine_section "Alert Hooks"

    engine_teach "Combined with monitoring, hooks can create a notification system:"

    echo ""
    printf "  ${C_WHITE}# Monitor for activity and bell${C_RESET}\n"
    printf "  ${C_WHITE}setw -g monitor-activity on${C_RESET}\n"
    printf "  ${C_WHITE}setw -g monitor-bell on${C_RESET}\n\n"
    printf "  ${C_WHITE}# Hook: run a command when alert triggers${C_RESET}\n"
    printf "  ${C_WHITE}set-hook -g alert-activity \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  'run-shell \"notify-send tmux \\\"Activity in #{window_name}\\\"\"'${C_RESET}\n"
    echo ""

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "hooks-1" \
        "Set Up a Hook" \
        "Create a hook that displays a message when
a new window is created.

Run this command:
  tmux set-hook -g after-new-window 'display-message \"Window created!\"'

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux set-hook -g after-new-window 'display-message \"Window created!\"'" \
        "none"

    # Cleanup
    tmux set-hook -gu after-new-window 2>/dev/null

    engine_teach "Hooks are a powerful automation mechanism that makes tmux reactive
to events. Combined with scripting, they create intelligent workflows."
}

verify_exercise_1() {
    verify_reset
    local hooks
    hooks=$(tmux show-hooks -g 2>/dev/null)

    if echo "$hooks" | grep -q "after-new-window"; then
        VERIFY_MESSAGE="Hook 'after-new-window' is configured"
        return 0
    else
        VERIFY_MESSAGE="No 'after-new-window' hook found"
        VERIFY_HINT="Run: tmux set-hook -g after-new-window 'display-message \"Window created!\"'"
        return 1
    fi
}
