#!/usr/bin/env ruby
#
#  Created by Bruno Mattarollo on 2006-12-21.
#  Copyright (c) 2006. All rights reserved.

module RedHillConsulting
  module Core

    module AbstractAdapter

      def add_foreign_key(table_name, column_names, references_table_name, references_column_names, options = {})
        foreign_key = ForeignKeyDefinition.new(column_names, ActiveRecord::Migrator.proper_table_name(references_table_name), references_column_names, options[:on_update], options[:on_delete])
        if options[:name]
          execute "ALTER TABLE #{table_name} ADD CONSTRAINT #{options[:name]} #{foreign_key}"
        else
          execute "ALTER TABLE #{table_name} ADD #{foreign_key}"
        end
      end

    end

  end
end
