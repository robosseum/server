defmodule Robosseum.Server.Card do
  @derive {Jason.Encoder, only: [:rank, :suit]}
  defstruct [:rank, :suit]
  # TODO: add a typespec

  @ranks 2..14
  @suites ["spades", "clubs", "hearts", "diamonds"]

  @doc """
  Converts a string representation of a card (e.g. "As") to a map (e.g. `%{rank: 14, suit: "spades"}`).
  """
  def from_string(<<rank, suit>>) do
    %{rank: rank_from_char(rank), suit: suit_from_char(suit)}
  end

  def from_string(cards) when is_list(cards), do: Enum.map(cards, &from_string(&1))

  def to_list(%{rank: rank, suit: suit}), do: [rank, suit]

  def ranks, do: Enum.to_list(@ranks)
  def suites, do: @suites

  defp rank_from_char(?A), do: 14
  defp rank_from_char(?a), do: 14
  defp rank_from_char(?K), do: 13
  defp rank_from_char(?k), do: 13
  defp rank_from_char(?Q), do: 12
  defp rank_from_char(?q), do: 12
  defp rank_from_char(?J), do: 11
  defp rank_from_char(?j), do: 11
  defp rank_from_char(?T), do: 10
  defp rank_from_char(?t), do: 10
  defp rank_from_char(rank) when rank >= ?2 and rank <= ?9, do: rank - ?0

  defp suit_from_char(?s), do: "spades"
  defp suit_from_char(?S), do: "spades"
  defp suit_from_char(?c), do: "clubs"
  defp suit_from_char(?C), do: "clubs"
  defp suit_from_char(?h), do: "hearts"
  defp suit_from_char(?H), do: "hearts"
  defp suit_from_char(?d), do: "diamonds"
  defp suit_from_char(?D), do: "diamonds"

  def to_string(%{rank: rank, suit: suit}) do
    "#{rank_to_char(rank)}#{suit_to_char(suit)}"
  end

  defp rank_to_char(rank) when rank < 10, do: rank
  defp rank_to_char(10), do: "T"
  defp rank_to_char(11), do: "J"
  defp rank_to_char(12), do: "Q"
  defp rank_to_char(13), do: "K"
  defp rank_to_char(14), do: "A"

  defp suit_to_char(suit) when is_binary(suit) do
    suit |> String.first()
  end
end
