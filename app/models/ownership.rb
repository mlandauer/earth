require "ldap"

class Ownership
  cattr_accessor :ldap_server_name, :ldap_server_port, :ldap_base_dn, :ldap_uid_field, :ldap_name_field
  attr_accessor :uid, :gid
    
  config_file = File.dirname(__FILE__) + "/../../config/earth.yml"
  config = YAML.load(File.open(config_file))
  @@ldap_server_name = config["ldap_server_name"]
  @@ldap_server_port = config["ldap_server_port"]
  @@ldap_user_base = config["ldap_user_base"]
  @@ldap_user_id_field = config["ldap_user_id_field"]
  @@ldap_user_name_field = config["ldap_user_name_field"]
  @@ldap_group_base = config["ldap_group_base"]
  @@ldap_group_id_field = config["ldap_group_id_field"]
  @@ldap_group_name_field = config["ldap_group_name_field"]

  def initialize(uid, gid)
    @uid = uid
    @gid = gid
  end
  
  def user_name
    #TODO: Don't make a new connection to the server for every request
    if @@ldap_server_name
      LDAP::Conn.new(@@ldap_server_name, @@ldap_server_port).bind do |conn|
        conn.search(@@ldap_user_base, LDAP::LDAP_SCOPE_SUBTREE, "#{@@ldap_user_id_field}=#{@uid}") do |e|
          return e.vals(@@ldap_user_name_field)[0]
        end
      end
    else
      return uid.to_s
    end
  end
  
  def group_name
    #TODO: Don't make a new connection to the server for every request
    if @@ldap_server_name
      LDAP::Conn.new(@@ldap_server_name, @@ldap_server_port).bind do |conn|
        conn.search(@@ldap_group_base, LDAP::LDAP_SCOPE_SUBTREE, "#{@@ldap_group_id_field}=#{@gid}") do |e|
          return e.vals(@@ldap_group_name_field)[0]
        end
      end
    else
      return gid.to_s
    end
  end
end
