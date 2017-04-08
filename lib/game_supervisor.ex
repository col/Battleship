defmodule BattleshipEngine.GameSupervisor do
  use Supervisor
  alias BattleshipEngine.Game

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Game, [], restart: :transient)
    ]
    supervise children, strategy: :simple_one_for_one
  end

  def start_game(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def list_games(pid) do
    Supervisor.which_children(pid)
    |> Enum.map(&(Game.get_name(elem(&1, 1))))
  end

end
