defmodule Robosseum.Repo.Migrations.CreateRoundPlayers do
  use Ecto.Migration

  def change do
    create table(:round_players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :bids, :integer
      add :min_bid, :integer
      add :to_call, :integer
      add :status, :string
      add :hand, :map
      add :round_id, references(:rounds, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:round_players, [:round_id])
  end
end
