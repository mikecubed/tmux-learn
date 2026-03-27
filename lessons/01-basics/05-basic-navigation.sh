#!/usr/bin/env bash
# Lesson: Basic Navigation

lesson_info() {
    LESSON_TITLE="Putting It All Together"
    LESSON_MODULE="01-basics"
    LESSON_DESCRIPTION="Practice navigating sessions, windows, and panes in a real tmux environment."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="01-basics/04-panes"
}

lesson_run() {
    engine_section "Navigation Cheat Sheet"

    engine_teach "Let's review all the navigation commands you've learned:"

    echo ""
    printf "  ${C_BOLD}${C_UNDERLINE}Sessions${C_RESET}\n"
    ui_keybinding "Prefix" "s" "Session picker"
    ui_keybinding "Prefix" "(" "Previous session"
    ui_keybinding "Prefix" ")" "Next session"
    ui_keybinding "Prefix" "d" "Detach"
    ui_keybinding "Prefix" "\$" "Rename session"
    echo ""

    printf "  ${C_BOLD}${C_UNDERLINE}Windows${C_RESET}\n"
    ui_keybinding "Prefix" "c" "New window"
    ui_keybinding "Prefix" "n" "Next window"
    ui_keybinding "Prefix" "p" "Previous window"
    ui_keybinding "Prefix" "0-9" "Go to window N"
    ui_keybinding "Prefix" "w" "Window picker"
    ui_keybinding "Prefix" "," "Rename window"
    ui_keybinding "Prefix" "&" "Kill window"
    echo ""

    printf "  ${C_BOLD}${C_UNDERLINE}Panes${C_RESET}\n"
    ui_keybinding "Prefix" "%" "Split vertical"
    ui_keybinding "Prefix" "\"" "Split horizontal"
    ui_keybinding "Prefix" "Arrow" "Navigate panes"
    ui_keybinding "Prefix" "z" "Zoom pane"
    ui_keybinding "Prefix" "x" "Kill pane"
    ui_keybinding "Prefix" "!" "Pane to window"
    ui_keybinding "Prefix" "Space" "Cycle layouts"
    echo ""

    engine_pause

    engine_section "Command Mode"

    engine_teach "You can also run tmux commands directly from inside tmux:"
    echo ""
    ui_keybinding "Prefix" ":" "Enter command mode"
    echo ""

    engine_teach "This opens a command prompt at the bottom of the screen. You can type
any tmux command without the 'tmux' prefix. For example:
  :new-window -n mywin
  :split-window -h
  :kill-pane"

    engine_pause

    engine_section "Useful Information Commands"

    engine_teach "These commands help you understand your tmux environment:"
    echo ""
    ui_keybinding "Prefix" "t" "Show a clock (press q to exit)"
    ui_keybinding "Prefix" "i" "Show current window info"
    ui_keybinding "Prefix" "q" "Show pane numbers"
    echo ""
    ui_command "tmux list-sessions" "List all sessions"
    ui_command "tmux list-windows" "List windows in current session"
    ui_command "tmux list-panes" "List panes in current window"
    ui_command "tmux display-message -p '#{session_name}'" "Show current session name"
    echo ""

    engine_pause

    engine_section "Quick Quiz"

    engine_quiz "How do you split a pane vertically (left/right)?" \
        "Prefix + \"" "Prefix + %" "Prefix + |" "Prefix + -" \
        2

    echo ""

    engine_quiz "How do you zoom (fullscreen) a pane?" \
        "Prefix + f" "Prefix + m" "Prefix + z" "Prefix + Z" \
        3

    echo ""

    engine_quiz "How do you open the interactive session picker?" \
        "Prefix + w" "Prefix + s" "Prefix + l" "Prefix + t" \
        2

    engine_pause

    # ── Exercise ──
    engine_section "Final Challenge"

    engine_teach "Let's put it all together! Create a mini workspace in the sandbox."

    engine_exercise \
        "navigation-1" \
        "Build a Workspace" \
        "In the sandbox session 'tmux-learn-sandbox':

1. Create at least 2 windows
2. Name one window 'code'
3. In that window, create at least 2 panes

Switch to sandbox with Prefix + s, do the work,
then switch back here to check." \
        verify_exercise_1 \
        "In sandbox: Prefix+c (new window), Prefix+, then type 'code', then Prefix+% to split" \
        "session"

    engine_teach "Congratulations! You've completed the Basics module. You now have
a solid foundation for using tmux. The next module covers advanced
navigation techniques including copy mode and searching."

    echo ""
    ui_tip "Practice makes perfect! Try using tmux for your daily work to build muscle memory."
}

verify_exercise_1() {
    verify_reset

    # Check window count
    local win_count
    win_count=$(tmux list-windows -t "$SANDBOX_SESSION" 2>/dev/null | wc -l | tr -d ' ')

    if ((win_count < 2)); then
        VERIFY_MESSAGE="Need at least 2 windows (found $win_count)"
        VERIFY_HINT="Create more windows with Prefix + c"
        return 1
    fi

    # Check for window named 'code'
    local has_code=false
    local code_window=""
    while IFS= read -r line; do
        local wname windex
        wname=$(echo "$line" | cut -d: -f1)
        if [[ "$wname" == "code" ]]; then
            has_code=true
            code_window=$(tmux list-windows -t "$SANDBOX_SESSION" -F '#{window_name}:#{window_index}' 2>/dev/null | grep "^code:" | cut -d: -f2)
            break
        fi
    done < <(tmux list-windows -t "$SANDBOX_SESSION" -F '#{window_name}' 2>/dev/null)

    if ! $has_code; then
        VERIFY_MESSAGE="No window named 'code' found"
        VERIFY_HINT="Rename a window: Prefix + , then type 'code'"
        return 1
    fi

    # Check pane count in 'code' window
    local pane_count
    pane_count=$(tmux list-panes -t "${SANDBOX_SESSION}:${code_window}" 2>/dev/null | wc -l | tr -d ' ')

    if ((pane_count < 2)); then
        VERIFY_MESSAGE="Window 'code' needs at least 2 panes (found $pane_count)"
        VERIFY_HINT="In the 'code' window: Prefix + % to split"
        return 1
    fi

    VERIFY_MESSAGE="Perfect! 2+ windows, 'code' window with $pane_count panes"
    return 0
}
