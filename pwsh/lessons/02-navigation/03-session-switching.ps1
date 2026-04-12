# Lesson: Session Management and Switching

function Lesson-Info {
    Set-LessonInfo -Title "Session Management and Switching" `
        -Module "02-navigation" `
        -Description "Master switching between sessions, the session tree, and session grouping." `
        -Time "7 minutes" `
        -Prerequisites "02-navigation/02-window-switching"
}

function Lesson-Run {
    Engine-Section "The Session Tree"

    Engine-Teach "The session tree gives you a bird's eye view of everything:"
    Write-Host ""
    UI-Keybinding "Prefix" "s" "Open session tree"
    Write-Host ""

    Engine-Teach "In the session tree:`n  - Arrow keys to navigate`n  - Enter to select`n  - Right arrow to expand a session (see its windows)`n  - Type to filter`n  - x to kill the highlighted session/window"

    Engine-Pause

    Engine-Section "Quick Session Switching"

    Engine-Teach "Navigate between sessions without the tree:"
    Write-Host ""
    UI-Keybinding "Prefix" "(" "Switch to previous session"
    UI-Keybinding "Prefix" ")" "Switch to next session"
    UI-Keybinding "Prefix" "L" "Switch to last session"
    Write-Host ""

    Engine-Teach "The 'last session' toggle (Prefix + L) works just like`n'last window' (Prefix + l) but for sessions. Capital L for`nsessions, lowercase l for windows."

    Engine-Pause

    Engine-Section "Command-Line Session Switching"

    Engine-Teach "Switch sessions from the command line or command mode:"
    Write-Host ""
    UI-Command "tmux switch-client -t mysession" "Switch to named session"
    UI-Command "tmux switch-client -n" "Next session"
    UI-Command "tmux switch-client -p" "Previous session"
    Write-Host ""

    Engine-Pause

    Engine-Section "Session Groups"

    Engine-Teach "Session groups let multiple clients view the same session`nindependently (each can look at different windows):"
    Write-Host ""
    UI-Command "tmux new-session -t existing_session" "Join a session group"
    Write-Host ""

    Engine-Teach "This is different from attaching:`n  - Attach: Both clients see the SAME window at the SAME time`n  - Group: Each client independently navigates windows`n`nSession groups are perfect for pair programming where each person`nwants to look at different files."

    Engine-Pause

    Engine-Section "Detach Other Clients"

    Engine-Teach "If another client is attached and you want exclusive access:"
    Write-Host ""
    UI-Command "tmux attach -d -t mysession" "Attach and detach others"
    UI-Keybinding "Prefix" "D" "Choose which client to detach"
    Write-Host ""

    Engine-Pause

    Engine-Section "Session Environment"

    Engine-Teach "Sessions can have their own environment variables:"
    Write-Host ""
    UI-Command "tmux set-environment -t mysession MY_VAR value" "Set env var"
    UI-Command "tmux show-environment -t mysession" "Show env vars"
    Write-Host ""

    Engine-Teach "This is useful for setting different configurations per project`nsession (like different AWS profiles or database connections)."

    Engine-Pause

    # ── Exercise ──
    Engine-Exercise -ExerciseId "session-switching-1" `
        -Title "Create and Navigate Sessions" `
        -Instructions "Create two new sessions (detached):`n  - 'project-a'`n  - 'project-b'`n`nUse: tmux new-session -d -s <name>`n`nThen verify they exist." `
        -VerifyFunc {
            Verify-Reset
            $hasA = $false
            $hasB = $false

            $null = tmux has-session -t "project-a" 2>$null
            if ($LASTEXITCODE -eq 0) { $hasA = $true }

            $null = tmux has-session -t "project-b" 2>$null
            if ($LASTEXITCODE -eq 0) { $hasB = $true }

            if ($hasA -and $hasB) {
                Set-VerifyMessage "Both sessions 'project-a' and 'project-b' exist"
                return $true
            } else {
                $missing = @()
                if (-not $hasA) { $missing += "project-a" }
                if (-not $hasB) { $missing += "project-b" }
                Set-VerifyMessage "Missing session(s): $($missing -join ', ')"
                Set-VerifyHint "Run: tmux new-session -d -s project-a && tmux new-session -d -s project-b"
                return $false
            }
        } `
        -Hint "Run: tmux new-session -d -s project-a && tmux new-session -d -s project-b" `
        -UseSandbox "none"

    # Cleanup
    tmux kill-session -t "project-a" 2>$null
    tmux kill-session -t "project-b" 2>$null

    Engine-Teach "You now understand the full session management toolkit. Sessions`nlet you organize your work into separate, persistent workspaces."
}
