#!/usr/bin/env bash
# Lesson: Session Scripts

lesson_info() {
    LESSON_TITLE="Session Management Scripts"
    LESSON_MODULE="04-scripting"
    LESSON_DESCRIPTION="Build reusable session scripts, smart starters, and project launchers."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="04-scripting/03-scripted-layouts"
}

lesson_run() {
    engine_section "The tmux Session Launcher"

    engine_teach "A well-crafted session launcher handles all edge cases:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}# Smart session launcher${C_RESET}\n"
    printf "  ${C_WHITE}SESSION=\"\${1:-default}\"${C_RESET}\n"
    printf "  ${C_WHITE}WORKDIR=\"\${2:-\$HOME}\"${C_RESET}\n\n"

    printf "  ${C_WHITE}# If already in tmux, switch to session${C_RESET}\n"
    printf "  ${C_WHITE}if [ -n \"\$TMUX\" ]; then${C_RESET}\n"
    printf "  ${C_WHITE}  if tmux has-session -t \$SESSION 2>/dev/null; then${C_RESET}\n"
    printf "  ${C_WHITE}    tmux switch-client -t \$SESSION${C_RESET}\n"
    printf "  ${C_WHITE}  else${C_RESET}\n"
    printf "  ${C_WHITE}    tmux new-session -d -s \$SESSION -c \$WORKDIR${C_RESET}\n"
    printf "  ${C_WHITE}    tmux switch-client -t \$SESSION${C_RESET}\n"
    printf "  ${C_WHITE}  fi${C_RESET}\n"
    printf "  ${C_WHITE}  exit 0${C_RESET}\n"
    printf "  ${C_WHITE}fi${C_RESET}\n\n"

    printf "  ${C_WHITE}# If not in tmux, attach or create${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -A -s \$SESSION -c \$WORKDIR${C_RESET}\n"
    echo ""

    engine_teach "The -A flag creates a session if it doesn't exist, or attaches
to it if it does. Perfect for one-liner session management."

    engine_pause

    engine_section "Project-Specific Launchers"

    engine_teach "Create a launcher per project, typically at the project root:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}# .tmux-session.sh - Project session launcher${C_RESET}\n"
    printf "  ${C_WHITE}PROJECT_DIR=\"\$(cd \"\$(dirname \"\$0\")\" && pwd)\"${C_RESET}\n"
    printf "  ${C_WHITE}SESSION=\"\$(basename \$PROJECT_DIR)\"${C_RESET}\n\n"

    printf "  ${C_WHITE}tmux has-session -t \$SESSION 2>/dev/null && \\\\${C_RESET}\n"
    printf "  ${C_WHITE}  { tmux attach -t \$SESSION; exit 0; }${C_RESET}\n\n"

    printf "  ${C_WHITE}tmux new-session -d -s \$SESSION -c \$PROJECT_DIR -n code${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t \$SESSION:code '\$EDITOR .' Enter${C_RESET}\n\n"

    printf "  ${C_WHITE}tmux new-window -t \$SESSION -n term -c \$PROJECT_DIR${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-window -t \$SESSION -n git -c \$PROJECT_DIR${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t \$SESSION:git 'git status' Enter${C_RESET}\n\n"

    printf "  ${C_WHITE}tmux select-window -t \$SESSION:code${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t \$SESSION${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Session Chooser"

    engine_teach "Build an interactive session picker:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}# tmux-chooser: Pick or create a session${C_RESET}\n\n"

    printf "  ${C_WHITE}if ! tmux list-sessions 2>/dev/null; then${C_RESET}\n"
    printf "  ${C_WHITE}  echo 'No sessions. Creating default...'${C_RESET}\n"
    printf "  ${C_WHITE}  tmux new-session -s main${C_RESET}\n"
    printf "  ${C_WHITE}  exit 0${C_RESET}\n"
    printf "  ${C_WHITE}fi${C_RESET}\n\n"

    printf "  ${C_WHITE}echo 'Active sessions:'${C_RESET}\n"
    printf "  ${C_WHITE}tmux list-sessions -F '  #{session_name} (#{session_windows} windows)'${C_RESET}\n"
    printf "  ${C_WHITE}echo ''${C_RESET}\n"
    printf "  ${C_WHITE}read -p 'Session name (or Enter for last): ' name${C_RESET}\n\n"

    printf "  ${C_WHITE}if [ -z \"\$name\" ]; then${C_RESET}\n"
    printf "  ${C_WHITE}  tmux attach${C_RESET}\n"
    printf "  ${C_WHITE}else${C_RESET}\n"
    printf "  ${C_WHITE}  tmux new-session -A -s \"\$name\"${C_RESET}\n"
    printf "  ${C_WHITE}fi${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Shell Integration"

    engine_teach "Add tmux to your shell profile for automatic session management:"

    echo ""
    printf "  ${C_WHITE}# Add to ~/.bashrc or ~/.zshrc${C_RESET}\n\n"

    printf "  ${C_WHITE}# Auto-start tmux on SSH connections${C_RESET}\n"
    printf "  ${C_WHITE}if [ -n \"\$SSH_CONNECTION\" ] && [ -z \"\$TMUX\" ]; then${C_RESET}\n"
    printf "  ${C_WHITE}  tmux new-session -A -s ssh${C_RESET}\n"
    printf "  ${C_WHITE}fi${C_RESET}\n"
    echo ""

    engine_teach "Or a function to quickly jump to project sessions:"

    echo ""
    printf "  ${C_WHITE}# Quick project session function${C_RESET}\n"
    printf "  ${C_WHITE}tp() {${C_RESET}\n"
    printf "  ${C_WHITE}  local dir=\"\${1:-.}\"${C_RESET}\n"
    printf "  ${C_WHITE}  local name=\$(basename \"\$(cd \"\$dir\" && pwd)\")${C_RESET}\n"
    printf "  ${C_WHITE}  tmux new-session -A -s \"\$name\" -c \"\$(cd \"\$dir\" && pwd)\"${C_RESET}\n"
    printf "  ${C_WHITE}}${C_RESET}\n"
    echo ""

    engine_teach "Usage: tp ~/projects/myapp  (creates/attaches to 'myapp' session)"

    engine_pause

    engine_section "Respawn and Recovery"

    engine_teach "Useful commands for long-running processes:"
    echo ""
    ui_command "tmux respawn-pane -t work:0.1" "Restart a dead pane"
    ui_command "tmux respawn-pane -k -t work:0.1 'npm start'" "Kill and restart with command"
    ui_command "tmux respawn-window -t work:server" "Restart a dead window"
    echo ""

    engine_teach "respawn-pane restarts the pane's shell (or a specific command)
without changing the layout. Perfect for restarting crashed servers."

    engine_pause

    engine_section "Pipe Pane"

    engine_teach "Log all output from a pane to a file:"
    echo ""
    ui_command "tmux pipe-pane -t work:0 'cat >> ~/tmux-work.log'" "Start logging"
    ui_command "tmux pipe-pane -t work:0" "Stop logging (no argument)"
    echo ""

    engine_teach "This captures everything displayed in the pane, including
terminal escape codes. Useful for debugging and auditing."

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "session-scripts-1" \
        "Create a Smart Session" \
        "Create a session that:
1. Named 'smart-test'
2. Has 2 windows: 'code' and 'term'

Run these commands:
  tmux new-session -d -s smart-test -n code
  tmux new-window -t smart-test -n term
  tmux select-window -t smart-test:code

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux new-session -d -s smart-test -n code && tmux new-window -t smart-test -n term" \
        "none"

    # Cleanup
    tmux kill-session -t smart-test 2>/dev/null || true

    engine_teach "You've completed the Scripting module! You can now automate any
tmux workflow. The final module covers advanced topics like hooks,
plugins, and pair programming."
}

verify_exercise_1() {
    verify_reset

    if ! tmux has-session -t "smart-test" 2>/dev/null; then
        VERIFY_MESSAGE="Session 'smart-test' not found"
        VERIFY_HINT="Run: tmux new-session -d -s smart-test -n code"
        return 1
    fi

    local names
    names=$(tmux list-windows -t "smart-test" -F '#{window_name}' 2>/dev/null)

    local has_code has_term
    has_code=$(echo "$names" | grep -c "^code$" || echo 0)
    has_term=$(echo "$names" | grep -c "^term$" || echo 0)

    if ((has_code > 0 && has_term > 0)); then
        VERIFY_MESSAGE="Session 'smart-test' has windows 'code' and 'term'"
        return 0
    else
        local missing=""
        ((has_code == 0)) && missing+="code "
        ((has_term == 0)) && missing+="term "
        VERIFY_MESSAGE="Missing window(s): ${missing}"
        VERIFY_HINT="Run: tmux new-session -d -s smart-test -n code && tmux new-window -t smart-test -n term"
        return 1
    fi
}
