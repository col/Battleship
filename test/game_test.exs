defmodule BattleshipEngine.GameTest do
  use ExUnit.Case
  alias BattleshipEngine.{Game, Player, Board, ShipSet, Ship, Coordinate}

  test "#start_link" do
    {:ok, game} = Game.start_link("Dirk")
    game_state = GenServer.call(game, :demo)
    assert is_pid(game_state.player1)
    assert is_pid(game_state.player2)
  end

  test "#start_link - registers process with global name" do
    {:ok, _game} = Game.start_link("Dirk")
    assert is_map(GenServer.call({:global, "game:Dirk"}, :demo))
  end

  test "#start_link - cannot have the same name as an existing process" do
    {:ok, game1} = Game.start_link("Dirk")
    {:error, {:already_started, _}} = Game.start_link("Dirk")
  end

  test "#stop" do
    {:ok, game} = Game.start_link("Dirk")
    assert :ok = Game.stop(game)
  end

  test "#add_player" do
    {:ok, game} = Game.start_link("Dirk")
    Game.add_player(game, "Gently")
    game_state = GenServer.call(game, :demo)
    assert Agent.get(game_state.player2, &(&1.name)) == "Gently"
  end

  test "#set_ship_coordinates" do
    {:ok, game} = Game.start_link("Dirk")
    assert :ok = Game.set_ship_coordinates(game, :player1, :battleship, [:a1, :a2, :a3, :a4])
    game_state = GenServer.call(game, :demo)
    coordinate = Player.get_ship_set(game_state.player1) |> ShipSet.get_ship(:battleship) |> Ship.get_coordinates |> List.first
    assert Coordinate.in_ship(coordinate) == :battleship
    assert Coordinate.guessed?(coordinate) == false
  end

  test "#guess_coordinate - when it's a miss" do
    {:ok, game} = Game.start_link("Dirk")
    assert {:miss, :none, :no_win} = Game.guess_coordinate(game, :player1, :a1)
    game_state = GenServer.call(game, :demo)
    assert Player.get_board(game_state.player2) |> Board.get_coordinate(:a1) |> Coordinate.guessed?
  end

  test "#guess_coordinate - when it's a hit but doesn't sink the ship" do
    {:ok, game} = Game.start_link("Dirk")
    Game.set_ship_coordinates(game, :player1, :battleship, [:a1, :a2])
    assert {:hit, :none, :no_win} = Game.guess_coordinate(game, :player2, :a1)
  end

  test "#guess_coordinate - when it's a hit and sinks the ship but doesn't win the game" do
    {:ok, game} = Game.start_link("Dirk")
    Game.set_ship_coordinates(game, :player1, :battleship, [:a1])
    Game.set_ship_coordinates(game, :player1, :cruiser, [:b2])
    assert {:hit, :battleship, :no_win} = Game.guess_coordinate(game, :player2, :a1)
  end

  test "#guess_coordinate - when it's a hit and sinks the ship to win the game" do
    {:ok, game} = Game.start_link("Dirk")
    Game.set_ship_coordinates(game, :player1, :battleship, [:a1])
    assert {:hit, :battleship, :win} = Game.guess_coordinate(game, :player2, :a1)
  end

end
