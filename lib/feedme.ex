defmodule Feedme do
  alias Feedme.Parsers.RSS2

  defmodule MetaData do
    defstruct title: "", link: "", description: ""
  end

  defmodule Entry do
    defstruct title: "", link: "", description: ""
  end

  defmodule Feed do
    defstruct meta: %MetaData{}, entries: []
  end

  def parse(feed_url) do
    fetch_document(feed_url)
    |> detect_parser
    |> parse_document
  end

  def parse_string(xml) do
    {:ok, XmlNode.from_string(xml)}
    |> detect_parser
    |> parse_document
  end

  defp parse_document({:ok, parser, document}) do
    {:ok, parser.parse(document)}
  end

  defp parse_document(other), do: other

  defp detect_parser({:ok, document}) do
    cond do
      RSS2.valid?(document) -> {:ok, RSS2, document}
      true -> {:error, "Feed format not valid"}
    end
  end

  defp detect_parser(other), do: other

  defp fetch_document(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> {:ok, XmlNode.from_string(body)}
      {_, other} -> {:error, other}
    end
  end
end
