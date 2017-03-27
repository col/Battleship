defmodule BattleshipEngine.Coordinate do
  alias BattleshipEngine.Coordinate

  defstruct [in_ship: :none, guessed?: false]

  def start_link() do
    Agent.start_link(fn -> %Coordinate{} end)
  end

  def guessed?(coord) do
    Agent.get(coord, &(&1.guessed?))
  end

  def in_ship(coord) do
    Agent.get(coord, &(&1.in_ship))
  end

  def in_ship?(coord) do
    Agent.get(coord, &(&1.in_ship != :none))
  end

  def hit?(coord) do
    in_ship?(coord) && guessed?(coord)
  end

  def guess(coord) do
    Agent.update(coord, &(Map.put(&1, :guessed?, true)))
  end

  def set_in_ship(coord, ship) when is_atom(ship) do
    Agent.update(coord, &(Map.put(&1, :in_ship, ship)))
  end

  def to_string(coord) do
    "(in_ship:#{in_ship(coord)}, guessed:#{guessed?(coord)})"
  end
end
