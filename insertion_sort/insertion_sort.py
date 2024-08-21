__author__ = "Aflah Hanif Amarlyadi (aflahamarlyadi@gmail.com)"

from typing import List


def insertion_sort(array: List[int]):
    """
    Sorts an array of integers in ascending order using the Insertion Sort algorithm.

    Args:
        array (List[int]): The array to be sorted.
    """
    length = len(array)
    for i in range(1, length):
        key = array[i]
        j = i-1
        while j >= 0 and key < array[j]:
            array[j + 1] = array[j]
            j -= 1
        array[j + 1] = key


def main() -> None:
    input = [6, -2, 7, 4, -10]
    insertion_sort(input)
    for i in range(len(input)):
        print(input[i], end=" ")
    print()


main()
