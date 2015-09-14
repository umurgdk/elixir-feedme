defmodule Feedme.Parsers.Atom do
  import Feedme.Parsers.Helpers

  alias Feedme.Feed
  alias Feedme.Entry
  alias Feedme.MetaData

  @date_format "{ISOz}"

  def valid?(document) do
    document
    |> XmlNode.first("/feed")
    |> XmlNode.namespace() == "http://www.w3.org/2005/Atom"
  end

  def parse(document) do
    %Feed{meta: parse_meta(document), entries: parse_entries(document)}
  end

  def parse_meta(document) do
    feed = XmlNode.first(document, "/feed")

    %MetaData{
      title: feed |> XmlNode.first("title") |> XmlNode.text,
      link: feed |> XmlNode.first("link") |> XmlNode.attr("href"),
      last_build_date: feed |> XmlNode.first("updated") |> parse_datetime(@date_format),
      author: feed |> XmlNode.first("author/name") |> XmlNode.text
    }
  end

  def parse_entries(document) do
    XmlNode.children_map(document, "entry", &parse_entry/1)
  end

  def parse_entry(node) do
    %Entry{
      title: node |> XmlNode.first("title") |> XmlNode.text,
      link: node |> XmlNode.first("link") |> XmlNode.attr("href"),
      publication_date: node |> XmlNode.first("updated") |> parse_datetime(@date_format),
      description: node |> XmlNode.first("summary") |> XmlNode.text
    }
  end
end
