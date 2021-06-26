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
    field :index, :integer, default: 0
    belongs_to :table, Table

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :points, :connected, :index, :table_id])
    |> validate_required([:name, :index, :table_id])
  end
end
