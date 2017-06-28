defmodule Stack.Server do
  use GenServer

  def start_link(stash_pid) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop() do
    GenServer.call __MODULE__, :pop
  end

  def push(value) do
    GenServer.cast __MODULE__, {:push, value}
  end

  def init(stash_pid) do
    current_stack = Stack.Stash.get_value stash_pid
    {:ok, {current_stack, stash_pid}}
  end

  def handle_call(:pop, _from, {[head | stack], stash_pid}) do
    {:reply, head, {stack, stash_pid}}
  end

  def handle_cast({:push, value}, {stack, stash_pid}) do
    {:noreply, {[value | stack], stash_pid}}
  end

  def terminate(_reason, {stack, stash_pid}) do
    IO.puts "terminate"
    Stack.Stash.save_value stash_pid, stack
  end
end