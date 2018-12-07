defmodule Day6Test do
  use ExUnit.Case, async: true
  doctest Day6

  describe "the size of the largest area that isn't infinite" do
    test "largest size from input" do
      assert 3223 == Day6.load_input() |> Day6.largest_area_size()
    end
  end

  describe "the size of the region containing all locations which have a total distance to all given coordinates of less than 10000" do
    test "area size from input" do
      assert 40495 == Day6.load_input() |> Day6.all_location_area(10000)
    end
  end
end
