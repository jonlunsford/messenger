defmodule Messenger.Server do
  require Logger
  @behaviour :gen_smtp_server_session

  def init(hostname, session_count, _address, _options) do
    if session_count > 40 do
      Logger.warn("SMTP server connection limit exceeded")
      {:stop, :normal, ["421", hostname, " is too busy to accept mail right now"]}
    else
      banner = [hostname, " ESMTP"]
      state = %{}
      {:ok, banner, state}
    end
  end

  def handle_DATA(_from, _to, data, state) do
    Logger.info "Received DATA:"
    state
    |> Map.put(:body, data)
    |> IO.inspect

    {:ok, data, state}
  end

  def handle_EHLO(hostname, extensions, state) do
    Logger.info("EHLO from #{hostname}")
    {:ok, extensions, state}
  end

  def handle_HELO(hostname, state) do
    Logger.info("HELO from #{hostname}")
    {:ok, 655360, state}
  end

  def handle_MAIL(from, state) do
    Logger.info("MAIL from #{from}")
    {:ok, Map.put(state, :from, from)}
  end

  def handle_MAIL_extension(extension, state) do
    Logger.info(extension)
    {:ok, state}
  end

  def handle_RCPT(to, state) do
    Logger.info("RCPT to #{to}")
    {:ok, Map.put(state, :to, to)}
  end

  def handle_RCPT_extension(extension, state) do
    Logger.info(extension)
    {:ok, state}
  end

  def handle_RSET(state) do
    {:ok, state}
  end

  def handle_VRFY(address, state) do
    Logger.info(address)
    {:ok, state}
  end

  def handle_other(command, _args, state) do
    Logger.info(command)
    {["500 Error: command not recognized : #{command}"], state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  def terminate(reason, state) do
    Logger.info("Terminating Session: #{reason}")
    {:ok, state}
  end
end
