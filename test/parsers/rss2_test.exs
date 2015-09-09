defmodule FeedmeParsersRss2Test do
  use ExUnit.Case
  
  alias Feedme.Parsers.RSS2

  setup do
    sample1 = XmlNode.from_file("test/fixtures/rss2/sample1.xml")
    sample2 = XmlNode.from_file("test/fixtures/rss2/sample2.xml")

    {:ok, [sample1: sample1, sample2: sample2]}
  end

  test "valid?", %{sample1: sample1, sample2: sample2} do
    wrong_doc = XmlNode.from_file("test/fixtures/wrong.xml")

    assert RSS2.valid?(sample1) == true
    assert RSS2.valid?(sample2) == true
    assert RSS2.valid?(wrong_doc) == false
  end

  test "parse_meta", %{sample1: sample1, sample2: sample2} do
    meta = RSS2.parse_meta(sample1)

    assert meta.title == "W3Schools Home Page"
    assert meta.link == "http://www.w3schools.com"
    assert meta.description == "Free web building tutorials"

    meta = RSS2.parse_meta(sample2)

    assert meta.title == nil
    assert meta.link == "http://www.w3schools.com"
    assert meta.description == nil
  end

  test "parse_entries", %{sample1: sample1, sample2: sample2} do
    [item1, item2] = RSS2.parse_entries(sample1)
    
    assert item1.title == "RSS Tutorial"
    assert item1.link == "http://www.w3schools.com/webservices"
    assert item1.description == "New RSS tutorial on W3Schools"

    assert item2.title == "XML Tutorial"
    assert item2.link == "http://www.w3schools.com/xml"
    assert item2.description == "New XML tutorial on W3Schools"

    [item1, item2] = RSS2.parse_entries(sample2)
    
    assert item1.title == nil
    assert item1.link == "http://www.w3schools.com/webservices"
    assert item1.description == nil

    assert item2.title == nil
    assert item2.link == "http://www.w3schools.com/xml"
    assert item2.description == nil
  end

  test "parse", %{sample1: sample1} do
    feed = RSS2.parse(sample1)

    assert feed == %Feedme.Parsers.RSS2.Feed{
      entries: [
        %Feedme.Parsers.RSS2.FeedEntry{
          description: "New RSS tutorial on W3Schools",
          link: "http://www.w3schools.com/webservices", 
          title: "RSS Tutorial"},
        %Feedme.Parsers.RSS2.FeedEntry{
          description: "New XML tutorial on W3Schools",
          link: "http://www.w3schools.com/xml", 
          title: "XML Tutorial"}],
      meta: %Feedme.Parsers.RSS2.FeedMeta{
        description: "Free web building tutorials",
        link: "http://www.w3schools.com", 
        title: "W3Schools Home Page"}}
  end
end
