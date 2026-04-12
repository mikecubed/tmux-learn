# Lesson: Windows

function Lesson-Info {
    Set-LessonInfo `
        -Title "Working with Windows" `
        -Module "01-basics" `
        -Description "Learn to create, navigate, rename, and manage tmux windows." `
        -Time "10 minutes" `
        -Prerequisites "01-basics/02-sessions"
}

function Lesson-Run {
    Engine-Section "What are Windows?"

    Engine-Teach @"
Windows in tmux are like tabs in a web browser. Each window takes
up the full screen and can contain one or more panes.

Every session starts with one window. You can create as many
additional windows as you need.
"@

    Engine-Pause

    Engine-Section "Creating Windows"

    Engine-Teach "Create a new window in the current session:"
    Write-Host ""
    UI-Keybinding "Prefix" "c" "Create a new window"
    Write-Host ""
    UI-Command "tmux new-window" "Command form"
    UI-Command "tmux new-window -n editor" "Create with a name"
    Write-Host ""

    Engine-Teach @"
New windows appear in the status bar at the bottom of the screen.
The current window is marked with an asterisk (*).
"@

    Engine-Pause

    Engine-Section "Navigating Windows"

    Engine-Teach "Several ways to switch between windows:"
    Write-Host ""
    UI-Keybinding "Prefix" "n" "Next window"
    UI-Keybinding "Prefix" "p" "Previous window"
    UI-Keybinding "Prefix" "0-9" "Jump to window by number"
    UI-Keybinding "Prefix" "l" "Last (previously active) window"
    UI-Keybinding "Prefix" "w" "Interactive window list"
    Write-Host ""

    Engine-Teach @"
The window list (Prefix + w) is especially useful when you have
many windows. You can navigate it with arrow keys and Enter.
"@

    Engine-Pause

    Engine-Section "Renaming Windows"

    Engine-Teach "Give your windows meaningful names to stay organized:"
    Write-Host ""
    UI-Keybinding "Prefix" "," "Rename current window (interactive)"
    Write-Host ""
    UI-Command "tmux rename-window editor" "Command form"
    Write-Host ""

    Engine-Teach @"
By default, tmux automatically renames windows based on the
running program. You can disable this with:
  set-option -g allow-rename off
"@

    Engine-Pause

    Engine-Section "Closing Windows"

    Engine-Teach "Close windows when you're done with them:"
    Write-Host ""
    UI-Keybinding "Prefix" "&" "Kill current window (with confirmation)"
    Write-Host ""
    UI-Command "tmux kill-window -t 2" "Kill window number 2"
    Write-Host ""

    Engine-Teach "Closing all panes in a window also closes the window."

    Engine-Pause

    Engine-Section "Moving and Swapping Windows"

    Engine-Teach "Rearrange your windows:"
    Write-Host ""
    UI-Command "tmux swap-window -s 2 -t 1" "Swap windows 2 and 1"
    UI-Command "tmux move-window -t 5" "Move current window to position 5"
    Write-Host ""

    Engine-Pause

    # -- Exercise 1 --
    Engine-Teach "Time to practice! We'll create a sandbox session for you to work in."

    Engine-Exercise `
        -ExerciseId "windows-1" `
        -Title "Create Multiple Windows" `
        -Instructions @"
In the sandbox session 'tmux-learn-sandbox':
1. Create at least 3 windows total

Switch to the sandbox with Prefix + s and select
'tmux-learn-sandbox', then use Prefix + c to
create new windows.

Switch back here with Prefix + s when done.
"@ `
        -VerifyFunc { Verify-WindowCount $SANDBOX_SESSION 3 } `
        -Hint "Switch to sandbox (Prefix+s), then press Prefix+c twice to create 2 more windows (3 total)" `
        -UseSandbox "session"

    # -- Exercise 2 --
    Engine-Exercise `
        -ExerciseId "windows-2" `
        -Title "Rename a Window" `
        -Instructions @"
In the sandbox session 'tmux-learn-sandbox':
Rename any window to 'editor'

Switch to sandbox, navigate to a window, then
press Prefix + , and type 'editor'.

Switch back here with Prefix + s when done.
"@ `
        -VerifyFunc { Verify-WindowNameExists $SANDBOX_SESSION "editor" } `
        -Hint "In the sandbox: Press Prefix + , then type 'editor' and press Enter" `
        -UseSandbox "session"

    Engine-Teach @"
Excellent! You can now manage windows like a pro. Windows help
you organize different tasks within a single session.
"@
}
