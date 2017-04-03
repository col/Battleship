defmodule BattleshipEngine.ShipTest do
  use ExUnit.Case
  alias BattleshipEngine.{Ship, Coordinate}

  setup do
    {:ok, coord1} = Coordinate.start_link
    {:ok, coord2} = Coordinate.start_link
    Enum.each([coord1, coord2], fn(coord) -> Coordinate.set_in_ship(coord, :destroyer) end)
    {:ok, coords: [coord1, coord2]}
  end

  test "#replace_coordinates", %{coords: coords} do
    {:ok, ship} = Ship.start_link
    assert :ok = Ship.replace_coordinates(ship, coords)
  end

  test "#get_coordinates", %{coords: coords} do
    {:ok, ship} = Ship.start_link
    assert [] = Ship.get_coordinates(ship)
    Ship.replace_coordinates(ship, coords)
    assert coords == Ship.get_coordinates(ship)
  end

  test "#sunk?", %{coords: coords} do
    {:ok, ship} = Ship.start_link
    Ship.replace_coordinates(ship, coords)
    assert false == Ship.sunk?(ship)
    Enum.each(coords, fn(coord) -> Coordinate.guess(coord) end)
    assert true == Ship.sunk?(ship)
  end

  test "#to_string", %{coords: coords} do
    {:ok, ship} = Ship.start_link
    Ship.replace_coordinates(ship, coords)
    assert "[(in_ship:destroyer, guessed:false), (in_ship:destroyer, guessed:false)]" = Ship.to_string(ship)
  end

end
