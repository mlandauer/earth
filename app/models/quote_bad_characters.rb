class QuoteBadCharacters
  def quote(text)
    result = ""
    text.each_byte do |c|
      if c == 0251
        result += "\\251"
      elsif c == 92
        result += "\\\\"
      else
        result += c.chr
      end
    end
    result
  end
end
