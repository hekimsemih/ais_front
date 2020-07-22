defmodule AisFrontWeb.Struct.Panels do
  alias AisFrontWeb.Struct.Panel
  defstruct [search: %Panel{}, shipinfos: %Panel{}, attributions: %Panel{}]

  defimpl Enumerable do
    def count(_panels), do: {:ok, 3}
    def member?(_, _), do: {:error, __MODULE__}
    def slice(_), do: {:error, __MODULE__}

    def reduce(panels, {:cont, acc}, fun), do: reduce_list(Map.to_list(panels), {:cont, acc}, fun)

    defp reduce_list(_, {:halt, acc}, _fun), do: {:halted, acc}
    defp reduce_list(list, {:suspend, acc}, fun), do: {:suspended, acc, &reduce_list(list, &1, fun)}
    defp reduce_list([], {:cont, acc}, _fun), do: {:done, acc}
    defp reduce_list([{:__struct__, _value}|t], {:cont, acc}, fun), do: reduce_list(t, {:cont, acc}, fun)
    defp reduce_list([h|t], {:cont, acc}, fun), do: reduce_list(t, fun.(h, acc), fun)
  end
end

