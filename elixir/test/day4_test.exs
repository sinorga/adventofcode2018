defmodule Day4Test do
  use ExUnit.Case, async: true
  doctest Day4

  setup %{} do
    inputs = [
      "[1518-11-01 00:00] Guard #10 begins shift",
      "[1518-11-01 00:05] falls asleep",
      "[1518-11-01 00:25] wakes up",
      "[1518-11-01 00:30] falls asleep",
      "[1518-11-01 00:55] wakes up",
      "[1518-11-01 23:58] Guard #99 begins shift",
      "[1518-11-02 00:40] falls asleep",
      "[1518-11-02 00:50] wakes up",
      "[1518-11-03 00:05] Guard #10 begins shift",
      "[1518-11-03 00:24] falls asleep",
      "[1518-11-03 00:29] wakes up",
      "[1518-11-04 00:02] Guard #99 begins shift",
      "[1518-11-04 00:36] falls asleep",
      "[1518-11-04 00:46] wakes up",
      "[1518-11-05 00:03] Guard #99 begins shift",
      "[1518-11-05 00:45] falls asleep",
      "[1518-11-05 00:55] wakes up"
    ]

    {:ok, example_input: inputs}
  end

  describe "find guard that has the most minutes asleep. What minute does that guard spend asleep the most" do
    test "guard id multipy minute from example", ctx do
      assert 240 == Day4.part1(ctx.example_input)
    end

    test "guard id multipy minute from file" do
      assert 77084 == Day4.load_input() |> Day4.part1()
    end
  end

  describe "find which guard is most frequently asleep on the same minute" do
    test "guard id multipy minute from example", ctx do
      assert 4455 == Day4.part2(ctx.example_input)
    end

    test "guard id multipy minute from file" do
      assert 23047 == Day4.load_input() |> Day4.part2()
    end
  end
end
