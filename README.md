# HappyWith

Tiny syntax sugar around Elixir's `with` special form.

#### Why ?

Because I'm happy on how Elixir's `with` special form works, 
and can get used to the `<-` arrow but I still dont like to
place commas between all the with expressions. 

Back then before elixir 1.2 release, I implemented [happy](http://github.com/vic/happy) using case
expressions, it leaked variables as normal case expressions would do, and _overriding_ the standard
`=` operator turned out to have some unexpected cases. Also, after using standard `with` a bit, I
really got to like it, except for the fact of having to place commas after expressions, so I wrote
`happy_with` which is a *very* tiny macro that just rewrites to Elixir's standard `with` special form.

## Installation

[Available in Hex](https://hex.pm/packages/happy_with), the package can be installed as:

  1. Add happy_with to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:happy_with, "~> 0.0.1"}]
end
```
        
## Usage

```elixir
import HappyWith
```

#### `happy_with` macro

```
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
