defmodule FeedmeParsersRss2Test do
  use ExUnit.Case
  
  alias Feedme.Parsers.RSS2

  setup do
    {:ok, xml} = File.read "test/fixtures/rss2/sample1.xml"
    [doc] = Quinn.parse(xml)

    {:ok, [doc: doc]}
  end

  test "valid?", %{doc: doc} do
    {:ok, wrong_xml} = File.read "test/fixtures/rss2/wrong.xml"
    [wrong_doc] = Quinn.parse(wrong_xml)

    assert RSS2.valid?(doc) == true
    assert RSS2.valid?(wrong_doc) == false
  end
end
