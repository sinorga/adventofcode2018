defmodule Day1 do
  @input_file "day1.input"
  use FileUtil

  def part1(inputs) do
    Enum.reduce(inputs, 0, fn feq, acc ->
      String.trim(feq, "\n")
      |> String.to_integer()
      |> Kernel.+(acc)
    end)
  end

  def part2(inputs, acc \\ 0, history \\ MapSet.new([0]))
  def part2([input|inputs], acc, history) do
    new_acc = acc + String.to_integer(input)
    if MapSet.member?(history, new_acc) do
      new_acc
    else
      part2(inputs ++ [input], new_acc, MapSet.put(history, new_acc))
    end
  end

  # Another solution with stream.cycle and reduce_while for large data set.
  def part2_stream(stream) do
    {freq, _} =
      Stream.cycle(stream)
      |> Enum.reduce_while({0, MapSet.new([0])}, &check_first_twice_freq/2)
    freq
  end

  defp check_first_twice_freq(delta_freq, {freq, history}) do
    new_freq =
      String.trim(delta_freq, "\n")
      |> String.to_integer()
      |> Kernel.+(freq)
    if MapSet.member?(history, new_freq) do
      {:halt, {new_freq, history}}
    else
      {:cont, {new_freq, MapSet.put(history, new_freq)}}
    end
  end


end


