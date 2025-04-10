defmodule IotHubWeb.Router do
  use IotHubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {IotHubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", IotHubWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/hubs", HubLive.Index, :index
      live "/hubs/new", HubLive.Index, :new
      live "/hubs/:id/edit", HubLive.Index, :edit
      live "/hubs/:id", HubLive.Show, :show
      live "/hubs/:id/show/edit", HubLive.Show, :edit

      live "/tags", TagLive.Index, :index
      live "/tags/new", TagLive.Index, :new
      live "/tags/:id/edit", TagLive.Index, :edit
      live "/tags/:id", TagLive.Show, :show
      live "/tags/:id/show/edit", TagLive.Show, :edit

      live "/device_models", DeviceModelLive.Index, :index
      live "/device_models/new", DeviceModelLive.Index, :new
      live "/device_models/:id/edit", DeviceModelLive.Index, :edit
      live "/device_models/:id", DeviceModelLive.Show, :show
      live "/device_models/:id/show/edit", DeviceModelLive.Show, :edit

      live "/firmwares", FirmwareLive.Index, :index
      live "/firmwares/new", FirmwareLive.Index, :new
      live "/firmwares/:id/edit", FirmwareLive.Index, :edit
      live "/firmwares/:id", FirmwareLive.Show, :show
      live "/firmwares/:id/show/edit", FirmwareLive.Show, :edit

      live "/devices", DeviceLive.Index, :index
      live "/devices/new", DeviceLive.Index, :new
      live "/devices/:id/edit", DeviceLive.Index, :edit
      live "/devices/:id", DeviceLive.Show, :show
      live "/devices/:id/show/edit", DeviceLive.Show, :edit

  end

  # Other scopes may use custom stacks.
  # scope "/api", IotHubWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:iot_hub, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: IotHubWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
