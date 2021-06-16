defmodule Robosseum.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :points, :integer, default: 0
      add :connected, :boolean, default: false, null: false
      add :chips, :integer, default: 0
      add :bids, :integer, default: 0
      add :min_bid, :integer
      add :to_call, :integer
      add :status, :string
      add :hand, :map
      add :table_id, references(:tables, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:players, [:table_id])
  end
end
