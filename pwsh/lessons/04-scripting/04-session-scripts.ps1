# Lesson: Session Scripts

function Lesson-Info {
    Set-LessonInfo `
        -Title "Session Management Scripts" `
        -Module "04-scripting" `
        -Description "Build reusable session scripts, smart starters, and project launchers." `
        -Time "10 minutes" `
        -Prerequisites "04-scripting/03-scripted-layouts"
}

function Lesson-Run {
    Engine-Section "The tmux Session Launcher"

    Engine-Teach "A well-crafted session launcher handles all edge cases:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}# Smart session launcher${C_RESET}"
    Write-Host "  ${C_WHITE}SESSION=`"`${1:-default}`"${C_RESET}"
    Write-Host "  ${C_WHITE}WORKDIR=`"`${2:-`$HOME}`"${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# If already in tmux, switch to session${C_RESET}"
    Write-Host "  ${C_WHITE}if [ -n `"`$TMUX`" ]; then${C_RESET}"
    Write-Host "  ${C_WHITE}  if tmux has-session -t `$SESSION 2>/dev/null; then${C_RESET}"
    Write-Host "  ${C_WHITE}    tmux switch-client -t `$SESSION${C_RESET}"
    Write-Host "  ${C_WHITE}  else${C_RESET}"
    Write-Host "  ${C_WHITE}    tmux new-session -d -s `$SESSION -c `$WORKDIR${C_RESET}"
    Write-Host "  ${C_WHITE}    tmux switch-client -t `$SESSION${C_RESET}"
    Write-Host "  ${C_WHITE}  fi${C_RESET}"
    Write-Host "  ${C_WHITE}  exit 0${C_RESET}"
    Write-Host "  ${C_WHITE}fi${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# If not in tmux, attach or create${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-session -A -s `$SESSION -c `$WORKDIR${C_RESET}"
    Write-Host ""

    Engine-Teach @"
The -A flag creates a session if it doesn't exist, or attaches
to it if it does. Perfect for one-liner session management.
"@

    Engine-Pause

    Engine-Section "Project-Specific Launchers"

    Engine-Teach "Create a launcher per project, typically at the project root:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}# .tmux-session.sh - Project session launcher${C_RESET}"
    Write-Host "  ${C_WHITE}PROJECT_DIR=`"`$(cd `"`$(dirname `"`$0`")`" && pwd)`"${C_RESET}"
    Write-Host "  ${C_WHITE}SESSION=`"`$(basename `$PROJECT_DIR)`"${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux has-session -t `$SESSION 2>/dev/null && \${C_RESET}"
    Write-Host "  ${C_WHITE}  { tmux attach -t `$SESSION; exit 0; }${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux new-session -d -s `$SESSION -c `$PROJECT_DIR -n code${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t `$SESSION:code '`$EDITOR .' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux new-window -t `$SESSION -n term -c `$PROJECT_DIR${C_RESET}"
    Write-Host "  ${C_WHITE}tmux new-window -t `$SESSION -n git -c `$PROJECT_DIR${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t `$SESSION:git 'git status' Enter${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux select-window -t `$SESSION:code${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t `$SESSION${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Session Chooser"

    Engine-Teach "Build an interactive session picker:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}# tmux-chooser: Pick or create a session${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}if ! tmux list-sessions 2>/dev/null; then${C_RESET}"
    Write-Host "  ${C_WHITE}  echo 'No sessions. Creating default...'${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux new-session -s main${C_RESET}"
    Write-Host "  ${C_WHITE}  exit 0${C_RESET}"
    Write-Host "  ${C_WHITE}fi${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}echo 'Active sessions:'${C_RESET}"
    Write-Host "  ${C_WHITE}tmux list-sessions -F '  #{session_name} (#{session_windows} windows)'${C_RESET}"
    Write-Host "  ${C_WHITE}echo ''${C_RESET}"
    Write-Host "  ${C_WHITE}read -p 'Session name (or Enter for last): ' name${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}if [ -z `"`$name`" ]; then${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux attach${C_RESET}"
    Write-Host "  ${C_WHITE}else${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux new-session -A -s `"`$name`"${C_RESET}"
    Write-Host "  ${C_WHITE}fi${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Shell Integration"

    Engine-Teach "Add tmux to your shell profile for automatic session management:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Add to ~/.bashrc or ~/.zshrc${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Auto-start tmux on SSH connections${C_RESET}"
    Write-Host "  ${C_WHITE}if [ -n `"`$SSH_CONNECTION`" ] && [ -z `"`$TMUX`" ]; then${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux new-session -A -s ssh${C_RESET}"
    Write-Host "  ${C_WHITE}fi${C_RESET}"
    Write-Host ""

    Engine-Teach "Or a function to quickly jump to project sessions:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# Quick project session function${C_RESET}"
    Write-Host "  ${C_WHITE}tp() {${C_RESET}"
    Write-Host "  ${C_WHITE}  local dir=`"`${1:-.}`"${C_RESET}"
    Write-Host "  ${C_WHITE}  local name=`$(basename `"`$(cd `"`$dir`" && pwd)`")${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux new-session -A -s `"`$name`" -c `"`$(cd `"`$dir`" && pwd)`"${C_RESET}"
    Write-Host "  ${C_WHITE}}${C_RESET}"
    Write-Host ""

    Engine-Teach "Usage: tp ~/projects/myapp  (creates/attaches to 'myapp' session)"

    Engine-Pause

    Engine-Section "Respawn and Recovery"

    Engine-Teach "Useful commands for long-running processes:"
    Write-Host ""
    UI-Command "tmux respawn-pane -t work:0.1" "Restart a dead pane"
    UI-Command "tmux respawn-pane -k -t work:0.1 'npm start'" "Kill and restart with command"
    UI-Command "tmux respawn-window -t work:server" "Restart a dead window"
    Write-Host ""

    Engine-Teach @"
respawn-pane restarts the pane's shell (or a specific command)
without changing the layout. Perfect for restarting crashed servers.
"@

    Engine-Pause

    Engine-Section "Pipe Pane"

    Engine-Teach "Log all output from a pane to a file:"
    Write-Host ""
    UI-Command "tmux pipe-pane -t work:0 'cat >> ~/tmux-work.log'" "Start logging"
    UI-Command "tmux pipe-pane -t work:0" "Stop logging (no argument)"
    Write-Host ""

    Engine-Teach @"
This captures everything displayed in the pane, including
terminal escape codes. Useful for debugging and auditing.
"@

    Engine-Pause

    # -- Exercise --
    Engine-Exercise -ExerciseId "session-scripts-1" `
        -Title "Create a Smart Session" `
        -Instructions @"
Create a session that:
1. Named 'smart-test'
2. Has 2 windows: 'code' and 'term'

Run these commands:
  tmux new-session -d -s smart-test -n code
  tmux new-window -t smart-test -n term
  tmux select-window -t smart-test:code

Then type 'check' to verify.
"@ `
        -VerifyFunc {
            Verify-Reset

            $null = tmux has-session -t "smart-test" 2>$null
            if ($LASTEXITCODE -ne 0) {
                Set-VerifyMessage "Session 'smart-test' not found"
                Set-VerifyHint "Run: tmux new-session -d -s smart-test -n code"
                return $false
            }

            $names = tmux list-windows -t "smart-test" -F '#{window_name}' 2>$null

            $hasCode = $false
            $hasTerm = $false
            foreach ($name in $names) {
                if ($name -eq "code") { $hasCode = $true }
                if ($name -eq "term") { $hasTerm = $true }
            }

            if ($hasCode -and $hasTerm) {
                Set-VerifyMessage "Session 'smart-test' has windows 'code' and 'term'"
                return $true
            } else {
                $missing = @()
                if (-not $hasCode) { $missing += "code" }
                if (-not $hasTerm) { $missing += "term" }
                Set-VerifyMessage "Missing window(s): $($missing -join ', ')"
                Set-VerifyHint "Run: tmux new-session -d -s smart-test -n code && tmux new-window -t smart-test -n term"
                return $false
            }
        } `
        -Hint "Run: tmux new-session -d -s smart-test -n code && tmux new-window -t smart-test -n term" `
        -UseSandbox "none"

    # Cleanup
    tmux kill-session -t smart-test 2>$null

    Engine-Teach @"
You've completed the Scripting module! You can now automate any
tmux workflow. The final module covers advanced topics like hooks,
plugins, and pair programming.
"@
}
