defmodule Robosseum.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :map
      add :action, :string
      add :message, :string
      add :index, :integer, default: 0
      add :game, :integer, default: 0
      add :round, :integer, default: 0
      add :table_id, references(:tables, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:actions, [:table_id])
  end
end
