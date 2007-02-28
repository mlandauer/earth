module Earth
  class CachedSize < ActiveRecord::Base
    belongs_to :directory

    def size
      Size.new(bytes, blocks, count)
    end
    
    def size=(size)
      self.bytes = size.bytes
      self.blocks = size.blocks
      self.count = size.count
    end
    
    def update
      # do not update; updating of cached_size is done with a bulk
      # update from directory's after_update callback.
    end
  end
end
