require "iconv"

class QuoteBadCharacters
  def quote(text)
    quote_bad_utf8(quote_backslashes(text))
  end
  
  def quote_backslashes(text)
    result = ""
    text.each_byte do |c|
      if c == 92
        result += "\\\\"
      else
        result += c.chr
      end
    end
    result
  end
  
  def quote_bad_utf8(text)
    c = Iconv.new("char", "UTF-8")
    begin
      c.iconv(text)
    rescue Iconv::IllegalSequence => c
      c.success + quote_bad_character(c.failed[0]) + c.failed[1..-1]
    end
  end
  
  def quote_bad_character(value)
    "\\" + value.to_s(8)
  end
end
