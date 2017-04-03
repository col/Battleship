defmodule BattleshipEngine.Player do
  alias BattleshipEngine.{Player, Board, ShipSet}

  defstruct name: :none, board: :none, ship_set: :none

  def start_link(name \\ :none) do
    {:ok, board} = Board.start_link
    {:ok, ship_set} = ShipSet.start_link
    Agent.start_link(fn -> %Player{name: name, board: board, ship_set: ship_set} end)
  end

  def get_name(player) do
    Agent.get(player, &(&1.name))
  end

  def get_board(player) do
    Agent.get(player, &(&1.board))
  end

  def get_ship_set(player) do
    Agent.get(player, &(&1.ship_set))
  end

  def set_name(player, name) do
    Agent.update(player, &(Map.put(&1, :name, name)))
  end

  def set_ship_coordinates(player, ship_key, coordinate_keys) do
    coordinates = player
    |> Player.get_board
    |> Board.get_coordinates(coordinate_keys)

    player
    |> Player.get_ship_set
    |> ShipSet.set_ship_coordinates(ship_key, coordinates)
  end

  def guess_coordinate(player, coordinate_key) when is_atom(coordinate_key) do
    board = Player.get_board(player)
    Board.guess_coordinate(board, coordinate_key)
    case Board.coordinate_hit?(board, coordinate_key) do
      true -> :hit
      false -> :miss
    end
  end

  def sunk_ship(player, coordinate_key) do
    ship_key = Player.get_board(player) |> Board.coordinate_ship(coordinate_key)
    case Player.get_ship_set(player) |> ShipSet.sunk?(ship_key) do
      true -> ship_key
      false -> :none
    end
  end

  def to_string(player) do
    "%Player{"<>string_body(player)<>"}"
  end

  defp string_body(player) do
    state = Agent.get(player, &(&1))
    ":name => #{state.name}, \n" <>
    ":board => " <> Board.to_string(state.board) <> ", \n" <>
    ":ship_set => " <> ShipSet.to_string(state.ship_set)
  end
end
