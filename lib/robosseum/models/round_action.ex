defmodule Robosseum.Models.RoundAction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "round_actions" do
    field :action, :string
    field :message, :string
    field :table_state, :map
    field :round_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(round_action, attrs) do
    round_action
    |> cast(attrs, [:table_state, :action, :message])
    |> validate_required([:table_state, :action, :message])
  end
end
