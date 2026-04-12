# Lesson: What is tmux?

function Lesson-Info {
    Set-LessonInfo `
        -Title "What is tmux?" `
        -Module "01-basics" `
        -Description "Learn what tmux is, why it's useful, and understand its core concepts." `
        -Time "5 minutes"
}

function Lesson-Run {
    Engine-Section "Welcome to tmux!"

    Engine-Teach @"
tmux (Terminal MUltipleXer) is a powerful tool that lets you run
multiple terminal sessions inside a single window. Think of it as a
window manager for your terminal.
"@

    Engine-Pause

    Engine-Section "Why use tmux?"

    Engine-Teach "Here are the top reasons developers love tmux:"

    UI-Print $C_GREEN "  1. Persistent sessions - Your work survives disconnections"
    UI-Print $C_GREEN "  2. Multiple windows   - Like browser tabs for your terminal"
    UI-Print $C_GREEN "  3. Split panes        - See multiple things at once"
    UI-Print $C_GREEN "  4. Remote work        - Keep sessions alive on servers"
    UI-Print $C_GREEN "  5. Pair programming   - Share sessions with teammates"
    Write-Host ""

    Engine-Teach @"
Imagine you're SSH'd into a server running a long process.
Without tmux, if your connection drops, the process dies.
With tmux, it keeps running and you can reconnect anytime.
"@

    Engine-Pause

    Engine-Section "The tmux Hierarchy"

    Engine-Teach "tmux organizes everything in a simple hierarchy:"

    Write-Host "${C_CYAN}"
    Write-Host ""
    Write-Host "      +---------------------------------------------+"
    Write-Host "      |                 tmux server                  |"
    Write-Host "      |                                              |"
    Write-Host "      |   +-------------------------------------+   |"
    Write-Host "      |   |           Session: `"dev`"             |   |"
    Write-Host "      |   |                                      |   |"
    Write-Host "      |   |  +----------+  +----------+         |   |"
    Write-Host "      |   |  | Window 0  |  | Window 1  |  ...   |   |"
    Write-Host "      |   |  | `"editor`"  |  | `"server`"  |        |   |"
    Write-Host "      |   |  |           |  |           |        |   |"
    Write-Host "      |   |  | +---+---+ |  | +--------+|        |   |"
    Write-Host "      |   |  | |P0 |P1 | |  | |  Pane  ||        |   |"
    Write-Host "      |   |  | +---+---+ |  | |   0    ||        |   |"
    Write-Host "      |   |  | |  P2   | |  | |        ||        |   |"
    Write-Host "      |   |  | +-------+ |  | +--------+|        |   |"
    Write-Host "      |   |  +----------+  +----------+         |   |"
    Write-Host "      |   +-------------------------------------+   |"
    Write-Host "      |                                              |"
    Write-Host "      |   +-------------------------------------+   |"
    Write-Host "      |   |        Session: `"monitoring`"         |   |"
    Write-Host "      |   |            ...                       |   |"
    Write-Host "      |   +-------------------------------------+   |"
    Write-Host "      +---------------------------------------------+"
    Write-Host ""
    Write-Host "${C_RESET}"

    Engine-Teach "Let's break this down:"

    UI-Print $C_BOLD "  Server  - Runs in the background, manages everything"
    UI-Print $C_BOLD "  Session - A collection of windows (like a workspace)"
    UI-Print $C_BOLD "  Window  - A full-screen view (like a browser tab)"
    UI-Print $C_BOLD "  Pane    - A split within a window"
    Write-Host ""

    Engine-Pause

    Engine-Section "The Prefix Key"

    Engine-Teach @"
tmux uses a 'prefix key' to distinguish its commands from regular
terminal input. By default, this is:
"@

    Write-Host ""
    UI-Keybinding "Ctrl-b" "" "The default tmux prefix key"
    Write-Host ""

    Engine-Teach @"
You press the prefix first, release it, then press the command key.
For example, to create a new window:
"@

    Write-Host ""
    UI-Print $C_DIM "  Step 1: Press Ctrl+b (and release)"
    UI-Print $C_DIM "  Step 2: Press c"
    Write-Host ""

    Engine-Teach "Throughout this tutorial, we'll write this as: Prefix + c"

    Engine-Pause

    Engine-Section "Key Commands to Remember"

    Engine-Teach "Here are the most important commands you'll learn:"
    Write-Host ""

    UI-Keybinding "Prefix" "c" "Create a new window"
    UI-Keybinding "Prefix" "%" "Split pane vertically"
    UI-Keybinding "Prefix" '"' "Split pane horizontally"
    UI-Keybinding "Prefix" "d" "Detach from session"
    UI-Keybinding "Prefix" "x" "Kill current pane"
    UI-Keybinding "Prefix" "n" "Next window"
    UI-Keybinding "Prefix" "p" "Previous window"
    Write-Host ""

    Engine-Teach @"
Don't worry about memorizing these now - you'll practice each one
in the upcoming lessons!
"@

    Engine-Pause

    Engine-Section "Quick Quiz"

    Engine-Quiz "What is the default prefix key in tmux?" @("Ctrl+a", "Ctrl+b", "Ctrl+c", "Alt+b") 2

    Write-Host ""

    Engine-Quiz "In the tmux hierarchy, what contains panes?" @("Server", "Session", "Window", "Terminal") 3

    Write-Host ""
    Engine-Teach @"
Excellent! You now understand the basics of what tmux is and how
it's organized. In the next lesson, you'll create your first tmux session!
"@
}
