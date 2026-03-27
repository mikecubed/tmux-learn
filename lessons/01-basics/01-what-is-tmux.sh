#!/usr/bin/env bash
# Lesson: What is tmux?

lesson_info() {
    LESSON_TITLE="What is tmux?"
    LESSON_MODULE="01-basics"
    LESSON_DESCRIPTION="Learn what tmux is, why it's useful, and understand its core concepts."
    LESSON_TIME="5 minutes"
    LESSON_PREREQUISITES=""
}

lesson_run() {
    engine_section "Welcome to tmux!"

    engine_teach "tmux (Terminal MUltipleXer) is a powerful tool that lets you run
multiple terminal sessions inside a single window. Think of it as a
window manager for your terminal."

    engine_pause

    engine_section "Why use tmux?"

    engine_teach "Here are the top reasons developers love tmux:"

    ui_print "$C_GREEN" "  1. Persistent sessions - Your work survives disconnections"
    ui_print "$C_GREEN" "  2. Multiple windows   - Like browser tabs for your terminal"
    ui_print "$C_GREEN" "  3. Split panes        - See multiple things at once"
    ui_print "$C_GREEN" "  4. Remote work         - Keep sessions alive on servers"
    ui_print "$C_GREEN" "  5. Pair programming   - Share sessions with teammates"
    echo ""

    engine_teach "Imagine you're SSH'd into a server running a long process.
Without tmux, if your connection drops, the process dies.
With tmux, it keeps running and you can reconnect anytime."

    engine_pause

    engine_section "The tmux Hierarchy"

    engine_teach "tmux organizes everything in a simple hierarchy:"

    printf "${C_CYAN}"
    cat << 'DIAGRAM'

      ┌─────────────────────────────────────────────┐
      │                 tmux server                  │
      │                                              │
      │   ┌─────────────────────────────────────┐   │
      │   │           Session: "dev"             │   │
      │   │                                      │   │
      │   │  ┌──────────┐  ┌──────────┐         │   │
      │   │  │ Window 0  │  │ Window 1  │  ...   │   │
      │   │  │ "editor"  │  │ "server"  │        │   │
      │   │  │           │  │           │        │   │
      │   │  │ ┌───┬───┐│  │ ┌────────┐│        │   │
      │   │  │ │P0 │P1 ││  │ │  Pane  ││        │   │
      │   │  │ ├───┴───┤│  │ │   0    ││        │   │
      │   │  │ │  P2   ││  │ │        ││        │   │
      │   │  │ └───────┘│  │ └────────┘│        │   │
      │   │  └──────────┘  └──────────┘         │   │
      │   └─────────────────────────────────────┘   │
      │                                              │
      │   ┌─────────────────────────────────────┐   │
      │   │        Session: "monitoring"         │   │
      │   │            ...                       │   │
      │   └─────────────────────────────────────┘   │
      └─────────────────────────────────────────────┘

DIAGRAM
    printf "${C_RESET}"

    engine_teach "Let's break this down:"

    ui_print "$C_BOLD" "  Server  - Runs in the background, manages everything"
    ui_print "$C_BOLD" "  Session - A collection of windows (like a workspace)"
    ui_print "$C_BOLD" "  Window  - A full-screen view (like a browser tab)"
    ui_print "$C_BOLD" "  Pane    - A split within a window"
    echo ""

    engine_pause

    engine_section "The Prefix Key"

    engine_teach "tmux uses a 'prefix key' to distinguish its commands from regular
terminal input. By default, this is:"

    echo ""
    ui_keybinding "Ctrl-b" "" "The default tmux prefix key"
    echo ""

    engine_teach "You press the prefix first, release it, then press the command key.
For example, to create a new window:"

    echo ""
    ui_print "$C_DIM" "  Step 1: Press Ctrl+b (and release)"
    ui_print "$C_DIM" "  Step 2: Press c"
    echo ""

    engine_teach "Throughout this tutorial, we'll write this as: Prefix + c"

    engine_pause

    engine_section "Key Commands to Remember"

    engine_teach "Here are the most important commands you'll learn:"
    echo ""

    ui_keybinding "Prefix" "c" "Create a new window"
    ui_keybinding "Prefix" "%" "Split pane vertically"
    ui_keybinding "Prefix" "\"" "Split pane horizontally"
    ui_keybinding "Prefix" "d" "Detach from session"
    ui_keybinding "Prefix" "x" "Kill current pane"
    ui_keybinding "Prefix" "n" "Next window"
    ui_keybinding "Prefix" "p" "Previous window"
    echo ""

    engine_teach "Don't worry about memorizing these now - you'll practice each one
in the upcoming lessons!"

    engine_pause

    engine_section "Quick Quiz"

    engine_quiz "What is the default prefix key in tmux?" \
        "Ctrl+a" "Ctrl+b" "Ctrl+c" "Alt+b" \
        2

    echo ""

    engine_quiz "In the tmux hierarchy, what contains panes?" \
        "Server" "Session" "Window" "Terminal" \
        3

    echo ""
    engine_teach "Excellent! You now understand the basics of what tmux is and how
it's organized. In the next lesson, you'll create your first tmux session!"
}
