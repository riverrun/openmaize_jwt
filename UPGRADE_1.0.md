# Upgrading to version 1.0

Add the following to mix.exs and run `mix deps.update openmaize_jwt`:

    {:openmaize_jwt, "~> 1.0.0"}

You can remove the entry for openmaize, which will be installed as
a dependency of openmaize_jwt.

### Config

You need to add a signing key to the config. See the documentation for
`OpenmaizeJWT.Tools.gen_key` for more information.

### OpenmaizeJWT.Authenticate

In the `web/router.ex` file, change the call to Openmaize.Authenticate to:

    plug OpenmaizeJWT.Authenticate

### Openmaize.Login and Openmaize.OnetimePass - storage option removed

These plugs now have fewer options.

The storage option has been removed, which means that you need to
handle the storage yourself - adding the token to a cookie or
web storage.

Openmaize.Login has two options - `db_module` and `unique_id`.

Openmaize.OnetimePass has one option for `db_module`, and it
also has options for the one-time passwords.

### Openmaize.Logout has been removed

The `handle_logout` function in the Authorize module shows an
example of adding the JSON Web Token to the logout manager.

### Change to the database module

In the Openmaize.Database behaviour and the MyApp.OpenmaizeEcto module,
the `find_user_byid` function has been renamed to `find_user_by_id`.

### Changes to the Authorize and Confirm module templates

The following changes have been made to the examples in the Authorize
and Confirm modules and tests:

`handle_login` in the Authorize module

  ```elixir
  def handle_login(%Plug.Conn{private: %{openmaize_error: _message}} = conn, _params) do
    unauthenticated conn
  end
  def handle_login(%Plug.Conn{private: %{openmaize_user: user}} = conn, _params) do
    add_token(conn, user, :username) |> send_resp
  end
  ```

`handle_logout` in the Authorize module

  ```elixir
  def handle_logout(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    logout_user(conn)
    |> render(MyApp.UserView, "info.json", %{info: message})
  end
  ```

`handle_reset` in the Confirm module

  ```elixir
  def handle_reset(%Plug.Conn{private: %{openmaize_error: message}} = conn, _params) do
    render(conn, MyApp.ErrorView, "error.json", %{error: message})
  end
  def handle_reset(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    logout_user(conn)
    |> render(MyApp.UserView, "info.json", %{info: message})
  end
  ```

the following lines at the beginning of the Authorize test

  ```elixir
  {:ok, user_token} = %{id: 3, email: "tony@mail.com", role: "user"}
                      |> generate_token({0, 1440})
  ```

There are several other changes to the Authorize test. For more information,
see the example app at [Openmaize-phoenix](https://github.com/riverrun/openmaize-phoenix).
