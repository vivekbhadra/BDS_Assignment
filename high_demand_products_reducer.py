#!/usr/bin/env python3
import sys

current_product = None
current_count = 0

# Read sorted input from Hadoop Shuffle phase
for line in sys.stdin:
    product_id, count = line.strip().split("\t")

    try:
        count = int(count)
    except ValueError:
        continue  # Skip invalid values

    if current_product == product_id:
        current_count += count
    else:
        if current_product:
            print(f"{current_product}\t{current_count}")  # Output: Product_ID  Total_Count
        current_product = product_id
        current_count = count

# Print last product count
if current_product:
    print(f"{current_product}\t{current_count}")

