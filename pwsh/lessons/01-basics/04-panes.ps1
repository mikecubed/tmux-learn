# Lesson: Panes

function Lesson-Info {
    Set-LessonInfo `
        -Title "Splitting and Managing Panes" `
        -Module "01-basics" `
        -Description "Learn to split windows into panes, resize them, and navigate between them." `
        -Time "10 minutes" `
        -Prerequisites "01-basics/03-windows"
}

function Lesson-Run {
    Engine-Section "What are Panes?"

    Engine-Teach @"
Panes let you split a single window into multiple sections, each
running its own shell. This is incredibly useful for:
  - Editing code in one pane, running it in another
  - Watching logs while working
  - Running a server and client side by side
"@

    Engine-Pause

    Engine-Section "Splitting Panes"

    Engine-Teach "There are two ways to split a window:"
    Write-Host ""
    UI-Keybinding "Prefix" "%" "Split vertically (left | right)"
    UI-Keybinding "Prefix" '"' "Split horizontally (top / bottom)"
    Write-Host ""

    Write-Host "${C_CYAN}"
    Write-Host ""
    Write-Host "    Prefix + %  (vertical)        Prefix + `"  (horizontal)"
    Write-Host "    +------+------+               +-------------+"
    Write-Host "    |      |      |               |             |"
    Write-Host "    |      |      |               +-------------+"
    Write-Host "    |      |      |               |             |"
    Write-Host "    +------+------+               +-------------+"
    Write-Host ""
    Write-Host "${C_RESET}"

    Engine-Teach "You can split panes multiple times to create complex layouts."

    Engine-Pause

    Engine-Section "Navigating Between Panes"

    Engine-Teach "Move between panes using these keys:"
    Write-Host ""
    UI-Keybinding "Prefix" "Arrow" "Move to pane in that direction"
    UI-Keybinding "Prefix" "o" "Cycle to next pane"
    UI-Keybinding "Prefix" "q" "Show pane numbers (press number to jump)"
    UI-Keybinding "Prefix" ";" "Toggle to last active pane"
    Write-Host ""

    Engine-Pause

    Engine-Section "Resizing Panes"

    Engine-Teach "Adjust pane sizes:"
    Write-Host ""
    UI-Keybinding "Prefix" "Ctrl+Arrow" "Resize by 1 cell"
    UI-Keybinding "Prefix" "Alt+Arrow" "Resize by 5 cells"
    Write-Host ""
    UI-Command "tmux resize-pane -D 10" "Resize down by 10 cells"
    UI-Command "tmux resize-pane -R 20" "Resize right by 20 cells"
    Write-Host ""

    Engine-Pause

    Engine-Section "Zooming Panes"

    Engine-Teach "Sometimes you need to focus on one pane temporarily:"
    Write-Host ""
    UI-Keybinding "Prefix" "z" "Toggle zoom (fullscreen current pane)"
    Write-Host ""

    Engine-Teach @"
When zoomed, the pane takes up the full window. Press Prefix + z
again to restore the layout. The status bar shows a 'Z' flag
when a pane is zoomed.
"@

    Engine-Pause

    Engine-Section "Closing Panes"

    Engine-Teach "Close a pane when you're done:"
    Write-Host ""
    UI-Keybinding "Prefix" "x" "Kill current pane (with confirmation)"
    Write-Host ""
    UI-Command "exit" "Or just type exit / Ctrl+d in the shell"
    Write-Host ""

    Engine-Pause

    Engine-Section "Pane Layouts"

    Engine-Teach "tmux has built-in layouts you can cycle through:"
    Write-Host ""
    UI-Keybinding "Prefix" "Space" "Cycle through preset layouts"
    Write-Host ""
    UI-Command "tmux select-layout even-horizontal" "All panes side by side"
    UI-Command "tmux select-layout even-vertical" "All panes stacked"
    UI-Command "tmux select-layout main-horizontal" "One large + small below"
    UI-Command "tmux select-layout main-vertical" "One large + small right"
    UI-Command "tmux select-layout tiled" "Equal grid"
    Write-Host ""

    Engine-Pause

    Engine-Section "Converting Panes"

    Engine-Teach "You can convert a pane to a window and vice versa:"
    Write-Host ""
    UI-Keybinding "Prefix" "!" "Break pane into its own window"
    Write-Host ""
    UI-Command "tmux join-pane -s 2 -t 1" "Move window 2 into window 1 as a pane"
    Write-Host ""

    Engine-Pause

    # -- Exercise 1 --
    Engine-Exercise `
        -ExerciseId "panes-1" `
        -Title "Create a 4-Pane Layout" `
        -Instructions @"
In the sandbox session 'tmux-learn-sandbox':
Create 4 panes in the first window.

Hint: Start with one pane, split it vertically,
then split each half horizontally.

Like this:
+------+------+
|  P0  |  P1  |
+------+------+
|  P2  |  P3  |
+------+------+

Switch to sandbox with Prefix + s
"@ `
        -VerifyFunc { Verify-PaneCount $SANDBOX_SESSION 4 } `
        -Hint 'In sandbox: Prefix+% (split vertical), then select left pane and Prefix+" (split horizontal), then select right top pane and Prefix+"' `
        -UseSandbox "session"

    # -- Exercise 2 --
    Engine-Exercise `
        -ExerciseId "panes-2" `
        -Title "Apply a Layout" `
        -Instructions @"
In the sandbox session (which should have 4 panes):
Apply the 'tiled' layout to make all panes equal.

Use Prefix + Space to cycle layouts,
or run: tmux select-layout -t tmux-learn-sandbox tiled
"@ `
        -VerifyFunc {
            Verify-Reset
            $count = @(tmux list-panes -t $SANDBOX_SESSION 2>$null).Count

            if ($count -ge 4) {
                Set-VerifyMessage "Found $count panes with layout applied"
                return $true
            } else {
                Set-VerifyMessage "Need at least 4 panes first"
                Set-VerifyHint "Create 4 panes first, then apply the tiled layout"
                return $false
            }
        } `
        -Hint "Run: tmux select-layout -t tmux-learn-sandbox tiled" `
        -UseSandbox "none"

    Engine-Teach @"
Fantastic! Panes are one of tmux's most powerful features. With
practice, you'll instinctively split and arrange panes to match
your workflow.
"@
}
