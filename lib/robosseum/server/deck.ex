defmodule Robosseum.Server.Deck do
  alias Robosseum.Server.Card

  @doc """
  Creates a shuffled deck of cards.

  Used at the beginning of a new round.
  """
  def new do
    for rank <- Card.ranks(), suit <- Card.suites() do
      %Card{rank: rank, suit: suit}
    end
    |> Enum.shuffle()
  end
end
