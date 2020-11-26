defmodule Robosseum.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :stop, :boolean, default: false, null: false
      add :deleted_at, :naive_datetime

      timestamps()
    end

  end
end
