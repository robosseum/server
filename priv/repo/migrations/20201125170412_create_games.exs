defmodule Robosseum.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :dealer, :integer
      add :blind, :integer
      add :table_id, references(:tables, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:games, [:table_id])
  end
end
