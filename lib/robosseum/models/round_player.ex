defmodule Robosseum.Models.RoundPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "round_players" do
    field :bids, :integer
    field :hand, :map
    field :min_bid, :integer
    field :status, :string
    field :to_call, :integer
    field :round_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(round_player, attrs) do
    round_player
    |> cast(attrs, [:bids, :min_bid, :to_call, :status, :hand])
    |> validate_required([:bids, :min_bid, :to_call, :status, :hand])
  end
end
