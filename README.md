# HappyWith

<a href="https://travis-ci.org/vic/happy_with"><img src="https://travis-ci.org/vic/happy_with.svg"></a>

Tiny syntax sugar around Elixir's `with` special form.

#### Why ?

Because I'm happy on how Elixir's `with` special form works, 
and can get used to the `<-` arrow but I still dont like to
place commas between all the with expressions. 

Back then before elixir 1.2 release, I implemented [happy](http://github.com/vic/happy) using case
expressions, it leaked variables as normal case expressions would do, and _overriding_ the standard
`=` operator turned out to have some [unexpected](https://github.com/vic/happy/issues/7) [issues](https://github.com/vic/happy/issues/8). Also, after using standard `with` a bit, I
really got to like it, except for the fact of having to place commas after expressions, so I wrote
`happy_with` which is a [*very* tiny macro](https://github.com/vic/happy_with/blob/master/lib/happy_with.ex#L42) that just rewrites to Elixir's standard `with` special form.

This package implements the *tags* feature originally found in `happy_path`.

For more examples see [docs](https://hexdocs.pm/happy_with/HappyWith.html#happy_with/1)

## Installation

[Available in Hex](https://hex.pm/packages/happy_with), the package can be installed as:

  1. Add happy_with to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:happy_with, "~> 1.0.0"}]
end
```
        
## Usage

```elixir
import HappyWith
```

#### `happy_with` macro

```elixir
happy_with do
  {:ok, friend} <- retrieve_friend
  name = String.downcase(friend)
  name
else
  _ -> "nobody"
end
```

rewrites into standard `with` form.
Only the last expression in the happy_with block is given to with's do.

```elixir
with({:ok, friend} <- retrieve_friend,
     name = String.downcase(friend))
do
  name
else
  _ -> "nobody"
end
```

IMHO the first one reads better.


## Examples

Rewrites the given block and else clauses into Elixir's standard `with` form.

```elixir
iex> import HappyWith
iex> happy_with do
...>   {:ok, name} <- {:ok, "joSE"}
...>   lower = String.downcase(name)
...>   lower
...> end
"jose"
```

You can also provide else clauses to the `with` form.

```elixir
iex> import HappyWith
iex> happy_with do
...>   {:ok, name} <- {:error, :nobody}
...>   _never_reached = String.downcase(name)
...> else
...>   {:error, _} -> "luis"
...> end
"luis"
```

You can also use tags a feature from the [happy](http://github.com/vic/happy) project.

```elixir
iex> import HappyWith
iex> happy_with do
...>   @something {:ok, name} when is_binary(name) and length(name) > 3 <- {:error, :nobody}
...>   _never_reached = String.downcase(name)
...> else
...>   {:something, {:error, _}} -> "could not fetch name"
...> end
"could not fetch name"
```
