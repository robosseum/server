defmodule Robosseum.Models.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "game_players" do
    field :chips, :integer
    field :game_id, :binary_id
    field :player_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(game_player, attrs) do
    game_player
    |> cast(attrs, [:chips])
    |> validate_required([:chips])
  end
end
