defmodule FeedmeTest do
  use ExUnit.Case, async: false

  alias Feedme.XmlNode

  import Mock

  setup do
    {:ok, wrong} = File.read("test/fixtures/wrong.xml")
    {:ok, rss2} = File.read("test/fixtures/rss2/bigsample.xml")
    {:ok, atom} = File.read("test/fixtures/atom/sample1.xml")

    {:ok, [rss2: rss2, atom: atom, wrong: wrong]}
  end

  test "parse", %{rss2: rss2, atom: atom, wrong: wrong} do
    rss2_doc = XmlNode.from_string(rss2)
    with_mock Feedme.Parsers.RSS2, [valid?: fn(_) -> true end, parse: fn(_) -> :ok end] do
      {:ok, feed} = Feedme.parse(rss2)
      assert called Feedme.Parsers.RSS2.valid?(rss2_doc)
      assert called Feedme.Parsers.RSS2.parse(rss2_doc)
    end

    atom_doc = XmlNode.from_string(atom)
    with_mock Feedme.Parsers.Atom, [valid?: fn(_) -> true end, parse: fn(_) -> :ok end] do
      {:ok, feed} = Feedme.parse(atom)
      assert called Feedme.Parsers.Atom.valid?(atom_doc)
      assert called Feedme.Parsers.Atom.parse(atom_doc)
    end

    {:error, "Feed format not valid"} = Feedme.parse(wrong)
  end
end
