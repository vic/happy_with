defmodule HappyWith do

  @doc ~S"""
  Rewrites the given block and else clauses into Elixir's standard `with` form.

      iex> import HappyWith
      iex> happy_with do
      ...>   {:ok, name} <- {:ok, "joSE"}
      ...>   lower = String.downcase(name)
      ...>   lower
      ...> end
      "jose"

  You can also provide else clauses to the `with` form.

      iex> import HappyWith
      iex> happy_with do
      ...>   {:ok, name} <- {:error, :nobody}
      ...>   _never_reached = String.downcase(name)
      ...> else
      ...>   {:error, _} -> "luis"
      ...> end
      "luis"

  You can also use tags a feature from the [happy](http://github.com/vic/happy) project.

      iex> import HappyWith
      iex> happy_with do
      ...>   @something {:ok, name} when is_binary(name) and length(name) > 3 <- {:error, :nobody}
      ...>   _never_reached = String.downcase(name)
      ...> else
      ...>   {:something, {:error, _}} -> "could not fetch name"
      ...> end
      "could not fetch name"

  """
  defmacro happy_with([do: {:__block__, _, body}, else: elses]), do: rewrite(body, elses)
  defmacro happy_with([do: {:__block__, _, body}]), do: rewrite(body, nil)

  defp rewrite(body, elses) when length(body) > 1 do
    exprs = Enum.slice(body, 0..-2//1) |> rewrite_tags
    do_last = [do: Enum.at(body, -1)]
    else_clauses = elses && [else: elses] || []
    {:with, [], exprs ++ [do_last ++ else_clauses]}
  end

  defp rewrite(body, _elses), do: body

  defp rewrite_tags(exprs) do
    exprs |> Enum.map(fn
      {:@, _, [{name, _, [{:<-, _, [{:when, _, [pattern, guard]}, expr]}]}]} when is_atom(name) ->
        {:<-, [], [{:when, [], [{name, pattern}, guard]}, {name, expr}]}
      {:@, _, [{name, _, [{:<-, _, [pattern, expr]}]}]} when is_atom(name) ->
        {:<-, [], [{name, pattern}, {name, expr}]}
      expr -> expr
    end)
  end

end
