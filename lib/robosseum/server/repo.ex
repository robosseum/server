defmodule Robosseum.Server.Repo do
  @moduledoc """
  Repository to work with server
  """
  import Ecto.Query, only: [from: 2]

  alias Robosseum.Repo
  alias Robosseum.Models.{Table, Player, Action}

  def list_tables do
    Repo.all(Table)
  end

  def get_table_with_preloads(id) do
    players_query = from(p in Player, order_by: p.index)

    Table
    |> Repo.get!(id)
    |> Repo.preload(players: players_query)
  end

  def get_table(id) do
    Repo.get!(Table, id)
  end

  def update_table(table_id, attrs) do
    table_id
    |> get_table
    |> Table.changeset(attrs)
    |> Repo.update!()
  end

  def get_player(player_id) do
    Player
    |> Repo.get!(player_id)
  end

  def update_player(player_id, attrs) do
    player_id
    |> get_player
    |> Player.changeset(attrs)
    |> Repo.update!()
  end

  def get_latest_action(table_id) do
    Repo.one(from a in Action, order_by: [desc: a.index], where: a.table_id == ^table_id, limit: 1)
  end

  def create_action(attrs) do
    %Action{}
    |> Action.changeset(attrs)
    |> Repo.insert!()
  end

  def delete_actions(table_id) do
    actions = Repo.all(from a in Action, where: a.table_id == ^table_id)
    Enum.each(actions, fn action ->
      Repo.delete(action)
    end)
  end
end
