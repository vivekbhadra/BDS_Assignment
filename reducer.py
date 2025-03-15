#!/usr/bin/env python3
import sys

# Ensure a file path is provided
if len(sys.argv) != 2:
    print("Usage: python3 reducer.py <input_file>", file=sys.stderr)
    sys.exit(1)

input_file = sys.argv[1]

current_word = None
current_count = 0

try:
    with open(input_file, "r", encoding="utf-8") as f:
        for line in f:
            word, count = line.strip().split("\t")
            count = int(count)

            if word == current_word:
                current_count += count
            else:
                if current_word:
                    print(f"{current_word}\t{current_count}")
                current_word = word
                current_count = count

    # Print last word count
    if current_word:
        print(f"{current_word}\t{current_count}")

except FileNotFoundError:
    print(f"Error: File {input_file} not found", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)

