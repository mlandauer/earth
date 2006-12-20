# This contains some additions/improvements to the better nested set plugin
module SymetrieCom
  module Acts
    module NestedSet
      module ClassMethods
        # Same as original but allows assignment of parent attribute
        def acts_as_nested_set(options = {})          
          
          options[:scope] = "#{options[:scope]}_id".intern if options[:scope].is_a?(Symbol) && options[:scope].to_s !~ /_id$/

          write_inheritable_attribute(:acts_as_nested_set_options,
             { :parent_column  => (options[:parent_column] || 'parent_id'),
               :left_column    => (options[:left_column]   || 'lft'),
               :right_column   => (options[:right_column]  || 'rgt'),
               :scope          => (options[:scope] || '1 = 1'),
               :text_column    => (options[:text_column] || columns.collect{|c| (c.type == :string) ? c.name : nil }.compact.first)
              } )
               
          class_inheritable_reader :acts_as_nested_set_options
          
          if acts_as_nested_set_options[:scope].is_a?(Symbol)
            scope_condition_method = %(
              def scope_condition
                if #{acts_as_nested_set_options[:scope].to_s}.nil?
                  "#{acts_as_nested_set_options[:scope].to_s} IS NULL"
                else
                  "#{acts_as_nested_set_options[:scope].to_s} = \#{#{acts_as_nested_set_options[:scope].to_s}}"
                end
              end
            )
          else
            scope_condition_method = "def scope_condition() \"#{acts_as_nested_set_options[:scope]}\" end"
          end
          
          # no bulk assignment
          attr_protected  acts_as_nested_set_options[:left_column].intern,
                          acts_as_nested_set_options[:right_column].intern
          # no assignment to structure fields
          module_eval <<-"end_eval", __FILE__, __LINE__
            def #{acts_as_nested_set_options[:left_column]}=(x)
              raise ActiveRecord::ActiveRecordError, "Unauthorized assignment to #{acts_as_nested_set_options[:left_column]}: it's an internal field handled by acts_as_nested_set code, use move_to_* methods instead."
            end
            def #{acts_as_nested_set_options[:right_column]}=(x)
              raise ActiveRecord::ActiveRecordError, "Unauthorized assignment to #{acts_as_nested_set_options[:right_column]}: it's an internal field handled by acts_as_nested_set code, use move_to_* methods instead."
            end
            #{scope_condition_method}
          end_eval
           
          include SymetrieCom::Acts::NestedSet::InstanceMethods
          extend SymetrieCom::Acts::NestedSet::ClassMethods          
        end        
        
      end
      
      module InstanceMethods
        
        # Overriding implementation from betternested set 
        # Before destroying this object instantiate and then destroy all the children first
        # This ensures that callbacks are called such as those that for destroying associations
        def before_destroy
          children.each {|c| c.destroy}
        end

        def parent=(parent)
          self.parent_id = parent.id unless parent.nil?
        end
        
        def parent_id=(id)
          write_attribute(:parent_id, id)
          @parent_id_updated = true
        end
        
        def after_save
          if @parent_id_updated
            move_to_child_of(parent)
            @parent_id_updated = false
          end
        end
    
        def has_children?
          reload
          children_count > 0
        end
    
        def children_with_caching(reload = false)
          @children = children_without_caching if @children.nil? || reload
          return @children
        end
    
        alias_method_chain :children, :caching
        
        def child_create(attributes)
          raise "Can't set parent" if attributes[:parent]
          directory = self.class.create(attributes.merge(:parent => self))
          # Adding this directory to children at the front to maintain the same order as children(true)
          @children = [directory] + @children if @children
          directory
        end
    
        def child_delete(child)
          @children.delete(child) {raise "Not a child of this directory"} if @children
          child.destroy
        end
    
        # Load all the children and the children of children, etc. so that they
        # can be accesed via the "children" method without requiring any db queries
        def load_all_children
          child_by_id = {id => self}
          children_of = {}
          all_children.each do |child|
            child_by_id[child.id] = child
            if children_of[child.parent_id].nil?
              children_of[child.parent_id] = []
            end
            children_of[child.parent_id] << child
          end
          child_by_id.each do |id, child|
            child.set_cached_children([])
          end
          children_of.each do |id, children|
            child_by_id[id].set_cached_children(children)
          end
        end

        # Override the default implementation of update to write all attributes except
        # lft and rgt
        def update
          a = attributes_with_quotes(false)
          a.delete(left_col_name)
          a.delete(right_col_name)
          connection.update(
            "UPDATE #{self.class.table_name} " +
            "SET #{quoted_comma_pair_list(connection, a)} " +
            "WHERE #{self.class.primary_key} = #{quote_value(id)}",
            "#{self.class.name} Update"
          )
        end
    
        protected
        # Only use this if you know what you're doing
        def set_cached_children(children)
          @children = children
        end
      end
    end
  end
end
