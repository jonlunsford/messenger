defmodule Messenger do
  use Application

  def start(_type, _args) do
    Messenger.Supervisor.start_link(name: Messenger.Supervisor)
  end
end
