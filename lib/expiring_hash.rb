class ExpiringHash
  def initialize(ttl_seconds)
    @hash = {}
    @ttl_seconds = ttl_seconds
  end
  
  def []=(key, value)
    @hash[key] = [value, @ttl_seconds.from_now]
  end
  
  def [](key)
    value, expiry = @hash[key]
    if expiry.nil?
      nil
    elsif Time.now < expiry
      value
    else
      @hash.delete(key)
      nil
    end
  end
end
