#!/usr/bin/env bash
# Lesson: Advanced Pane Movement

lesson_info() {
    LESSON_TITLE="Advanced Pane Movement"
    LESSON_MODULE="02-navigation"
    LESSON_DESCRIPTION="Master pane resizing, swapping, and advanced movement techniques."
    LESSON_TIME="8 minutes"
    LESSON_PREREQUISITES="01-basics/05-basic-navigation"
}

lesson_run() {
    engine_section "Precise Pane Resizing"

    engine_teach "In the basics module you learned Prefix + Ctrl+Arrow for resizing.
Let's explore more precise control:"
    echo ""
    ui_command "tmux resize-pane -L 5" "Shrink left by 5 cells"
    ui_command "tmux resize-pane -R 5" "Grow right by 5 cells"
    ui_command "tmux resize-pane -U 5" "Shrink up by 5 cells"
    ui_command "tmux resize-pane -D 5" "Grow down by 5 cells"
    echo ""

    engine_teach "You can also resize to exact dimensions:"
    echo ""
    ui_command "tmux resize-pane -x 80" "Set width to 80 columns"
    ui_command "tmux resize-pane -y 24" "Set height to 24 rows"
    echo ""

    engine_teach "Or use percentages (tmux 3.1+):"
    echo ""
    ui_command "tmux resize-pane -x 50%" "Set width to 50% of window"
    echo ""

    engine_pause

    engine_section "Swapping Panes"

    engine_teach "Rearrange panes without recreating them:"
    echo ""
    ui_keybinding "Prefix" "{" "Swap current pane with previous"
    ui_keybinding "Prefix" "}" "Swap current pane with next"
    echo ""
    ui_command "tmux swap-pane -s 0 -t 1" "Swap pane 0 with pane 1"
    ui_command "tmux swap-pane -U" "Swap with pane above"
    ui_command "tmux swap-pane -D" "Swap with pane below"
    echo ""

    engine_pause

    engine_section "Pane Display and Selection"

    engine_teach "Quickly identify and jump to panes:"
    echo ""
    ui_keybinding "Prefix" "q" "Display pane numbers"
    echo ""

    engine_teach "When pane numbers appear, press the number to jump to that pane.
You can increase the display time with:"
    echo ""
    ui_command "tmux set -g display-panes-time 5000" "Show pane numbers for 5 seconds"
    echo ""

    engine_pause

    engine_section "Rotating Panes"

    engine_teach "Rotate all panes in the current window:"
    echo ""
    ui_keybinding "Prefix" "Ctrl+o" "Rotate panes forward"
    ui_keybinding "Prefix" "Alt+o" "Rotate panes backward"
    echo ""

    engine_teach "This shifts every pane's content to the next position in the layout.
Useful when you want to rearrange without changing the layout itself."

    engine_pause

    engine_section "Marking Panes"

    engine_teach "You can 'mark' a pane for reference in commands (tmux 2.4+):"
    echo ""
    ui_keybinding "Prefix" "m" "Toggle mark on current pane"
    echo ""

    engine_teach "The marked pane can be referenced as {marked} in commands:
  tmux swap-pane -s {marked}
  tmux join-pane -s {marked}

This is useful when you need to reference a specific pane in a
complex layout."

    engine_pause

    # ── Exercise ──
    engine_exercise \
        "pane-movement-1" \
        "Create and Rearrange Panes" \
        "In the sandbox session 'tmux-learn-sandbox':

1. Create 3 panes (split the window twice)
2. The window should have at least 3 panes

Switch to sandbox with Prefix + s" \
        verify_exercise_1 \
        "In sandbox: Prefix+% then Prefix+\" to get 3 panes" \
        "session"

    engine_teach "You now have precise control over pane positioning and sizing.
These skills are essential for building efficient layouts."
}

verify_exercise_1() {
    verify_pane_count "$SANDBOX_SESSION" 3
}
