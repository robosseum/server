defmodule RobosseumWeb.TableLive.Index do
  use RobosseumWeb, :live_view

  alias RobosseumWeb.TableLive

  def mount(_params, _session, socket) do
    socket = assign(
      socket,
      tables: TableLive.list_tables()
    )
    {:ok, socket}
  end
end
