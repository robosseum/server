defmodule RobosseumWeb.TableLive do
  import Ecto.Query, warn: false
  alias Robosseum.Repo

  alias Robosseum.Models.{Table, Player, Game, Round}

  @topic inspect(__MODULE__)

  def list_tables do
    Table
    |> Repo.all()
    |> Repo.preload(:players)
  end

  def get_table!(id) do
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

  def create_game(table_id) do
    game =
      %Game{}
      |> Game.changeset(%{table_id: table_id, blind: 100, dealer: 0})
      |> Repo.insert()

    broadcast({:game_created, game})
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Robosseum.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(
      Robosseum.PubSub,
      @topic,
      message
    )
    |> IO.inspect

    IO.inspect(@topic, label: "broadcasting")
  end
end
