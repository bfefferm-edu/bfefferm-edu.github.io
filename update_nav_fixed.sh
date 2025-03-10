#!/bin/bash

# Script to update the front matter of all Markdown files in _pages directory 
# (except about.md) to set nav: false.
# If a file already has a nav property, update its value to false.
# If it doesn't have one, add it with the value false.

# Find all Markdown files in _pages directory except about.md
for file in _pages/*.md; do
    # Skip about.md
    if [ "$(basename "$file")" = "about.md" ]; then
        echo "Skipping $file"
        continue
    fi
    
    echo "Processing $file"
    
    # Check if the file has front matter (delimited by ---)
    if grep -q "^---" "$file"; then
        # Check if nav property already exists in the file
        if grep -q "^nav:" "$file"; then
            # Replace existing nav property with nav: false
            sed -i '' 's/^nav:.*$/nav: false/' "$file"
            echo "  Updated existing nav property to false"
        else
            # Add nav: false after the first --- line
            awk '
            BEGIN {found=0}
            {
                if (!found && $0 ~ /^---$/) {
                    print $0;
                    print "nav: false";
                    found=1;
                } else {
                    print $0;
                }
            }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
            echo "  Added nav: false to front matter"
        fi
    else
        echo "  Warning: No front matter found in $file"
    fi
done

echo "All files processed. Only about.md will remain in navigation."

