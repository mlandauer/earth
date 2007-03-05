require "iconv"

class QuoteBadCharacters
  # From the iconv_open man page:
  # Locale dependent, in terms of char or wchar_t
  #   (with  machine  dependent  endianness  and  alignment,  and with semantics
  #   depending on the OS and the  current  LC_CTYPE  locale facet)
  #     char, wchar_t
  def initialize(source_encoding = "char")
    @convert = Iconv.new(source_encoding, "UTF-8")
  end
  
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
    begin
      @convert.iconv(text)
    rescue Iconv::Failure => c
      c.success + quote_bad_character(c.failed[0]) + c.failed[1..-1]
    end
  end
  
  def quote_bad_character(value)
    "\\" + value.to_s(8)
  end
end
