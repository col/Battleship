defmodule BattleshipEngine.CoordinateTest do
  use ExUnit.Case
  alias BattleshipEngine.Coordinate

  test "#guessed?" do
    {:ok, coord} = Coordinate.start_link
    assert false == Coordinate.guessed?(coord)
  end

  test "#in_ship" do
    {:ok, coord} = Coordinate.start_link
    assert :none == Coordinate.in_ship(coord)
  end

  test "#in_ship?" do
    {:ok, coord} = Coordinate.start_link
    assert false == Coordinate.in_ship?(coord)
  end

  test "#hit?" do
    {:ok, coord} = Coordinate.start_link
    assert false == Coordinate.hit?(coord)
  end

  test "#guess" do
    {:ok, coord} = Coordinate.start_link
    assert :ok == Coordinate.guess(coord)
    assert true == Coordinate.guessed?(coord)
  end

  test "#set_in_ship" do
    {:ok, coord} = Coordinate.start_link
    assert :ok == Coordinate.set_in_ship(coord, :battleship)
    assert true == Coordinate.in_ship?(coord)
    assert :battleship == Coordinate.in_ship(coord)
  end

  test "#to_string" do
    {:ok, coord} = Coordinate.start_link
    assert "(in_ship:none, guessed:false)" == Coordinate.to_string(coord)
  end

end
