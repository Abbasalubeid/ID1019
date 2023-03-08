defmodule Huffman do

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do
    freq(sample, [])
  end
  def freq([], freq) do
    freq
  end
  def freq([char | rest], freq) do
    freq(rest, new_freq(char, freq))
  end

  #The char was not in the list
  def new_freq(char, []) do [{char, 1}] end
  def new_freq(char, [first | rest]) do
    case first do
      {^char, n} -> [{char, n+1} | rest]
      #If the char is not found, check in the rest
      _  ->  [first | new_freq(char, rest)]
    end
  end

  def huffman(freq) do
    sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
    huffman_tree(sorted)
  end

  def huffman_tree([{tree, _}]) do tree end
  def huffman_tree([{char1, char1f}, {char2, char2f} | rest]) do
    huffman_tree(insert({{char1, char2}, char1f + char2f}, rest))
  end

  def insert({char1, char1f}, []) do
    [{char1, char1f}]
  end
  def insert({char1, char1f}, [{char2, char2f} | rest]) do
    case char1f < char2f do
      true -> [{char1, char1f}, {char2, char2f} | rest]
      _ -> [{char2, char2f} | insert({char1, char1f}, rest)]
    end
  end

  def encode_table(tree) do
    codes(tree, [])
  end

  def codes({left, right}, path) do
    left_path = codes(left, [path ++ [0]])
    right_path = codes(right, [path ++ [1]])
    left_path ++ right_path
  end
  def codes(char, code) do
    [{char, Enum.reverse(code)}]
  end

  def encode([], _), do: []
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end

  def decode_table(tree) do
    codes(tree, [])
  end

  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}
      nil ->
        decode_char(seq, n + 1, table)
    end
  end
end
