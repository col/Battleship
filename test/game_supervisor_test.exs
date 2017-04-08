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
    assert ["game1", "game2"] = list
    Enum.each([game1, game2], &(Game.stop(&1)))
  end

end
