defmodule Tokenizer do
  def tokenize(""), do: []
  def tokenize(" " <> rest), do: tokenize(rest)
  def tokenize("\t" <> rest), do: tokenize(rest)
  def tokenize("=" <> rest), do: [{:symbol, "="} | tokenize(rest)]

  def tokenize(str) do
    case Regex.run(~r/\A([A-Za-z_][A-Za-z_\d]*)(.*)\Z/s, str) do
      [_, id, rest] ->
        [{:identifier, id} | tokenize(rest)]

      _ ->
        case Integer.parse(str) do
          {num, rest} -> [{:literal, num} | tokenize(rest)]
          :error -> raise(ArgumentError, "I can't tokenize: #{str}")
        end
    end
  end
end

defmodule Parser do
  def parse(tokens) do
    case List.first(tokens, :identifier, 0) do
      {{:identifier, str}, rest} -> (
        case List.keytake(tokens, :symbol, 0) do
          {{:symbol, "="}, rest} -> cond do
            {{:literal, value}, rest} = List.keytake(tokens, :literal, 0) -> {:variable, {:identifier, str}, {:integer, value}}
          end
        end
      )
    end
  end
end
