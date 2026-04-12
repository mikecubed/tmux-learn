# Lesson: tmux Commands from Shell

function Lesson-Info {
    Set-LessonInfo `
        -Title "Running tmux Commands from Shell" `
        -Module "04-scripting" `
        -Description "Learn to control tmux programmatically from the command line and scripts." `
        -Time "8 minutes" `
        -Prerequisites "03-customization/04-colors-and-themes"
}

function Lesson-Run {
    Engine-Section "tmux as a Scriptable Tool"

    Engine-Teach @"
Everything you do with key bindings can also be done with
commands. This makes tmux fully scriptable - you can automate
any workflow with shell scripts.
"@
    Write-Host ""

    Engine-Teach "The basic pattern is: tmux <command> [arguments]"

    Engine-Pause

    Engine-Section "Session Commands"

    Engine-Teach "Create and manage sessions programmatically:"
    Write-Host ""
    UI-Command "tmux new-session -d -s work" "Create detached session"
    UI-Command "tmux new-session -d -s work -x 200 -y 50" "With specific size"
    UI-Command "tmux kill-session -t work" "Kill a session"
    UI-Command "tmux has-session -t work 2>/dev/null" "Check if session exists"
    UI-Command "tmux rename-session -t old new" "Rename a session"
    UI-Command "tmux switch-client -t work" "Switch to session"
    Write-Host ""

    Engine-Pause

    Engine-Section "Window Commands"

    Engine-Teach "Create and manage windows:"
    Write-Host ""
    UI-Command "tmux new-window -t work" "New window in session 'work'"
    UI-Command "tmux new-window -t work -n editor" "New window with name"
    UI-Command "tmux select-window -t work:0" "Switch to window 0"
    UI-Command "tmux rename-window -t work:0 main" "Rename window"
    UI-Command "tmux kill-window -t work:2" "Kill window 2"
    Write-Host ""

    Engine-Pause

    Engine-Section "Pane Commands"

    Engine-Teach "Split and manage panes:"
    Write-Host ""
    UI-Command "tmux split-window -h -t work" "Vertical split"
    UI-Command "tmux split-window -v -t work" "Horizontal split"
    UI-Command "tmux split-window -h -p 30" "Split with 30% width"
    UI-Command "tmux select-pane -t work:0.1" "Select pane 1 in window 0"
    UI-Command "tmux resize-pane -t work -R 10" "Resize pane right"
    UI-Command "tmux select-layout -t work tiled" "Apply tiled layout"
    Write-Host ""

    Engine-Pause

    Engine-Section "Target Syntax"

    Engine-Teach "tmux uses a specific syntax for targeting sessions, windows, and panes:"
    Write-Host ""
    Write-Host "  ${C_BOLD}session${C_RESET}           Target a session"
    Write-Host "  ${C_BOLD}session:window${C_RESET}     Target a window in a session"
    Write-Host "  ${C_BOLD}session:window.pane${C_RESET} Target a specific pane"
    Write-Host ""

    Engine-Teach "Examples:"
    Write-Host ""
    UI-Command "tmux send-keys -t work:0.1 'ls' Enter" "Type 'ls' in work, window 0, pane 1"
    UI-Command "tmux select-pane -t :0.0" "Pane 0 in window 0 (current session)"
    UI-Command "tmux select-window -t :+" "Next window (current session)"
    Write-Host ""

    Engine-Pause

    Engine-Section "Querying tmux State"

    Engine-Teach "Get information about the current tmux environment:"
    Write-Host ""
    UI-Command "tmux display-message -p '#{session_name}'" "Current session name"
    UI-Command "tmux display-message -p '#{window_index}'" "Current window index"
    UI-Command "tmux display-message -p '#{pane_id}'" "Current pane ID"
    UI-Command "tmux list-sessions -F '#{session_name}'" "All session names"
    UI-Command "tmux list-windows -F '#{window_name}'" "All window names"
    UI-Command "tmux list-panes -F '#{pane_index}:#{pane_width}x#{pane_height}'" "Pane details"
    Write-Host ""

    Engine-Teach @"
The -F flag lets you specify a format string for the output.
This is essential for parsing tmux state in scripts.
"@

    Engine-Pause

    Engine-Section "Chaining Commands"

    Engine-Teach "Run multiple tmux commands in sequence:"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Using shell chaining${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-window -n logs \${C_RESET}"
    Write-Host "  ${C_WHITE}  && tmux split-window -h \${C_RESET}"
    Write-Host "  ${C_WHITE}  && tmux send-keys 'tail -f app.log' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Using tmux command chaining (in tmux.conf or command mode)${C_RESET}"
    Write-Host "  ${C_WHITE}new-window -n logs \; split-window -h \; send-keys 'tail -f app.log' Enter${C_RESET}"
    Write-Host ""

    Engine-Teach @"
The \; separator chains commands within a single tmux invocation.
This is faster than running tmux multiple times.
"@

    Engine-Pause

    # -- Exercise --
    Engine-Exercise -ExerciseId "tmux-commands-1" `
        -Title "Create a Session with Commands" `
        -Instructions @"
Using tmux commands, create:
1. A detached session named 'scripted'
2. With a window named 'main'

Use this command:
  tmux new-session -d -s scripted -n main

Then type 'check' to verify.
"@ `
        -VerifyFunc {
            Verify-Reset
            $null = tmux has-session -t "scripted" 2>$null
            if ($LASTEXITCODE -ne 0) {
                Set-VerifyMessage "Session 'scripted' not found"
                Set-VerifyHint "Run: tmux new-session -d -s scripted -n main"
                return $false
            }

            $winName = tmux list-windows -t "scripted" -F '#{window_name}' 2>$null | Select-Object -First 1

            if ($winName -eq "main") {
                Set-VerifyMessage "Session 'scripted' with window 'main' exists"
                return $true
            } else {
                Set-VerifyMessage "Window name is '$winName', expected 'main'"
                Set-VerifyHint "Kill and recreate: tmux kill-session -t scripted && tmux new-session -d -s scripted -n main"
                return $false
            }
        } `
        -Hint "Run: tmux new-session -d -s scripted -n main" `
        -UseSandbox "none"

    # Cleanup
    tmux kill-session -t scripted 2>$null

    Engine-Teach @"
You now know how to drive tmux from the command line. This is
the foundation for building automated tmux scripts.
"@
}
