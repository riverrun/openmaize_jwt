defmodule OpenmaizeJWT.Plug do
  @moduledoc """
  Generate JSON Web Tokens (JWTs) and add them to the connection.

  ## Storage of JSON Web Tokens

  In many cases, the JWTs need to be stored somewhere, either in cookies
  or sessionStorage (or localStorage), so that they can be used in subsequent
  requests. You need to handle storing the JWT yourself.

  If you decide to store the token in sessionStorage, and not in a cookie,
  you will not need to use the `protect_from_forgery` (csrf protection) plug.
  However, storing tokens in sessionStorage opens up the risk of cross-site
  scripting attacks.
  """

  import Plug.Conn
  import OpenmaizeJWT.Create
  alias OpenmaizeJWT.{Config, LogoutManager}

  @doc """
  Generate JWT based on the user information.

  The JWT is then added to the body of the response.
  """
  def add_token(conn, user, uniq) do
    user = Map.take(user, [:id, :role, uniq]) |> Map.merge(Config.token_data)
    {:ok, token} = generate_token user, {0, Config.token_validity}
    resp(conn, 200, ~s({"access_token": "#{token}"}))
  end

  @doc """
  Handle logout.
  """
  def logout_user(%Plug.Conn{req_cookies: %{"access_token" => token}} = conn) do
    LogoutManager.store_jwt(token)
    assign(conn, :current_user, nil)
  end
  def logout_user(%Plug.Conn{req_headers: headers} = conn) do
    case List.keyfind(headers, "authorization", 0) do
      {_, "Bearer " <> token} -> LogoutManager.store_jwt(token)
      nil -> nil
    end
    assign(conn, :current_user, nil)
  end
end
