# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

tmux-learn is an interactive terminal-based tutorial for learning tmux. It is a pure bash application (no build system, no dependencies beyond bash 4.0+ and tmux 2.6+) that runs inside tmux and teaches users through explanations, exercises, and quizzes.

## Running

```bash
./tmux-learn
```

The script auto-bootstraps into a tmux session if not already inside one. There is no build step, test suite, or linter.

## Architecture

**Entry point:** `tmux-learn` — sources all libraries, defines module metadata, handles prerequisites/bootstrap, and runs the main menu loop.

**Library layer (`lib/`):**
- `engine.sh` — Lesson runner. Provides the lesson authoring API: `engine_teach`, `engine_section`, `engine_exercise`, `engine_quiz`, `engine_demo`, `engine_pause`. Each lesson file calls these functions.
- `ui.sh` — Terminal UI primitives using ANSI escape codes and Unicode box-drawing. Menus, headers, progress bars, typewriter effect, keybinding display.
- `verify.sh` — Exercise verification framework. Functions like `verify_session_exists`, `verify_pane_count`, `verify_window_name` inspect live tmux state to check exercise completion. Sets `VERIFY_MESSAGE` and `VERIFY_HINT` globals.
- `progress.sh` — Tracks lesson completion in `~/.tmux-learn/progress` (flat file, `lesson_id=status:timestamp` format).
- `tmux_helpers.sh` — Thin wrappers around tmux CLI commands for introspection (counting sessions/windows/panes, reading options, etc.).

**Sandbox (`exercises/sandbox.sh`):** Creates/destroys temporary tmux sessions (`tmux-learn-sandbox`) for hands-on exercises. Supports both separate-session and split-pane sandbox modes.

**Lessons (`lessons/`):** 21 lesson files across 5 modules (`01-basics` through `05-advanced`). Each lesson is a bash script that defines `lesson_info()` (sets metadata globals) and `lesson_run()` (calls engine API functions). Modules unlock progressively (80% completion of previous module required).

## Writing New Lessons

Lessons follow a strict convention. Each lesson file must define:
1. `lesson_info()` — sets `LESSON_TITLE`, `LESSON_MODULE`, `LESSON_DESCRIPTION`, `LESSON_TIME`, `LESSON_PREREQUISITES`
2. `lesson_run()` — the lesson body, using engine API functions

File naming determines sort order: `NN-slug.sh` within `MM-topic/` directories. The lesson ID is `module/lesson-name` (e.g., `01-basics/01-what-is-tmux`).

Exercises require a verify function that returns 0/1 and sets `VERIFY_MESSAGE`. The sandbox type parameter controls the practice environment: `"session"` (default), `"split"`, `"current"`, or `"none"`.
