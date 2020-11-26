defmodule Robosseum.Repo.Migrations.CreateGamePlayers do
  use Ecto.Migration

  def change do
    create table(:game_players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :chips, :integer
      add :game_id, references(:games, on_delete: :nothing, type: :binary_id)
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:game_players, [:game_id])
    create index(:game_players, [:player_id])
  end
end
