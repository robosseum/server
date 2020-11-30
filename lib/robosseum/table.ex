defmodule Robosseum.Table do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(stack) do
    Process.send_after(self(), :broadcast, 5000)
    {:ok, stack}
  end

  def handle_info(:broadcast, state) do
    IO.inspect "hanlde_info in Table"
    RobosseumWeb.TableLive.broadcast({:game_created, "hola"})
    {:noreply, state}
  end
end
