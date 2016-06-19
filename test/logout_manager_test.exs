defmodule LogoutManagerTest do
  use ExUnit.Case

  import OpenmaizeJWT.Create
  alias OpenmaizeJWT.LogoutManager, as: LM

  setup_all do
    {:ok, jwt} = %{id: 10, name: "Inspector Dim", role: "user"}
    |> generate_token({0, 120})

    {:ok, exp_jwt} = %{id: 11, name: "Mr Spare Button", role: "user"}
    |> generate_token({0, -10})

    {:ok, %{jwt: jwt, exp_jwt: exp_jwt}}
  end

  test "query token", %{jwt: jwt} do
    refute LM.query_jwt(jwt)
    LM.store_jwt(jwt)
    assert LM.query_jwt(jwt)
    refute LM.query_jwt(jwt <> "a")
  end

  test "clean jwt store", %{exp_jwt: exp_jwt} do
    LM.store_jwt(exp_jwt)
    assert LM.query_jwt(exp_jwt)
    state = LM.get_state()
    {:noreply, store = newstate} = LM.handle_info(:clean, state)
    assert newstate != state
    refute store[exp_jwt]
  end

  test "get state from file" do
    dest = Path.join(Application.app_dir(:openmaize_jwt, "priv"), "logout_state.json")
    Application.stop :openmaize_jwt
    :ok = File.rm dest
    {:ok, _} = File.copy Path.join([__DIR__, "support", "logout_state.json"]), dest
    Application.start :openmaize_jwt
    jwt = "eyJ0eXAiOiJKV1QiLCJraWQiOiIxMDAiLCJhbGciOiJIUzUxMiJ9." <>
    "eyJ1c2VybmFtZSI6IkNvbHRyYW5lIiwicm9sZSI6ImJlc3QiLCJuYmYiOjE0Nj" <>
    "YzMTY3MTEwOTEsImlkIjoyMSwiZXhwIjoxNDY2MzIzOTExMDkxfQ.UQqgPVUx5BO" <>
    "2zeFeWLsxsM9QPuTWhBsP0jxcvrtoL5x71Rk1hroMyXTHf6GrUMHHrqnalQIoEi91pMKNeRPm_w"
    assert LM.query_jwt(jwt)
    refute LM.query_jwt(jwt <> "a")
  end

end
