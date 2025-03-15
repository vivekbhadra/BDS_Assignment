import sys

word_count = {}

for line in sys.stdin:
    try:
        word, count = line.strip().split("\t")
        count = int(count)
        if word in word_count:
            word_count[word] += count
        else:
            word_count[word] = count
    except ValueError:
        # Ignore malformed input lines
        continue

for word, count in word_count.items():
    print(f"{word}\t{count}")

