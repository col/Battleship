defmodule BattleshipEngine.ShipSet do
  alias BattleshipEngine.{Ship, ShipSet}

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
