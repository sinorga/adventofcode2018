defmodule Day2 do
  @input_path "./day2.input"

  @spec checksum(list(String.t()), integer(), integer()) :: integer()
  def checksum(inputs, twice_num \\ 0, thrice_num \\ 0)
  def checksum([], twice_num, thrice_num), do: twice_num * thrice_num
  def checksum([input|inputs], twice_num, thrice_num) do
    {twice_exist, thrice_exist} =
      String.codepoints(input)
      |> Enum.reduce(%{}, fn char, acc ->
        Map.update(acc, char, 1, &(&1+1))
      end)
      |> Enum.reduce({0, 0}, fn
        {_, count}, {twice, _} when count === 3 -> {twice, 1}
        {_, count}, {_, thrice} when count === 2 -> {1, thrice}
        _, acc -> acc
      end)
    checksum(inputs, twice_num + twice_exist, thrice_num + thrice_exist)
  end

  def load_input do
    File.read!(@input_path)
    |> String.split("\n")
  end

  def load_input_stream do
    File.stream!(@input_path)
  end
end

ExUnit.start()

defmodule Day2Test do
  use ExUnit.Case, async: true

  test "checksum correct" do
    inputs = [
      "abcdef",
      "bababc",
      "abbcde",
      "abcccd",
      "aabcdd",
      "abcdee",
      "ababab"
    ]
    assert 12 === Day2.checksum(inputs)

    assert 5681 === Day2.load_input() |> Day2.checksum()
  end

end
