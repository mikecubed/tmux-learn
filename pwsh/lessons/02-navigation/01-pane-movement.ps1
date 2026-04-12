# Lesson: Advanced Pane Movement

function Lesson-Info {
    Set-LessonInfo -Title "Advanced Pane Movement" `
        -Module "02-navigation" `
        -Description "Master pane resizing, swapping, and advanced movement techniques." `
        -Time "8 minutes" `
        -Prerequisites "01-basics/05-basic-navigation"
}

function Lesson-Run {
    Engine-Section "Precise Pane Resizing"

    Engine-Teach "In the basics module you learned Prefix + Ctrl+Arrow for resizing.`nLet's explore more precise control:"
    Write-Host ""
    UI-Command "tmux resize-pane -L 5" "Shrink left by 5 cells"
    UI-Command "tmux resize-pane -R 5" "Grow right by 5 cells"
    UI-Command "tmux resize-pane -U 5" "Shrink up by 5 cells"
    UI-Command "tmux resize-pane -D 5" "Grow down by 5 cells"
    Write-Host ""

    Engine-Teach "You can also resize to exact dimensions:"
    Write-Host ""
    UI-Command "tmux resize-pane -x 80" "Set width to 80 columns"
    UI-Command "tmux resize-pane -y 24" "Set height to 24 rows"
    Write-Host ""

    Engine-Teach "Or use percentages (tmux 3.1+):"
    Write-Host ""
    UI-Command "tmux resize-pane -x 50%" "Set width to 50% of window"
    Write-Host ""

    Engine-Pause

    Engine-Section "Swapping Panes"

    Engine-Teach "Rearrange panes without recreating them:"
    Write-Host ""
    UI-Keybinding "Prefix" "{" "Swap current pane with previous"
    UI-Keybinding "Prefix" "}" "Swap current pane with next"
    Write-Host ""
    UI-Command "tmux swap-pane -s 0 -t 1" "Swap pane 0 with pane 1"
    UI-Command "tmux swap-pane -U" "Swap with pane above"
    UI-Command "tmux swap-pane -D" "Swap with pane below"
    Write-Host ""

    Engine-Pause

    Engine-Section "Pane Display and Selection"

    Engine-Teach "Quickly identify and jump to panes:"
    Write-Host ""
    UI-Keybinding "Prefix" "q" "Display pane numbers"
    Write-Host ""

    Engine-Teach "When pane numbers appear, press the number to jump to that pane.`nYou can increase the display time with:"
    Write-Host ""
    UI-Command "tmux set -g display-panes-time 5000" "Show pane numbers for 5 seconds"
    Write-Host ""

    Engine-Pause

    Engine-Section "Rotating Panes"

    Engine-Teach "Rotate all panes in the current window:"
    Write-Host ""
    UI-Keybinding "Prefix" "Ctrl+o" "Rotate panes forward"
    UI-Keybinding "Prefix" "Alt+o" "Rotate panes backward"
    Write-Host ""

    Engine-Teach "This shifts every pane's content to the next position in the layout.`nUseful when you want to rearrange without changing the layout itself."

    Engine-Pause

    Engine-Section "Marking Panes"

    Engine-Teach "You can 'mark' a pane for reference in commands (tmux 2.4+):"
    Write-Host ""
    UI-Keybinding "Prefix" "m" "Toggle mark on current pane"
    Write-Host ""

    Engine-Teach "The marked pane can be referenced as {marked} in commands:`n  tmux swap-pane -s {marked}`n  tmux join-pane -s {marked}`n`nThis is useful when you need to reference a specific pane in a`ncomplex layout."

    Engine-Pause

    # ── Exercise ──
    Engine-Exercise -ExerciseId "pane-movement-1" `
        -Title "Create and Rearrange Panes" `
        -Instructions "In the sandbox session 'tmux-learn-sandbox':`n`n1. Create 3 panes (split the window twice)`n2. The window should have at least 3 panes`n`nSwitch to sandbox with Prefix + s" `
        -VerifyFunc {
            Verify-PaneCount $SANDBOX_SESSION 3
        } `
        -Hint "In sandbox: Prefix+% then Prefix+`" to get 3 panes" `
        -UseSandbox "session"

    Engine-Teach "You now have precise control over pane positioning and sizing.`nThese skills are essential for building efficient layouts."
}
