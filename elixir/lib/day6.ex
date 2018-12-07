defmodule Day6 do
  @input_file "day6.input"
  use FileUtil

  @doc """
  find the size of the largest area that isn't infinite.

  ## Examples
      iex> Day6.largest_area_size([
      ...>  "1, 1",
      ...>  "1, 6",
      ...>  "8, 3",
      ...>  "3, 4",
      ...>  "5, 5",
      ...>  "8, 9"
      ...> ])
      17
  """
  def largest_area_size(inputs) when is_list(inputs) do
    coordinates = parse_coords(inputs)
    {x_range, y_range} = find_corners(coordinates)

    {finite_area_count, _} =
      Enum.reduce(x_range, {%{}, MapSet.new([])}, fn x, acc ->
        Enum.reduce(y_range, acc, fn y, {coords_count, infinity_coords} ->
          closest_coord = find_cloest_coord({x, y}, coordinates)

          cond do
            x in [x_range.first, x_range.last] || y in [y_range.first, y_range.last] ->
              {coords_count, MapSet.put(infinity_coords, closest_coord)}

            MapSet.member?(infinity_coords, closest_coord) ->
              {coords_count, infinity_coords}

            true ->
              {Map.update(coords_count, closest_coord, 1, &(&1 + 1)), infinity_coords}
          end
        end)
      end)

    Map.values(finite_area_count)
    |> Enum.max()
  end

  @doc """
  Part2 question, the size of the region containing all locations which have a total distance to all given coordinates of less than 10000?

      iex> Day6.all_location_area([
      ...>  "1, 1",
      ...>  "1, 6",
      ...>  "8, 3",
      ...>  "3, 4",
      ...>  "5, 5",
      ...>  "8, 9"
      ...> ], 32)
      16
  """
  def all_location_area(inputs, total_distance) when is_list(inputs) do
    coordinates = parse_coords(inputs)
    {x_range, y_range} = find_corners(coordinates)

    points =
      for x <- x_range,
          y <- y_range,
          distance_less_threshold?({x, y}, coordinates, total_distance),
          do: {x, y}

    length(points)
  end

  defp distance_less_threshold?(point, coordinates, total_distance) do
    Enum.reduce(coordinates, 0, &(manhattan_distance(&1, point) + &2)) < total_distance
  end

  defp parse_coords(coords) do
    Enum.map(coords, fn coord ->
      String.split(coord, ", ")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp find_corners(coords) do
    {{left, _}, {right, _}} = Enum.min_max_by(coords, &elem(&1, 0))
    {{_, top}, {_, bottom}} = Enum.min_max_by(coords, &elem(&1, 1))
    {left..right, top..bottom}
  end

  defp find_cloest_coord({x, y}, coords) do
    {coord, _distance} =
      Enum.reduce(coords, {nil, nil}, fn {c_x, c_y}, {_coord, min} = acc ->
        case manhattan_distance({x, y}, {c_x, c_y}) do
          ^min ->
            {nil, min}

          distance when distance < min ->
            {{c_x, c_y}, distance}

          _ ->
            acc
        end
      end)

    coord
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
