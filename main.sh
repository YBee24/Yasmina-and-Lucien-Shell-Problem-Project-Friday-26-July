echo "Good evening Lucien. Thank you dearly for helping me so, very much concerning the wonderful EC2 issue I had been experiencing. Let's get this project underway, eh?!"

generate_summary() {
    local log_dir=$1
    echo "Generating log summary for directory: $log_dir"
    echo "-----------------------------------------"
    echo "Log files in $log_dir:"
    echo "-----------------------------------------"
    find "$log_dir" -type f | while read file; do
        echo "File: $file"
        echo "Size: $(du -sh "$file" | cut -f1)"
        echo "Lines: $(wc -l < "$file")"
        echo "-----------------------------------------"
    done
}

# Function to display tree information for /var/log
display_default_tree() {
    echo "Tree information for /var/log:"
    echo "-----------------------------------------"
    tree /var/log
}

# Ask the user for input
echo "Do you want to use the default log repository (/var/log)? Type 'default' for yes or enter your own path:"
read user_input

# Check the user's input
if [ "$user_input" == "default" ]; then
    display_default_tree
else
    if [ -d "$user_input" ]; then
        generate_summary "$user_input"
    else
        echo "The path you entered is not a valid directory. Please try again."
        exit 1
    fi
fi
