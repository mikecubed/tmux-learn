#!/usr/bin/env bash
# tmux_helpers.sh - Tmux introspection wrappers

TMUX_MIN_VERSION="2.6"
TMUX_VERSION=""

# Check if tmux is installed and get version
tmux_check_installed() {
    if ! command -v tmux &>/dev/null; then
        return 1
    fi
    TMUX_VERSION=$(tmux -V 2>/dev/null | grep -oE '[0-9]+\.[0-9a-z]+' | head -1)
    return 0
}

# Compare version strings (returns 0 if $1 >= $2)
tmux_version_gte() {
    local ver1="$1" ver2="$2"
    local v1_major v1_minor v2_major v2_minor
    v1_major="${ver1%%.*}"
    v1_minor="${ver1#*.}"
    v1_minor="${v1_minor%%[a-z]*}"
    v2_major="${ver2%%.*}"
    v2_minor="${ver2#*.}"
    v2_minor="${v2_minor%%[a-z]*}"

    if ((v1_major > v2_major)); then return 0; fi
    if ((v1_major < v2_major)); then return 1; fi
    if ((v1_minor >= v2_minor)); then return 0; fi
    return 1
}

# Check minimum tmux version
tmux_check_version() {
    if [[ -z "$TMUX_VERSION" ]]; then
        tmux_check_installed || return 1
    fi
    tmux_version_gte "$TMUX_VERSION" "$TMUX_MIN_VERSION"
}

# Session helpers
tmux_session_exists() {
    local name="$1"
    tmux has-session -t "$name" 2>/dev/null
}

tmux_list_sessions() {
    tmux list-sessions -F '#{session_name}' 2>/dev/null
}

tmux_count_sessions() {
    tmux list-sessions 2>/dev/null | wc -l | tr -d ' '
}

tmux_current_session() {
    tmux display-message -p '#{session_name}' 2>/dev/null
}

# Window helpers
tmux_count_windows() {
    local session="${1:-}"
    if [[ -n "$session" ]]; then
        tmux list-windows -t "$session" 2>/dev/null | wc -l | tr -d ' '
    else
        tmux list-windows 2>/dev/null | wc -l | tr -d ' '
    fi
}

tmux_get_window_name() {
    local session="$1" index="$2"
    tmux display-message -t "${session}:${index}" -p '#{window_name}' 2>/dev/null
}

tmux_list_window_names() {
    local session="${1:-}"
    if [[ -n "$session" ]]; then
        tmux list-windows -t "$session" -F '#{window_name}' 2>/dev/null
    else
        tmux list-windows -F '#{window_name}' 2>/dev/null
    fi
}

# Pane helpers
tmux_count_panes() {
    local target="${1:-}"
    if [[ -n "$target" ]]; then
        tmux list-panes -t "$target" 2>/dev/null | wc -l | tr -d ' '
    else
        tmux list-panes 2>/dev/null | wc -l | tr -d ' '
    fi
}

tmux_get_pane_width() {
    local target="${1:-}"
    if [[ -n "$target" ]]; then
        tmux display-message -t "$target" -p '#{pane_width}' 2>/dev/null
    else
        tmux display-message -p '#{pane_width}' 2>/dev/null
    fi
}

tmux_get_pane_height() {
    local target="${1:-}"
    if [[ -n "$target" ]]; then
        tmux display-message -t "$target" -p '#{pane_height}' 2>/dev/null
    else
        tmux display-message -p '#{pane_height}' 2>/dev/null
    fi
}

# Capture pane content
tmux_pane_content() {
    local target="${1:-}" start="${2:--}" end="${3:-}"
    local args=(-t "$target" -p)
    if [[ -n "$start" ]]; then
        args+=(-S "$start")
    fi
    if [[ -n "$end" ]]; then
        args+=(-E "$end")
    fi
    tmux capture-pane "${args[@]}" 2>/dev/null
}

# Get a tmux option value
tmux_get_option() {
    local option="$1" scope="${2:-global}"
    case "$scope" in
        global)  tmux show-options -gv "$option" 2>/dev/null ;;
        session) tmux show-options -v "$option" 2>/dev/null ;;
        window)  tmux show-window-options -v "$option" 2>/dev/null ;;
    esac
}

# Get current layout of a window
tmux_get_layout() {
    local target="${1:-}"
    if [[ -n "$target" ]]; then
        tmux display-message -t "$target" -p '#{window_layout}' 2>/dev/null
    else
        tmux display-message -p '#{window_layout}' 2>/dev/null
    fi
}

# Check if a keybinding exists
tmux_has_keybinding() {
    local key="$1" command_pattern="${2:-}"
    if [[ -n "$command_pattern" ]]; then
        tmux list-keys 2>/dev/null | grep -q "$key.*$command_pattern"
    else
        tmux list-keys 2>/dev/null | grep -q "$key"
    fi
}

# Get the prefix key
tmux_get_prefix() {
    tmux show-options -gv prefix 2>/dev/null || echo "C-b"
}

# Check terminal size
tmux_check_min_size() {
    local min_width="${1:-80}" min_height="${2:-24}"
    local width height
    width=$(tmux display-message -p '#{window_width}' 2>/dev/null || echo 80)
    height=$(tmux display-message -p '#{window_height}' 2>/dev/null || echo 24)

    if ((width < min_width || height < min_height)); then
        return 1
    fi
    return 0
}
