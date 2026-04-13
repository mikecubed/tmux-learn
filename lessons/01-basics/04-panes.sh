#!/usr/bin/env bash
# Lesson: Panes

lesson_info() {
    LESSON_TITLE="Splitting and Managing Panes"
    LESSON_MODULE="01-basics"
    LESSON_DESCRIPTION="Learn to split windows into panes, resize them, and navigate between them."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="01-basics/03-windows"
}

lesson_run() {
    engine_section "What are Panes?"

    engine_teach "Panes let you split a single window into multiple sections, each
running its own shell. This is incredibly useful for:
  - Editing code in one pane, running it in another
  - Watching logs while working
  - Running a server and client side by side"

    engine_pause

    engine_section "Splitting Panes"

    engine_teach "There are two ways to split a window:"
    echo ""
    ui_keybinding "Prefix" "%" "Split vertically (left | right)"
    ui_keybinding "Prefix" "\"" "Split horizontally (top / bottom)"
    echo ""

    printf "${C_CYAN}"
    cat << 'DIAGRAM'

    Prefix + %  (vertical)        Prefix + "  (horizontal)
    ┌──────┬──────┐               ┌─────────────┐
    │      │      │               │             │
    │      │      │               ├─────────────┤
    │      │      │               │             │
    └──────┴──────┘               └─────────────┘

DIAGRAM
    printf "${C_RESET}"

    engine_teach "You can split panes multiple times to create complex layouts."

    engine_pause

    engine_section "Navigating Between Panes"

    engine_teach "Move between panes using these keys:"
    echo ""
    ui_keybinding "Prefix" "Arrow" "Move to pane in that direction"
    ui_keybinding "Prefix" "o" "Cycle to next pane"
    ui_keybinding "Prefix" "q" "Show pane numbers (press number to jump)"
    ui_keybinding "Prefix" ";" "Toggle to last active pane"
    echo ""

    engine_pause

    engine_section "Resizing Panes"

    engine_teach "Adjust pane sizes:"
    echo ""
    ui_keybinding "Prefix" "Ctrl+Arrow" "Resize by 1 cell"
    ui_keybinding "Prefix" "Alt+Arrow" "Resize by 5 cells"
    echo ""
    ui_command "tmux resize-pane -D 10" "Resize down by 10 cells"
    ui_command "tmux resize-pane -R 20" "Resize right by 20 cells"
    echo ""

    engine_pause

    engine_section "Zooming Panes"

    engine_teach "Sometimes you need to focus on one pane temporarily:"
    echo ""
    ui_keybinding "Prefix" "z" "Toggle zoom (fullscreen current pane)"
    echo ""

    engine_teach "When zoomed, the pane takes up the full window. Press Prefix + z
again to restore the layout. The status bar shows a 'Z' flag
when a pane is zoomed."

    engine_pause

    engine_section "Closing Panes"

    engine_teach "Close a pane when you're done:"
    echo ""
    ui_keybinding "Prefix" "x" "Kill current pane (with confirmation)"
    echo ""
    ui_command "exit" "Or just type exit / Ctrl+d in the shell"
    echo ""

    engine_pause

    engine_section "Pane Layouts"

    engine_teach "tmux has built-in layouts you can cycle through:"
    echo ""
    ui_keybinding "Prefix" "Space" "Cycle through preset layouts"
    echo ""
    ui_command "tmux select-layout even-horizontal" "All panes side by side"
    ui_command "tmux select-layout even-vertical" "All panes stacked"
    ui_command "tmux select-layout main-horizontal" "One large + small below"
    ui_command "tmux select-layout main-vertical" "One large + small right"
    ui_command "tmux select-layout tiled" "Equal grid"
    echo ""

    engine_pause

    engine_section "Converting Panes"

    engine_teach "You can convert a pane to a window and vice versa:"
    echo ""
    ui_keybinding "Prefix" "!" "Break pane into its own window"
    echo ""
    ui_command "tmux join-pane -s 2 -t 1" "Move window 2 into window 1 as a pane"
    echo ""

    engine_pause

    # ── Exercise 1 ──
    sandbox_create
    engine_exercise \
        "panes-1" \
        "Create a 4-Pane Layout" \
        "In the sandbox session 'tmux-learn-sandbox':
Create 4 panes in the first window.

Hint: Start with one pane, split it vertically,
then split each half horizontally.

Like this:
┌──────┬──────┐
│  P0  │  P1  │
├──────┼──────┤
│  P2  │  P3  │
└──────┴──────┘

Switch to sandbox with Prefix + s" \
        verify_exercise_1 \
        "In sandbox: Prefix+% (split vertical), then select left pane and Prefix+\" (split horizontal), then select right top pane and Prefix+\"" \
        "current"

    # ── Exercise 2 ──
    engine_exercise \
        "panes-2" \
        "Apply a Layout" \
        "In the sandbox session (which should have 4 panes):
Apply the 'tiled' layout to make all panes equal.

Use Prefix + Space to cycle layouts,
or run: tmux select-layout -t tmux-learn-sandbox tiled" \
        verify_exercise_2 \
        "Run: tmux select-layout -t tmux-learn-sandbox tiled" \
        "current"

    sandbox_destroy

    engine_teach "Fantastic! Panes are one of tmux's most powerful features. With
practice, you'll instinctively split and arrange panes to match
your workflow."
}

verify_exercise_1() {
    verify_pane_count "$SANDBOX_SESSION" 4
}

verify_exercise_2() {
    verify_reset
    local count
    count=$(tmux list-panes -t "$SANDBOX_SESSION" 2>/dev/null | wc -l | tr -d ' ')

    if ((count >= 4)); then
        VERIFY_MESSAGE="Found $count panes with layout applied"
        return 0
    else
        VERIFY_MESSAGE="Need at least 4 panes first"
        VERIFY_HINT="Create 4 panes first, then apply the tiled layout"
        return 1
    fi
}
