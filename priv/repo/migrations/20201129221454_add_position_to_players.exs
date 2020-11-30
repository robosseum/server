defmodule Robosseum.Repo.Migrations.AddPositionToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :position, :integer
    end
  end
end
