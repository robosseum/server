defmodule Robosseum.Server.Player do
  @derive Jason.Encoder
  defstruct [:id, :name, :chips, :status, :to_call, :bids]

  @doc """
  Creates a new player map.
  `status` ("active" | "folded" | "raised" | "called" | "all_in" | "blind" | "out") - current status of a player in a round
  """
  def new(nil), do: nil

  def new(player) do
    %__MODULE__{
      id: player.id,
      name: player.name,
      chips: player.chips,
      status: player.status,
      to_call: player.to_call,
      bids: player.bids
    }
  end

  def active?(player) do
    !Enum.member?(["folded", "all_in", "out"], player.status)
  end
end
