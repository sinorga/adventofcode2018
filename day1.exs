defmodule Day1 do
  @part1_input_path "./day1p1.input"

  def part1 do
    File.stream!(@part1_input_path)
    |> Enum.reduce(0, fn feq, acc ->
      String.trim(feq, "\n")
      |> String.to_integer()
      |> Kernel.+(acc)
    end)
  end
end

ExUnit.start()

defmodule Day1Test do
  use ExUnit.Case, async: true

  test "Part 1 correct" do
    assert 439 === Day1.part1()
  end
end
