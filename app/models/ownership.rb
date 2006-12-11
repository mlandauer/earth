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
    lookup(config["ldap_user_base"], config["ldap_user_id_field"], config["ldap_user_name_field"], uid)
  end
  
  def group_name
    lookup config["ldap_group_base"], config["ldap_group_id_field"], config["ldap_group_name_field"], gid
  end
  
  private
  
  def lookup(base, id_field, name_field, id)
    #TODO: Don't make a new connection to the server for every request
    if config["ldap_server_name"]
      LDAP::Conn.new(config["ldap_server_name"], config["ldap_server_port"]).bind do |conn|
        conn.search(base, LDAP::LDAP_SCOPE_SUBTREE, "#{id_field}=#{id}") do |e|
          return e.vals(name_field)[0]
        end
      end
    else
      return id.to_s
    end
  end
  
end
