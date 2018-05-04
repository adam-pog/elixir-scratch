defmodule Sequence.Server do
  use GenServer
  require Logger

  @vsn "1"

  #####
  # External API

  defmodule State do
    defstruct(current_number: 0, delta: 1)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def next_number do
    number = GenServer.call __MODULE__, :next_number
    "The next number is #{number}"
  end

  def increment_number(delta) do
    GenServer.cast __MODULE__, {:increment_number, delta}
  end

  #####
  # GenServer implementation

  def init(_) do
    # state = %State{ current_number: Sequence.Stash.get()}
    { :ok, Sequence.Stash.get() }
  end

  def handle_call(:next_number, _from, state = %{current_number: n}) do
    { :reply, n, %{state | current_number: n + state.delta} }
  end

  def handle_cast({:increment_number, delta}, state) do
    { :noreply, %{state | delta: delta}}
  end

  def terminate(_reason, state) do
    Sequence.Stash.update(state)
  end

  def code_change("0", old_state = current_number, _extra) do
    new_state = %State{
      current_number: current_number,
      delta: 1
    }
    Logger.info "Changing code from 0 to 1"
    Logger.info inspect(old_state)
    Logger.info inspect(new_state)
    { :ok, new_state }
  end

end
