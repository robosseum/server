defmodule Robosseum.Models.Table do
  use Ecto.Schema
  import Ecto.Changeset

  alias Robosseum.Models.{Player, Game}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tables" do
    field :deleted_at, :naive_datetime
    field :name, :string
    field :stop, :boolean, default: false
    field :config, :map, default: Application.fetch_env!(:robosseum, :table_config)
    has_many :players, Player
    has_many :games, Game

    timestamps()
  end

  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, [:name, :stop, :deleted_at])
    |> validate_required([:name])
  end
end
