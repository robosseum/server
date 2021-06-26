defmodule Robosseum.Server.API do
  alias Robosseum.Server.Impl

  def start_link(table_id) do
    GenServer.start_link(Impl, table_id, name: via_tuple(table_id))
  end

  # state actions
  def state(table_id), do: GenServer.call(via_tuple(table_id), {:state})

  def start(table_id), do: GenServer.call(via_tuple(table_id), {:start})

  def stop(table_id), do: GenServer.call(via_tuple(table_id), {:stop})

  def restart(table_id), do: GenServer.call(via_tuple(table_id), {:restart})

  # player actions
  def bid(table_id, player_id, amount) do
    GenServer.call(via_tuple(table_id), {:bid, player_id, amount})
  end

  def fold(table_id, player_id), do: GenServer.call(via_tuple(table_id), {:fold, player_id})

  # internal
  def via_tuple(table_id), do: {:via, Registry, {Registry.Tables, table_id}}
end
