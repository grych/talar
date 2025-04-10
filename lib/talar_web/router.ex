defmodule TalarWeb.Router do
  use TalarWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TalarWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Talar.Auth, repo: Talar.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TalarWeb do
    pipe_through :browser

    get "/", SessionsController, :new
    resources "/sessions", SessionsController, only: [:new, :create, :delete]
    resources "/users", UserController
    # get "/signup", UserController, :new, as: :signup
    resources "/directories", DirectoryController, only: [:new, :edit, :delete, :update, :create]
    resources "/passwords", PasswordController, only: [:new, :create]
    get "/dir/*dir", DirectoryController, :list_directory
  end

  # Other scopes may use custom stacks.
  # scope "/api", TalarWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:talar, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TalarWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
