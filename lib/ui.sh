#!/usr/bin/env bash
# ui.sh - Terminal UI helpers using ANSI escape codes

# Colors
readonly C_RESET=$'\033[0m'
readonly C_BOLD=$'\033[1m'
readonly C_DIM=$'\033[2m'
readonly C_ITALIC=$'\033[3m'
readonly C_UNDERLINE=$'\033[4m'
readonly C_RED=$'\033[31m'
readonly C_GREEN=$'\033[32m'
readonly C_YELLOW=$'\033[33m'
readonly C_BLUE=$'\033[34m'
readonly C_MAGENTA=$'\033[35m'
readonly C_CYAN=$'\033[36m'
readonly C_WHITE=$'\033[37m'
readonly C_BG_BLUE=$'\033[44m'
readonly C_BG_GREEN=$'\033[42m'
readonly C_BG_RED=$'\033[41m'
readonly C_BG_YELLOW=$'\033[43m'

# Unicode box-drawing characters
readonly BOX_TL='╔' BOX_TR='╗' BOX_BL='╚' BOX_BR='╝'
readonly BOX_H='═' BOX_V='║'
readonly BOX_TL_S='┌' BOX_TR_S='┐' BOX_BL_S='└' BOX_BR_S='┘'
readonly BOX_H_S='─' BOX_V_S='│'
readonly CHECKMARK='✓'
readonly CROSSMARK='✗'
readonly ARROW='→'
readonly BULLET='•'
readonly LOCK='🔒'
readonly BOOK='📗'
readonly PROGRESS_FULL='█'
readonly PROGRESS_EMPTY='░'

ui_clear() {
    printf '\033[2J\033[H'
}

# Get terminal width
ui_term_width() {
    local width
    if [[ -n "$TMUX" ]]; then
        width=$(tmux display-message -p '#{pane_width}' 2>/dev/null)
    fi
    if [[ -z "$width" ]]; then
        width=$(tput cols 2>/dev/null || echo 80)
    fi
    echo "$width"
}

# Print a string repeated N times
ui_repeat() {
    local str="$1" count="$2"
    local result=""
    for ((i = 0; i < count; i++)); do
        result+="$str"
    done
    printf '%s' "$result"
}

# Print centered text
ui_center() {
    local text="$1" width
    width=$(ui_term_width)
    local text_len=${#text}
    local pad=$(( (width - text_len) / 2 ))
    [[ $pad -lt 0 ]] && pad=0
    printf '%*s%s\n' "$pad" '' "$text"
}

# Double-line boxed header
ui_header() {
    local title="$1"
    local width=50
    local inner=$((width - 2))
    local title_len=${#title}
    local left_pad=$(( (inner - title_len) / 2 ))
    local right_pad=$(( inner - title_len - left_pad ))

    echo ""
    printf "  ${C_CYAN}${BOX_TL}"
    ui_repeat "$BOX_H" "$inner"
    printf "${BOX_TR}${C_RESET}\n"

    printf "  ${C_CYAN}${BOX_V}${C_RESET}"
    printf "%*s${C_BOLD}${C_WHITE}%s${C_RESET}%*s" "$left_pad" '' "$title" "$right_pad" ''
    printf "${C_CYAN}${BOX_V}${C_RESET}\n"

    printf "  ${C_CYAN}${BOX_BL}"
    ui_repeat "$BOX_H" "$inner"
    printf "${BOX_BR}${C_RESET}\n"
    echo ""
}

# Sub-header with single-line box
ui_subheader() {
    local title="$1"
    local width=46
    local title_len=${#title}
    local right_pad=$((width - title_len - 2))
    [[ $right_pad -lt 0 ]] && right_pad=0

    printf "\n  ${C_YELLOW}${BOX_TL_S}"
    ui_repeat "$BOX_H_S" "$width"
    printf "${BOX_TR_S}${C_RESET}\n"

    printf "  ${C_YELLOW}${BOX_V_S}${C_RESET} ${C_BOLD}%s${C_RESET}%*s ${C_YELLOW}${BOX_V_S}${C_RESET}\n" "$title" "$right_pad" ''

    printf "  ${C_YELLOW}${BOX_BL_S}"
    ui_repeat "$BOX_H_S" "$width"
    printf "${BOX_BR_S}${C_RESET}\n\n"
}

# Print informational text with word wrapping
ui_info() {
    local text="$1"
    local width
    width=$(ui_term_width)
    local max_width=$((width - 6))
    [[ $max_width -gt 76 ]] && max_width=76

    echo "$text" | fold -s -w "$max_width" | while IFS= read -r line; do
        printf "  %s\n" "$line"
    done
    echo ""
}

# Print with a specific color
ui_print() {
    local color="$1" text="$2"
    printf "  ${color}%s${C_RESET}\n" "$text"
}

ui_success() {
    printf "  ${C_GREEN}${C_BOLD}${CHECKMARK} %s${C_RESET}\n" "$1"
}

ui_warn() {
    printf "  ${C_YELLOW}${C_BOLD}! %s${C_RESET}\n" "$1"
}

ui_error() {
    printf "  ${C_RED}${C_BOLD}${CROSSMARK} %s${C_RESET}\n" "$1"
}

# Wait for Enter key
ui_press_enter() {
    local msg="${1:-Press Enter to continue...}"
    printf "\n  ${C_DIM}%s${C_RESET}" "$msg"
    read -r
}

# Prompt for input and return it
ui_prompt() {
    local question="$1"
    printf "  ${C_CYAN}${C_BOLD}?${C_RESET} %s " "$question"
    read -r REPLY
    echo "$REPLY"
}

# Y/N confirmation
ui_confirm() {
    local question="$1"
    local answer
    printf "  ${C_CYAN}${C_BOLD}?${C_RESET} %s ${C_DIM}(y/n)${C_RESET} " "$question"
    read -r answer
    [[ "$answer" =~ ^[Yy] ]]
}

# Numbered menu - sets MENU_CHOICE to selected index (0-based)
ui_menu() {
    local title="$1"
    shift
    local options=("$@")

    if [[ -n "$title" ]]; then
        printf "\n  ${C_BOLD}%s${C_RESET}\n\n" "$title"
    fi

    local i=1
    for opt in "${options[@]}"; do
        printf "  ${C_CYAN}${C_BOLD}%2d${C_RESET}${C_DIM})${C_RESET} %s\n" "$i" "$opt"
        ((i++))
    done

    echo ""
    local choice
    while true; do
        printf "  ${C_CYAN}${C_BOLD}>${C_RESET} Enter choice: "
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
            MENU_CHOICE=$((choice - 1))
            return 0
        elif [[ "$choice" == "q" || "$choice" == "Q" ]]; then
            MENU_CHOICE=-1
            return 1
        fi
        ui_error "Invalid choice. Enter 1-${#options[@]} or 'q' to quit."
    done
}

# Progress bar
ui_progress_bar() {
    local current="$1" total="$2" width="${3:-30}"
    local filled=$((current * width / total))
    local empty=$((width - filled))
    local pct=$((current * 100 / total))

    printf "  ${C_GREEN}"
    ui_repeat "$PROGRESS_FULL" "$filled"
    printf "${C_DIM}"
    ui_repeat "$PROGRESS_EMPTY" "$empty"
    printf "${C_RESET} ${C_BOLD}%3d%%${C_RESET}  (%d/%d)\n" "$pct" "$current" "$total"
}

# Typewriter effect (skippable)
ui_typewriter() {
    local text="$1" delay="${2:-0.02}"

    # Set nonblocking input (only when stdin is a terminal)
    local old_settings=""
    if [[ -t 0 ]] && command -v stty &>/dev/null; then
        old_settings=$(stty -g 2>/dev/null) || true
        stty -echo -icanon min 0 time 0 2>/dev/null || true
    fi

    local i char skip=0
    for ((i = 0; i < ${#text}; i++)); do
        char="${text:$i:1}"

        # Check for keypress to skip (only when stdin is a terminal)
        if [[ $skip -eq 0 && -t 0 ]]; then
            local key
            key=$(dd bs=1 count=1 2>/dev/null) || true
            if [[ -n "$key" ]]; then
                skip=1
            fi
        fi

        if [[ $skip -eq 1 ]]; then
            printf '%s' "${text:$i}"
            break
        fi

        printf '%s' "$char"
        sleep "$delay" 2>/dev/null || true
    done
    printf '\n'

    # Restore terminal
    if [[ -n "$old_settings" ]]; then
        stty "$old_settings" 2>/dev/null || true
    fi
}

# Display a keybinding
ui_keybinding() {
    local prefix="$1" key="$2" description="$3"
    printf "  ${C_BG_BLUE}${C_WHITE}${C_BOLD} %s ${C_RESET}" "$prefix"
    if [[ -n "$key" ]]; then
        printf " + ${C_BG_BLUE}${C_WHITE}${C_BOLD} %s ${C_RESET}" "$key"
    fi
    printf "  ${C_DIM}${ARROW}${C_RESET}  %s\n" "$description"
}

# Display a command example
ui_command() {
    local cmd="$1" description="${2:-}"
    printf "  ${C_GREEN}\$ ${C_BOLD}%s${C_RESET}" "$cmd"
    if [[ -n "$description" ]]; then
        printf "  ${C_DIM}# %s${C_RESET}" "$description"
    fi
    printf '\n'
}

# Separator line
ui_separator() {
    local width
    width=$(ui_term_width)
    local sep_width=$((width - 4))
    [[ $sep_width -gt 76 ]] && sep_width=76
    printf "  ${C_DIM}"
    ui_repeat "$BOX_H_S" "$sep_width"
    printf "${C_RESET}\n"
}

# Display a tip/note box
ui_tip() {
    local text="$1"
    printf "\n  ${C_YELLOW}${C_BOLD}TIP:${C_RESET} ${C_YELLOW}%s${C_RESET}\n\n" "$text"
}

# Display an exercise instruction box
ui_exercise_box() {
    local title="$1" instructions="$2"
    local width=46

    printf "\n  ${C_GREEN}${BOX_TL_S}"
    ui_repeat "$BOX_H_S" "$width"
    printf "${BOX_TR_S}${C_RESET}\n"

    printf "  ${C_GREEN}${BOX_V_S}${C_RESET} ${C_BOLD}${C_GREEN}EXERCISE: %s${C_RESET}" "$title"
    local title_len=$(( 11 + ${#title} ))
    local rpad=$((width - title_len))
    [[ $rpad -gt 0 ]] && printf '%*s' "$rpad" ''
    printf " ${C_GREEN}${BOX_V_S}${C_RESET}\n"

    printf "  ${C_GREEN}${BOX_V_S}"
    ui_repeat " " "$width"
    printf "${BOX_V_S}${C_RESET}\n"

    echo "$instructions" | fold -s -w $((width - 2)) | while IFS= read -r line; do
        local line_len=${#line}
        local pad=$((width - line_len - 1))
        [[ $pad -lt 0 ]] && pad=0
        printf "  ${C_GREEN}${BOX_V_S}${C_RESET} %s%*s${C_GREEN}${BOX_V_S}${C_RESET}\n" "$line" "$pad" ''
    done

    printf "  ${C_GREEN}${BOX_BL_S}"
    ui_repeat "$BOX_H_S" "$width"
    printf "${BOX_BR_S}${C_RESET}\n\n"
}

# ASCII art logo
ui_logo() {
    printf "${C_CYAN}${C_BOLD}"
    cat << 'LOGO'

     _                          _
    | |_ _ __ ___  _   ___  __ | | ___  __ _ _ __ _ __
    | __| '_ ` _ \| | | \ \/ / | |/ _ \/ _` | '__| '_ \
    | |_| | | | | | |_| |>  <  | |  __/ (_| | |  | | | |
     \__|_| |_| |_|\__,_/_/\_\ |_|\___|\__,_|_|  |_| |_|

LOGO
    printf "${C_RESET}"
    ui_center "Interactive Tmux Tutorial"
    echo ""
}
