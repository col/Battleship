defmodule BattleshipEngine.ShipSetTest do
  use ExUnit.Case
  alias BattleshipEngine.{ShipSet, Ship, Coordinate}

  test "#start_link" do
    {:ok, ship_set} = ShipSet.start_link
    battleship_pid = Agent.get(ship_set, fn(struct) -> struct.battleship end)
    assert is_pid(battleship_pid)
  end

  test "#get_ship" do
    {:ok, ship_set} = ShipSet.start_link
    assert is_pid(ShipSet.get_ship(ship_set, :battleship))
  end

  test "#to_string" do
    {:ok, ship_set} = ShipSet.start_link
    assert String.starts_with?(ShipSet.to_string(ship_set), "%ShipSet{:aircraft_carrier => [], \n")
    assert String.ends_with?(ShipSet.to_string(ship_set), ":submarine2 => [], \n}")
  end

  test "#set_ship_coordinates" do
    {:ok, ship_set} = ShipSet.start_link
    {:ok, coord1} = Coordinate.start_link
    {:ok, coord2} = Coordinate.start_link
    assert :ok = ShipSet.set_ship_coordinates(ship_set, :battleship, [coord1, coord2])
    assert [coord1, coord2] == ShipSet.get_ship(ship_set, :battleship) |> Ship.get_coordinates()
  end

  test "#set_ship_coordinates - removes ship from previous coordinates" do
    {:ok, ship_set} = ShipSet.start_link
    {:ok, coord} = Coordinate.start_link
    ShipSet.set_ship_coordinates(ship_set, :battleship, [coord])
    assert :battleship == Coordinate.in_ship(coord)
    ShipSet.set_ship_coordinates(ship_set, :battleship, [])
    assert :none == Coordinate.in_ship(coord)
  end

  test "#sunk? - when false" do
    {:ok, ship_set} = ShipSet.start_link
    {:ok, coord} = Coordinate.start_link
    ShipSet.set_ship_coordinates(ship_set, :battleship, [coord])
    assert ShipSet.sunk?(ship_set, :battleship) == false
  end

  test "#sunk? - when true" do
    {:ok, ship_set} = ShipSet.start_link
    {:ok, coord} = Coordinate.start_link
    ShipSet.set_ship_coordinates(ship_set, :battleship, [coord])
    Coordinate.guess(coord)
    assert ShipSet.sunk?(ship_set, :battleship) == true
  end

end
