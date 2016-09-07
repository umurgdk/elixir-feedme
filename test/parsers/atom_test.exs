defmodule Feedme.Test.Parsers.Atom do
  use ExUnit.Case

  alias Feedme.XmlNode
  alias Feedme.Parsers.Atom

  setup do
    sample1 = XmlNode.from_file("test/fixtures/atom/sample1.xml")

    {:ok, [sample1: sample1]}
  end

  test "valid?", %{sample1: sample1} do
    assert Atom.valid?(sample1) == true
  end

  test "parse", %{sample1: sample1} do
    feed = Atom.parse(sample1)

    assert Enum.count(feed.entries) == 1
    assert feed.meta.author == "John Doe"
  end

  test "parse_meta", %{sample1: sample1} do
    assert Atom.parse_meta(sample1) == %Feedme.MetaData{
      title: "Example Feed",
      last_build_date: %DateTime{
        calendar: Calendar.ISO,
        day: 13,
        hour: 18,
        microsecond: {0, 0},
        minute: 30,
        month: 12,
        second: 2,
        std_offset: 0,
        time_zone: "Etc/UTC",
        utc_offset: 0,
        zone_abbr: "UTC",
        year: 2003
      },
      link: "http://example.org/",
      author: "John Doe"
    }
  end

  test "parse_entry", %{sample1: sample1} do
    entry = XmlNode.first(sample1, "/feed/entry")

    assert Atom.parse_entry(entry) == %Feedme.Entry{
      title: "Atom-Powered Robots Run Amok",
      link: "http://example.org/2003/12/13/atom03",
      publication_date: %DateTime{
        calendar: Calendar.ISO,
        day: 13,
        hour: 18,
        microsecond: {0, 0},
        minute: 30,
        month: 12,
        second: 2,
        std_offset: 0,
        time_zone: "Etc/UTC",
        utc_offset: 0,
        zone_abbr: "UTC",
        year: 2003
      },
      description: "Some text."
    }
  end

  test "parse_entries", %{sample1: sample1} do
    entries = Atom.parse_entries(sample1)

    assert Enum.count(entries) == 1
  end
end
