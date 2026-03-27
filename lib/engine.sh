#!/usr/bin/env bash
# engine.sh - Lesson runner engine

# Lesson metadata (set by lesson_info)
LESSON_TITLE=""
LESSON_MODULE=""
LESSON_DESCRIPTION=""
LESSON_TIME=""
LESSON_PREREQUISITES=""

# Engine state
ENGINE_LESSON_ID=""
ENGINE_EXERCISE_COUNT=0
ENGINE_SANDBOX_PANE=""

# Run a lesson file
engine_run_lesson() {
    local lesson_file="$1"
    local lesson_id="$2"
    ENGINE_LESSON_ID="$lesson_id"
    ENGINE_EXERCISE_COUNT=0

    # Source the lesson
    # shellcheck disable=SC1090
    source "$lesson_file"

    # Get lesson info
    lesson_info

    # Show lesson header
    ui_clear
    ui_header "$LESSON_TITLE"

    if [[ -n "$LESSON_DESCRIPTION" ]]; then
        ui_info "$LESSON_DESCRIPTION"
    fi

    if [[ -n "$LESSON_TIME" ]]; then
        ui_print "$C_DIM" "Estimated time: $LESSON_TIME"
        echo ""
    fi

    ui_separator
    ui_press_enter "Press Enter to begin..."

    # Mark in progress
    progress_mark_in_progress "$lesson_id"

    # Run the lesson
    lesson_run

    # Mark complete
    progress_mark_complete "$lesson_id"

    # Cleanup sandbox if used
    if [[ -n "$ENGINE_SANDBOX_PANE" ]]; then
        sandbox_close_split "$ENGINE_SANDBOX_PANE"
        ENGINE_SANDBOX_PANE=""
    fi

    # Completion message
    ui_clear
    ui_header "Lesson Complete!"
    ui_success "$LESSON_TITLE"
    echo ""
    ui_info "Great work! You've completed this lesson."

    local stats
    stats=$(progress_get_stats "$TMUX_LEARN_DIR/lessons")
    local completed total
    completed=$(echo "$stats" | cut -d' ' -f1)
    total=$(echo "$stats" | cut -d' ' -f2)
    ui_info "Overall progress:"
    ui_progress_bar "$completed" "$total"
    echo ""

    ui_press_enter "Press Enter to return to the menu..."
}

# Teach: display instructional text with typewriter effect
engine_teach() {
    local text="$1"
    echo ""
    # Word wrap and display
    local width
    width=$(ui_term_width)
    local max_width=$((width - 6))
    [[ $max_width -gt 76 ]] && max_width=76

    echo "$text" | fold -s -w "$max_width" | while IFS= read -r line; do
        printf "  "
        ui_typewriter "$line" 0.01
    done
    echo ""
}

# Teach section: display a titled section
engine_section() {
    local title="$1"
    ui_subheader "$title"
}

# Demo: show and optionally execute a tmux command
engine_demo() {
    local description="$1" cmd="$2" execute="${3:-false}"

    ui_info "$description"
    ui_command "$cmd"
    echo ""

    if [[ "$execute" == "true" ]]; then
        eval "$cmd" 2>/dev/null
        sleep 0.5
    fi
}

# Show a keybinding explanation
engine_show_key() {
    local prefix="$1" key="$2" description="$3"
    ui_keybinding "$prefix" "$key" "$description"
}

# Interactive exercise
engine_exercise() {
    local exercise_id="$1"
    local title="$2"
    local instructions="$3"
    local verify_func="$4"
    local hint="${5:-}"
    local use_sandbox="${6:-session}"

    ((ENGINE_EXERCISE_COUNT++))

    ui_clear
    ui_exercise_box "$title" "$instructions"

    # Create sandbox environment
    case "$use_sandbox" in
        "session")
            sandbox_create
            ui_info "A sandbox session '${SANDBOX_SESSION}' has been created for you."
            ui_info "Switch to it with: Prefix + ( or Prefix + s to see session list"
            ;;
        "split")
            ENGINE_SANDBOX_PANE=$(sandbox_create_split)
            ui_info "A sandbox pane has been opened on the right."
            ui_info "Click it or use Prefix + Right Arrow to switch to it."
            ;;
        "current")
            # Use current session, no sandbox
            ;;
        "none")
            # No sandbox needed
            ;;
    esac

    echo ""
    ui_print "$C_DIM" "Commands: 'check' to verify | 'hint' for help | 'skip' to skip | 'quit' to exit"
    ui_separator

    local attempts=0
    local max_attempts_for_hint=2

    while true; do
        echo ""
        printf "  ${C_CYAN}${C_BOLD}exercise>${C_RESET} "
        read -r user_input

        case "$user_input" in
            check)
                if $verify_func; then
                    echo ""
                    ui_success "$VERIFY_MESSAGE"
                    ui_success "Exercise passed!"
                    echo ""
                    ui_press_enter
                    # Cleanup sandbox
                    if [[ "$use_sandbox" == "session" ]]; then
                        sandbox_destroy
                    elif [[ "$use_sandbox" == "split" && -n "$ENGINE_SANDBOX_PANE" ]]; then
                        sandbox_close_split "$ENGINE_SANDBOX_PANE"
                        ENGINE_SANDBOX_PANE=""
                    fi
                    return 0
                else
                    ((attempts++))
                    echo ""
                    ui_error "$VERIFY_MESSAGE"
                    if ((attempts >= max_attempts_for_hint)) && [[ -n "$VERIFY_HINT" || -n "$hint" ]]; then
                        echo ""
                        ui_tip "${VERIFY_HINT:-$hint}"
                    fi
                fi
                ;;
            hint)
                echo ""
                if [[ -n "$hint" ]]; then
                    ui_tip "$hint"
                elif [[ -n "$VERIFY_HINT" ]]; then
                    ui_tip "$VERIFY_HINT"
                else
                    ui_info "No hints available for this exercise. Keep trying!"
                fi
                ;;
            skip)
                echo ""
                ui_warn "Skipping exercise..."
                # Cleanup sandbox
                if [[ "$use_sandbox" == "session" ]]; then
                    sandbox_destroy
                elif [[ "$use_sandbox" == "split" && -n "$ENGINE_SANDBOX_PANE" ]]; then
                    sandbox_close_split "$ENGINE_SANDBOX_PANE"
                    ENGINE_SANDBOX_PANE=""
                fi
                return 0
                ;;
            quit|q)
                # Cleanup sandbox
                if [[ "$use_sandbox" == "session" ]]; then
                    sandbox_destroy
                elif [[ "$use_sandbox" == "split" && -n "$ENGINE_SANDBOX_PANE" ]]; then
                    sandbox_close_split "$ENGINE_SANDBOX_PANE"
                    ENGINE_SANDBOX_PANE=""
                fi
                return 1
                ;;
            *)
                ui_print "$C_DIM" "Type 'check' to verify, 'hint' for help, 'skip' to skip, or 'quit' to exit"
                ;;
        esac
    done
}

# Checkpoint: save progress mid-lesson
engine_checkpoint() {
    local message="${1:-Progress saved}"
    progress_mark_in_progress "$ENGINE_LESSON_ID"
    ui_success "$message"
}

# Wait for user to continue
engine_pause() {
    local message="${1:-Press Enter to continue...}"
    ui_press_enter "$message"
}

# Show a quick quiz question
engine_quiz() {
    local question="$1"
    shift
    local options=("$@")
    local correct_idx="${options[-1]}"
    unset 'options[-1]'

    echo ""
    printf "  ${C_BOLD}${C_YELLOW}QUIZ:${C_RESET} %s\n\n" "$question"

    local i=1
    for opt in "${options[@]}"; do
        printf "    ${C_CYAN}%d)${C_RESET} %s\n" "$i" "$opt"
        ((i++))
    done

    echo ""
    local answer
    while true; do
        printf "  ${C_CYAN}answer>${C_RESET} "
        read -r answer
        if [[ "$answer" =~ ^[0-9]+$ ]] && ((answer >= 1 && answer <= ${#options[@]})); then
            if ((answer == correct_idx)); then
                ui_success "Correct!"
                return 0
            else
                ui_error "Not quite. Try again!"
            fi
        else
            ui_print "$C_DIM" "Enter a number 1-${#options[@]}"
        fi
    done
}
