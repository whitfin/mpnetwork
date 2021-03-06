defmodule MpnetworkWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :mpnetwork

  socket("/socket", MpnetworkWeb.UserSocket)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :mpnetwork,
    gzip: true,
    only: ~w(css fonts images js favicon.ico robots.txt),
    headers: [{"access-control-allow-origin", "*"}]
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    length: Application.get_env(:mpnetwork, :max_attachment_size),
    read_length: Application.get_env(:mpnetwork, :attachment_chunk_size),
    read_timeout: Application.get_env(:mpnetwork, :attachment_chunk_timeout)
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(
    Plug.Session,
    store: :cookie,
    key: "_mpnetwork_key",
    signing_salt: "EDekwQ8K"
  )

  # Add Timber plugs for capturing HTTP context and events
  plug(Timber.Integrations.ContextPlug)
  plug(Timber.Integrations.EventPlug)

  # Add PryIn plug for metrics monitoring. NOTE: Must remain just before Router plug
  plug(PryIn.Plug)

  plug(MpnetworkWeb.Router)

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
