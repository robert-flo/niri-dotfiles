# Cursor API key (kept out of the repo; see .gitignore)
if test -r ~/.config/cursor/api-key
    set -gx CURSOR_API_KEY (string trim < ~/.config/cursor/api-key)
end

if status is-interactive
    clavis-fish-theme init fish | source
end
