defmodule Day5 do
  @input_file "day5.input"
  use FileUtil

  # Part 1
  def remain_units(origin_units) when is_binary(origin_units) do
    list = String.codepoints(origin_units)
    remain_units([], list)
  end
  defp remain_units([], [next|left]), do: remain_units([next], left)
  defp remain_units([prev|right]=remains, [next|left]) do
    if is_react?(prev, next) do
      remain_units(right, left)
    else
      remain_units([next|remains], left)
    end
  end
  defp remain_units(remains, []), do: length(remains)

  defp is_react?(str1, str2), do: str1 != str2 && String.upcase(str1) == String.upcase(str2)
end
