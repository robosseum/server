defmodule Robosseum.Server.Repo do
  @moduledoc """
  Repository to work with server
  """
  import Ecto.Query, only: [from: 2]

  alias Robosseum.Repo
  alias Robosseum.Models.{Table, Player, Game, Round, RoundAction}

  def list_tables do
    query = from(t in Table, where: is_nil(t.deleted_at))

    query
    |> Repo.all()
  end

  def get_table_with_preloads(id) do
    players_query = from(p in Player, order_by: p.inserted_at)
    games_query = from(g in Game, order_by: g.inserted_at)
    rounds_query = from(r in Round, order_by: r.inserted_at)

    Table
    |> Repo.get!(id)
    |> Repo.preload(players: players_query)
    |> Repo.preload(games: {games_query, [rounds: rounds_query]})
  end

  def get_table(id) do
    Repo.get!(Table, id)
  end

  def create_table(name) do
    %Table{}
    |> Table.changeset(%{name: name, config: Application.fetch_env!(:robosseum, :table_config)})
    |> Repo.insert!()
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

  def get_game(game_id) do
    Game
    |> Repo.get!(game_id)
  end

  def create_game(table_model) do
    %Game{}
    |> Game.changeset(%{table_id: table_model.id, blind: table_model.config["blind"], dealer: 0})
    |> Repo.insert!()
  end

  def create_round(game_model) do
    %Round{}
    |> Round.changeset(%{
      game_id: game_model.id,
      board: [],
      deck: Robosseum.Server.Deck.new(),
      pot: 0,
      active_player: game_model.dealer + 1,
      stage: ["blinds", "normal"],
    })
    |> Repo.insert!()
  end

  def create_round_action(table = %{round_id: round_id}, action, message) do
    %RoundAction{}
    |> RoundAction.changeset(%{
      round_id: round_id,
      action: action,
      message: message,
      table_state: table
    })
    |> Repo.insert!()
  end

  def delete_games(table_id) do
    table = get_table_with_preloads(table_id)

    Enum.each(table.games, fn game ->
      Enum.each(game.game_players, fn game_player ->
        Repo.delete(game_player)
      end)

      Repo.delete(game)
    end)
  end

  # def update(table) do
  #   old_table = Repo.get(Table, table.id)
  #   changeset = Table.changeset(old_table, table)
  #   Repo.update!(changeset)
  # end

  # def destroy(table_id) do
  #   table = Repo.get(Table, table_id)
  #   changeset = Table.changeset(table, %{deleted_at: DateTime.utc_now()})
  #   Repo.update!(changeset)
  # end

  # def atomize_keys(struct = %{__struct__: _}) do
  #   struct
  # end

  # def atomize_keys(map = %{}) do
  #   map
  #   |> Enum.map(fn {k, v} -> {if(is_atom(k), do: k, else: String.to_atom(k)), atomize_keys(v)} end)
  #   |> Enum.into(%{})
  # end

  # def atomize_keys([head | rest]) do
  #   [atomize_keys(head) | atomize_keys(rest)]
  # end

  # def atomize_keys(not_a_map) do
  #   not_a_map
  # end
end
