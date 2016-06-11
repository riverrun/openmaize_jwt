defmodule OpenmaizeJWT.LogoutManager do
  use GenServer

  import OpenmaizeJWT.{Tools, Verify}

  @sixty_mins 10_000
  #@sixty_mins 3_600_000

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Process.send_after(self, :clean, @sixty_mins)
    {:ok, %{jwtstore: Map.new}}
  end

  def get_state(), do: GenServer.call(__MODULE__, :get_state)

  def query_jwt(jwt), do: GenServer.call(__MODULE__, {:query, jwt})

  def store_jwt(jwt), do: GenServer.cast(__MODULE__, {:push, jwt, exp_value(jwt)})

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
  def handle_call({:query, jwt}, _from, %{jwtstore: store} = state) do
    {:reply, Map.has_key?(store, jwt), state}
  end

  def handle_cast({:push, jwt, time}, %{jwtstore: store}) do
    {:noreply, %{jwtstore: Map.put(store, jwt, time)}}
  end

  def handle_info(:clean, %{jwtstore: store}) do
    store = clean_store(store)
    Process.send_after(self, :clean, @sixty_mins)
    {:noreply, %{jwtstore: store}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  defp clean_store(store) do
    time = current_time
    :maps.filter fn _, y -> y > time end, store
  end
end
