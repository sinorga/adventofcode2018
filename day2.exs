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

  def common_letter([_|js]=is) do
    common_letter(is, js, false)
  end
  def common_letter([], [], common), do: common
  def common_letter([_|[_|js]=is], [], false), do: common_letter(is, js, false)
  def common_letter([i|_]=is, [j|js], false), do: common_letter(is, js, correct_box_id(i, j))
  def common_letter(_, _, common), do: common

  defp correct_box_id(id1, id2, common \\ "", diff \\ 0)
  defp correct_box_id(_, _, _, 2), do: false
  defp correct_box_id("", "", common, 1), do: common
  defp correct_box_id(<<c1::size(8), id1::binary>>, <<c1::size(8), id2::binary>>, common, diff) do
    correct_box_id(id1, id2, <<common::binary, c1>>, diff)
  end
  defp correct_box_id(<<_::size(8), id1::binary>>, <<_::size(8), id2::binary>>, common, diff) do
    correct_box_id(id1, id2, common, diff + 1)
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

  test "common letter correct" do
    inputs = [
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ]

    assert "fgij" == Day2.common_letter(inputs)
    assert "uqyoeizfvmbistpkgnocjtwld" == Day2.load_input() |> Day2.common_letter()
  end

end
