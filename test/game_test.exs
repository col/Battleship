defmodule BattleshipEngine.GameTest do
  use ExUnit.Case
  alias BattleshipEngine.Game

  test "#start_link" do
    {:ok, game} = Game.start_link("Dirk")
    game_state = GenServer.call(game, :demo)
    assert is_pid(game_state.player1)
    assert is_pid(game_state.player2)
  end

  test "#add_player" do
    {:ok, game} = Game.start_link("Dirk")
    Game.add_player(game, "Gently")
    game_state = GenServer.call(game, :demo)
    assert Agent.get(game_state.player2, &(&1.name)) == "Gently"
  end

end
