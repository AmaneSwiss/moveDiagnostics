#!/bin/bash
clear

# Ask if the 'diagnostics' command should be run again
echo "Do you want to run the 'diagnostics' command? (y/n)"
read -r run_diag
if [[ "$run_diag" == "y" ]]; then
  clear
  diagnostics
fi
clear

# Display files matching *diagnostics*.zip in /boot/logs
files=(/boot/logs/*diagnostics*.zip)
if [ ${#files[@]} -eq 1 ] && [ ${files[0]} == "/boot/logs/*diagnostics*.zip" ]; then
  echo "No diagnostics files found. Running diagnostics..."
  diagnostics
  files=(/boot/logs/*diagnostics*.zip)
fi
clear

echo "Diagnostics files found:"
for i in "${!files[@]}"; do
  echo "$((i+1))) ${files[$i]}"
done
echo ""

# Ask which diagnostics file to copy
if [ ${#files[@]} -gt 1 ]; then
    echo "Which diagnostics file do you want to copy? Enter the number:"
    read -r file_choice
    let file_index=file_choice-1
    
    if [ -z "${files[$file_index]}" ]; then
      echo "Invalid choice. Exiting."
      exit 1
    fi
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
for file in $target_path/*diagnostics*.zip; do
  chown 99:100 "$file"
  chmod 777 "$file"
done
clear
echo "File ${files[$file_index]} copied to $target_path successfully."
