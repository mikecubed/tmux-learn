#!/usr/bin/env bash
# Lesson: Sessions

lesson_info() {
    LESSON_TITLE="Creating and Managing Sessions"
    LESSON_MODULE="01-basics"
    LESSON_DESCRIPTION="Learn to create, list, detach from, attach to, and kill tmux sessions."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="01-basics/01-what-is-tmux"
}

lesson_run() {
    engine_section "What is a Session?"

    engine_teach "A session is the top-level container in tmux. Each session is an
independent workspace with its own set of windows and panes.

You might have one session for each project you're working on:
  - 'webapp' for your web application
  - 'api' for your backend service
  - 'dotfiles' for config editing"

    engine_pause

    engine_section "Creating Sessions"

    engine_teach "You create sessions from the command line using 'tmux new-session'
(or the shorthand 'tmux new')."

    echo ""
    ui_command "tmux new-session -s myproject" "Create a named session"
    ui_command "tmux new -s myproject" "Short form"
    ui_command "tmux new -d -s background" "Create detached (in background)"
    echo ""

    engine_teach "The -s flag sets the session name. The -d flag creates it
detached so you don't switch to it immediately."

    engine_pause

    engine_section "Listing Sessions"

    engine_teach "To see all running sessions:"
    echo ""
    ui_command "tmux list-sessions" "Full command"
    ui_command "tmux ls" "Short form"
    echo ""

    engine_teach "Or from inside tmux, press:"
    echo ""
    ui_keybinding "Prefix" "s" "Show session list (interactive)"
    echo ""

    engine_pause

    engine_section "Detaching from Sessions"

    engine_teach "Detaching leaves the session running in the background. This is one
of tmux's most powerful features - your work persists even after
you disconnect!"
    echo ""
    ui_keybinding "Prefix" "d" "Detach from current session"
    echo ""
    ui_command "tmux detach" "Command form"
    echo ""

    engine_pause

    engine_section "Attaching to Sessions"

    engine_teach "To reconnect to a running session:"
    echo ""
    ui_command "tmux attach -t myproject" "Attach to a named session"
    ui_command "tmux a -t myproject" "Short form"
    ui_command "tmux a" "Attach to last session"
    echo ""

    engine_pause

    engine_section "Switching Between Sessions"

    engine_teach "When you're inside tmux and want to switch sessions:"
    echo ""
    ui_keybinding "Prefix" "s" "Interactive session picker"
    ui_keybinding "Prefix" "(" "Previous session"
    ui_keybinding "Prefix" ")" "Next session"
    echo ""

    engine_pause

    engine_section "Killing Sessions"

    engine_teach "To destroy a session and all its windows/panes:"
    echo ""
    ui_command "tmux kill-session -t myproject" "Kill a specific session"
    ui_command "tmux kill-server" "Kill ALL sessions (careful!)"
    echo ""

    engine_pause

    engine_section "Renaming Sessions"

    engine_teach "You can rename an existing session:"
    echo ""
    ui_keybinding "Prefix" "$" "Rename current session (interactive)"
    ui_command "tmux rename-session -t old new" "Command form"
    echo ""

    engine_pause

    # ── Exercise 1 ──
    engine_exercise \
        "sessions-1" \
        "Create a Named Session" \
        "Create a new tmux session named 'practice'.

Use the sandbox session or open a new terminal pane.
Remember: tmux new-session -d -s practice

(Use -d to create it detached so you stay here)" \
        verify_exercise_1 \
        "Run: tmux new-session -d -s practice" \
        "none"

    # ── Exercise 2 ──
    engine_exercise \
        "sessions-2" \
        "Create Multiple Sessions" \
        "Create two MORE sessions (in addition to 'practice'):
  - One named 'dev'
  - One named 'logs'

Use -d flag to keep them detached." \
        verify_exercise_2 \
        "Run: tmux new-session -d -s dev && tmux new-session -d -s logs" \
        "none"

    # ── Exercise 3 ──
    engine_teach "Now let's practice cleaning up. You should have sessions named
'practice', 'dev', and 'logs' running."

    engine_exercise \
        "sessions-3" \
        "Kill a Session" \
        "Kill the session named 'logs'.

Remember: tmux kill-session -t <name>" \
        verify_exercise_3 \
        "Run: tmux kill-session -t logs" \
        "none"

    # Cleanup remaining practice sessions
    tmux kill-session -t practice 2>/dev/null || true
    tmux kill-session -t dev 2>/dev/null || true
    tmux kill-session -t logs 2>/dev/null || true

    engine_teach "Great work! You can now create, manage, and destroy tmux sessions.
Sessions are the foundation of everything in tmux."
}

verify_exercise_1() {
    verify_session_exists "practice"
}

verify_exercise_2() {
    verify_reset
    local has_dev has_logs
    has_dev=false
    has_logs=false

    tmux has-session -t "dev" 2>/dev/null && has_dev=true
    tmux has-session -t "logs" 2>/dev/null && has_logs=true

    if $has_dev && $has_logs; then
        VERIFY_MESSAGE="Sessions 'dev' and 'logs' both exist"
        return 0
    else
        local missing=""
        $has_dev || missing+="dev "
        $has_logs || missing+="logs "
        VERIFY_MESSAGE="Missing session(s): ${missing}"
        VERIFY_HINT="Create them with: tmux new-session -d -s dev && tmux new-session -d -s logs"
        return 1
    fi
}

verify_exercise_3() {
    verify_session_not_exists "logs"
}
