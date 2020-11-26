defmodule Robosseum.Dashboard do
  import Ecto.Query, warn: false
  alias Robosseum.Repo

  alias Robosseum.Models.{Table, Player}

  def list_tables, do: Repo.all(Table)
  def list_players(table_id) do
    Repo.all(from player in Player, where: player.table_id == ^table_id)
  end

  def get_table!(id), do: Repo.get!(Table, id)
  def get_player!(id), do: Repo.get!(Player, id)

  def create_table(attrs \\ %{}) do
    %Table{}
    |> Table.changeset(attrs)
    |> Repo.insert()
  end
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def update_table(%Table{} = table, attrs) do
    table
    |> Table.changeset(attrs)
    |> Repo.update()
  end
  def update_player(%Player{} = table, attrs) do
    table
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  def delete_table(%Table{} = table) do
    Repo.delete(table)
  end
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  def change_table(%Table{} = table, attrs \\ %{}) do
    Table.changeset(table, attrs)
  end
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end
end
