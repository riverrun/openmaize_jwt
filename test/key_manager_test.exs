defmodule KeyManagerTest do
  use ExUnit.Case

  alias OpenmaizeJWT.KeyManager, as: KM

  test "initial key state" do
    assert KM.get_key("100")
    refute KM.get_key("101")
    refute KM.get_key("102")
    refute KM.get_key("103")
    refute KM.get_key("104")
    refute KM.get_key("105")
  end

  test "update state and get new key" do
    assert KM.get_current_kid() == "100"
    state = KM.get_state()
    {:noreply, %{"current_kid" => current_kid} = newstate} = KM.handle_info(:rotate, state)
    assert newstate != state
    assert current_kid == "101"
  end

end
