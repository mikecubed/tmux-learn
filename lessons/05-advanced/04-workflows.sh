#!/usr/bin/env bash
# Lesson: Real-World Workflows

lesson_info() {
    LESSON_TITLE="Real-World tmux Workflows"
    LESSON_MODULE="05-advanced"
    LESSON_DESCRIPTION="Master professional tmux workflows, IDE-like setups, and productivity patterns."
    LESSON_TIME="10 minutes"
    LESSON_PREREQUISITES="05-advanced/03-pair-programming"
}

lesson_run() {
    engine_section "The IDE-Like Layout"

    engine_teach "Recreate an IDE experience in the terminal:"

    echo ""
    printf "${C_CYAN}"
    cat << 'DIAGRAM'

    ┌──────────────────────────────────────────────┐
    │  Window: code                                │
    │ ┌──────────┬───────────────────────────────┐ │
    │ │ File     │                               │ │
    │ │ Tree     │         Editor (vim)          │ │
    │ │ (Pane 0) │         (Pane 1)              │ │
    │ │          │                               │ │
    │ │  20%     │          60%                  │ │
    │ ├──────────┴───────────────┬───────────────┤ │
    │ │      Terminal            │   Git Status  │ │
    │ │      (Pane 2)            │   (Pane 3)    │ │
    │ │          60%             │     20%       │ │
    │ └──────────────────────────┴───────────────┘ │
    └──────────────────────────────────────────────┘

DIAGRAM
    printf "${C_RESET}"

    engine_teach "Script to create this layout:"

    echo ""
    printf "  ${C_WHITE}tmux new-session -d -s ide -n code -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -h -t ide:code -p 80 -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -v -t ide:code.1 -p 30 -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -h -t ide:code.2 -p 25 -c \$PROJECT${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t ide:code.0 'ranger' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t ide:code.1 'vim .' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t ide:code.3 'git status' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux select-pane -t ide:code.1${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "The DevOps Dashboard"

    engine_teach "Monitor multiple services at once:"

    echo ""
    printf "${C_CYAN}"
    cat << 'DIAGRAM'

    ┌──────────────────────────────────────────────┐
    │  Window: monitor                             │
    │ ┌─────────────────────┬────────────────────┐ │
    │ │   htop / top        │   Docker logs      │ │
    │ │                     │                    │ │
    │ ├─────────────────────┼────────────────────┤ │
    │ │   App logs          │   Network monitor  │ │
    │ │   (tail -f)         │   (iftop/nload)    │ │
    │ └─────────────────────┴────────────────────┘ │
    └──────────────────────────────────────────────┘

DIAGRAM
    printf "${C_RESET}"

    printf "  ${C_WHITE}tmux new-session -d -s monitor -n dash${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys -t monitor:dash 'htop' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -h -t monitor:dash${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys 'docker logs -f myapp' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -v -t monitor:dash.0${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys 'tail -f /var/log/app.log' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux split-window -v -t monitor:dash.1${C_RESET}\n"
    printf "  ${C_WHITE}tmux send-keys 'watch -n1 ss -tlnp' Enter${C_RESET}\n"
    printf "  ${C_WHITE}tmux select-layout -t monitor:dash tiled${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "The Multi-Server Admin"

    engine_teach "Manage multiple servers simultaneously:"

    echo ""
    printf "  ${C_WHITE}#!/bin/bash${C_RESET}\n"
    printf "  ${C_WHITE}# Connect to multiple servers${C_RESET}\n"
    printf "  ${C_WHITE}SERVERS=(web1 web2 web3 db1 db2)${C_RESET}\n"
    printf "  ${C_WHITE}SESSION=\"servers\"${C_RESET}\n\n"
    printf "  ${C_WHITE}tmux new-session -d -s \$SESSION${C_RESET}\n\n"
    printf "  ${C_WHITE}for i in \"\${!SERVERS[@]}\"; do${C_RESET}\n"
    printf "  ${C_WHITE}  if [ \$i -gt 0 ]; then${C_RESET}\n"
    printf "  ${C_WHITE}    tmux split-window -t \$SESSION${C_RESET}\n"
    printf "  ${C_WHITE}    tmux select-layout -t \$SESSION tiled${C_RESET}\n"
    printf "  ${C_WHITE}  fi${C_RESET}\n"
    printf "  ${C_WHITE}  tmux send-keys -t \$SESSION \"ssh \${SERVERS[\$i]}\" Enter${C_RESET}\n"
    printf "  ${C_WHITE}done${C_RESET}\n\n"
    printf "  ${C_WHITE}tmux select-layout -t \$SESSION tiled${C_RESET}\n"
    printf "  ${C_WHITE}tmux attach -t \$SESSION${C_RESET}\n"
    echo ""

    engine_teach "Then use synchronize-panes to type commands on all servers at once!"

    engine_pause

    engine_section "SSH Workflow Patterns"

    engine_teach "Keep SSH sessions alive and organized:"

    echo ""
    printf "  ${C_WHITE}# On remote server, always use tmux${C_RESET}\n"
    printf "  ${C_WHITE}ssh server 'tmux new-session -A -s main'${C_RESET}\n\n"

    printf "  ${C_WHITE}# Or in your .bashrc on the server:${C_RESET}\n"
    printf "  ${C_WHITE}if [ -n \"\$SSH_CONNECTION\" ] && [ -z \"\$TMUX\" ]; then${C_RESET}\n"
    printf "  ${C_WHITE}  tmux new-session -A -s \$(whoami)${C_RESET}\n"
    printf "  ${C_WHITE}fi${C_RESET}\n"
    echo ""

    engine_teach "This means you never lose work on a remote server, even if
your connection drops."

    engine_pause

    engine_section "Nested tmux Sessions"

    engine_teach "When you SSH from tmux into a server also running tmux, you
get nested sessions. Handle this with different prefix keys:"

    echo ""
    printf "  ${C_WHITE}# On remote server's tmux.conf${C_RESET}\n"
    printf "  ${C_WHITE}set -g prefix C-a  # Different from local Ctrl+b${C_RESET}\n"
    echo ""

    engine_teach "Or send the prefix to the inner session:"
    echo ""
    ui_keybinding "Prefix" "Prefix" "Sends prefix to inner tmux"
    echo ""

    engine_teach "Example: If your prefix is Ctrl+b, pressing Ctrl+b twice sends
Ctrl+b to the inner tmux session."

    engine_pause

    engine_section "Productivity Tips"

    engine_teach "Final tips for tmux mastery:"

    echo ""
    printf "  ${C_BOLD}1. Name everything${C_RESET}\n"
    printf "     Name sessions and windows descriptively.\n"
    printf "     Future you will thank present you.\n\n"

    printf "  ${C_BOLD}2. Use scripts for repeatable setups${C_RESET}\n"
    printf "     If you set up the same layout twice, script it.\n\n"

    printf "  ${C_BOLD}3. Keep a cheat sheet handy${C_RESET}\n"
    printf "     Until muscle memory kicks in (~2 weeks).\n\n"

    printf "  ${C_BOLD}4. Start simple, add complexity${C_RESET}\n"
    printf "     Don't try to configure everything day one.\n"
    printf "     Add keybindings and plugins as you need them.\n\n"

    printf "  ${C_BOLD}5. Use tmux-resurrect${C_RESET}\n"
    printf "     Session persistence is a game changer.\n\n"

    printf "  ${C_BOLD}6. Learn copy mode well${C_RESET}\n"
    printf "     It replaces scrolling with the mouse and is\n"
    printf "     much more powerful once you get used to it.\n\n"

    printf "  ${C_BOLD}7. Integrate with your editor${C_RESET}\n"
    printf "     vim-tmux-navigator or similar makes tmux\n"
    printf "     and your editor feel like one tool.\n"
    echo ""

    engine_pause

    engine_section "Your tmux.conf Starter Kit"

    engine_teach "Here's a complete, battle-tested tmux.conf to get you started:"

    echo ""
    printf "  ${C_GREEN}# ── General ──${C_RESET}\n"
    printf "  ${C_WHITE}set -g default-terminal 'tmux-256color'${C_RESET}\n"
    printf "  ${C_WHITE}set -g mouse on${C_RESET}\n"
    printf "  ${C_WHITE}set -g base-index 1${C_RESET}\n"
    printf "  ${C_WHITE}setw -g pane-base-index 1${C_RESET}\n"
    printf "  ${C_WHITE}set -g renumber-windows on${C_RESET}\n"
    printf "  ${C_WHITE}set -g history-limit 10000${C_RESET}\n"
    printf "  ${C_WHITE}set -sg escape-time 10${C_RESET}\n"
    printf "  ${C_WHITE}set -g mode-keys vi${C_RESET}\n\n"

    printf "  ${C_GREEN}# ── Prefix ──${C_RESET}\n"
    printf "  ${C_WHITE}# unbind C-b${C_RESET}\n"
    printf "  ${C_WHITE}# set -g prefix C-a${C_RESET}\n"
    printf "  ${C_WHITE}# bind C-a send-prefix${C_RESET}\n\n"

    printf "  ${C_GREEN}# ── Splits ──${C_RESET}\n"
    printf "  ${C_WHITE}bind | split-window -h -c '#{pane_current_path}'${C_RESET}\n"
    printf "  ${C_WHITE}bind - split-window -v -c '#{pane_current_path}'${C_RESET}\n"
    printf "  ${C_WHITE}bind c new-window -c '#{pane_current_path}'${C_RESET}\n\n"

    printf "  ${C_GREEN}# ── Navigation ──${C_RESET}\n"
    printf "  ${C_WHITE}bind -r h select-pane -L${C_RESET}\n"
    printf "  ${C_WHITE}bind -r j select-pane -D${C_RESET}\n"
    printf "  ${C_WHITE}bind -r k select-pane -U${C_RESET}\n"
    printf "  ${C_WHITE}bind -r l select-pane -R${C_RESET}\n\n"

    printf "  ${C_GREEN}# ── Resize ──${C_RESET}\n"
    printf "  ${C_WHITE}bind -r H resize-pane -L 5${C_RESET}\n"
    printf "  ${C_WHITE}bind -r J resize-pane -D 5${C_RESET}\n"
    printf "  ${C_WHITE}bind -r K resize-pane -U 5${C_RESET}\n"
    printf "  ${C_WHITE}bind -r L resize-pane -R 5${C_RESET}\n\n"

    printf "  ${C_GREEN}# ── Reload ──${C_RESET}\n"
    printf "  ${C_WHITE}bind r source-file ~/.tmux.conf \\\\; display 'Reloaded!'${C_RESET}\n"
    echo ""

    engine_pause

    engine_section "Congratulations!"

    engine_teach "You've completed the entire tmux-learn tutorial!"

    echo ""
    printf "${C_GREEN}${C_BOLD}"
    cat << 'TROPHY'

           ___________
          '._==_==_=_.'
          .-\:      /-.
         | (|:.     |) |
          '-|:.     |-'
            \::.    /
             '::. .'
               ) (
             _.' '._
            '-------'
          TMUX MASTER!

TROPHY
    printf "${C_RESET}"

    engine_teach "You've learned:
  - Sessions, windows, and panes
  - Advanced navigation and copy mode
  - Configuration and keybindings
  - Scripting and automation
  - Hooks, plugins, pair programming
  - Real-world workflow patterns

The best way to solidify these skills is to USE tmux every day.
Start with the basics and gradually add customizations as you
discover your own preferences.

Happy tmuxing!"
}
