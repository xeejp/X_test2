defmodule Test2 do
  use Xee.ThemeScript

  def script_type do
    :message
  end

  def init do
    {:ok, %{"data" => %{"host" => [], "participant" => %{}}}}
  end

  def join(%{"host" => host, "participant" => participant} = state, id) do
    unless Map.has_key?(participant, id) do
      state = %{state | "participant" => Map.put(participant, id, [])}
    end
    {:ok, %{data: state}}
  end

  def handle_received(data, %{"action" => "redirect", "id" => id, "xid" => xid}) do
    {:ok, %{"data" => data, redirect: %{ id => xid }}}
  end

  def handle_received(%{"host" => host, "participant" => _participant} = state, received) do
    data = %{state | "host" => List.insert_at(host, -1, received)}
    {:ok, %{"data" => data, host: data["host"]}}
  end

  def handle_received(%{"host" => _host, "participant" => participant} = state, received, id) do
    data = %{state | "participant" => %{participant | id => List.insert_at(Map.get(participant, id, []), -1, received)}}
    {:ok, %{"data" => data, participant: %{id => data["participant"][id]}}}
  end
end
