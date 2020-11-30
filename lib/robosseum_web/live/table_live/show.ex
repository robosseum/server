defmodule RobosseumWeb.TableLive.Show do
  use RobosseumWeb, :live_view

  alias RobosseumWeb.TableLive

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: TableLive.subscribe()

    table = TableLive.get_table!(id)
    socket = assign(
      socket,
      table: table,
      dealer: nil,
      active_player: nil,
      games: table.games,
      game: List.first(table.games)
    )
    {:ok, socket}
  end

  def handle_event("broadcast", _params, socket) do
    TableLive.broadcast({:game_created, "helo"})
    {:noreply, socket}
  end

  def handle_info({:game_created, game}, socket) do
    IO.inspect game, label: "game_created"
    {:noreply, socket}
  end
end
