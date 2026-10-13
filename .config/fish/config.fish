# Cursor API key (kept out of the repo; see .gitignore)
if test -r ~/.config/cursor/api-key
    set -gx CURSOR_API_KEY (string trim < ~/.config/cursor/api-key)
end

# try: shared tries directory /zt; graduated tries go to ~/Work. SHELL is bash for
# this user, so try init must be told to emit fish.
set -gx TRY_PATH /zt
set -gx TRY_PROJECTS ~/Work

if status is-interactive
    clavis-fish-theme init fish | source
    command -q try; and env SHELL=fish try init /zt | source
end
