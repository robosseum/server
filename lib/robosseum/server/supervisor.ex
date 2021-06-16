defmodule Robosseum.Server.Supervisor do
  @moduledoc """
  Dynamic Supervisor which supervisers tables
  """
  use DynamicSupervisor

  alias Robosseum.Server.{Table, API}

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    result = DynamicSupervisor.init(strategy: :one_for_one)

    Task.start(fn -> Table.restore_all() end)

    result
  end

  # API

  def start_child(table_id) do
    IO.inspect table_id, label: "START_CHILD"
    child_spec = %{
      id: API,
      start: {API, :start_link, [table_id]}
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def terminate_child(table_id) do
    pid = GenServer.whereis(API.via_tuple(table_id))
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end
