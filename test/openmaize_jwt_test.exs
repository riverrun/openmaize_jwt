defmodule OpenmaizeJWTTest do
  use ExUnit.Case

  import OpenmaizeJWT.{Create, Verify}
  alias OpenmaizeJWT.LogoutManager

  setup_all do
    {:ok, ok_jwt} = %{id: 1, name: "Raymond Luxury Yacht", role: "user"}
    |> generate_token({0, 120})

    {:ok, error_jwt} = %{id: 1, name: "Raymond Luxury Yacht"}
    |> generate_token({0, 120})

    {:ok, add_to_store} = %{id: 2, name: "Gladys Stoate", role: "user"}
    |> generate_token({0, 120})
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

  test "get expiration time" do
    token = "1MTIifQ.eyJyb2xlIjoidXNlciIsIm5iZiI6MTQ2NTY1NDM0OTU0NywibmFtZSI6" <>
    "IlJheW1vbmQgTHV4dXJ5IFlhY2h0IiwiaWQiOjEsImV4cCI6MTQ2NjA4NjM0OTU0N30.L4L4F0A"
    exp = exp_value(token)
    assert exp == 1466086349547
  end

end
