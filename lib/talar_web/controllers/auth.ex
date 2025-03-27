defmodule Talar.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn

      user = user_id && repo.get(Talar.Accounts.User, user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> delete_resp_cookie("save_me_token")
    |> configure_session(drop: true)
    |> assign(:user_id, nil)
  end

  # def remember(conn, user) do
  #   token = Talar.Token.gen_remember_token(user)
  #   put_resp_cookie(conn, "save_me_token", token, max_age: @cookie_max_age)
  # end

  def get_session(conn) do
    if session = get_session(conn, :user_id) do
      user = Talar.Accounts.get_user(session)
      user.name
    else
      ""
    end
  end

  # def get_cookie(conn) do
  #   conn = fetch_cookies(conn, signed: ~w(save_me_token))
  #   if cookie = conn.cookies["save_me_token"] do
  #     user = Talar.Accounts.get_user(cookie)
  #     user.name
  #   else
  #     ""
  #   end
  # end

  def login_by_email_and_password(conn, email, given_pass) do
    # repo = Keyword.fetch!(opts, :repo)
    email = String.downcase(email)
    user = Talar.Repo.get_by(Talar.Accounts.User, email: email)

    cond do
      user && Argon2.verify_pass(given_pass, user.password_hash) ->
        conn =
          if String.to_atom(conn.params["user"]["save"]) do
            conn
            |> put_resp_cookie("save_me_token", user.id, sign: true, max_age: 60 * 60 * 24 * 30)
            |> fetch_cookies(encrypted: ~w(save_me_token))
          else
            delete_resp_cookie(conn, "save_me_token")
          end

        {:ok, login(conn, user)}

      user ->
        {:error, :unauthorized, conn}

      true ->
        Argon2.no_user_verify()
        {:error, :not_found, conn}
    end
  end
end
