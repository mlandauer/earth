class QuoteBadCharactersTest < Test::Unit::TestCase
  def setup
    @quote = QuoteBadCharacters.new
  end
      
  def test_valid_string
    assert_equal "Hello", @quote.quote("Hello")
  end
  
  # This contains a character that is invalid in UTF8
  def test_invalid_character
    assert_equal 'Hello\251 sir!', @quote.quote("Hello\251 sir!")
  end
  
  def test_quoting_backslash
    assert_equal "Hello\\\\ sir!", @quote.quote("Hello\\ sir!")
  end
end
