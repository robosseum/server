defmodule Robosseum.Server.Player do
  @derive Jason.Encoder
  @doc """
  `status` ("active" | "folded" | "raised" | "called" | "all_in" | "blind" | "out") - current status of a player in a round
  `rank` -> used for storing the end round rank of cards for finding the winner
  """
  defstruct [
    :id,
    :name,
    :index,
    hand: [],
    status: "active",
    chips: 0,
    to_call: 0,
    bids: 0,
    rank: nil
  ]

  def new(nil), do: nil

  def new(player) do
    %__MODULE__{
      id: player.id,
      name: player.name,
      index: player.index
    }
  end

  def active?(player) do
    !Enum.member?(["folded", "all_in", "out"], player.status)
  end

  def set_status_for_new_stage(players) do
    Enum.map(
      players,
      &%{&1 | status: if(active?(&1), do: "active", else: &1.status)}
    )
  end
end
