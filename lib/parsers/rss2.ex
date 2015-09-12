defmodule Feedme.Parsers.RSS2 do
  alias Feedme.Feed
  alias Feedme.Entry
  alias Feedme.MetaData

  def valid?(document) do
    document
    |> XmlNode.first("/rss")
    |> XmlNode.attr("version") == "2.0"
  end

  def parse(document) do
    %Feed{meta: parse_meta(document), entries: parse_entries(document)}
  end

  def parse_meta(document) do
    title = XmlNode.text_for_node(document, "/rss/channel/title")
    link = XmlNode.text_for_node(document, "/rss/channel/link")
    description = XmlNode.text_for_node(document, "/rss/channel/description")

    %MetaData{title: title, link: link, description: description}
  end

  def parse_entries(document) do
    entries = XmlNode.all(document, "/rss/channel/item")

    Enum.map entries, fn(entry) ->
      title = XmlNode.text_for_node(entry, "title")
      link = XmlNode.text_for_node(entry, "link")
      description = XmlNode.text_for_node(entry, "description")

      %Entry{title: title, link: link, description: description}
    end
  end
end
