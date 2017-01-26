defmodule Feedme.XmlNode do
  require Record
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlNamespace, Record.extract(:xmlNamespace, from_lib: "xmerl/include/xmerl.hrl")

  def from_file(file_path, options \\ [quiet: true]) do
    {doc, []} = :xmerl_scan.file(file_path, options)
    doc
  end

  def from_string(xml_string, options \\ [quiet: true]) do
    {doc, []} =
      xml_string
      |> :binary.bin_to_list
      |> :xmerl_scan.string(options)

    doc
  end

  def namespace(xmlElement(namespace: xmlNamespace(default: namespace))) do
    Atom.to_string namespace
  end
  def namespace(_), do: nil

  def all(node, path) do
    for child_element <- xpath(node, path) do
      child_element
    end
  end

  def all_try(_, []), do: []
  def all_try(node, [path | rest]) do
    case all(node, path) do
      [] -> all_try(node, rest)
      children -> children
    end
  end

  def first(node, path), do: node |> xpath(path) |> take_one
  defp take_one([head | _]), do: head
  defp take_one(_), do: nil

  def first_try(_, []), do: nil
  def first_try(node, [path | rest]) do
    first(node, path) || first_try(node, rest)
  end

  def text_for_node(node, path), do: first(node, path) |> text

  def text_for_node_try(_, []), do: nil
  def text_for_node_try(node, [first | rest]), do: text_for_node(node, first) || text_for_node_try(node, rest)

  def node_name(nil), do: nil
  def node_name(node), do: elem(node, 1)

  def attr(node, name), do: node |> xpath('./@#{name}') |> extract_attr
  defp extract_attr([xmlAttribute(value: value)]), do: List.to_string(value)
  defp extract_attr(_), do: nil

  def text(node), do: node |> xpath('./text()') |> extract_text
  defp extract_text(fragments) when is_list(fragments) do
    strings = Enum.map(fragments, fn(fragment) ->
                xmlText(value: v) = fragment
                List.to_string(v)
              end)
    case Enum.join(strings, "") do
      "" -> nil
      x -> x
    end
  end
  defp extract_text(_x), do: nil


  def children_map(node, paths, callback) when is_list(paths) do
    all_try(node, paths) |> Enum.map(callback)
  end

  def children_map(node, selector, callback) when is_binary(selector) do
    all(node, selector) |> Enum.map(callback)
  end

  def integer(node) do
    node |> text |> String.to_integer
  end

  defp xpath(nil, _), do: []
  defp xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node)
  end
end
