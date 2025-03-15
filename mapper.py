#!/usr/bin/env python3
import sys

# Ensure a file path is provided
if len(sys.argv) != 2:
    print("Usage: python3 mapper.py <input_file>", file=sys.stderr)
    sys.exit(1)

input_file = sys.argv[1]

try:
    with open(input_file, "r", encoding="utf-8") as f:
        for line in f:
            words = line.strip().split()
            for word in words:
                print(f"{word}\t1")  # Output: word 1
except FileNotFoundError:
    print(f"Error: File {input_file} not found", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)

