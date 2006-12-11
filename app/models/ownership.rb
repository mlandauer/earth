require "ldap"

class Ownership
  cattr_accessor :config
  attr_accessor :uid, :gid
    
  @@config = YAML.load(File.open(File.dirname(__FILE__) + "/../../config/earth.yml"))

  def initialize(uid, gid)
    @uid = uid
    @gid = gid
  end
  
  def user_name
    lookup uid, config["ldap_user_lookup"]
  end
  
  def group_name
    lookup gid, config["ldap_group_lookup"]
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
