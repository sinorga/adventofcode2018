defmodule Day5Test do
  use ExUnit.Case, async: true

  describe "find How many units remain after fully reacting the polymer you scanned" do
    test "remain units from example" do

      assert 10 == Day5.remain_units("dabAcCaCBAcCcaDA")
    end

    test "remain units from input" do
      assert 11894 == Day5.load_input_raw() |> Day5.remain_units()
    end
  end
end
