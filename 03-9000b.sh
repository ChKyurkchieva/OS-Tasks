find $HOME -type f -not -path "$HOME/." -mmin -15 -exec sh -c "echo "$(stat -c "%Y %n" "$1")" >> eternity" sh {} \;
