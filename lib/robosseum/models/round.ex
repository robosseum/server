defmodule Robosseum.Models.Round do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rounds" do
    field :board, :map
    field :deck, :map
    field :pot, :integer
    field :stage, {:array, :string}
    field :game_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:deck, :pot, :stage, :board])
    |> validate_required([:deck, :pot, :stage, :board])
  end
end
