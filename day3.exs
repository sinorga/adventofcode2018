defmodule Day3 do
  @input_path "./day3.input"

  def overlapped_num(inputs) do
    fabric_area = claim_fabric(inputs)

    Map.values(fabric_area)
    |> Enum.reduce(0, fn row_map, acc ->
      Map.values(row_map)
      |> Enum.count(&(&1 > 1))
      |> Kernel.+(acc)
    end)
  end

  defp claim_fabric(claims, fabric_area \\ %{})
  defp claim_fabric([], fabric_area), do: fabric_area

  defp claim_fabric([claim | claims], fabric_area) do
    [_, left_edge, top_edge, wide, tall] = extract_claim(claim)

    new_fabric_area =
      Enum.reduce(top_edge..(top_edge + tall - 1), fabric_area, fn row_pos, fabric_area ->
        Enum.reduce(left_edge..(left_edge + wide - 1), fabric_area, fn col_pos, fabric_area ->
          Map.update(fabric_area, row_pos, %{col_pos => 1}, fn row_map ->
            Map.update(row_map, col_pos, 1, &(&1 + 1))
          end)
        end)
      end)

    claim_fabric(claims, new_fabric_area)
  end

  defp extract_claim(claim) do
    Regex.run(~r/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/, claim)
    |> List.delete_at(0)
    |> Enum.map(&String.to_integer/1)
  end

  def claim_id_without_overlap(inputs) do
    fabric_area = claim_fabric(inputs)
    claim_id_without_overlap(inputs, fabric_area)
  end

  def claim_id_without_overlap([claim | inputs], fabric_area) do
    [claim_id | claim_info] = extract_claim(claim)

    if claim_overlapped?(claim_info, fabric_area) do
      claim_id_without_overlap(inputs, fabric_area)
    else
      claim_id
    end
  end

  defp claim_overlapped?([left_edge, top_edge, wide, tall], fabric_area) do
    Enum.any?(top_edge..(top_edge + tall - 1), fn row_pos ->
      Enum.any?(left_edge..(left_edge + wide - 1), fn col_pos ->
        fabric_area[row_pos][col_pos] > 1
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

  test "claim id without overlapping" do
    inputs = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    assert 3 === Day3.claim_id_without_overlap(inputs)
    assert 297 === Day3.load_input() |> Day3.claim_id_without_overlap()
  end
end
