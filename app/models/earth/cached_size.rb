module Earth
  class CachedSize < ActiveRecord::Base
    belongs_to :directory
    belongs_to :filter

    def snapshot
      @size_snapshot, @blocks_snapshot, @count_snapshot = size, blocks, count
    end

    def difference
      [ size - @size_snapshot, blocks - @blocks_snapshot, count - @count_snapshot ]
    end

    def increment(file_or_cached_size)
      self.size += file_or_cached_size.size
      self.blocks += file_or_cached_size.blocks
      if file_or_cached_size.respond_to?("count")
        self.count += file_or_cached_size.count
      else
        self.count += 1
      end
    end

    def decrement(file_or_cached_size)
      self.size -= file_or_cached_size.size
      self.blocks -= file_or_cached_size.blocks
      if file_or_cached_size.respond_to?("count")
        self.count -= file_or_cached_size.count
      else
        self.count -= 1
      end
    end
  end
end
