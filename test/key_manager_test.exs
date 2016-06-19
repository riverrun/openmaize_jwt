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

  test "get state from file" do
    dest = Path.join(Application.app_dir(:openmaize_jwt, "priv"), "key_state.json")
    Application.stop :openmaize_jwt
    :ok = File.rm dest
    {:ok, _} = File.copy Path.join([__DIR__, "support", "key_state.json"]), dest
    Application.start :openmaize_jwt
    key = "HFFRR7/Llzjf6fRIagRirI4s4NfwV8yw9/W46OYgso4="
    assert KM.get_key("100") == key
    assert KM.get_key("101") == nil
  end

end
