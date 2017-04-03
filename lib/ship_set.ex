defmodule BattleshipEngine.ShipSet do
  alias BattleshipEngine.{Ship, ShipSet, Coordinate}

  defstruct aircraft_carrier: :none, battleship: :none, cruiser: :none, destroyer1: :none, destroyer2: :none, submarine1: :none, submarine2: :none

  def start_link() do
    Agent.start_link(fn -> initialised_set() end)
  end

  def initialised_set() do
    Enum.reduce(keys(), %ShipSet{}, fn(key, set) ->
      {:ok, ship} = Ship.start_link
      Map.put(set, key, ship)
    end)
  end

  def get_ship(ship_set, key) when is_atom(key) do
    Agent.get(ship_set, &(Map.get(&1, key)))
  end

  def set_ship_coordinates(ship_set, ship_key, coordinates) when is_atom(ship_key) do
    ship = ShipSet.get_ship(ship_set, ship_key)
    Coordinate.set_all_in_ship(Ship.get_coordinates(ship), :none)
    Coordinate.set_all_in_ship(coordinates, ship_key)
    Ship.replace_coordinates(ship, coordinates)
  end

  def sunk?(ship_set, :none), do: false
  def sunk?(ship_set, ship_key), do: ShipSet.get_ship(ship_set, ship_key) |> Ship.sunk?

  defp keys do
    %ShipSet{}
    |> Map.from_struct
    |> Map.keys
  end

  def to_string(ship_set) do
    "%ShipSet{"<>string_body(ship_set)<>"}"
  end

  defp string_body(ship_set) do
    Enum.reduce(keys(), "", fn(key, acc) ->
      ship = Agent.get(ship_set, &(Map.fetch!(&1, key)))
      acc <> ":#{key} => " <> Ship.to_string(ship) <> ", \n"
    end)
  end

end
