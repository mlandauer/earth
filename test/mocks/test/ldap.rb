module LDAP
  LDAP_SCOPE_SUBTREE = 1
  LDAP_OPT_PROTOCOL_VERSION = 3

  class Result
    def initialize(record)
      @record = record
    end
    def vals(field_name)
      [ @record[field_name] ]
    end
  end

  class Conn
    
    RECORDS = [
      { "uidNumber" => "3054", "uid" => "kenji" },
      { "uidNumber" => "1234", "uid" => "julians" }
    ]

    def initialize(name, port)
    end

    def Conn.set_option(option, value)
      # ignore
    end

    def bind
      yield(self)
    end

    def search(base, scope, query, result_field)
      query_match = /(.*)[=](.*)/.match(query)
      query_field = query_match[1]
      query_regex = Regexp.new("^" + ("x" + query_match[2] + "x").split("*").map { |fragment| Regexp.escape(fragment) }.join(".*")[1..-2] + "$")
      results = []
      RECORDS.each do |record|
        if query_regex.match(record[query_field])
          yield(Result.new(record))
        end
      end      
    end
  end
end
