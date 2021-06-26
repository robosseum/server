defmodule Robosseum.Models.Table do
  use Ecto.Schema
  import Ecto.Changeset

  alias Robosseum.Models.{Player, Action}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tables" do
    field :name, :string
    field :stop, :boolean, default: true
    field :config, :map, default: Application.fetch_env!(:robosseum, :table_config)
    has_many :players, Player
    has_many :actions, Action

    embeds_one :counters, Counters, on_replace: :delete  do
      field :games, :integer, default: 0
      field :rounds, {:array, :integer}, default: []
      field :actions, {:array, {:array, :integer}}, default: []
    end

    timestamps()
  end

  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, [:name, :stop])
    |> cast_embed(:counters, with: &counters_changeset/2)
    |> validate_required([:name])
  end

  defp counters_changeset(counters, params) do
    counters
    |> cast(params, [
      :games,
      :rounds,
      :actions
    ])
  end
end
