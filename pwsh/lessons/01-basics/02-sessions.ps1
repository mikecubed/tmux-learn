# Lesson: Sessions

function Lesson-Info {
    Set-LessonInfo `
        -Title "Creating and Managing Sessions" `
        -Module "01-basics" `
        -Description "Learn to create, list, detach from, attach to, and kill tmux sessions." `
        -Time "10 minutes" `
        -Prerequisites "01-basics/01-what-is-tmux"
}

function Lesson-Run {
    Engine-Section "What is a Session?"

    Engine-Teach @"
A session is the top-level container in tmux. Each session is an
independent workspace with its own set of windows and panes.

You might have one session for each project you're working on:
  - 'webapp' for your web application
  - 'api' for your backend service
  - 'dotfiles' for config editing
"@

    Engine-Pause

    Engine-Section "Creating Sessions"

    Engine-Teach @"
You create sessions from the command line using 'tmux new-session'
(or the shorthand 'tmux new').
"@

    Write-Host ""
    UI-Command "tmux new-session -s myproject" "Create a named session"
    UI-Command "tmux new -s myproject" "Short form"
    UI-Command "tmux new -d -s background" "Create detached (in background)"
    Write-Host ""

    Engine-Teach @"
The -s flag sets the session name. The -d flag creates it
detached so you don't switch to it immediately.
"@

    Engine-Pause

    Engine-Section "Listing Sessions"

    Engine-Teach "To see all running sessions:"
    Write-Host ""
    UI-Command "tmux list-sessions" "Full command"
    UI-Command "tmux ls" "Short form"
    Write-Host ""

    Engine-Teach "Or from inside tmux, press:"
    Write-Host ""
    UI-Keybinding "Prefix" "s" "Show session list (interactive)"
    Write-Host ""

    Engine-Pause

    Engine-Section "Detaching from Sessions"

    Engine-Teach @"
Detaching leaves the session running in the background. This is one
of tmux's most powerful features - your work persists even after
you disconnect!
"@
    Write-Host ""
    UI-Keybinding "Prefix" "d" "Detach from current session"
    Write-Host ""
    UI-Command "tmux detach" "Command form"
    Write-Host ""

    Engine-Pause

    Engine-Section "Attaching to Sessions"

    Engine-Teach "To reconnect to a running session:"
    Write-Host ""
    UI-Command "tmux attach -t myproject" "Attach to a named session"
    UI-Command "tmux a -t myproject" "Short form"
    UI-Command "tmux a" "Attach to last session"
    Write-Host ""

    Engine-Pause

    Engine-Section "Switching Between Sessions"

    Engine-Teach "When you're inside tmux and want to switch sessions:"
    Write-Host ""
    UI-Keybinding "Prefix" "s" "Interactive session picker"
    UI-Keybinding "Prefix" "(" "Previous session"
    UI-Keybinding "Prefix" ")" "Next session"
    Write-Host ""

    Engine-Pause

    Engine-Section "Killing Sessions"

    Engine-Teach "To destroy a session and all its windows/panes:"
    Write-Host ""
    UI-Command "tmux kill-session -t myproject" "Kill a specific session"
    UI-Command "tmux kill-server" "Kill ALL sessions (careful!)"
    Write-Host ""

    Engine-Pause

    Engine-Section "Renaming Sessions"

    Engine-Teach "You can rename an existing session:"
    Write-Host ""
    UI-Keybinding "Prefix" "`$" "Rename current session (interactive)"
    UI-Command "tmux rename-session -t old new" "Command form"
    Write-Host ""

    Engine-Pause

    # -- Exercise 1 --
    Engine-Exercise `
        -ExerciseId "sessions-1" `
        -Title "Create a Named Session" `
        -Instructions @"
Create a new tmux session named 'practice'.

Use the sandbox session or open a new terminal pane.
Remember: tmux new-session -d -s practice

(Use -d to create it detached so you stay here)
"@ `
        -VerifyFunc { Verify-SessionExists "practice" } `
        -Hint "Run: tmux new-session -d -s practice" `
        -UseSandbox "none"

    # -- Exercise 2 --
    Engine-Exercise `
        -ExerciseId "sessions-2" `
        -Title "Create Multiple Sessions" `
        -Instructions @"
Create two MORE sessions (in addition to 'practice'):
  - One named 'dev'
  - One named 'logs'

Use -d flag to keep them detached.
"@ `
        -VerifyFunc {
            Verify-Reset
            $hasDev = $false
            $hasLogs = $false

            $null = tmux has-session -t "dev" 2>$null
            if ($LASTEXITCODE -eq 0) { $hasDev = $true }
            $null = tmux has-session -t "logs" 2>$null
            if ($LASTEXITCODE -eq 0) { $hasLogs = $true }

            if ($hasDev -and $hasLogs) {
                Set-VerifyMessage "Sessions 'dev' and 'logs' both exist"
                return $true
            } else {
                $missing = @()
                if (-not $hasDev) { $missing += "dev" }
                if (-not $hasLogs) { $missing += "logs" }
                Set-VerifyMessage "Missing session(s): $($missing -join ', ')"
                Set-VerifyHint "Create them with: tmux new-session -d -s dev && tmux new-session -d -s logs"
                return $false
            }
        } `
        -Hint "Run: tmux new-session -d -s dev && tmux new-session -d -s logs" `
        -UseSandbox "none"

    # -- Exercise 3 --
    Engine-Teach @"
Now let's practice cleaning up. You should have sessions named
'practice', 'dev', and 'logs' running.
"@

    Engine-Exercise `
        -ExerciseId "sessions-3" `
        -Title "Kill a Session" `
        -Instructions @"
Kill the session named 'logs'.

Remember: tmux kill-session -t <name>
"@ `
        -VerifyFunc { Verify-SessionNotExists "logs" } `
        -Hint "Run: tmux kill-session -t logs" `
        -UseSandbox "none"

    # Cleanup remaining practice sessions
    tmux kill-session -t practice 2>$null
    tmux kill-session -t dev 2>$null
    tmux kill-session -t logs 2>$null

    Engine-Teach @"
Great work! You can now create, manage, and destroy tmux sessions.
Sessions are the foundation of everything in tmux.
"@
}
