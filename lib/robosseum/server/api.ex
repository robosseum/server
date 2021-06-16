defmodule Robosseum.Server.API do
  alias Robosseum.Server.Impl

  def start_link(table_id) do
    GenServer.start_link(Impl, table_id, name: via_tuple(table_id))
  end

  def state(table_id), do: GenServer.call(via_tuple(table_id), {:state})

  def start(table_id), do: GenServer.call(via_tuple(table_id), {:start})

  def stop(table_id), do: GenServer.call(via_tuple(table_id), {:stop})

  def restart(table_id), do: GenServer.call(via_tuple(table_id), {:restart})

  def via_tuple(table_id), do: {:via, Registry, {Registry.Tables, table_id}}
end
