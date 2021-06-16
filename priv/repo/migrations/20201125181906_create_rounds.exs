defmodule Robosseum.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :deck, :map
      add :pot, :integer
      add :active_player, :integer
      add :stage, {:array, :string}
      add :board, :map
      add :game_id, references(:games, on_delete: :nothing, type: :binary_id)
      add :winner_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:rounds, [:game_id])
  end
end
