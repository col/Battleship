defmodule BattleshipEngine.Board do
  alias BattleshipEngine.{Board, Coordinate}

  @letters ~W(a b c d e f g h i j)
  @numbers [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  def start_link() do
    Agent.start_link(fn -> initialised_board() end)
  end

  defp keys() do
    for letter <- @letters, number <- @numbers do
      String.to_atom("#{letter}#{number}")
    end
  end

  defp initialised_board() do
    Enum.reduce(keys(), %{}, fn key, board ->
      {:ok, coord} = Coordinate.start_link
      Map.put(board, key, coord)
    end)
  end

  def get_coordinate(board, key) when is_atom(key) do
    Agent.get(board, &(Map.get(&1, key)))
  end

  def guess_coordinate(board, key) do
    get_coordinate(board, key)
    |> Coordinate.guess
  end

  def coordinate_hit?(board, key) do
    get_coordinate(board, key)
    |> Coordinate.hit?
  end

  def coordinate_ship(board, key) do
    get_coordinate(board, key)
    |> Coordinate.in_ship
  end

  def set_coordinate_in_ship(board, key, ship) do
    get_coordinate(board, key)
    |> Coordinate.set_in_ship(ship)
  end

  def to_string(board) do
    "%{"<>string_body(board)<>"}"
  end

  defp string_body(board) do
    Enum.reduce(keys(), "", fn(key, acc) ->
      coord = Agent.get(board, &(Map.fetch!(&1, key)))
      acc <> ":#{key} => #{Coordinate.to_string(coord)}, \n"
    end)
  end
end
