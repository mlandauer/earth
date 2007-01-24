module Earth
  class File < ActiveRecord::Base
    belongs_to :directory
    composed_of :user, :mapping => [%w(uid uid)]
    
    Stat = Struct.new(:mtime, :size, :blocks, :uid, :gid)
    class Stat
      def ==(s)
        mtime == s.mtime && size == s.size && blocks == s.blocks && uid == s.uid && gid == s.gid
      end
    end
    
    # Convenience method for setting all the fields associated with stat in one hit
    def stat=(stat)
      self.modified = stat.mtime
      self.size = stat.size
      self.blocks = stat.blocks
      self.uid = stat.uid
      self.gid = stat.gid
    end
    
    # Returns a "fake" Stat object with some of the same information as File::Stat
    def stat
      Stat.new(modified, size, blocks, uid, gid)
    end

    def File.with_filter(params) 
      filter_filename = params[:filter_filename]
      if filter_filename.nil? || filter_filename == ""
        filter_filename = "*"
      end
      filter_user = params[:filter_user]
      
      users = User.find_all

      if filter_user && filter_user != ""    
        filter_uid = User.find_by_name(@filter_user).uid
      else
        filter_uid = nil
      end

      if not filter_uid.nil?
        filter_conditions = ["files.name LIKE ? AND files.uid = ?", filter_filename.tr('*', '%'), uid]
      elsif filter_filename != '*'
        filter_conditions = ["files.name LIKE ?", filter_filename.tr('*', '%')]
      else
        filter_conditions = nil
      end

      filter = Earth::Filter.find_filter_for_params(filter_filename, filter_uid)

      Thread.current[:with_filter] = filter

      Earth::File.with_scope(:find => {:conditions => filter_conditions}) do
        begin
          yield
        ensure
          Thread.current[:with_filter] = nil
        end
      end
    end
  end
end
