defmodule BattleshipEngine.ShipSetTest do
  use ExUnit.Case
  alias BattleshipEngine.ShipSet

  test "#start_link" do
    {:ok, ship_set} = ShipSet.start_link
    battleship_pid = Agent.get(ship_set, fn(struct) -> struct.battleship end)
    assert is_pid(battleship_pid)
  end

  test "#to_string" do
    {:ok, ship_set} = ShipSet.start_link
    assert String.starts_with?(ShipSet.to_string(ship_set), "%ShipSet{:aircraft_carrier => [], \n")
    assert String.ends_with?(ShipSet.to_string(ship_set), ":submarine2 => [], \n}")
  end

end
