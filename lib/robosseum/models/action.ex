defmodule Robosseum.Models.Action do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "actions" do
    field :action, :string
    field :message, :string
    field :state, :map
    field :game, :integer
    field :round, :integer
    field :index, :integer
    field :table_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:state, :action, :message, :game, :round, :index, :table_id])
    |> validate_required([:state, :action, :message, :game, :round, :index, :table_id])
  end
end
