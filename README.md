# tmux-learn

An interactive terminal-based tutorial for learning tmux, from basics to advanced.

```
    ╔╦╗╔╦╗╦ ╦═╗ ╦     ╦  ╔═╗╔═╗╦═╗╔╗╔
     ║ ║║║║ ║╔╩╦╝ ─── ║  ║╣ ╠═╣╠╦╝║║║
     ╩ ╩ ╩╚═╝╩ ╚═     ╩═╝╚═╝╩ ╩╩╚═╝╚╝
```

## Features

- **21 interactive lessons** across 5 progressive modules
- **Real exercises** that verify actual tmux state (pane counts, session names, window names, etc.)
- **Progressive unlocking** — modules unlock as you complete the previous one
- **Persistent progress** — pick up where you left off
- **Quizzes** to reinforce key concepts
- **Hint system** — get help when you're stuck, or skip exercises
- **Zero dependencies** — pure bash + tmux

## Modules

| # | Module | Lessons | Topics |
|---|--------|---------|--------|
| 1 | **Basics** | 5 | What is tmux, sessions, windows, panes, navigation |
| 2 | **Navigation** | 4 | Pane movement, window switching, session switching, copy mode |
| 3 | **Customization** | 4 | tmux.conf, keybindings, status bar, colors & themes |
| 4 | **Scripting** | 4 | tmux commands, send-keys, scripted layouts, session scripts |
| 5 | **Advanced** | 4 | Hooks, plugins/TPM, pair programming, real-world workflows |

## Requirements

- **bash** 4.0+
- **tmux** 2.6+ (3.0+ recommended)
- Linux or macOS

## Quick Start

```bash
git clone https://github.com/mikecubed/tmux-learn.git
cd tmux-learn
./tmux-learn
```

The tutorial will automatically launch inside a tmux session if you're not already in one.

## How It Works

Each lesson teaches concepts with explanations, keybinding references, and ASCII diagrams, then presents hands-on exercises. The tutorial creates sandbox tmux sessions for you to practice in, and verifies your work by inspecting real tmux state.

```
┌─────────────────────────────────────────────────────┐
│  EXERCISE: Create a 4-Pane Layout                   │
│                                                     │
│  In the sandbox session, create 4 panes:            │
│  ┌──────┬──────┐                                    │
│  │  P0  │  P1  │                                    │
│  ├──────┼──────┤                                    │
│  │  P2  │  P3  │                                    │
│  └──────┴──────┘                                    │
│                                                     │
│  Commands: 'check' | 'hint' | 'skip' | 'quit'      │
└─────────────────────────────────────────────────────┘
```

## Progress

Progress is saved to `~/.tmux-learn/progress`. To reset:

```bash
# From the main menu, select "Reset progress"
# Or manually:
rm ~/.tmux-learn/progress
```

## License

[MIT](LICENSE)
