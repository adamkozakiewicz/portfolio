# -*- coding: utf-8 -*-

# -- Text analysis --

# 
# ### 1. Characters and words in input text calculator


import re

# Count characters function
def count_characters(text):
    char_counts = {}
    for char in text:
        char = char.lower()
        if char in char_counts:
            char_counts[char] += 1
        else:
            char_counts[char] = 1

    return char_counts


# Count words function
def count_words(text):

    # Remove special characters from the text
    only_words = re.sub(r'[^A-Za-z0-9\s]', '', text)
    words = only_words.split()

    word_counts = {}
    for word in words:
        word = word.lower()
        if word in word_counts:
            word_counts[word] += 1
        else:
            word_counts[word] = 1

    return word_counts


# Get input text
input_text = input('Enter your text: ')

# Variables for char counts and word counts
char_counts = count_characters(input_text)
word_counts = count_words(input_text)

# Print character and word counts
print('Character counts:')
for char, count in sorted(char_counts.items()):
    print(f"'{char}': {count}")

print('\nWord counts:')
for word, count in sorted(word_counts.items()):
    print(f"'{word}': {count}")


# ### 2. Polish version of "Scrabble" - letters appearance


scrabble = {
'a': 9,
'b': 2,
'c': 3,
'd': 3,
'e': 7,
'f': 1,
'g': 2,
'h': 2,
'i': 8,
'j': 2,
'k': 3,
'l': 3,
'm': 3,
'n': 5,
'o': 6,
'p': 3,
'r': 4,
's': 4,
't': 3,
'u': 2,
'v': 0,
'w': 4,
'x': 0,
'y': 4,
'z': 5,
'ó': 1,
'ą': 1,
'ć': 1,
'ę': 1,
'ł': 1,
'ń': 1,
'ś': 1,
'ź': 1,
'ż': 1
}

# ### 3. Dictionaries preparation


# Convert to percentages function
def convert_to_percentages(dictionary):
    summary = sum(dictionary.values())
    # Avoid division by zero
    if summary == 0:
        return {key: 0 for key in dictionary}
    return {key: (value / summary) * 100 for key, value in dictionary.items()}

# Convert to percentages
scrabble = convert_to_percentages(scrabble)
char_counts = convert_to_percentages(char_counts)


# Filter function 
def filter(dict1, dict2):
    return {key: dict1[key] for key in dict1 if key in dict2}

# Filter char_counts to include only keys that exist in scrabble
char_counts = filter(char_counts, scrabble)

# ### 4. Letters appearance comparison (Wiki page vs Scrabble)


import matplotlib.pyplot as plt

# Create lists for comparison
union_keys = set(char_counts.keys()).union(scrabble.keys())
char_values = [char_counts.get(key) for key in union_keys]
scrabble_values = [scrabble.get(key) for key in union_keys]

# Create bar chart
plt.bar(x, char_values, width=0.4, label='Character appearance', align='center')
plt.bar(x, scrabble_values, width=0.4, label='Scrabble appearance', align='edge')
plt.ylabel('Counts percent')
plt.title('Comparison of Character appearance vs Scrabble appearance')
x = range(len(union_keys))
plt.xticks(x, union_keys)
plt.legend()
plt.tight_layout()



