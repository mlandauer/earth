# Decided to remove foreign key constraints during development. I found another
# problem related to using them with Rails where on running rake db:test:clone
# a table couldn't be dropped because of foreign key constraint (but the exception
# is caught low down in Rails, so I never saw it... Ugh)
# Also see http://blog.caboo.se/articles/2006/05/01/are-foreign-keys-worth-your-time

class RemoveForeignKeyConstraints < ActiveRecord::Migration
  def self.up
    remove_foreign_key :file_info, :file_info_ibfk_1
    remove_foreign_key :servers, :servers_ibfk_1
  end

  def self.down
    add_foreign_key :file_info, :directory_id, :directories, :id
    add_foreign_key :servers, :directory_id, :directories, :id
  end
end
