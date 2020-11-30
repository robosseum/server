defmodule Robosseum.Repo.Migrations.AddConfigToTables do
  use Ecto.Migration

  def change do
    alter table(:tables) do
      add :config, :map
    end
  end
end
