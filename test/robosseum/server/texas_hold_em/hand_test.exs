defmodule Robosseum.Server.TexasHoldEm.HandTest do
  use ExUnit.Case, async: true

  alias Robosseum.Server.{Card, TexasHoldEm.Hand}

  test "#rank" do
    assert hand_rank(["As", "Ks", "Qs", "Js", "Ts"]) == [10, nil]
    assert hand_rank(["Ks", "Qs", "Js", "9s", "Ts"]) == [9, 13]
    assert hand_rank(["As", "2s", "3s", "4s", "5s"]) == [9, 5]
    assert hand_rank(["Ks", "Kd", "Kc", "Kh", "As"]) == [8, [13, 14]]
    assert hand_rank(["Js", "Jd", "Jc", "Jh", "9s"]) == [8, [11, 9]]
    assert hand_rank(["Ks", "Kd", "Kc", "9h", "9s"]) == [7, [13, 9]]
    assert hand_rank(["3h", "3c", "3s", "Jd", "Jc"]) == [7, [3, 11]]
    assert hand_rank(["2h", "7h", "8h", "9h", "Th"]) == [6, [10, 9, 8, 7, 2]]
    assert hand_rank(["Ks", "Qc", "Js", "Ah", "Ts"]) == [5, 14]
    assert hand_rank(["As", "2c", "3s", "4h", "5s"]) == [5, 5]
    assert hand_rank(["Ks", "Kd", "Kc", "9h", "As"]) == [4, [13, 14, 9]]
    assert hand_rank(["3h", "3c", "3s", "Jd", "Qc"]) == [4, [3, 12, 11]]
    assert hand_rank(["Ks", "Kd", "9c", "9h", "As"]) == [3, [13, 9, 14]]
    assert hand_rank(["3h", "3c", "Js", "Jd", "Tc"]) == [3, [11, 3, 10]]
    assert hand_rank(["3h", "3c", "4d", "4s", "2c"]) == [3, [4, 3, 2]]
    assert hand_rank(["Ks", "Kd", "8c", "9h", "Js"]) == [2, [13, 11, 9, 8]]
    assert hand_rank(["7h", "Tc", "8s", "Jd", "Tc"]) == [2, [10, 11, 8, 7]]
    assert hand_rank(["3h", "3c", "4d", "5s", "2c"]) == [2, [3, 5, 4, 2]]
    assert hand_rank(["Ks", "Qd", "9c", "9h", "As"]) == [2, [9, 14, 13, 12]]
    assert hand_rank(["Ks", "Qd", "9c", "Jh", "As"]) == [1, [14, 13, 12, 11, 9]]
  end

  test "winning hands" do
    assert hand_rank(["As", "Ks", "Qs", "Js", "Ts"]) > hand_rank(["Ks", "Qs", "Js", "Ts", "9s"])
    assert hand_rank(["As", "Ks", "Qs", "Js", "Ts"]) == hand_rank(["Ah", "Kh", "Qh", "Jh", "Th"])
  end

  test "hand with board" do
    assert best_hand_rank(["Kd", "Ks", "As", "Js", "Kh"], ["Kc", "Ac"]) == [8, [13, 14]]
    assert best_hand_rank(["Kd", "Ks", "Kc", "Ts", "9s"], ["Qs", "Js"]) == [9, 13]
  end

  def hand_rank(hand) do
    cards = Card.from_string(hand)
    [[rank, _name], value] = Hand.rank(cards)
    [rank, value]
  end

  def best_hand_rank(board, hand) do
    board_cards = Card.from_string(board)
    hand_cards = Card.from_string(hand)

    [[[ranking, _name], value], _best_hand] =
      Hand.best_combination(board_cards, hand_cards)

    [ranking, value]
  end
end

