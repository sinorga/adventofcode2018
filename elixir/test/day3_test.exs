defmodule Day3Test do
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
