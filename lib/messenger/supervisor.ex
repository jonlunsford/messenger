defmodule Messenger.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(:gen_smtp_server, [Messenger.Server, Application.get_env(:messenger, :smtp_opts)])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
