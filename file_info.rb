require 'db_config'

class FileInfo < ActiveRecord::Base
  belongs_to :directory_info
end
