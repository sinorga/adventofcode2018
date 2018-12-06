defmodule Day4 do
  @input_file "day4.input"
  use FileUtil

  # Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?
  def part1(posts) do
    guard =
      group_by_id(posts)
      |> Map.values()
      |> Enum.max_by(& &1.total_sleep_time)

    Enum.max_by(guard.sleep_slot_acc, fn {_, num} -> num end)
    |> elem(0)
    |> Kernel.*(guard.guard_id)
  end

  # Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?
  def part2(posts) do
    guard_info = group_by_id(posts)

    {guard_id, minute, _} =
      Enum.reduce(1..59, {nil, 0, 0}, fn minute, acc ->
        Enum.reduce(guard_info, acc, fn {_, guard_info}, {_, _sleepy_minute, num} = acc ->
          if (guard_info.sleep_slot_acc[minute] || 0) > num do
            {guard_info.guard_id, minute, guard_info.sleep_slot_acc[minute]}
          else
            acc
          end
        end)
      end)

    guard_id * minute
  end

  @typep guard_id :: String.t()
  @typep guard_info :: %{
           guard_id: integer(),
           total_sleep_time: integer(),
           sleep_slot_acc: %{number() => number()}
         }

  @doc """
  Parse posts

  ## Examples
      iex> Day4.group_by_id([
      ...>    "[1518-11-01 00:00] Guard #10 begins shift",
      ...>    "[1518-11-01 00:05] falls asleep",
      ...>    "[1518-11-01 00:25] wakes up",
      ...>    "[1518-11-01 00:30] falls asleep",
      ...>    "[1518-11-01 00:55] wakes up",
      ...>    "[1518-11-01 23:58] Guard #99 begins shift",
      ...>    "[1518-11-02 00:40] falls asleep",
      ...>    "[1518-11-02 00:50] wakes up",
      ...>    "[1518-11-03 00:05] Guard #10 begins shift",
      ...>    "[1518-11-03 00:24] falls asleep",
      ...>    "[1518-11-03 00:29] wakes up",
      ...>    "[1518-11-04 00:02] Guard #99 begins shift",
      ...>    "[1518-11-04 00:36] falls asleep",
      ...>    "[1518-11-04 00:46] wakes up",
      ...>    "[1518-11-05 00:03] Guard #99 begins shift",
      ...>    "[1518-11-05 00:45] falls asleep",
      ...>    "[1518-11-05 00:55] wakes up"
      ...> ])
      %{
        10 => %{
          guard_id: 10,
          sleep_slot_acc: %{
            48 => 1,
            11 => 1,
            39 => 1,
            34 => 1,
            26 => 1,
            52 => 1,
            15 => 1,
            20 => 1,
            50 => 1,
            17 => 1,
            25 => 1,
            13 => 1,
            44 => 1,
            8 => 1,
            36 => 1,
            7 => 1,
            32 => 1,
            37 => 1,
            35 => 1,
            45 => 1,
            6 => 1,
            49 => 1,
            41 => 1,
            33 => 1,
            42 => 1,
            43 => 1,
            10 => 1,
            9 => 1,
            19 => 1,
            51 => 1,
            14 => 1,
            5 => 1,
            54 => 1,
            18 => 1,
            31 => 1,
            22 => 1,
            21 => 1,
            27 => 1,
            24 => 2,
            47 => 1,
            40 => 1,
            30 => 1,
            23 => 1,
            28 => 1,
            46 => 1,
            53 => 1,
            16 => 1,
            38 => 1,
            12 => 1
          },
          total_sleep_time: 50
        },
        99 => %{
          guard_id: 99,
          sleep_slot_acc: %{
            36 => 1,
            37 => 1,
            38 => 1,
            39 => 1,
            40 => 2,
            41 => 2,
            42 => 2,
            43 => 2,
            44 => 2,
            45 => 3,
            46 => 2,
            47 => 2,
            48 => 2,
            49 => 2,
            50 => 1,
            51 => 1,
            52 => 1,
            53 => 1,
            54 => 1
          },
          total_sleep_time: 30
        }
      }
  """
  @spec group_by_id([String.t()]) :: %{guard_id => guard_info}
  def group_by_id(posts) do
    Enum.sort(posts) |> Enum.map(&parse_post/1) |> group_by_id(%{})
  end

  defp group_by_id([], guard_info), do: guard_info

  defp group_by_id(posts, acc) do
    {guard_day_info, rest} = group_by_id_per_day(posts)

    group_by_id(
      rest,
      Map.update(acc, guard_day_info.guard_id, guard_day_info, fn guard_info ->
        Map.update!(guard_info, :total_sleep_time, &(&1 + guard_day_info.total_sleep_time))
        |> Map.update!(:sleep_slot_acc, fn slot ->
          Enum.reduce(guard_day_info.sleep_slot_acc, slot, fn {time, count}, slot ->
            Map.update(slot, time, 1, &(&1 + count))
          end)
        end)
      end)
    )
  end

  defp parse_post(<<"[", date::size(80), " ", time::size(40), "] ", msg::binary>>) do
    %{
      date: <<date::size(80)>> |> Date.from_iso8601!(),
      time: <<time::size(40), ":00">> |> Time.from_iso8601!(),
      guard_id: (Regex.run(~r/#(\d+)/, msg) || []) |> Enum.at(1),
      action: String.slice(msg, 0..3) |> String.to_atom()
    }
  end

  defp group_by_id_per_day([%{guard_id: guard_id} | action_posts]) when is_binary(guard_id) do
    group_by_id_per_day(action_posts, %{
      guard_id: String.to_integer(guard_id),
      total_sleep_time: 0,
      sleep_slot_acc: %{}
    })
  end

  defp group_by_id_per_day([%{guard_id: nil} = sleep, awake | action_posts], guard_info) do
    sleep_time = awake.time.minute - sleep.time.minute

    sleep_slots =
      Enum.to_list(sleep.time.minute..(awake.time.minute - 1))
      |> Enum.reduce(%{}, &Map.put(&2, &1, 1))

    new_guard_info =
      Map.update(guard_info, :total_sleep_time, sleep_time, &(&1 + sleep_time))
      |> Map.update(:sleep_slot_acc, sleep_slots, &Map.merge(&1, sleep_slots))

    group_by_id_per_day(action_posts, new_guard_info)
  end

  defp group_by_id_per_day(rest, guard_info), do: {guard_info, rest}
end
