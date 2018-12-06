defmodule Day4 do
  @input_file "day4.input"
  use FileUtil

  def part1(posts) do
    guard =
      parse_posts(posts)
      |> Map.values()
      |> Enum.max_by(& &1.total_sleep_time)

    Enum.max_by(guard.sleep_slot_acc, fn {_, num} -> num end)
    |> elem(0)
    |> Kernel.*(guard.guard_id)
  end

  def part2(posts) do
    guard_info = parse_posts(posts)
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

  defp parse_posts(posts) do
    Enum.sort(posts)
    |> Enum.map(fn <<"[", date::size(80), " ", time::size(40), "] ", msg::binary>> ->
      %{
        date: <<date::size(80)>> |> Date.from_iso8601!(),
        time: <<time::size(40), ":00">> |> Time.from_iso8601!(),
        guard_id: (Regex.run(~r/#(\d+)/, msg) || []) |> Enum.at(1),
        action: String.slice(msg, 0..3) |> String.to_atom()
      }
    end)
    |> Enum.chunk_by(fn
      %{date: date, time: %{hour: 0}} -> date
      %{date: date} -> Date.add(date, 1)
    end)
    |> Enum.reduce(%{}, &parse_posts_per_day/2)
  end

  defp parse_posts_per_day([first_post | action_posts], acc) do
    guard_id = first_post.guard_id

    {_, sleep_time, sleep_slot} =
      Enum.reduce(action_posts, {0, 0, []}, fn
        %{time: time, action: :fall}, {_, sleep_time, sleep_slot} ->
          {time.minute, sleep_time, sleep_slot}

        %{time: time, action: :wake}, {prev, sleep_time, sleep_slot} ->
          {time.minute, sleep_time + (time.minute - prev),
           sleep_slot ++ Enum.to_list(prev..(time.minute - 1))}
      end)

    default_guard = %{
      guard_id: String.to_integer(guard_id),
      total_sleep_time: sleep_time,
      sleep_slot_acc: Enum.reduce(sleep_slot, %{}, &Map.put(&2, &1, 1))
    }

    Map.update(
      acc,
      guard_id,
      default_guard,
      fn guard_info ->
        Map.update!(guard_info, :total_sleep_time, &(&1 + sleep_time))
        |> Map.update!(:sleep_slot_acc, fn slot ->
          Enum.reduce(sleep_slot, slot, fn time, slot ->
            Map.update(slot, time, 1, &(&1 + 1))
          end)
        end)
      end
    )
  end
end
