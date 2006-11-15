class Directory < ActiveRecord::Base

  def self.size_children(server, observation_point)
    
    caching_key = "#{server}_#{observation_point}"
    
    if ENV['RAILS_ENV'] == "production"
      if cached_children = Cache.get(caching_key)
        return cached_children
      else
        # Super-Duper query with regular expression matching!
        # We use the regex to only look for the immediate children
        # of our observation point.
        fresh_children = find_by_sql("SELECT SUM(filesize) as storage, \
                                      SUBSTRING(path from '^(#{observation_point}[^/]*/)') as path \
                                      FROM directories WHERE server = '#{server}' AND path LIKE '#{observation_point}%' \
                                      GROUP BY  SUBSTRING(path from '^(#{observation_point}[^/]*/)') \
                                      HAVING SUBSTRING(path from '^(#{observation_point}[^/]*/)') <> '' \
                                      ORDER BY path"  )
        # Let's cache the results for 4 hours
        # Why 4 hours? Because we now Cache by a combo of server and observation_point
        # and when we repopulate the DB, that doesn't change ... we don't want to cache
        # that, don't we? And, in addition, this is MUCH faster than the previous version
        # so ... we should be able to run without cache
        Cache.put(caching_key, fresh_children, 14400)
        return fresh_children
      end
    else
      # We are in "DEVELOPMENT" therefor there is no Cache available
      # Yes, I know ... I could spend more time thinking about DRY
      # but in this case, I need to focus on reporting ... 
      # TODO: how to use DRY principles
      fresh_children = find_by_sql("SELECT SUM(filesize) as storage, \
                                    SUBSTRING(path from '^(#{observation_point}[^/]*/)') as path \
                                    FROM directories WHERE server = '#{server}' AND path LIKE '#{observation_point}%' \
                                    GROUP BY  SUBSTRING(path from '^(#{observation_point}[^/]*/)') \
                                    HAVING SUBSTRING(path from '^(#{observation_point}[^/]*/)') <> '' \
                                    ORDER BY path"  )
      return fresh_children
    end
  end

end
