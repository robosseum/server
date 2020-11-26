defmodule Robosseum.Models.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    field :blind, :integer
    field :dealer, :integer
    field :table_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:dealer, :blind])
    |> validate_required([:dealer, :blind])
  end
end
