#!/usr/bin/env python3
import sys

# Read input line by line
for line in sys.stdin:
    fields = line.strip().split(',')
    if len(fields) > 1:
        product_id = fields[1]  # Assuming Product_ID is in the second column
        print(f"{product_id}\t1")  # Output: Product_ID  1

