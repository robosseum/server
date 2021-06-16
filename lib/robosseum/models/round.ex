defmodule Robosseum.Models.Round do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rounds" do
    field :board, {:array, :map}
    field :deck, {:array, :map}
    field :pot, :integer
    field :stage, {:array, :string}
    field :active_player, :integer
    field :game_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:deck, :pot, :stage, :board, :game_id, :active_player])
    |> validate_required([:deck, :pot, :stage, :board, :game_id, :active_player])
  end
end
