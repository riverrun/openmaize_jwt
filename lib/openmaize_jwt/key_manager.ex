defmodule OpenmaizeJWT.KeyManager do
  use GenServer

  alias OpenmaizeJWT.Config

  @oneday 86_400_000
  @kids Enum.map 100..105, &to_string/1

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Process.send_after(self(), :rotate, Config.keyrotate_days * @oneday)
    {:ok, init_keys()}
  end

  def get_state(), do: GenServer.call(__MODULE__, :get_state)

  def get_key(kid), do: GenServer.call(__MODULE__, {:get_key, kid})

  def get_current_kid do
    GenServer.call(__MODULE__, :get_current_kid)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
  def handle_call({:get_key, kid}, _from, state) do
    {:reply, Map.get(state, kid), state}
  end
  def handle_call(:get_current_kid, _from, %{"current_kid" => kid} = state) do
    {:reply, kid, state}
  end

  def handle_info(:rotate, state) do
    newstate = update_state(state)
    Process.send_after(self(), :rotate, Config.keyrotate_days * @oneday)
    {:noreply, newstate}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  defp update_state(%{"kid_index" => idx} = state) do
    index = if idx < 5, do: idx + 1, else: 0
    kid = Enum.at @kids, index
    %{state | kid => gen_key(), "current_kid" => kid, "kid_index" => index}
  end

  defp gen_key do
    :crypto.strong_rand_bytes(32) |> Base.encode64
  end

  defp init_keys do
    key_map = for kid <- @kids, into: %{}, do: {kid, nil}
    %{key_map | "100" => gen_key()}
    |> Map.merge(%{"current_kid" => "100", "kid_index" => 0})
  end
end
