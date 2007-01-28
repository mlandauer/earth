module Earth
  class CachedSize < ActiveRecord::Base
    belongs_to :directory
    belongs_to :filter

    def snapshot
      @size_snapshot, @blocks_snapshot = size, blocks
    end

    def difference
      [ size - @size_snapshot, blocks - @blocks_snapshot ]
    end

    def increment(file_or_cached_size)
      self.size += file_or_cached_size.size
      self.blocks += file_or_cached_size.blocks
    end

    def decrement(file_or_cached_size)
      self.size -= file_or_cached_size.size
      self.blocks -= file_or_cached_size.blocks
    end
  end
end
