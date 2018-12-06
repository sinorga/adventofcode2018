defmodule Day3 do
  @input_file "day3.input"
  use FileUtil

  @doc """
  Calculate number of overlapped fabric

  ## Examples

      iex(1)> Day3.overlapped_num([
      ...(1)>         "#1 @ 1,3: 4x4",
      ...(1)>         "#2 @ 3,1: 4x4",
      ...(1)>         "#3 @ 5,5: 2x2"
      ...(1)>       ])
      4
  """
  @spec overlapped_num([String.t()]) :: integer()
  def overlapped_num(inputs) do
    claim_fabric(inputs)
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end

  defp claim_fabric(claims, fabric_area \\ %{})
  defp claim_fabric([], fabric_area), do: fabric_area

  defp claim_fabric([claim | claims], fabric_area) do
    [_, left_edge, top_edge, wide, tall] = extract_claim(claim)

    # ETS can be faster.
    new_fabric_area =
      Enum.reduce(top_edge..(top_edge + tall - 1), fabric_area, fn row_pos, fabric_area ->
        Enum.reduce(left_edge..(left_edge + wide - 1), fabric_area, fn col_pos, fabric_area ->
          # Learning: use {x, y} as a key to prevent deep nested map
          Map.update(fabric_area, {row_pos, col_pos}, 1, &(&1 + 1))
        end)
      end)

    claim_fabric(claims, new_fabric_area)
  end

  defp extract_claim(claim) do
    claim
    # Learning use split instead of regex
    # Anotehr faster solution: https://github.com/plataformatec/nimble_parsec
    |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
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
        fabric_area[{row_pos, col_pos}] > 1
      end)
    end)
  end
end
