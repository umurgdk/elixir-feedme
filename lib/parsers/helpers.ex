defmodule Feedme.Parsers.Helpers do
  alias Feedme.XmlNode

  def parse_datetime(node), do: parse_datetime(node, "{RFC1123}")
  def parse_datetime(nil, _), do: nil
  def parse_datetime(node, format) do
    case XmlNode.text(node) |> Timex.parse(format) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  def parse_into_struct(document, struct), do: parse_into_struct(document, struct, [])
  def parse_into_struct(nil, _, _), do: nil
  def parse_into_struct(document, struct, ignore) do
    # structs are basically maps
    [_ | string_fields] = Map.keys(struct)
                          |> Enum.reject(&Enum.member?(ignore, &1))

    get_text = fn(name) -> XmlNode.text_for_node(document, name) end

    # try to read all string typed fields from xml into struct
    Enum.reduce string_fields, struct, fn(key, struct) ->
      value = get_text.(key) || Map.get struct, key
      Map.put struct, key, value
    end
  end

  def parse_attributes_into_struct(document, struct), do: parse_attributes_into_struct(document, struct, [])
  def parse_attributes_into_struct(nil, _, _), do: nil
  def parse_attributes_into_struct(node, struct, ignore) do
    [_ | string_fields] = Map.keys(struct)
                          |> Enum.reject(&Enum.member?(ignore, &1))

    get_text = fn(name) -> XmlNode.attr(node, name) end

    Enum.reduce string_fields, struct, fn(key, struct) ->
      value = get_text.(key) || Map.get struct, key
      Map.put struct, key, value
    end
  end
end
