defmodule Day3 do
  @input_path "./day3.input"

  def overlapped_num(inputs, fabric_area \\ %{})

  def overlapped_num([], fabric_area) do
    Map.values(fabric_area)
    |> Enum.reduce(0, fn row_map, acc ->
      Map.values(row_map)
      |> Enum.count(&(&1 > 1))
      |> Kernel.+(acc)
    end)
  end

  def overlapped_num([input | inputs], fabric_area) do
    overlapped_num(inputs, claim_fabric(input, fabric_area))
  end

  defp claim_fabric(claim, fabric_area) do
    [left_edge, top_edge, wide, tall] =
      Regex.run(~r/^#\d+ @ (\d+),(\d+): (\d+)x(\d+)$/, claim)
      |> List.delete_at(0)
      |> Enum.map(&String.to_integer/1)

    Enum.reduce(top_edge..(top_edge + tall - 1), fabric_area, fn row_pos, fabric_area ->
      Enum.reduce(left_edge..(left_edge + wide - 1), fabric_area, fn col_pos, fabric_area ->
        Map.update(fabric_area, row_pos, %{col_pos => 1}, fn row_map ->
          Map.update(row_map, col_pos, 1, &(&1 + 1))
        end)
      end)
    end)
  end

  def load_input do
    File.read!(@input_path)
    |> String.split("\n", trim: true)
  end

  def load_input_stream do
    File.stream!(@input_path)
  end
end

ExUnit.start()

defmodule Day2Test do
  use ExUnit.Case, async: true

  test "number of overlapped fabric correct" do
    inputs = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    assert 4 === Day3.overlapped_num(inputs)
    assert 110_891 === Day3.load_input() |> Day3.overlapped_num()
  end
end
