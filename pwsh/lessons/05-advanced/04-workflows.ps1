# Lesson: Real-World tmux Workflows

function Lesson-Info {
    Set-LessonInfo `
        -Title "Real-World tmux Workflows" `
        -Module "05-advanced" `
        -Description "Master professional tmux workflows, IDE-like setups, and productivity patterns." `
        -Time "10 minutes" `
        -Prerequisites "05-advanced/03-pair-programming"
}

function Lesson-Run {
    Engine-Section "The IDE-Like Layout"

    Engine-Teach "Recreate an IDE experience in the terminal:"

    Write-Host ""
    Write-Host "${C_CYAN}"
    Write-Host "    ┌──────────────────────────────────────────────┐"
    Write-Host "    │  Window: code                                │"
    Write-Host "    │ ┌──────────┬───────────────────────────────┐ │"
    Write-Host "    │ │ File     │                               │ │"
    Write-Host "    │ │ Tree     │         Editor (vim)          │ │"
    Write-Host "    │ │ (Pane 0) │         (Pane 1)              │ │"
    Write-Host "    │ │          │                               │ │"
    Write-Host "    │ │  20%     │          60%                  │ │"
    Write-Host "    │ ├──────────┴───────────────┬───────────────┤ │"
    Write-Host "    │ │      Terminal            │   Git Status  │ │"
    Write-Host "    │ │      (Pane 2)            │   (Pane 3)    │ │"
    Write-Host "    │ │          60%             │     20%       │ │"
    Write-Host "    │ └──────────────────────────┴───────────────┘ │"
    Write-Host "    └──────────────────────────────────────────────┘"
    Write-Host ""
    Write-Host "${C_RESET}"

    Engine-Teach "Script to create this layout:"

    Write-Host ""
    Write-Host "  ${C_WHITE}tmux new-session -d -s ide -n code -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -h -t ide:code -p 80 -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -v -t ide:code.1 -p 30 -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -h -t ide:code.2 -p 25 -c `$PROJECT${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t ide:code.0 'ranger' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t ide:code.1 'vim .' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t ide:code.3 'git status' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux select-pane -t ide:code.1${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "The DevOps Dashboard"

    Engine-Teach "Monitor multiple services at once:"

    Write-Host ""
    Write-Host "${C_CYAN}"
    Write-Host "    ┌──────────────────────────────────────────────┐"
    Write-Host "    │  Window: monitor                             │"
    Write-Host "    │ ┌─────────────────────┬────────────────────┐ │"
    Write-Host "    │ │   htop / top        │   Docker logs      │ │"
    Write-Host "    │ │                     │                    │ │"
    Write-Host "    │ ├─────────────────────┼────────────────────┤ │"
    Write-Host "    │ │   App logs          │   Network monitor  │ │"
    Write-Host "    │ │   (tail -f)         │   (iftop/nload)    │ │"
    Write-Host "    │ └─────────────────────┴────────────────────┘ │"
    Write-Host "    └──────────────────────────────────────────────┘"
    Write-Host ""
    Write-Host "${C_RESET}"

    Write-Host "  ${C_WHITE}tmux new-session -d -s monitor -n dash${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys -t monitor:dash 'htop' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -h -t monitor:dash${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys 'docker logs -f myapp' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -v -t monitor:dash.0${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys 'tail -f /var/log/app.log' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux split-window -v -t monitor:dash.1${C_RESET}"
    Write-Host "  ${C_WHITE}tmux send-keys 'watch -n1 ss -tlnp' Enter${C_RESET}"
    Write-Host "  ${C_WHITE}tmux select-layout -t monitor:dash tiled${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "The Multi-Server Admin"

    Engine-Teach "Manage multiple servers simultaneously:"

    Write-Host ""
    Write-Host "  ${C_WHITE}#!/bin/bash${C_RESET}"
    Write-Host "  ${C_WHITE}# Connect to multiple servers${C_RESET}"
    Write-Host "  ${C_WHITE}SERVERS=(web1 web2 web3 db1 db2)${C_RESET}"
    Write-Host "  ${C_WHITE}SESSION=`"servers`"${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux new-session -d -s `$SESSION${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}for i in `"`${!SERVERS[@]}`"; do${C_RESET}"
    Write-Host "  ${C_WHITE}  if [ `$i -gt 0 ]; then${C_RESET}"
    Write-Host "  ${C_WHITE}    tmux split-window -t `$SESSION${C_RESET}"
    Write-Host "  ${C_WHITE}    tmux select-layout -t `$SESSION tiled${C_RESET}"
    Write-Host "  ${C_WHITE}  fi${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux send-keys -t `$SESSION `"ssh `${SERVERS[`$i]}`" Enter${C_RESET}"
    Write-Host "  ${C_WHITE}done${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}tmux select-layout -t `$SESSION tiled${C_RESET}"
    Write-Host "  ${C_WHITE}tmux attach -t `$SESSION${C_RESET}"
    Write-Host ""

    Engine-Teach "Then use synchronize-panes to type commands on all servers at once!"

    Engine-Pause

    Engine-Section "SSH Workflow Patterns"

    Engine-Teach "Keep SSH sessions alive and organized:"

    Write-Host ""
    Write-Host "  ${C_WHITE}# On remote server, always use tmux${C_RESET}"
    Write-Host "  ${C_WHITE}ssh server 'tmux new-session -A -s main'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_WHITE}# Or in your .bashrc on the server:${C_RESET}"
    Write-Host "  ${C_WHITE}if [ -n `"`$SSH_CONNECTION`" ] && [ -z `"`$TMUX`" ]; then${C_RESET}"
    Write-Host "  ${C_WHITE}  tmux new-session -A -s `$(whoami)${C_RESET}"
    Write-Host "  ${C_WHITE}fi${C_RESET}"
    Write-Host ""

    Engine-Teach @"
This means you never lose work on a remote server, even if
your connection drops.
"@

    Engine-Pause

    Engine-Section "Nested tmux Sessions"

    Engine-Teach @"
When you SSH from tmux into a server also running tmux, you
get nested sessions. Handle this with different prefix keys:
"@

    Write-Host ""
    Write-Host "  ${C_WHITE}# On remote server's tmux.conf${C_RESET}"
    Write-Host "  ${C_WHITE}set -g prefix C-a  # Different from local Ctrl+b${C_RESET}"
    Write-Host ""

    Engine-Teach "Or send the prefix to the inner session:"
    Write-Host ""
    UI-Keybinding "Prefix" "Prefix" "Sends prefix to inner tmux"
    Write-Host ""

    Engine-Teach @"
Example: If your prefix is Ctrl+b, pressing Ctrl+b twice sends
Ctrl+b to the inner tmux session.
"@

    Engine-Pause

    Engine-Section "Productivity Tips"

    Engine-Teach "Final tips for tmux mastery:"

    Write-Host ""
    Write-Host "  ${C_BOLD}1. Name everything${C_RESET}"
    Write-Host "     Name sessions and windows descriptively."
    Write-Host "     Future you will thank present you."
    Write-Host ""
    Write-Host "  ${C_BOLD}2. Use scripts for repeatable setups${C_RESET}"
    Write-Host "     If you set up the same layout twice, script it."
    Write-Host ""
    Write-Host "  ${C_BOLD}3. Keep a cheat sheet handy${C_RESET}"
    Write-Host "     Until muscle memory kicks in (~2 weeks)."
    Write-Host ""
    Write-Host "  ${C_BOLD}4. Start simple, add complexity${C_RESET}"
    Write-Host "     Don't try to configure everything day one."
    Write-Host "     Add keybindings and plugins as you need them."
    Write-Host ""
    Write-Host "  ${C_BOLD}5. Use tmux-resurrect${C_RESET}"
    Write-Host "     Session persistence is a game changer."
    Write-Host ""
    Write-Host "  ${C_BOLD}6. Learn copy mode well${C_RESET}"
    Write-Host "     It replaces scrolling with the mouse and is"
    Write-Host "     much more powerful once you get used to it."
    Write-Host ""
    Write-Host "  ${C_BOLD}7. Integrate with your editor${C_RESET}"
    Write-Host "     vim-tmux-navigator or similar makes tmux"
    Write-Host "     and your editor feel like one tool."
    Write-Host ""

    Engine-Pause

    Engine-Section "Your tmux.conf Starter Kit"

    Engine-Teach "Here's a complete, battle-tested tmux.conf to get you started:"

    Write-Host ""
    Write-Host "  ${C_GREEN}# ── General ──${C_RESET}"
    Write-Host "  ${C_WHITE}set -g default-terminal 'tmux-256color'${C_RESET}"
    Write-Host "  ${C_WHITE}set -g mouse on${C_RESET}"
    Write-Host "  ${C_WHITE}set -g base-index 1${C_RESET}"
    Write-Host "  ${C_WHITE}setw -g pane-base-index 1${C_RESET}"
    Write-Host "  ${C_WHITE}set -g renumber-windows on${C_RESET}"
    Write-Host "  ${C_WHITE}set -g history-limit 10000${C_RESET}"
    Write-Host "  ${C_WHITE}set -sg escape-time 10${C_RESET}"
    Write-Host "  ${C_WHITE}set -g mode-keys vi${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# ── Prefix ──${C_RESET}"
    Write-Host "  ${C_WHITE}# unbind C-b${C_RESET}"
    Write-Host "  ${C_WHITE}# set -g prefix C-a${C_RESET}"
    Write-Host "  ${C_WHITE}# bind C-a send-prefix${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# ── Splits ──${C_RESET}"
    Write-Host "  ${C_WHITE}bind | split-window -h -c '#{pane_current_path}'${C_RESET}"
    Write-Host "  ${C_WHITE}bind - split-window -v -c '#{pane_current_path}'${C_RESET}"
    Write-Host "  ${C_WHITE}bind c new-window -c '#{pane_current_path}'${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# ── Navigation ──${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r h select-pane -L${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r j select-pane -D${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r k select-pane -U${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r l select-pane -R${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# ── Resize ──${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r H resize-pane -L 5${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r J resize-pane -D 5${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r K resize-pane -U 5${C_RESET}"
    Write-Host "  ${C_WHITE}bind -r L resize-pane -R 5${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_GREEN}# ── Reload ──${C_RESET}"
    Write-Host "  ${C_WHITE}bind r source-file ~/.tmux.conf \; display 'Reloaded!'${C_RESET}"
    Write-Host ""

    Engine-Pause

    Engine-Section "Congratulations!"

    Engine-Teach "You've completed the entire tmux-learn tutorial!"

    Write-Host ""
    Write-Host "${C_GREEN}${C_BOLD}"
    Write-Host "           ___________"
    Write-Host "          '._==_==_=_.'"
    Write-Host "          .-\:      /-."
    Write-Host "         | (|:.     |) |"
    Write-Host "          '-|:.     |-'"
    Write-Host "            \::.    /"
    Write-Host "             '::. .'"
    Write-Host "               ) ("
    Write-Host "             _.' '._"
    Write-Host "            '-------'"
    Write-Host "         TMUX MASTER!"
    Write-Host ""
    Write-Host "${C_RESET}"

    Engine-Teach @"
You've learned:
  - Sessions, windows, and panes
  - Advanced navigation and copy mode
  - Configuration and keybindings
  - Scripting and automation
  - Hooks, plugins, pair programming
  - Real-world workflow patterns

The best way to solidify these skills is to USE tmux every day.
Start with the basics and gradually add customizations as you
discover your own preferences.

Happy tmuxing!
"@
}
