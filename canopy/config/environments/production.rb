# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

# MEMCACHE settings
memcache_options = {
 :c_threshold => 10_000,
 :compression => true,
 :debug => true,
 :namespace => 'rspIntranet',
 :readonly => false,
 :urlencode => true
}

CACHE = MemCache.new memcache_options
CACHE.servers = '10.2.0.108:11211'
 
session_options = {
 :database_manager => CGI::Session::MemCacheStore,
 :cache => CACHE
}

ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update session_options
