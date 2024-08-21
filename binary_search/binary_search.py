__author__ = "Aflah Hanif Amarlyadi (aflahamarlyadi@gmail.com)"

from typing import List


def binary_search(array: List[int], item: int, low: int, high: int) -> int:
    """
    Searches for the given integer in a sorted array using the Binary Search algorithm.

    Args:
        array (List[int]): The sorted array to search.
        item (int): The integer to search in the sorted array.
        low (int): The lower index of the subarray.
        high (int): The upper index of the subarray.

    Returns:
        mid (int): The index of the item if found; otherwise, -1.
    """
    if low > high:
        return -1
    else:
        mid = (high + low) // 2

        if array[mid] == item:
            return mid
        elif array[mid] > item:
            return binary_search(array, item, low, mid - 1)
        else:
            return binary_search(array, item, mid + 1, high)


def main() -> None:
    input = [1, 5, 10, 11, 12]
    index = binary_search(input, 11, 0, len(input) - 1)
    print(index)


main()
