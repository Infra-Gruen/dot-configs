if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
thefuck --alias | source 
direnv hook fish | source