defmodule OpenmaizeJWTTest do
  use ExUnit.Case

  import OpenmaizeJWT.{Create, TestConn, Verify}
  alias OpenmaizeJWT.LogoutManager

  setup_all do
    {:ok, ok_jwt} = %{id: 1, name: "Raymond Luxury Yacht", role: "user"}
    |> generate_token({0, 120}, get_secret())

    {:ok, norole_jwt} = %{id: 1, name: "Raymond Luxury Yacht"}
    |> generate_token({0, 120}, get_secret())

    {:ok, error_jwt} = %{name: "Raymond Luxury Yacht"}
    |> generate_token({0, 120}, get_secret())

    {:ok, add_to_store} = %{id: 2, name: "Gladys Stoate", role: "user"}
    |> generate_token({0, 120}, get_secret())
    LogoutManager.store_jwt(add_to_store)

    {:ok, %{ok_jwt: ok_jwt, norole_jwt: norole_jwt,
      error_jwt: error_jwt, add_to_store: add_to_store}}
  end

  test "verify token with correct signature", %{ok_jwt: ok_jwt} do
    {:ok, user} = verify_token(ok_jwt, get_secret())
    assert user.name == "Raymond Luxury Yacht"
    assert user.role == "user"
  end

  test "verify token with invalid signature", %{ok_jwt: ok_jwt} do
    token = ok_jwt <> "a"
    {:error, message} = verify_token(token, get_secret())
    assert message =~ "Invalid"
  end

  test "verify succeeds if jwt has no role", %{norole_jwt: norole_jwt} do
    {:ok, user} = verify_token(norole_jwt, get_secret())
    assert user.name == "Raymond Luxury Yacht"
  end

  test "verify fails if jwt has no id", %{error_jwt: error_jwt} do
    {:error, message} = verify_token(error_jwt, get_secret())
    assert message =~ "Incomplete"
  end

  test "verify fails after jwt has been added to jwt_store", %{add_to_store: add_to_store} do
    {:error, message} = verify_token(add_to_store, get_secret())
    assert message =~ "logged out"
  end

  test "get expiration time" do
    token = "1MTIifQ.eyJyb2xlIjoidXNlciIsIm5iZiI6MTQ2NTY1NDM0OTU0NywibmFtZSI6" <>
    "IlJheW1vbmQgTHV4dXJ5IFlhY2h0IiwiaWQiOjEsImV4cCI6MTQ2NjA4NjM0OTU0N30.L4L4F0A"
    exp = exp_value(token)
    assert exp == 1466086349547
  end

end
