defmodule OpenmaizeJWTPlugTest do
  use ExUnit.Case
  use Plug.Test

  import OpenmaizeJWT.Plug
  import OpenmaizeJWT.Verify

  test "token not stored in cookie" do
    user = %{id: 1, username: "Raymond Luxury Yacht", role: "user"}
    conn = conn(:get, "/") |> add_token(user, nil, :username)
    assert String.starts_with?(conn.resp_body, "{\"access_token\":")
    assert conn.status == 200
    assert conn.private.openmaize_user.id == 1
    assert conn.private.openmaize_user.role == "user"
  end

  test "token with custom unique_id" do
    user = %{id: 2, email: "ray@mail.com", role: "user"}
    conn = conn(:get, "/") |> add_token(user, :cookie, :email)
    token = conn.resp_cookies["access_token"].value
    {:ok, data} = verify_token(token)
    assert data.email
    assert conn.private.openmaize_user.id == 2
    assert conn.private.openmaize_user.role == "user"
    {:ok, user} = verify_token(token)
    assert user.email == "ray@mail.com"
  end

  test "token with additional data" do
    Application.put_env(:openmaize_jwt, :token_data, [:iss])
    user = %{id: 1, username: "Raymond Luxury Yacht", role: "user", iss: "example.com"}
    conn = conn(:get, "/") |> add_token(user, nil, :username)
    Application.delete_env(:openmaize_jwt, :token_data)
    assert conn.private.openmaize_user.id == 1
    assert conn.private.openmaize_user.role == "user"
    assert conn.private.openmaize_user.iss == "example.com"
  end

  test "override token_validity config value" do
    user = %{id: 1, username: "Raymond Luxury Yacht", role: "user"}
    conn = conn(:get, "/") |> add_token(user, nil, :username, -10)
    %{"access_token" => token} = Poison.Parser.parse!(conn.resp_body)
    {:error, message} = verify_token(token)
    assert message =~ "token has expired"
  end

end
