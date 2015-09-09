defmodule XmlNode do
  require Record
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")

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

  def all(node, path) do
    for child_element <- xpath(node, path) do
      child_element
    end
  end

  def first(node, path), do: node |> xpath(path) |> take_one
  defp take_one([head | _]), do: head
  defp take_one(_), do: nil

  def text_for_node(node, path), do: first(node, path) |> text

  def node_name(nil), do: nil
  def node_name(node), do: elem(node, 1)

  def attr(node, name), do: node |> xpath('./@#{name}') |> extract_attr
  defp extract_attr([xmlAttribute(value: value)]), do: List.to_string(value)
  defp extract_attr(_), do: nil

  def text(node), do: node |> xpath('./text()') |> extract_text
  defp extract_text([xmlText(value: value)]), do: List.to_string(value)
  defp extract_text(_x), do: nil

  defp xpath(nil, _), do: []
  defp xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node)
  end
end
