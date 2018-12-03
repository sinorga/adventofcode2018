defmodule Day1Test do
  use ExUnit.Case, async: true

  test "device final frequency correct" do
    assert 439 === (Day1.load_input_stream() |> Day1.part1())
  end

  test "device the first frequency reached twice correct" do
    assert 0 === Day1.part2(["+1", "-1"])
    assert 10 === Day1.part2(["+3", "+3", "+4", "-2", "-4"])
    assert 5 === Day1.part2(["-6", "+3", "+8", "+5", "-6"])
    assert 14 === Day1.part2(["+7", "+7", "-2", "-7", "-4"])
    assert 124645 === (Day1.load_input() |> Day1.part2())
    assert 124645 === (Day1.load_input_stream() |> Day1.part2_stream())
  end
end
