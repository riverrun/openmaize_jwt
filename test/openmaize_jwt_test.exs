defmodule OpenmaizeJWTTest do
  use ExUnit.Case

  import OpenmaizeJWT.{Create, Verify}
  alias OpenmaizeJWT.LogoutManager

  setup_all do
    {:ok, ok_jwt} = %{id: 1, name: "Raymond Luxury Yacht", role: "user"}
    |> generate_token({0, 7200})

    {:ok, error_jwt} = %{id: 1, name: "Raymond Luxury Yacht"}
    |> generate_token({0, 7200})

    {:ok, add_to_store} = %{id: 1, name: "Raymond Luxury Yacht", role: "user"}
    |> generate_token({0, 7200})
    LogoutManager.store_jwt(add_to_store)

    {:ok, %{ok_jwt: ok_jwt, error_jwt: error_jwt, add_to_store: add_to_store}}
  end

  test "verify token with correct signature", %{ok_jwt: ok_jwt} do
    {:ok, user} = verify_token(ok_jwt)
    assert user.name == "Raymond Luxury Yacht"
    assert user.role == "user"
  end

  test "verify token with invalid signature", %{ok_jwt: ok_jwt} do
    token = ok_jwt <> "a"
    {:error, message} = verify_token(token)
    assert message =~ "Invalid"
  end

  test "verify fails if jwt has no role", %{error_jwt: error_jwt} do
    {:error, message} = verify_token(error_jwt)
    assert message =~ "Incomplete"
  end

  test "verify fails after jwt has been added to jwt_store", %{add_to_store: add_to_store} do
    {:error, message} = verify_token(add_to_store)
    assert message =~ "logged out"
  end

end
