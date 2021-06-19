defmodule Robosseum.Server.TexasHoldEm.Hand do
  @moduledoc """
  Calculates best combination of cards from 5 community cards and 2 hand cards.
  """

  # Hand ranks
  @royal_flush [10, "Royal flush"]
  @straight_flush [9, "Straight flush"]
  @four_of_a_kind [8, "Four of a kind"]
  @full_house [7, "Full house"]
  @flush [6, "Flush"]
  @straight [5, "Straight"]
  @three_of_a_kind [4, "Three of a kind"]
  @two_pair [3, "Two pair"]
  @one_pair [2, "One pair"]
  @high_card [1, "High card"]

  @doc """
  Returns best combination of cards from 5 community cards and 2 hand cards.
  """
  def best_combination(board, hand) do
    (board ++ hand)
    |> combinations(5)
    |> Stream.map(&[rank(&1), &1])
    |> Enum.max()
  end

  @doc """
  (private) Ported from the Erlang http://rosettacode.org/wiki/Combinations#Dynamic_Programming
  """
  def combinations(list, k), do: List.last(do_combinations(list, k))

  defp do_combinations(list, k) do
    accum = [[[]]] ++ List.duplicate([], k)

    Enum.reduce(list, accum, fn x, next ->
      sub = Enum.take(next, length(next) - 1)
      step = [[]] ++ for l <- sub, do: for(s <- l, do: [x | s])
      :lists.zipwith(&:lists.append/2, step, next)
    end)
  end

  @doc """
  (private) Used only in this module and in `Robosseum.TestHelpers.HandHelper`
  """
  def rank(cards) do
    cards
    |> Enum.map(&Robosseum.Server.Card.to_list(&1))
    |> Enum.sort()
    |> rank_tuple
  end

  defp rank_tuple([[10, s], [11, s], [12, s], [13, s], [14, s]]), do: [@royal_flush, nil]

  defp rank_tuple([[a, s], [_b, s], [_c, s], [_d, s], [e, s]]) when e - a == 4,
    do: [@straight_flush, e]

  defp rank_tuple([[2, s], [3, s], [4, s], [5, s], [14, s]]), do: [@straight_flush, 5]

  defp rank_tuple([[a, _], [a, _], [a, _], [a, _], [b, _]]), do: [@four_of_a_kind, [a, b]]
  defp rank_tuple([[b, _], [a, _], [a, _], [a, _], [a, _]]), do: [@four_of_a_kind, [a, b]]

  defp rank_tuple([[a, _], [a, _], [a, _], [b, _], [b, _]]), do: [@full_house, [a, b]]
  defp rank_tuple([[b, _], [b, _], [a, _], [a, _], [a, _]]), do: [@full_house, [a, b]]

  defp rank_tuple([[e, s], [d, s], [c, s], [b, s], [a, s]]), do: [@flush, [a, b, c, d, e]]

  defp rank_tuple([[a, _], [b, _], [c, _], [d, _], [e, _]])
       when a + 1 == b and b + 1 == c and c + 1 == d and d + 1 == e,
       do: [@straight, e]

  defp rank_tuple([[2, _], [3, _], [4, _], [5, _], [14, _]]), do: [@straight, 5]

  defp rank_tuple([[a, _], [a, _], [a, _], [c, _], [b, _]]), do: [@three_of_a_kind, [a, b, c]]
  defp rank_tuple([[c, _], [a, _], [a, _], [a, _], [b, _]]), do: [@three_of_a_kind, [a, b, c]]
  defp rank_tuple([[c, _], [b, _], [a, _], [a, _], [a, _]]), do: [@three_of_a_kind, [a, b, c]]

  defp rank_tuple([[b, _], [b, _], [a, _], [a, _], [c, _]]), do: [@two_pair, [a, b, c]]
  defp rank_tuple([[b, _], [b, _], [c, _], [a, _], [a, _]]), do: [@two_pair, [a, b, c]]
  defp rank_tuple([[c, _], [b, _], [b, _], [a, _], [a, _]]), do: [@two_pair, [a, b, c]]

  defp rank_tuple([[a, _], [a, _], [d, _], [c, _], [b, _]]), do: [@one_pair, [a, b, c, d]]
  defp rank_tuple([[d, _], [a, _], [a, _], [c, _], [b, _]]), do: [@one_pair, [a, b, c, d]]
  defp rank_tuple([[d, _], [c, _], [a, _], [a, _], [b, _]]), do: [@one_pair, [a, b, c, d]]
  defp rank_tuple([[d, _], [c, _], [b, _], [a, _], [a, _]]), do: [@one_pair, [a, b, c, d]]

  defp rank_tuple([[e, _], [d, _], [c, _], [b, _], [a, _]]), do: [@high_card, [a, b, c, d, e]]
end

