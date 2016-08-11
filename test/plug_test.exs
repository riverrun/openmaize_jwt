defmodule OpenmaizeJWT.PlugTest do
  use ExUnit.Case
  use Plug.Test

  import OpenmaizeJWT.{Plug, Verify}

  def get_token(conn) do
    %{access_token: token} = conn.resp_body |> Poison.decode!(keys: :atoms)
    token
  end

  test "add token" do
    user = %{id: 1, username: "Raymond Luxury Yacht", role: "user"}
    conn = conn(:get, "/") |> add_token(user, :username)
    assert conn.status == 200
    {:ok, token} = get_token(conn) |> verify_token
    %{id: id, username: username, role: role, exp: _, nbf: _} = token
    assert id == 1
    assert username == "Raymond Luxury Yacht"
    assert role == "user"
  end

  test "token with custom unique_id" do
    user = %{id: 2, email: "ray@mail.com", role: "user"}
    conn = conn(:get, "/") |> add_token(user, :email)
    assert conn.status == 200
    {:ok, token} = get_token(conn) |> verify_token
    %{id: id, email: email, role: role, exp: _, nbf: _} = token
    assert id == 2
    assert email == "ray@mail.com"
    assert role == "user"
  end

  test "token with additional data" do
    Application.put_env(:openmaize_jwt, :token_data, %{iss: "www.example.com"})
    user = %{id: 1, username: "Raymond Luxury Yacht", role: "user"}
    conn = conn(:get, "/") |> add_token(user, :username)
    Application.delete_env(:openmaize_jwt, :token_data)
    {:ok, %{iss: iss}} = get_token(conn) |> verify_token
    assert iss == "www.example.com"
  end

  test "token without role" do
    user = %{id: 1, username: "Raymond Luxury Yacht"}
    conn = conn(:get, "/") |> add_token(user, :username)
    assert conn.status == 200
    {:ok, %{id: id}} = get_token(conn) |> verify_token
    assert id == 1
  end

end
