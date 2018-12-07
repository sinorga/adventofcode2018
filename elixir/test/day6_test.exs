defmodule Day6Test do
  use ExUnit.Case, async: true
  doctest Day6
  describe "the size of the largest area that isn't infinite" do

    test "largest size from input" do
      assert 3223 == Day6.load_input() |> Day6.largest_area_size()
    end
  end
end
