defmodule BattleshipEngine.BoardTest do
  use ExUnit.Case
  alias BattleshipEngine.{Board, Coordinate}

  test "#get_coordinate" do
    {:ok, board} = Board.start_link
    coordinate = Board.get_coordinate(board, :a1)
    assert is_pid(coordinate)
    assert "(in_ship:none, guessed:false)" = Coordinate.to_string(coordinate)
  end

  test "#guess_coordinate" do
    {:ok, board} = Board.start_link
    assert :ok == Board.guess_coordinate(board, :a1)
    coordinate = Board.get_coordinate(board, :a1)
    assert "(in_ship:none, guessed:true)" = Coordinate.to_string(coordinate)
  end

  test "#coordinate_hit?" do
    {:ok, board} = Board.start_link
    assert false == Board.coordinate_hit?(board, :a1)
    Board.set_coordinate_in_ship(board, :a1, :destroyer)
    Board.guess_coordinate(board, :a1)
    assert true == Board.coordinate_hit?(board, :a1)
  end

  test "#coordinate_ship" do
    {:ok, board} = Board.start_link
    assert :none == Board.coordinate_ship(board, :a1)
  end

  test "#set_coordinate_in_ship" do
    {:ok, board} = Board.start_link
    assert :ok == Board.set_coordinate_in_ship(board, :a1, :destroyer)
    assert :destroyer == Board.coordinate_ship(board, :a1)
  end
end
