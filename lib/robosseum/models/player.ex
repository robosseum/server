defmodule Robosseum.Models.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias Robosseum.Models.Table

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :connected, :boolean, default: false
    field :name, :string
    field :points, :integer
    belongs_to :table, Table

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :points, :connected])
    |> validate_required([:name, :points, :connected])
  end
end
