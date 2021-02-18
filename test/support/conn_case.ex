defmodule QuizzicalWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use QuizzicalWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import QuizzicalWeb.ConnCase

      alias QuizzicalWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint QuizzicalWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Quizzical.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Quizzical.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = Quizzical.AccountsFixtures.user_fixture()

    user |> Quizzical.Accounts.User.confirm_changeset() |> Quizzical.Repo.update()

    %{conn: log_in_user(conn, user), user: user}
  end

  @spec register_and_log_in_admin(%{:conn => Plug.Conn.t(), optional(any) => any}) :: %{
          conn: Plug.Conn.t(),
          user: %{
            :__struct__ => atom | %{:__changeset__ => any, optional(any) => any},
            :id => any,
            optional(atom) => any
          }
        }
  def register_and_log_in_admin(%{conn: conn}) do
    user = Quizzical.AccountsFixtures.user_fixture(%{is_admin: true})

    user |> Quizzical.Accounts.User.confirm_changeset() |> Quizzical.Repo.update!()

    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = Quizzical.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
