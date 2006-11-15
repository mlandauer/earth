class Archive < ActiveRecord::Base

  def self.get_servers
    return find_by_sql("SELECT DISTINCT(server) FROM archives")
  end

  def self.get_report(server, observation_point, startdate, enddate)
    report_data = find_by_sql(  "SELECT SUM(filesize) as storage,
                                  SUBSTRING(path from '^(#{observation_point}[^/]*/)') as observation,
                                  DATE_TRUNC('day', original_time) as observed
                                  FROM archives WHERE server = '#{server}' AND path LIKE '#{observation_point}%'
                                  AND DATE_TRUNC('day', original_time) #{(startdate..enddate).to_s(:db)}
                                  GROUP BY observed, observation
                                  HAVING SUBSTRING(path from '^(#{observation_point}[^/]*/)') <> ''
                                  ORDER BY observed, observation" )
    return report_data
  end

  def self.get_top_growers(server, observation, before, after, limit)
    top_growers = find_by_sql("select
        (max(after.storage) - max(coalesce(before.storage, 0))) as increased_storage,
        after.observation as observation_point
      from
        (
          select
            sum(B.filesize) as storage,
            substring(B.path from '^(#{observation}[^/]+/)') as observation,
            date_trunc('day', B.original_time) as observed
          from
            archives B
          where
            B.server = '#{server}' and
            date_trunc('day', B.original_time) = '#{before}'
          group by
            observation, observed
          order by
            observation ASC
          ) AS before RIGHT OUTER JOIN
          (
            select
              sum(A.filesize) as storage,
              substring(A.path from '^(#{observation}[^/]+/)') as observation,
              date_trunc('day', A.original_time) as observed
            from
              archives A
            where
              A.server = '#{server}' and
              date_trunc('day', A.original_time) = '#{after}'
            group by
              observation, observed
            order by
              observation ASC
            ) AS after
          ON (before.observation = after.observation)
      group by
        observation_point
      having
        after.observation <> ''
      order by
        increased_storage desc
      limit #{limit}")
    return top_growers
  end

end
