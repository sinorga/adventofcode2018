defmodule Day1 do
  @part1_input_path "./day1.input"

  def part1 do
    File.stream!(@part1_input_path)
    |> Enum.reduce(0, fn feq, acc ->
      String.trim(feq, "\n")
      |> String.to_integer()
      |> Kernel.+(acc)
    end)
  end

  def part2(inputs, acc \\ 0, history \\ MapSet.new([0]))
  def part2([input|inputs], acc, history) do
    new_acc = acc + String.to_integer(input)
    if MapSet.member?(history, new_acc) do
      new_acc
    else
      part2(inputs ++ [input], new_acc, MapSet.put(history, new_acc))
    end
  end

  def load_input do
    File.read!(@part1_input_path)
    |> String.split("\n")
  end
end

ExUnit.start()

defmodule Day1Test do
  use ExUnit.Case, async: true

  test "device final frequency correct" do
    assert 439 === Day1.part1()
  end

  test "device the first frequency reached twice correct" do
    assert 0 === Day1.part2(["+1", "-1"])
    assert 10 === Day1.part2(["+3", "+3", "+4", "-2", "-4"])
    assert 5 === Day1.part2(["-6", "+3", "+8", "+5", "-6"])
    assert 14 === Day1.part2(["+7", "+7", "-2", "-7", "-4"])
    assert 124645 === (Day1.load_input() |> Day1.part2())
  end
end
