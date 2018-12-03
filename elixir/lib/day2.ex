defmodule Day2 do
  @input_file "day2.input"
  use FileUtil

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
  defp correct_box_id(<<c1::utf8, id1::binary>>, <<c1::utf8, id2::binary>>, common, diff) do
    correct_box_id(id1, id2, <<common::binary, c1>>, diff)
  end
  defp correct_box_id(<<_::utf8, id1::binary>>, <<_::utf8, id2::binary>>, common, diff) do
    correct_box_id(id1, id2, common, diff + 1)
  end
end
