defmodule BattleshipEngine.PlayerTest do
  use ExUnit.Case
  alias BattleshipEngine.{Player, Board, Coordinate}

  test "#start_link" do
    {:ok, player} = Player.start_link("Dirk")
    assert Player.get_name(player) == "Dirk"
    assert is_pid(Player.get_board(player))
    assert is_pid(Player.get_ship_set(player))
  end

  test "#start_link - without a name" do
    {:ok, player} = Player.start_link()
    assert Player.get_name(player) == :none
  end

  test "#set_name" do
    {:ok, player} = Player.start_link
    Player.set_name(player, "Dirk")
    assert Player.get_name(player) == "Dirk"
  end

  test "#set_ship_coordinates" do
    {:ok, player} = Player.start_link
    assert :ok = Player.set_ship_coordinates(player, :battleship, [:a1])
    assert :battleship = player |> Player.get_board |> Board.get_coordinate(:a1) |> Coordinate.in_ship
  end

  test "#guess_coordinate" do
    {:ok, player} = Player.start_link
    assert :miss = Player.guess_coordinate(player, :a1)
    assert player |> Player.get_board |> Board.get_coordinate(:a1) |> Coordinate.guessed?
  end

  test "#sunk_ship - when ship there is no ship" do
    {:ok, player} = Player.start_link
    assert :none = Player.sunk_ship(player, :a1)
  end

  test "#sunk_ship - when ship is not sunk" do
    {:ok, player} = Player.start_link
    Player.set_ship_coordinates(player, :battleship, [:a1])
    assert :none = Player.sunk_ship(player, :a1)
  end

  test "#sunk_ship - when ship is sunk" do
    {:ok, player} = Player.start_link
    Player.set_ship_coordinates(player, :battleship, [:a1])
    Player.guess_coordinate(player, :a1)
    assert :battleship = Player.sunk_ship(player, :a1)
  end

  test "#win? - when game is not won" do
    {:ok, player} = Player.start_link
    Player.set_ship_coordinates(player, :battleship, [:a1])
    assert :no_win = Player.win?(player)
  end

  test "#win? - when game is won" do
    {:ok, player} = Player.start_link
    Player.set_ship_coordinates(player, :battleship, [:a1])
    Player.guess_coordinate(player, :a1)
    assert :win = Player.win?(player)
  end

  test "#to_string" do
    {:ok, player} = Player.start_link
    assert String.starts_with?(Player.to_string(player), "%Player{:name => none, \n")
  end

end
