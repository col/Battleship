defmodule BattleshipEngine.RulesTest do
  use ExUnit.Case
  alias BattleshipEngine.Rules

  test "#state" do
    {:ok, fsm} = Rules.start_link
    assert :waiting_for_player = Rules.state(fsm)
  end

  test "handle add_player event" do
    {:ok, fsm} = Rules.start_link
    Rules.event(fsm, :add_player)
    assert :players_set = Rules.state(fsm)
  end

  test "handle set ship events" do
    {:ok, fsm} = Rules.start_link
    Rules.event(fsm, :add_player)
    Rules.event(fsm, :player1_set_ships)
    Rules.event(fsm, :player2_set_ships)
    assert :player1_turn = Rules.state(fsm)
  end

end
