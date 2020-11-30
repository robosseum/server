defmodule Robosseum.Models.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias Robosseum.Models.{GamePlayer, Round}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    field :blind, :integer
    field :dealer, :integer
    field :table_id, :binary_id
    has_many :rounds, Round
    has_many :game_players, GamePlayer

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:dealer, :blind, :table_id])
    |> validate_required([:blind, :table_id])
  end
end
