defmodule RobosseumWeb.TableLive.Show do
  use RobosseumWeb, :live_view

  import Robosseum.Server.Utils

  alias RobosseumWeb.{TableLive, TableCounters}
  alias Robosseum.{Server}

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: TableLive.subscribe("table" <> id)

    table = TableLive.get_table(id)
    action = TableLive.get_action(id)

    state = if is_nil(action), do: nil, else: atomize_keys(action.state)
    counters = TableCounters.new(table.counters)
    actions = TableLive.get_actions(id, counters.game, counters.round)
    IO.inspect(state)

    socket =
      assign(socket, table: table, state: state, counters: counters, actions: actions)

    {:ok, socket}
  end

  def handle_event("restart", %{"id" => id}, socket) do
    Server.API.restart(id)
    {:noreply, socket}
  end

  # def handle_info({"update_table", table_id}, socket) do
  #   table = TableLive.get_table(table_id)

  #   socket = assign(socket, table: table)

  #   {:noreply, socket}
  # end

  # def handle_info({"update_game", game_id}, socket) do
  #   socket =
  #     if(socket.game.id == game_id) do
  #       game = TableLive.get_game(game_id)

  #       assign(
  #         socket,
  #         game: game
  #       )
  #     else
  #       socket
  #     end

  #   {:noreply, socket}
  # end

  def card_class(card) do
    Robosseum.Server.Card.to_string(card)
  end

end
