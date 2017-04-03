defmodule BattleshipEngine.PlayerTest do
  use ExUnit.Case
  alias BattleshipEngine.Player

  test "#start_link" do
    {:ok, player} = Player.start_link
    state = Agent.get(player, &(&1))
    assert is_pid(state.board)
    assert is_pid(state.ship_set)
  end

  test "#set_name" do
    {:ok, player} = Player.start_link
    Player.set_name(player, "Dirk")
    assert Agent.get(player, &(&1.name)) == "Dirk"
  end

  test "#to_string" do
    {:ok, player} = Player.start_link
    assert String.starts_with?(Player.to_string(player), "%Player{:name => none, \n")
  end

end
