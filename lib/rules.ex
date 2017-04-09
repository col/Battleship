defmodule BattleshipEngine.Rules do
  use GenStateMachine
  alias BattleshipEngine.Rules

  def start_link() do
    GenStateMachine.start_link(Rules, {:waiting_for_player, 0})
  end

  def event(fsm, event) do
    GenStateMachine.cast(fsm, event)
  end

  def state(fsm) do
    GenStateMachine.call(fsm, :get_state)
  end

  def handle_event(:cast, :add_player, :waiting_for_player, state) do
    {:next_state, :players_set, state}
  end

  def handle_event(:cast, :player1_guess, :player1_turn, state) do
    {:next_state, :player2_turn, state}
  end

  def handle_event(:cast, :player2_guess, :player2_turn, state) do
    {:next_state, :player1_turn, state}
  end

  def handle_event(:cast, :player1_set_ships, :players_set, state) do
    {:next_state, :players_set, state}
  end

  def handle_event(:cast, :player2_set_ships, :players_set, state) do
    {:next_state, :player1_turn, state}
  end

  def handle_event({:call, from}, :get_state, state, data) do
    {:next_state, state, data, [{:reply, from, state}]}
  end

end
