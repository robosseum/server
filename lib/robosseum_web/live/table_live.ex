defmodule RobosseumWeb.TableLive do
  import Ecto.Query, warn: false
  alias Robosseum.Repo

  alias Robosseum.Models.{Table, Player, Action}

  def list_tables do
    Table
    |> Repo.all()
    |> Repo.preload(:players)
  end

  def get_table(id) do
    # players_query = from p in Player, order_by: p.index
    # actions_query = from a in Action, order_by: a.index

    Table
    |> Repo.get!(id)
    # |> Repo.preload(players: players_query)
    # |> Repo.preload(actions: actions_query)
  end

  def get_action(table_id) do
    Repo.one(from a in Action, order_by: [desc: a.index], where: a.table_id == ^table_id, limit: 1)
  end

  def get_actions(table_id, game, round) do
    Repo.all(
      from a in Action,
        order_by: [desc: a.index],
        where:
          a.table_id == ^table_id and a.game == ^game and a.round == ^round
    )
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Robosseum.PubSub, topic)
  end
end
