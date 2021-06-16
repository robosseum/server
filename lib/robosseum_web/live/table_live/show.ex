defmodule RobosseumWeb.TableLive.Show do
  use RobosseumWeb, :live_view

  alias RobosseumWeb.TableLive
  alias Robosseum.Server

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: TableLive.subscribe("table" <> id)

    table = TableLive.get_table(id)
    game = List.first(table.games)

    socket =
      assign(
        socket,
        table: table,
        players: table.players,
        dealer: nil,
        active_player: nil,
        games: table.games,
        game: game,
        rounds: game.rounds,
        round: List.first(game.rounds)
      )

    {:ok, socket}
  end

  def handle_event("restart", %{"id" => id}, socket) do
    Server.API.restart(id)
    {:noreply, socket}
  end

  def handle_info({"update_table", table_id}, socket) do
    table = TableLive.get_table(table_id)

    socket =
      assign(
        socket,
        table: table,
        players: table.players,
        dealer: nil,
        active_player: nil,
        games: table.games,
        game: List.first(table.games)
      )

    {:noreply, socket}
  end

  def handle_info({"update_game", game_id}, socket) do
    socket = 
      if(socket.game.id == game_id) do
        game = TableLive.get_game(game_id)

        assign(
          socket,
          game: game
        )
      else
        socket
      end

    {:noreply, socket}
  end
end
