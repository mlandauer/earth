class User
  cattr_accessor :config
  attr_accessor :uid
    
  self.config = YAML.load(File.open(File.dirname(__FILE__) + "/../../config/earth.yml"))

  require "ldap" if config["ldap_server_name"]

  def initialize(uid)
    @uid = uid
  end
  
  def name
    lookup uid, config["ldap_user_lookup"]
  end
  
  private
  
  def lookup(id, lookup_config)
    #TODO: Don't make a new connection to the server for every request
    if config["ldap_server_name"]
      LDAP::Conn.new(config["ldap_server_name"], config["ldap_server_port"]).bind do |conn|
        conn.search(lookup_config["base"], LDAP::LDAP_SCOPE_SUBTREE, "#{lookup_config["id_field"]}=#{id}") do |e|
          return e.vals(lookup_config["name_field"])[0]
        end
      end
    else
      return id.to_s
    end
  end
  
end
