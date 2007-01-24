module Earth
  class CachedSize < ActiveRecord::Base
    belongs_to :directory
    belongs_to :filter

    def snapshot
      @recursive_size_snapshot, @recursive_blocks_snapshot = recursive_size, recursive_blocks
    end

    def difference
      [ recursive_size - @recursive_size_snapshot, recursive_blocks - @recursive_blocks_snapshot ]
    end
  end
end
