defmodule Robosseum.Models.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias Robosseum.Models.Table

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :connected, :boolean, default: false
    field :name, :string
    field :points, :integer, default: 0
    field :chips, :integer, default: 0
    field :bids, :integer, default: 0
    field :min_bid, :integer, default: 0
    field :to_call, :integer, default: 0
    field :status, :string
    field :hand, :map
    belongs_to :table, Table

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :points, :connected, :chips, :bids, :min_bid, :to_call, :status, :hand, :table_id])
    |> validate_required([:name, :table_id])
  end
end
