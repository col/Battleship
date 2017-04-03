defmodule BattleshipEngine.Player do
  alias BattleshipEngine.{Player, Board, ShipSet}

  defstruct name: :none, board: :none, ship_set: :none

  def start_link(name \\ :none) do
    {:ok, board} = Board.start_link
    {:ok, ship_set} = ShipSet.start_link
    Agent.start_link(fn -> %Player{name: name, board: board, ship_set: ship_set} end)
  end

  def set_name(player, name) do
    Agent.update(player, &(Map.put(&1, :name, name)))
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
