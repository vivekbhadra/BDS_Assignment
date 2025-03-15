#!/usr/bin/env python3
import sys
import re

# Precompiled regex for efficient tokenization
WORD_REGEX = re.compile(r'\b[a-zA-Z]+\b')

def process_line(line):
    """
    Tokenizes a line into words, converts to lowercase, and prints word count pairs.
    """
    words = WORD_REGEX.findall(line)  # Extract only valid words
    for word in words:
        print(f"{word.lower()}\t1")  # Output: word 1

# Process each line from standard input (stdin)
for line in sys.stdin:
    process_line(line)

