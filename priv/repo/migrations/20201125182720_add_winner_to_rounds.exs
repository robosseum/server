defmodule Robosseum.Repo.Migrations.AddWinnerToRounds do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :winner_id, references(:players, on_delete: :nothing, type: :binary_id)
    end
  end
end
