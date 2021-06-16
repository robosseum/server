defmodule RobosseumWeb.TableLive do
  import Ecto.Query, warn: false
  alias Robosseum.Repo

  alias Robosseum.Models.{Table, Player, Game, Round}

  def list_tables do
    Table
    |> Repo.all()
    |> Repo.preload(:players)
  end

  def get_table(id) do
    players_query = from p in Player, order_by: p.position
    games_query = from g in Game, order_by: g.inserted_at
    rounds_query = from r in Round, order_by: r.inserted_at

    Table
    |> Repo.get!(id)
    |> Repo.preload(players: players_query)
    |> Repo.preload(
      games: {games_query, [:game_players, rounds: {rounds_query, [:round_players]}]}
    )
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Robosseum.PubSub, topic)
  end
end
