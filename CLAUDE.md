# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

tmux-learn is an interactive terminal-based tutorial for learning tmux. It is a pure bash application (no external dependencies beyond bash 4.0+ and tmux 2.6+) that teaches tmux through 21 hands-on lessons across 5 progressive modules. It runs inside a tmux session, creates sandbox environments for exercises, and verifies user actions by inspecting real tmux state.

## Running

```bash
./tmux-learn
```

No build step. No tests. No linter configured. The app auto-launches into a tmux session if not already in one.

User progress is stored in `~/.tmux-learn/progress`.

## Architecture

**Entry point:** `tmux-learn` - main launcher script that sources all libraries, defines module metadata, handles the main menu loop, and bootstraps into tmux.

**Library layer** (`lib/`):
- `engine.sh` - Lesson runner. Provides the API that lesson files call: `engine_teach`, `engine_section`, `engine_exercise`, `engine_quiz`, `engine_demo`, `engine_pause`. Manages exercise flow (check/hint/skip/quit loop) and sandbox lifecycle per exercise.
- `ui.sh` - Terminal UI primitives using ANSI escape codes. Box drawing, menus, progress bars, typewriter effect, keybinding display. All output goes through `ui_*` functions.
- `verify.sh` - Exercise verification framework. Functions like `verify_session_exists`, `verify_pane_count`, `verify_window_name` inspect live tmux state and set `VERIFY_MESSAGE`/`VERIFY_HINT` globals.
- `progress.sh` - Flat-file progress tracking (`~/.tmux-learn/progress`). Lessons are identified by `module/lesson-name` keys with `complete` or `in-progress` status.
- `tmux_helpers.sh` - Thin wrappers around tmux commands for introspection (counting sessions/windows/panes, reading options, etc.).

**Sandbox** (`exercises/sandbox.sh`): Creates isolated tmux sessions (`tmux-learn-sandbox`) or split panes for exercises. The tutorial session is `tmux-learn`.

**Lessons** (`lessons/<module>/<nn>-<topic>.sh`): Each lesson is a bash script that defines two functions:
- `lesson_info()` - Sets metadata globals: `LESSON_TITLE`, `LESSON_MODULE`, `LESSON_DESCRIPTION`, `LESSON_TIME`
- `lesson_run()` - The lesson body, using engine API calls

## Writing Lessons

Lessons use the engine API exclusively. Key patterns:

```bash
engine_section "Title"           # Section header
engine_teach "Text..."           # Typewriter-style instruction text
engine_pause                     # Wait for Enter
engine_demo "desc" "cmd" true    # Show and optionally execute a command
engine_show_key "Prefix" "c" "Create window"  # Keybinding display
engine_quiz "Question?" "A" "B" "C" 2         # Quiz (last arg = correct answer index)

# Interactive exercise with tmux state verification
engine_exercise "id" "Title" "Instructions" verify_function "hint text" "sandbox-type"
# sandbox-type: "session" (default), "split", "current", "none"
```

Verification functions must set `VERIFY_MESSAGE` (and optionally `VERIFY_HINT`) and return 0/1. Use existing `verify_*` functions from `lib/verify.sh` or compose custom ones.

## Module Unlocking

Modules unlock progressively - a module requires 80% completion of the previous module (calculated in `module_is_unlocked` in `tmux-learn`).
