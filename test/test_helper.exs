defmodule OpenmaizeJWT.TestConn do

  def sign_conn(conn, secret \\ get_secret()) do
    put_in(conn.secret_key_base, secret)
  end

  def get_secret do
    String.duplicate("abcdef0123456789", 8)
  end
end

ExUnit.start()

Application.put_env(:openmaize_jwt, :signing_salt, "1234567812345678")
