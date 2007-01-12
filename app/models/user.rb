class User
  cattr_accessor :config
  attr_reader :uid, :name
    
  self.config = YAML.load(File.open(File.dirname(__FILE__) + "/../../config/earth.yml"))
  
  @@uid_to_name = ExpiringHash.new(eval(config["ldap_cache_time"]))

  def User.ldap_configured?
    config["ldap_server_name"]
  end
  
  require "ldap" if ldap_configured?

  def initialize(uid)
    @uid = uid
    @name = find_name_by_uid_cached(@uid)
  end
 
   # here... look here! right below this
  def logger
    RAILS_DEFAULT_LOGGER
  end
 
  # Simple cache
  def find_name_by_uid_cached(uid)
    result = @@uid_to_name[uid]
    if result.nil?
      result = find_name_by_uid_uncached(uid)
      @@uid_to_name[uid] = result
    end
    result
  end
  
  def find_name_by_uid_uncached(uid)
    User.lookup(uid.to_s, config["ldap_user_lookup"]["id_field"], config["ldap_user_lookup"]["name_field"],
        config["ldap_user_lookup"]["base"]) || "#{uid}"
  end
  
  def User.find(uid)
    User.new(uid)
  end
  
  def User.find_by_name(name)
    no = User.lookup(name, config["ldap_user_lookup"]["name_field"], config["ldap_user_lookup"]["id_field"],
      config["ldap_user_lookup"]["base"]).to_i
    return User.new(no)
  end
  
  def User.find_all
    if User.ldap_configured?
      nos = User.lookup_all('*', config["ldap_user_lookup"]["name_field"], config["ldap_user_lookup"]["id_field"],
       config["ldap_user_lookup"]["base"])
      return nos.map{|n| User.new(n)}
    else
      return []
    end
  end
  
  def User.find_matching(m)
    if User.ldap_configured?
      nos = User.lookup_all("*#{m}*", config["ldap_user_lookup"]["name_field"], config["ldap_user_lookup"]["id_field"],
        config["ldap_user_lookup"]["base"])
      return nos.map{|n| User.new(n)}
    else
      return []
    end
  end
  
  private
  
  def User.lookup(value, lookup_field, result_field, base)
    #TODO: Don't make a new connection to the server for every request
    if User.ldap_configured?
      LDAP::Conn.new(config["ldap_server_name"], config["ldap_server_port"]).bind do |conn|
        conn.search(base, LDAP::LDAP_SCOPE_SUBTREE, "#{lookup_field}=#{value}", result_field) do |e|
          return e.vals(result_field)[0]
        end
      end
      return nil
    else
      return value
    end
  end
  
  def User.lookup_all(value, lookup_field, result_field, base)
    #TODO: Don't make a new connection to the server for every request
    if User.ldap_configured?
      results = []
      LDAP::Conn.new(config["ldap_server_name"], config["ldap_server_port"]).bind do |conn|
        conn.search(base, LDAP::LDAP_SCOPE_SUBTREE, "#{lookup_field}=#{value}", result_field) do |e|
          results << e.vals(result_field)[0]
        end
      end
      return results
    else
      return [value]
    end
  end
  
end
