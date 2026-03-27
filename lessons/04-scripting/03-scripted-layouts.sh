#!/usr/bin/env bash
# Lesson: Scripted Layouts

lesson_info() {
    LESSON_TITLE="Building Scripted Layouts"
    LESSON_MODULE="04-scripting"
    LESSON_DESCRIPTION="Create complex, reproducible tmux layouts with scripts."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="04-scripting/02-send-keys"
}

lesson_run() {
    engine_section "Why Script Layouts?"

    engine_teach "Instead of manually setting up your tmux environment every time,
write a script that creates your ideal layout instantly.

Benefits:
  - Consistent workspace every time
  - Share setups with your team
  - Quick recovery after reboots
  - Per-project configurations"

    engine_pause

    engine_section "Layout Script Pattern"

    engine_teach "Here's the standard pattern for a layout script:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}SESSION=\"myproject\"${C_RESET}\n\n"
    printf "  ${C_WHITE}# Kill existing session if any${C_RESET}\n"
    printf "  ${C_WHITE}tmux kill-session -t \$SESSION 2>/dev/null${C_RESET}\n\n"
    printf "  ${C_WHITE}# Create new session (detached)${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -d -s \$SESSION -c ~/projects/myproject${C_RESET}\n\n"
    printf "  ${C_WHITE}# Set up windows and panes...${C_RESET}\n\n"
    printf "  ${C_WHITE}# Attach at the end${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t \$SESSION${C_RESET}\n"
    echo ""

    engine_teach "The -c flag sets the starting directory for the session."

    engine_pause

    engine_section "Example: Web Dev Layout"

    engine_teach "A typical web development environment:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}SESSION=\"webapp\"${C_RESET}\n"
    printf "  ${C_WHITE}PROJECT=~/projects/webapp${C_RESET}\n\n"

    printf "  ${C_WHITE}tmux kill-session -t \$SESSION 2>/dev/null${C_RESET}\n\n"

    printf "  ${C_GREEN}# Window 1: Editor${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -d -s \$SESSION -n editor -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t \$SESSION:editor 'vim .' Enter${C_RESET}\n\n"

    printf "  ${C_GREEN}# Window 2: Server + Logs${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-window -t \$SESSION -n server -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t \$SESSION:server 'npm run dev' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -v -t \$SESSION:server -c \$PROJECT -p 30${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t \$SESSION:server.1 'tail -f logs/dev.log' Enter${C_RESET}\n\n"

    printf "  ${C_GREEN}# Window 3: Git + Terminal${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-window -t \$SESSION -n git -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t \$SESSION:git 'git status' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -h -t \$SESSION:git -c \$PROJECT${C_RESET}\n\n"

    printf "  ${C_GREEN}# Select first window and attach${C_RESET}\n"
    printf "  ${C_WHITE}tmux select-window -t \$SESSION:editor${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t \$SESSION${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Using Percentage Splits"

    engine_teach "Control pane sizes precisely with -p (percentage) or -l (lines/columns):"
    echo ""
    ui_command "tmux split-window -v -p 30" "Bottom pane gets 30% height"
    ui_command "tmux split-window -h -p 70" "Right pane gets 70% width"
    ui_command "tmux split-window -v -l 10" "Bottom pane gets 10 rows"
    echo ""

    engine_pause

    engine_section "Idempotent Scripts"

    engine_teach "Make your scripts safe to run multiple times:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}SESSION=\"work\"${C_RESET}\n\n"
    printf "  ${C_WHITE}# Attach if session already exists${C_RESET}\n"
    printf "  ${C_WHITE}tmux has-session -t \$SESSION 2>/dev/null${C_RESET}\n"
    printf "  ${C_WHITE}if [ \$? -eq 0 ]; then${C_RESET}\n"
    printf "  ${C_WHITE}  echo \"Session exists. Attaching...\"${C_RESET}\n"
    printf "  ${C_WHITE}  tmux attach -t \$SESSION${C_RESET}\n"
    printf "  ${C_WHITE}  exit 0${C_RESET}\n"
    printf "  ${C_WHITE}fi${C_RESET}\n\n"
    printf "  ${C_WHITE}# Otherwise create it...${C_RESET}\n"
    printf "  ${C_WHITE}tmux new-session -d -s \$SESSION${C_RESET}\n"
    printf "  ${C_WHITE}# ... set up layout ...${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t \$SESSION${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Using select-layout for Precision"

    engine_teach "For complex layouts, create panes then apply a layout checksum:"
    echo ""
    ui_command "tmux list-windows -F '#{window_layout}'" "Get current layout checksum"
    echo ""

    engine_teach "You can save this checksum and replay it:"
    echo ""
    printf "  ${C_WHITE}tmux select-layout '5b0f,191x47,0,0{95x47,0,0,0,95x47,96,0[95x23,96,0,1,95x23,96,24,2]}'${C_RESET}\n"
    echo ""

    engine_teach "This precisely reproduces a complex layout. The checksum encodes
all pane positions and sizes."

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "scripted-layouts-1" \
        "Build a Scripted Layout" \
        "Create a session named 'layout-test' with:
1. A session named 'layout-test'
2. The first window named 'main'
3. At least 2 panes in that window

Run these commands:
  tmux new-session -d -s layout-test -n main
  tmux split-window -h -t layout-test:main

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run: tmux new-session -d -s layout-test -n main && tmux split-window -h -t layout-test:main" \
        "none"

    # Cleanup
    tmux kill-session -t layout-test 2>/dev/null || true

    engine_teach "Scripted layouts transform tmux from a tool into a personalized
development environment. Many developers have a script per project."
}

verify_exercise_1() {
    verify_reset

    if ! tmux has-session -t "layout-test" 2>/dev/null; then
        VERIFY_MESSAGE="Session 'layout-test' not found"
        VERIFY_HINT="Run: tmux new-session -d -s layout-test -n main"
        return 1
    fi

    local win_name
    win_name=$(tmux list-windows -t "layout-test" -F '#{window_name}' 2>/dev/null | head -1)

    if [[ "$win_name" != "main" ]]; then
        VERIFY_MESSAGE="First window is named '$win_name', expected 'main'"
        return 1
    fi

    local pane_count
    pane_count=$(tmux list-panes -t "layout-test:main" 2>/dev/null | wc -l | tr -d ' ')

    if ((pane_count >= 2)); then
        VERIFY_MESSAGE="Session 'layout-test' has window 'main' with $pane_count panes"
        return 0
    else
        VERIFY_MESSAGE="Window 'main' has $pane_count pane(s), expected at least 2"
        VERIFY_HINT="Run: tmux split-window -h -t layout-test:main"
        return 1
    fi
}
