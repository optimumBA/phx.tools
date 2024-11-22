defmodule PhxToolsWeb.Router do
  use PhxToolsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhxToolsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :curl_detector do
    plug PhxToolsWeb.CurlDetector
  end

  pipeline :system_detector do
    plug PhxToolsWeb.SystemDetector
  end

  scope "/", PhxToolsWeb do
    pipe_through [:browser, :curl_detector, :system_detector]

    live_session :default,
      session: {PhxToolsWeb.LiveSessionHelper, :get_system_name, []} do
      live "/", PhxToolsLive.Index, :index
    end
  end

  resources "/health", PhxToolsWeb.HealthController, only: [:index]

  # Enable LiveDashboard in development
  if Application.compile_env(:phx_tools, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhxToolsWeb.Telemetry
    end
  end
end
