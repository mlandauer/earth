##
# A utility wrapper around the MemCache client to simplify cache access.  All
# methods silently ignore MemCache errors.

module Cache

    ##
    # Returns the object at +key+ from the cache if successful, or nil if
    # either the object is not in the cache or if there was an error
    # attermpting to access the cache.

    def self.get(key)
        start_time = Time.now.to_f
        result = CACHE.get key
        end_time = Time.now.to_f
        ActiveRecord::Base.logger.debug(
            sprintf("MemCache Get (%0.6f)  %s",
                    end_time - start_time, key))
        return result
    rescue MemCache::MemCacheError => err
        # MemCache error is a cache miss.
        ActiveRecord::Base.logger.debug("MemCache Error: #{err.message}")
        return nil
    end

    ##
    # Places +value+ in the cache at +key+, with an optional +expiry+ time in
    # seconds. (?)

    def self.put(key, value, expiry = 0)
        start_time = Time.now.to_f
        CACHE.set key, value, expiry
        end_time = Time.now.to_f
        ActiveRecord::Base.logger.debug(
            sprintf("MemCache Set (%0.6f)  %s",
                    end_time - start_time, key))
    rescue MemCache::MemCacheError => err
        # Ignore put failure.
        ActiveRecord::Base.logger.debug("MemCache Error: #{err.message}")
    end

    ##
    # Deletes +key+ from the cache in +delay+ seconds. (?)

    def self.delete(key, delay = nil)
        start_time = Time.now.to_f
        CACHE.delete key, delay
        end_time = Time.now.to_f
        ActiveRecord::Base.logger.debug(
            sprintf("MemCache Delete (%0.6f)  %s",
                    end_time - start_time, key))
    rescue MemCache::MemCacheError => err
        # Ignore delete failure.
        ActiveRecord::Base.logger.debug("MemCache Error: #{err.message}")
    end

    ##
    # Resets all connections to mecache servers.

    def self.reset
        CACHE.reset
        ActiveRecord::Base.logger.debug("MemCache Reset")
    end
    
end

# vim: ts=4 sts=4 sw=4

