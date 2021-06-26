defmodule Robosseum.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :stop, :boolean, default: true, null: false
      add :config, :map
      add :counters, :map

      timestamps()
    end

  end
end
