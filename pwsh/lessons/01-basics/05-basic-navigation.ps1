# Lesson: Basic Navigation

function Lesson-Info {
    Set-LessonInfo `
        -Title "Putting It All Together" `
        -Module "01-basics" `
        -Description "Practice navigating sessions, windows, and panes in a real tmux environment." `
        -Time "8 minutes" `
        -Prerequisites "01-basics/04-panes"
}

function Lesson-Run {
    Engine-Section "Navigation Cheat Sheet"

    Engine-Teach "Let's review all the navigation commands you've learned:"

    Write-Host ""
    Write-Host "  ${C_BOLD}${C_UNDERLINE}Sessions${C_RESET}"
    UI-Keybinding "Prefix" "s" "Session picker"
    UI-Keybinding "Prefix" "(" "Previous session"
    UI-Keybinding "Prefix" ")" "Next session"
    UI-Keybinding "Prefix" "d" "Detach"
    UI-Keybinding "Prefix" "`$" "Rename session"
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_UNDERLINE}Windows${C_RESET}"
    UI-Keybinding "Prefix" "c" "New window"
    UI-Keybinding "Prefix" "n" "Next window"
    UI-Keybinding "Prefix" "p" "Previous window"
    UI-Keybinding "Prefix" "0-9" "Go to window N"
    UI-Keybinding "Prefix" "w" "Window picker"
    UI-Keybinding "Prefix" "," "Rename window"
    UI-Keybinding "Prefix" "&" "Kill window"
    Write-Host ""

    Write-Host "  ${C_BOLD}${C_UNDERLINE}Panes${C_RESET}"
    UI-Keybinding "Prefix" "%" "Split vertical"
    UI-Keybinding "Prefix" '"' "Split horizontal"
    UI-Keybinding "Prefix" "Arrow" "Navigate panes"
    UI-Keybinding "Prefix" "z" "Zoom pane"
    UI-Keybinding "Prefix" "x" "Kill pane"
    UI-Keybinding "Prefix" "!" "Pane to window"
    UI-Keybinding "Prefix" "Space" "Cycle layouts"
    Write-Host ""

    Engine-Pause

    Engine-Section "Command Mode"

    Engine-Teach "You can also run tmux commands directly from inside tmux:"
    Write-Host ""
    UI-Keybinding "Prefix" ":" "Enter command mode"
    Write-Host ""

    Engine-Teach @"
This opens a command prompt at the bottom of the screen. You can type
any tmux command without the 'tmux' prefix. For example:
  :new-window -n mywin
  :split-window -h
  :kill-pane
"@

    Engine-Pause

    Engine-Section "Useful Information Commands"

    Engine-Teach "These commands help you understand your tmux environment:"
    Write-Host ""
    UI-Keybinding "Prefix" "t" "Show a clock (press q to exit)"
    UI-Keybinding "Prefix" "i" "Show current window info"
    UI-Keybinding "Prefix" "q" "Show pane numbers"
    Write-Host ""
    UI-Command "tmux list-sessions" "List all sessions"
    UI-Command "tmux list-windows" "List windows in current session"
    UI-Command "tmux list-panes" "List panes in current window"
    UI-Command "tmux display-message -p '#{session_name}'" "Show current session name"
    Write-Host ""

    Engine-Pause

    Engine-Section "Quick Quiz"

    Engine-Quiz "How do you split a pane vertically (left/right)?" @('Prefix + "', "Prefix + %", "Prefix + |", "Prefix + -") 2

    Write-Host ""

    Engine-Quiz "How do you zoom (fullscreen) a pane?" @("Prefix + f", "Prefix + m", "Prefix + z", "Prefix + Z") 3

    Write-Host ""

    Engine-Quiz "How do you open the interactive session picker?" @("Prefix + w", "Prefix + s", "Prefix + l", "Prefix + t") 2

    Engine-Pause

    # -- Exercise --
    Engine-Section "Final Challenge"

    Engine-Teach "Let's put it all together! Create a mini workspace in the sandbox."

    Engine-Exercise `
        -ExerciseId "navigation-1" `
        -Title "Build a Workspace" `
        -Instructions @"
In the sandbox session 'tmux-learn-sandbox':

1. Create at least 2 windows
2. Name one window 'code'
3. In that window, create at least 2 panes

Switch to sandbox with Prefix + s, do the work,
then switch back here to check.
"@ `
        -VerifyFunc {
            Verify-Reset

            # Check window count
            $winCount = @(tmux list-windows -t (Get-SandboxSession) 2>$null).Count

            if ($winCount -lt 2) {
                Set-VerifyMessage "Need at least 2 windows (found $winCount)"
                Set-VerifyHint "Create more windows with Prefix + c"
                return $false
            }

            # Check for window named 'code'
            $hasCode = $false
            $codeWindow = ""
            $windowList = tmux list-windows -t (Get-SandboxSession) -F '#{window_name}:#{window_index}' 2>$null
            foreach ($entry in $windowList) {
                $parts = $entry -split ':'
                if ($parts[0] -eq "code") {
                    $hasCode = $true
                    $codeWindow = $parts[1]
                    break
                }
            }

            if (-not $hasCode) {
                Set-VerifyMessage "No window named 'code' found"
                Set-VerifyHint "Rename a window: Prefix + , then type 'code'"
                return $false
            }

            # Check pane count in 'code' window
            $paneCount = @(tmux list-panes -t "${SANDBOX_SESSION}:${codeWindow}" 2>$null).Count

            if ($paneCount -lt 2) {
                Set-VerifyMessage "Window 'code' needs at least 2 panes (found $paneCount)"
                Set-VerifyHint "In the 'code' window: Prefix + % to split"
                return $false
            }

            Set-VerifyMessage "Perfect! 2+ windows, 'code' window with $paneCount panes"
            return $true
        } `
        -Hint "In sandbox: Prefix+c (new window), Prefix+, then type 'code', then Prefix+% to split" `
        -UseSandbox "session"

    Engine-Teach @"
Congratulations! You've completed the Basics module. You now have
a solid foundation for using tmux. The next module covers advanced
navigation techniques including copy mode and searching.
"@

    Write-Host ""
    UI-Tip "Practice makes perfect! Try using tmux for your daily work to build muscle memory."
}
