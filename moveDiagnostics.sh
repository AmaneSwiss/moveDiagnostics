#!/bin/bash
clear

# Ask if the 'diagnostics' command should be run again
echo "Do you want to run the 'diagnostics' command? (y/n)"
read -r run_diag
if [[ "$run_diag" == "y" ]]; then
  diagnostics
fi
clear

# Display files matching *diagnostics* in /boot/logs
files=(/boot/logs/*diagnostics*)
if [ ${#files[@]} -eq 0 ]; then
  echo "No diagnostics files found. Running diagnostics..."
  diagnostics
  files=(/boot/logs/*diagnostics*)
fi

echo "Diagnostics files found:"
for i in "${!files[@]}"; do
  echo "$((i+1))) ${files[$i]}"
done
echo ""

# Ask which diagnostics file to move
echo "Which diagnostics file do you want to move? Enter the number:"
read -r file_choice
let file_index=file_choice-1

if [ -z "${files[$file_index]}" ]; then
  echo "Invalid choice. Exiting."
  exit 1
fi
clear

# Display directories in /mnt/user/ and offer to enter a path manually
echo "0) Enter a path manually."
dirs=(/mnt/user/*)
for i in "${!dirs[@]}"; do
  echo "$((i+1))) ${dirs[$i]}"
done

# Ask which path to copy the file to
echo ""
echo "Into which path do you want to copy the file? Enter the number:"
read -r dir_choice

if [[ "$dir_choice" -eq 0 ]]; then
  echo "Enter the full path:"
  read -r target_path
else
  let dir_index=dir_choice-1
  if [ -z "${dirs[$dir_index]}" ]; then
    echo "Invalid choice. Exiting."
    exit 1
  fi
  target_path=${dirs[$dir_index]}
fi

# Copy the selected diagnostics file to the chosen path
cp "${files[$file_index]}" "$target_path"
chown 1000:100 "$target_path"
chmod 777 "$target_path"
clear
echo "File ${files[$file_index]} copied to $target_path successfully."
