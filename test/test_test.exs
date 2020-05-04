defmodule TestTest do
  use ExUnit.Case
  doctest Tokenizer

  test "tokenizes a string" do
    tokens = Tokenizer.tokenize("hello = 987")
    IO.inspect tokens
    IO.inspect Parser.parse(tokens)
  end
end
