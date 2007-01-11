class User
  cattr_accessor :config
  attr_accessor :uid
    
  self.config = YAML.load(File.open(File.dirname(__FILE__) + "/../../config/earth.yml"))

  def User.ldap_configured?
    config["ldap_server_name"]
  end
  
  require "ldap" if ldap_configured?

  def initialize(uid)
    @uid = uid
  end
  
  def name
    User.lookup(uid, config["ldap_user_lookup"]["id_field"], config["ldap_user_lookup"]["name_field"],
      config["ldap_user_lookup"]["base"]).to_s
  end
  
  def User.find_by_name(name)
    no = User.lookup(name, config["ldap_user_lookup"]["name_field"], config["ldap_user_lookup"]["id_field"],
      config["ldap_user_lookup"]["base"]).to_i
    return User.new(no)
  end
  
  private
  
  def User.lookup(value, lookup_field, result_field, base)
    #TODO: Don't make a new connection to the server for every request
    if User.ldap_configured?
      LDAP::Conn.new(config["ldap_server_name"], config["ldap_server_port"]).bind do |conn|
        conn.search(base, LDAP::LDAP_SCOPE_SUBTREE, "#{lookup_field}=#{value}") do |e|
          return e.vals(result_field)[0]
        end
      end
    else
      return value
    end
  end
  
end
