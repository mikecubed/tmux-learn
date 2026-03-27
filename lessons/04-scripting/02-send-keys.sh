#!/usr/bin/env bash
# Lesson: send-keys and Automation

lesson_info() {
    LESSON_TITLE="Automation with send-keys"
    LESSON_MODULE="04-scripting"
    LESSON_DESCRIPTION="Use send-keys to type commands, simulate keystrokes, and automate workflows."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="04-scripting/01-tmux-commands"
}

lesson_run() {
    engine_section "The send-keys Command"

    engine_teach "send-keys simulates typing into a pane. It's the key to automating
workflows in tmux."
    echo ""
    ui_command "tmux send-keys 'echo hello' Enter" "Type and press Enter"
    ui_command "tmux send-keys -t work:0 'ls -la' Enter" "Type in specific pane"
    echo ""

    engine_teach "The 'Enter' at the end is a special key name. Without it, the
text is typed but not executed."

    engine_pause

    engine_section "Special Key Names"

    engine_teach "send-keys recognizes these special keys:"
    echo ""
    printf "  ${C_BOLD}Enter${C_RESET}        Return/Enter key\n"
    printf "  ${C_BOLD}Escape${C_RESET}       Escape key\n"
    printf "  ${C_BOLD}Space${C_RESET}        Space bar\n"
    printf "  ${C_BOLD}Tab${C_RESET}          Tab key\n"
    printf "  ${C_BOLD}BSpace${C_RESET}       Backspace\n"
    printf "  ${C_BOLD}Up/Down${C_RESET}      Arrow keys\n"
    printf "  ${C_BOLD}Left/Right${C_RESET}   Arrow keys\n"
    printf "  ${C_BOLD}C-c${C_RESET}          Ctrl+C\n"
    printf "  ${C_BOLD}C-z${C_RESET}          Ctrl+Z\n"
    printf "  ${C_BOLD}C-l${C_RESET}          Ctrl+L (clear screen)\n"
    echo ""

    engine_pause

    engine_section "Literal vs Key Names"

    engine_teach "By default, send-keys interprets special key names. Use -l to
send text literally (no key interpretation):"
    echo ""
    ui_command "tmux send-keys 'Enter'" "Sends the Enter KEY"
    ui_command "tmux send-keys -l 'Enter'" "Types the WORD 'Enter'"
    echo ""

    engine_teach "This is important when you need to type text that matches a key name."

    engine_pause

    engine_section "Clearing a Pane"

    engine_teach "Before running a command, you might want to clear the pane:"
    echo ""
    ui_command "tmux send-keys C-c" "Cancel any running command"
    ui_command "tmux send-keys C-l" "Clear the screen"
    ui_command "tmux send-keys '' Enter" "Send a blank Enter"
    echo ""

    engine_teach "A common pattern for scripts:"
    echo ""
    printf "  ${C_WHITE}# Clear and run a command${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t work:0 C-c${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t work:0 C-l${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t work:0 'npm start' Enter${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Automating Multiple Panes"

    engine_teach "Set up a multi-pane workflow:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}# Start a 3-pane dev environment${C_RESET}\n\n"
    printf "  ${C_WHITE}tmux new-session -d -s dev${C_RESET}\n\n"
    printf "  ${C_WHITE}# Pane 0: editor${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t dev 'vim .' Enter${C_RESET}\n\n"
    printf "  ${C_WHITE}# Pane 1: server${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -h -t dev${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t dev 'npm run dev' Enter${C_RESET}\n\n"
    printf "  ${C_WHITE}# Pane 2: terminal${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -v -t dev${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t dev 'git status' Enter${C_RESET}\n\n"
    printf "  ${C_WHITE}# Focus on the editor${C_RESET}\n"
    printf "  ${C_WHITE}tmux select-pane -t dev:0.0${C_RESET}\n\n"
    printf "  ${C_WHITE}# Attach to the session${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t dev${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Synchronized Panes"

    engine_teach "Type the same command in ALL panes simultaneously:"
    echo ""
    ui_command "tmux setw synchronize-panes on" "Enable sync"
    ui_command "tmux setw synchronize-panes off" "Disable sync"
    echo ""

    engine_teach "This is extremely useful for:
  - Running the same command on multiple servers
  - Updating multiple environments at once
  - Comparing command output side-by-side"

    engine_pause

    engine_section "Capturing Output"

    engine_teach "Capture what's currently displayed in a pane:"
    echo ""
    ui_command "tmux capture-pane -p" "Print pane content to stdout"
    ui_command "tmux capture-pane -p -S -100" "Last 100 lines"
    ui_command "tmux capture-pane -p > output.txt" "Save to file"
    ui_command "tmux capture-pane -t work:0 -p" "Capture specific pane"
    echo ""

    engine_teach "This is useful for logging, testing, and extracting information
from running processes."

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "send-keys-1" \
        "Automate with send-keys" \
        "Create a sandbox session and send a command to it:

1. tmux new-session -d -s automated
2. tmux send-keys -t automated 'echo HELLO_AUTOMATED' Enter

Then type 'check' to verify." \
        verify_exercise_1 \
        "Run both commands: tmux new-session -d -s automated && sleep 0.5 && tmux send-keys -t automated 'echo HELLO_AUTOMATED' Enter" \
        "none"

    # Cleanup
    tmux kill-session -t automated 2>/dev/null || true

    engine_teach "send-keys is incredibly powerful for automation. Combined with
session/window/pane management, you can script entire workflows."
}

verify_exercise_1() {
    verify_reset

    if ! tmux has-session -t "automated" 2>/dev/null; then
        VERIFY_MESSAGE="Session 'automated' not found"
        VERIFY_HINT="Run: tmux new-session -d -s automated"
        return 1
    fi

    local content
    content=$(tmux capture-pane -t "automated" -p 2>/dev/null)

    if echo "$content" | grep -q "HELLO_AUTOMATED"; then
        VERIFY_MESSAGE="Found 'HELLO_AUTOMATED' in the automated session"
        return 0
    else
        VERIFY_MESSAGE="'HELLO_AUTOMATED' not found in session output"
        VERIFY_HINT="Run: tmux send-keys -t automated 'echo HELLO_AUTOMATED' Enter"
        return 1
    fi
}
