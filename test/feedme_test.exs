defmodule FeedmeTest do
  use ExUnit.Case, async: false

  import Mock

  setup do
    wrong = XmlNode.from_file("test/fixtures/wrong.xml")
    {:ok, rss2} = File.read("test/fixtures/rss2/bigsample.xml")

    {:ok, [rss2: rss2]}
  end

  test "parse", %{rss2: rss2} do
    doc = XmlNode.from_string(rss2)

    with_mock HTTPoison, [get: fn(_) -> {:ok, %HTTPoison.Response{status_code: 200, body: rss2}} end] do
      with_mock Feedme.Parsers.RSS2, [valid?: fn(_) -> true end, parse: fn(_) -> :ok end] do
        {:ok, feed} = Feedme.parse("http://blog.drewolson.org/rss/")
        assert called Feedme.Parsers.RSS2.valid?(doc)
        assert called Feedme.Parsers.RSS2.parse(doc)
      end
    end
  end

  test "parse_string", %{rss2: rss2} do
    doc = XmlNode.from_string(rss2)

    with_mock Feedme.Parsers.RSS2, [valid?: fn(_) -> true end, parse: fn(_) -> :ok end] do
      {:ok, feed} = Feedme.parse_string(rss2)
      assert called Feedme.Parsers.RSS2.valid?(doc)
      assert called Feedme.Parsers.RSS2.parse(doc)
    end
  end
end
