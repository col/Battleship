defmodule BattleshipEngine.GameSupervisorTest do
  use ExUnit.Case
  alias BattleshipEngine.{Game, GameSupervisor}

  test "#start_game - should start game process with the name provided" do
    {:ok, game_pid} = GameSupervisor.start_game("MyGame")
    assert "MyGame" = Game.get_name(game_pid)
    Game.stop(game_pid)
  end

  test "#list_games - should list all of the running games by name" do
    {:ok, game1} = GameSupervisor.start_game("game1")
    {:ok, game2} = GameSupervisor.start_game("game2")
    list = GameSupervisor.list_games(GameSupervisor)
    assert Enum.member?(list, "game1")
    assert Enum.member?(list, "game2")
    Enum.each([game1, game2], &(Game.stop(&1)))
  end

  test "#list_open_games - should list all the open games by name" do
    {:ok, game1} = GameSupervisor.start_game("game1")
    {:ok, game2} = GameSupervisor.start_game("game2")
    Game.add_player(game1, "Player 2")
    list = GameSupervisor.list_open_games(GameSupervisor)
    assert Enum.member?(list, "game1") == false
    assert Enum.member?(list, "game2") == true
    Enum.each([game1, game2], &(Game.stop(&1)))
  end

end
