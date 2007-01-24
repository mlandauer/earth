module Earth
  class Filter < ActiveRecord::Base    
    belongs_to :cached_size

    def matches(file)
      (self.filename == "*" or not filename_regexp.match(file.name).nil? and 
         (self.uid.nil? or self.uid == file.uid))
    end
    
    def filename_regexp
      Regexp.new("^" + filename.split("*").map { |fragment| Regexp.escape(fragment) }.join(".*") + "$")
    end

    def Filter.find_filter_for_params(filename, uid)
      if uid
        find :first, :conditions => ["filename = ? AND uid = ?", filename, uid]
      else
        find :first, :conditions => ["filename = ? AND uid IS NULL", filename]
      end
    end
  end
end
