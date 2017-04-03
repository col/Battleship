defmodule BattleshipEngine.Ship do
  alias BattleshipEngine.{Ship, Coordinate}

  def start_link() do
    Agent.start_link(fn -> [] end)
  end

  def replace_coordinates(ship, new_coords) when is_list(new_coords) do
    Agent.update(ship, fn(_) -> new_coords end)
  end

  def get_coordinates(ship) do
    Agent.get(ship, &(&1))
  end
  
  def sunk?(ship) do
    Agent.get(ship, &(&1))
    |> Enum.all?(&(Coordinate.hit?(&1)))
  end

  def to_string(ship) do
    Agent.get(ship, &(&1))
    |> Enum.reduce("", &("#{&2}, #{Coordinate.to_string(&1)}"))
    |> String.replace_leading(", ", "")
    |> String.replace_prefix("", "[")
    |> String.replace_suffix("", "]")
  end
end
