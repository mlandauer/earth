require "ldap"

class Ownership
  cattr_accessor :ldap_server_name, :ldap_server_port, :ldap_base_dn, :ldap_uid_field, :ldap_name_field
  
  config_file = File.dirname(__FILE__) + "/../../config/earth.yml"
  config = YAML.load(File.open(config_file))
  @@ldap_server_name = config["ldap_server_name"]
  @@ldap_server_port = config["ldap_server_port"]
  @@ldap_base_dn = config["ldap_base_dn"]
  @@ldap_uid_field = config["ldap_uid_field"]
  @@ldap_name_field = config["ldap_name_field"]

  attr_accessor :uid
  
  def initialize(uid)
    @uid = uid
  end
  
  def user_name
    #TODO: Don't make a new connection to the server for every request
    if @@ldap_server_name
      LDAP::Conn.new(@@ldap_server_name, @@ldap_server_port).bind do |conn|
        conn.search(@@ldap_base_dn, LDAP::LDAP_SCOPE_SUBTREE, "#{@@ldap_uid_field}=#{@uid}") do |e|
          return e.vals(@@ldap_name_field)[0]
        end
      end
    else
      return uid.to_s
    end
  end
end
