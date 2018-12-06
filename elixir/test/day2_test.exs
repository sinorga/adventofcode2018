defmodule Day2Test do
  use ExUnit.Case, async: true

  test "checksum correct" do
    inputs = [
      "abcdef",
      "bababc",
      "abbcde",
      "abcccd",
      "aabcdd",
      "abcdee",
      "ababab"
    ]

    assert 12 === Day2.checksum(inputs)

    assert 5681 === Day2.load_input() |> Day2.checksum()
  end

  test "common letter correct" do
    inputs = [
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ]

    assert "fgij" == Day2.common_letter(inputs)
    assert "uqyoeizfvmbistpkgnocjtwld" == Day2.load_input() |> Day2.common_letter()
  end
end
