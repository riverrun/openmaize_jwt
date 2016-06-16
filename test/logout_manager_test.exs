defmodule LogoutManagerTest do
  use ExUnit.Case

  import OpenmaizeJWT.Create
  alias OpenmaizeJWT.LogoutManager, as: LM

  setup_all do
    {:ok, jwt} = %{id: 10, name: "Inspector Dim", role: "user"}
    |> generate_token({0, 120})

    {:ok, %{jwt: jwt}}
  end

  test "query token", %{jwt: jwt} do
    refute LM.query_jwt(jwt)
    LM.store_jwt(jwt)
    assert LM.query_jwt(jwt)
    refute LM.query_jwt(jwt <> "a")
  end

end
