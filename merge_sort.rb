def merge_sort(array)
  if array.length > 1
    left = array[0..((array.length / 2) - 1)]
    right = array[((array.length / 2))..array.length]
    merge_sort(left)
    merge_sort(right)
    merge_array(array, left, right)
  end
  array
end

def merge_array(array, left, right)
  left_index = 0
  right_index = 0
  array_index = 0
  while left_index < left.length && right_index < right.length do
    if left[left_index] < right[right_index]
      array[array_index] = left[left_index]
      left_index += 1
    else
      array[array_index] = right[right_index]
      right_index += 1
    end
    array_index += 1
  end
  if left_index == (left.length)
    array[array_index..array.length] = right[right_index..right.length]
  else
    array[array_index..array.length] = left[left_index..left.length]
  end
end

a = [4, 7, 10, 5, 1, 6, 3, 9, 8, 2]
p merge_sort(a)