defmodule Robosseum.Repo.Migrations.CreateRoundActions do
  use Ecto.Migration

  def change do
    create table(:round_actions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :table_state, :map
      add :action, :string
      add :message, :string
      add :round_id, references(:rounds, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:round_actions, [:round_id])
  end
end
