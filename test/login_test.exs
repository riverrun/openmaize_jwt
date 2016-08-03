defmodule OpenmaizeJWT.LoginTest do
  use ExUnit.Case
  use Plug.Test

  import OpenmaizeJWT.{Plug, TestConn}

  def call(name, password) do
    conn(:post, "/login",
         %{"user" => %{"username" => name, "password" => password}})
    |> sign_conn
    |> login_check(name, password)
    |> handle_login(%{})
  end

  def login_check(conn, "ray", "h4rd2gU3$$") do
    put_private(conn, :openmaize_user, %{username: "ray"})
  end
  def login_check(conn, "ray", "wrongpass") do
    put_private(conn, :openmaize_error, "Invalid credentials")
  end

  def handle_login(%Plug.Conn{private: %{openmaize_error: message}} = conn, _params) do
    send_resp conn, 200, message
  end
  def handle_login(%Plug.Conn{private: %{openmaize_user: user}} = conn, _params) do
    add_token(conn, user, :username) |> send_resp
  end

  test "login valid user" do
    conn = call("ray", "h4rd2gU3$$")
    body = conn.resp_body
    assert body =~ "access_token"
  end

  test "login fails for invalid password" do
    conn = call("ray", "wrongpass")
    body = conn.resp_body
    assert body =~ "Invalid credentials"
  end

end
