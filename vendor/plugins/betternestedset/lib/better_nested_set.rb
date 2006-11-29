module SymetrieCom
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      def self.append_features(base)
        super        
        base.extend(ClassMethods)              
      end  

      # better_nested_set ehances the core nested_set tree functionality provided in ruby_on_rails.
      #
      # This acts provides Nested Set functionality. Nested Set is a smart way to implement
      # an _ordered_ tree, with the added feature that you can select the children and all of their 
      # descendents with a single query. The drawback is that insertion or move need some complex
      # sql queries. But everything is done here by this module!
      #
      # Nested sets are appropriate each time you want either an orderd tree (menus, 
      # commercial categories) or an efficient way of querying big trees (threaded posts).
      #
      # == API
      # Methods names are aligned on Tree's ones as much as possible, to make replacment from one 
      # by another easier, except for the creation:
      # 
      # in acts_as_tree:
      #   item.children.create(:name => "child1")
      #
      # in acts_as_nested_set:
      #   # adds a new item at the "end" of the tree, i.e. with child.left = max(tree.right)+1
      #   child = MyClass.new(:name => "child1")
      #   child.save
      #   # now move the item to its right place
      #   child.move_to_child_of my_item
      #
      # You can use:
      # * move_to_child_of
      # * move_to_right_of
      # * move_to_left_of
      # and pass them an id or an object.
      #
      # Other methods added by this mixin are:
      # * +root+ - root item of the tree (the one that has a nil parent; should have left_column = 1 too)
      # * +roots+ - root items, in case of multiple roots (the ones that have a nil parent)
      # * +level+ - number indicating the level, a root being level 0
      # * +ancestors+ - array of all parents, with root as first item
      # * +self_and_ancestors+ - array of all parents and self
      # * +siblings+ - array of all siblings, that are the items sharing the same parent and level
      # * +self_and_siblings+ - array of itself and all siblings
      # * +children_count+ - count of all immediate children
      # * +children+ - array of all immediate childrens
      # * +all_children+ - array of all children and nested children
      # * +full_set+ - array of itself and all children and nested children
      #
      # These should not be useful, except if you want to write direct SQL:
      # * +left_col_name+ - name of the left column passed on the declaration line
      # * +right_col_name+ - name of the right column passed on the declaration line    
      # * +parent_col_name+ - name of the parent column passed on the declaration line
      #
      # recommandations:
      # Don't name your left and right columns 'left' and 'right': these names are reserved on most of dbs.
      # Usage is to name them 'lft' and 'rgt' for instance.
      #
      module ClassMethods                
        # Configuration options are:
        #
        # * +parent_column+ - specifies the column name to use for keeping the position integer (default: parent_id)
        # * +left_column+ - column name for left boundry data, default "lft"
        # * +right_column+ - column name for right boundry data, default "rgt"
        # * +text_column+ - column name for the title field (optional). Used as default in the 
        #   {your-class}_options_for_select helper method. If empty, will use the first string field 
        #   of your model class.
        # * +scope+ - restricts what is to be considered a list. Given a symbol, it'll attach "_id" 
        #   (if that hasn't been already) and use that as the foreign key restriction. It's also possible 
        #   to give it an entire string that is interpolated if you need a tighter scope than just a foreign key.
        #   Example: <tt>acts_as_nested_set :scope => 'todo_list_id = #{todo_list_id} AND completed = 0'</tt>
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
                          acts_as_nested_set_options[:right_column].intern,
                          acts_as_nested_set_options[:parent_column].intern
          # no assignment to structure fields
          module_eval <<-"end_eval", __FILE__, __LINE__
            def #{acts_as_nested_set_options[:left_column]}=(x)
              raise ActiveRecord::ActiveRecordError, "Unauthorized assignment to #{acts_as_nested_set_options[:left_column]}: it's an internal field handled by acts_as_nested_set code, use move_to_* methods instead."
            end
            def #{acts_as_nested_set_options[:right_column]}=(x)
              raise ActiveRecord::ActiveRecordError, "Unauthorized assignment to #{acts_as_nested_set_options[:right_column]}: it's an internal field handled by acts_as_nested_set code, use move_to_* methods instead."
            end
            def #{acts_as_nested_set_options[:parent_column]}=(x)
              raise ActiveRecord::ActiveRecordError, "Unauthorized assignment to #{acts_as_nested_set_options[:parent_column]}: it's an internal field handled by acts_as_nested_set code, use move_to_* methods instead."
            end
            #{scope_condition_method}
          end_eval
           
        
          include SymetrieCom::Acts::NestedSet::InstanceMethods
          extend SymetrieCom::Acts::NestedSet::ClassMethods
          
          # adds the helper for the class
#          ActionView::Base.send(:define_method, "#{Inflector.underscore(self.class)}_options_for_select") { special=nil
#              "#{acts_as_nested_set_options[:text_column]} || "#{self.class} id #{id}"
#            }
          
        end        


        # Returns the single root for the class (or just the first root, if there are several)
        # Note: for our purposes, a root is anything with parent_id IS NULL or parent_id = 0. 
        # It can be argued that parent_id should never be 0, but not everyone follows that convention, and we want to be nice.
        def root
          self.find(:first, :conditions => "(#{acts_as_nested_set_options[:parent_column]} IS NULL OR #{acts_as_nested_set_options[:parent_column]} = 0)")
        end
        
        # Returns roots when multiple roots (or virtual root, which is the same)
        def roots
          self.find(:all, :conditions => "(#{acts_as_nested_set_options[:parent_column]} IS NULL OR #{acts_as_nested_set_options[:parent_column]} = 0)", :order => "#{acts_as_nested_set_options[:left_column]}")
        end
        
        # Check all trees. Slow. Throws ActiveRecord::ActiveRecordError if it finds a problem.
        def check_all
          roots.each{|r| return false unless r.check_full_tree}
          return true
        end
        
      end
      
      module InstanceMethods
        
        def left_col_name()#:nodoc:
          acts_as_nested_set_options[:left_column]
        end
        def right_col_name()#:nodoc:
          acts_as_nested_set_options[:right_column]
        end              
        def parent_col_name()#:nodoc:
          acts_as_nested_set_options[:parent_column]
        end
        alias parent_column parent_col_name#:nodoc: Deprecated

        # On creation, automatically add the new node to the right of all existing nodes in this tree.
        def before_create # already protected by a transaction
          maxright = self.class.maximum(right_col_name, :conditions => scope_condition) || 0
          self[left_col_name] = maxright+1
          self[right_col_name] = maxright+2
        end
        
        # On destruction, delete all children and shift the lft/rgt values back to the left so the counts still work.
        def before_destroy # already protected by a transaction
          return if self[right_col_name].nil? || self[left_col_name].nil?
          dif = self[right_col_name] - self[left_col_name] + 1
          self.class.delete_all( "#{scope_condition} AND #{left_col_name} > #{self[left_col_name]} and #{right_col_name} < #{self[right_col_name]}" )
          self.class.update_all("#{left_col_name} = CASE \
                                      WHEN #{left_col_name} > #{self[right_col_name]} THEN (#{left_col_name} - #{dif}) \
                                      ELSE #{left_col_name} END, \
                                 #{right_col_name} = CASE \
                                      WHEN #{right_col_name} > #{self[right_col_name]} THEN (#{right_col_name} - #{dif} ) \
                                      ELSE #{right_col_name} END",
                                 scope_condition)
        end

        # By default, objects are compared and sorted using the left column.
        def <=>(x)
          self[left_col_name] <=> x[left_col_name]
        end
        
        # Deprecated. Returns true if this is a root node.
        def root?
          parent_id = self[parent_col_name]
          (parent_id == 0 || parent_id.nil?) && (self[left_col_name] == 1) && (self[right_col_name] > self[left_col_name])
        end                                                                                             
                                    
        # Deprecated. Returns true if this is a child node
        def child?                          
          parent_id = self[parent_col_name]
          !(parent_id == 0 || parent_id.nil?) && (self[left_col_name] > 1) && (self[right_col_name] > self[left_col_name])
        end     
        
        # Deprecated. Returns true if we have no idea what this is
        def unknown?
          !root? && !child?
        end
        
        # Returns root
        def root
            self.class.find(:first, :conditions => "#{scope_condition} AND (#{parent_col_name} IS NULL OR #{parent_col_name} = 0)")
        end
                
        # Returns roots when multiple roots (or virtual root, which is the same)
        def roots
            self.class.find(:all, :conditions => "#{scope_condition} AND (#{parent_col_name} IS NULL OR #{parent_col_name} = 0)", :order => "#{left_col_name}")
        end
                
        # Returns the parent
        def parent
            self.class.find(self[parent_col_name]) if self[parent_col_name]
        end
        
        # Returns an array of all parents.
        # Maybe 'full_outline' would be a better name, but we prefer to mimic the Tree class
        def ancestors
            self.class.find(:all, :conditions => "#{scope_condition} AND (#{left_col_name} < #{self[left_col_name]} and #{right_col_name} > #{self[right_col_name]})", :order => left_col_name )
        end
        
        # Returns the array of all parents and self
        def self_and_ancestors
            ancestors + [self]
        end
        
        # Returns the array of all children of the parent, except self
        def siblings
            self_and_siblings - [self]
        end
        
        # Returns the array of all children of the parent, included self
        def self_and_siblings
            if self[parent_col_name].nil? || self[parent_col_name].zero?
                [self]
            else
                self.class.find(:all, :conditions => "#{scope_condition} and #{parent_col_name} = #{self[parent_col_name]}", :order => left_col_name)
            end
        end
        
        # Returns the level of this object in the tree
        # root level is 0
        def level
            return 0 if self[parent_col_name].nil?
            self.class.count(:conditions => "#{scope_condition} AND (#{left_col_name} < #{self[left_col_name]} and #{right_col_name} > #{self[right_col_name]})")
        end                                  
                                           
        # Returns the number of nested children of this object.
        def children_count
          return (self[right_col_name] - self[left_col_name] - 1)/2
        end
                                                               
        # Returns a set of itself and all of its nested children
        # Pass :exclude => item, or id, or [items or id] to exclude one or more items and all their descendants
        def full_set(special=nil)
          if special && special[:exclude]
            transaction do
              # exclude some items and all their children
              special[:exclude] = [special[:exclude]] if !special[:exclude].is_a?(Array)
              # get objects for ids
              special[:exclude].collect! {|s| s.is_a?(self.class) ? s : self.class.find(s)}.uniq
              # generate a set of conditions-- better performance than calling full_set to get list of IDs
              exclude_conditions = special[:exclude].map{|e| "(#{left_col_name} >= #{e[left_col_name]} AND #{right_col_name} <= #{e[right_col_name]})" }.join(' OR ')
              if exclude_conditions.blank?
                self.class.find(:all, :conditions => "#{scope_condition} AND (#{left_col_name} >= #{self[left_col_name]}) and (#{right_col_name} <= #{self[right_col_name]})", :order => left_col_name)
              else
                self.class.find(:all, :conditions => "#{scope_condition} AND NOT (#{exclude_conditions}) AND (#{left_col_name} >= #{self[left_col_name]}) and (#{right_col_name} <= #{self[right_col_name]})", :order => left_col_name)
              end
            end
          else
            return [self] if new_record? or self[right_col_name]-self[left_col_name] == 1
            self.class.find(:all, :conditions => "#{scope_condition} AND (#{left_col_name} >= #{self[left_col_name]}) and (#{right_col_name} <= #{self[right_col_name]})", :order => left_col_name)
          end
        end
                  
        # Returns a set of all of its children and nested children
        # Pass :exclude => item, or id, or [items or id] to exclude one or more items and all their descendants
        def all_children(special=nil)
          full_set(special) - [self]
        end

        # Returns a set of only this entry's immediate children
        def children
            self.class.find(:all, :conditions => "#{scope_condition} AND #{parent_col_name} = #{self.id}", :order => left_col_name)
        end
        
        alias direct_children children
        
        # Check one node and everything below it. Slow. Throws ActiveRecord::ActiveRecordError if it finds a problem.
        def check_subtree
          ## Would wrapping this in a transaction prevent the table from being updated while the check was in progress?
          if children.empty?
            unless self[left_col_name] and self[right_col_name]
              raise ActiveRecord::ActiveRecordError, "#{self.class.name}##{self.id}.#{right_col_name} or #{left_col_name} is blank"
            end
            unless self[right_col_name] - self[left_col_name] == 1
              raise ActiveRecord::ActiveRecordError, "#{self.class.name}##{self.id}.#{right_col_name} should be 1 greater than #{left_col_name}"
            end
          else
            n = self[left_col_name]
            for c in (children) # the children come back ordered by lft
              unless c[left_col_name] and c[right_col_name]
                raise ActiveRecord::ActiveRecordError, "#{self.class.name}##{c.id}.#{right_col_name} or #{left_col_name} is blank"
              end
              unless c[left_col_name] == n + 1
                raise ActiveRecord::ActiveRecordError, "#{self.class.name}##{c.id}.#{left_col_name} should be 1 greater than #{n}"
              end
              c.check_subtree
              n = c[right_col_name]
            end
            unless self[right_col_name] == n + 1
              raise ActiveRecord::ActiveRecordError, "#{self.class.name}##{self.id}.#{right_col_name} should be 1 greater than #{n}"
            end
          end
          return true
        end
        
        # Check the entire tree this node belongs to. Slow. Throws ActiveRecord::ActiveRecordError if it finds a problem.
        def check_full_tree
          ## May not work with virtual roots
          ## should we enforce root.lft = 1 ?
          # this method is needed because check_subtree alone cannot find orphaned nodes or endless loops
          root.check_subtree
          unless self.class.count(:conditions => "#{scope_condition}") == root.children_count + 1
            raise ActiveRecord::ActiveRecordError, "There appear to be orphaned nodes or endless loops in the tree where #{scope_condition}"
          end
          return true
        end
        
        # Adds a child to this object in the tree.  If this object hasn't been initialized,
        # it gets set up as a root node.  Otherwise, this method will update all of the
        # other elements in the tree and shift them to the right, keeping everything
        # balanced. 
        #
        # Deprecated, will be removed in next versions
        def add_child(child)
          self.reload; child.reload # for compatibility with old version
          # the old version allows records with nil values for lft and rgt
          unless self[left_col_name] && self[right_col_name]
            if child[left_col_name] || child[right_col_name]
              raise ActiveRecord::ActiveRecordError, "If parent lft or rgt are nil, you can't add a child with non-nil lft or rgt"
            end
            self.class.update_all("#{left_col_name} = CASE \
                                        WHEN id = #{self.id} \
                                          THEN 1 \
                                        WHEN id = #{child.id} \
                                          THEN 3 \
                                        ELSE #{left_col_name} END, \
                                   #{right_col_name} = CASE \
                                        WHEN id = #{self.id} \
                                          THEN 2 \
                                        WHEN id = #{child.id} \
                                          THEN 4 \
                                       ELSE #{right_col_name} END",
                                    scope_condition)
            self.reload; child.reload
          end
          unless child[left_col_name] && child[right_col_name]
            maxright = self.class.maximum(right_col_name, :conditions => scope_condition) || 0
            self.class.update_all("#{left_col_name} = CASE \
                                        WHEN id = #{child.id} \
                                          THEN #{maxright + 1} \
                                        ELSE #{left_col_name} END, \
                                    #{right_col_name} = CASE \
                                        WHEN id = #{child.id} \
                                          THEN #{maxright + 2} \
                                        ELSE #{right_col_name} END",
                                    scope_condition)
            child.reload
          end
          
          if self.children.empty?
            child.move_to_child_of(self)
          else
            child.move_to_right_of(self.children.last) # old method adds to right of right-most child
          end
          self.reload ## even though move_to calls target.reload, at least one object in the tests was not reloading (near the end of test_common_usage)
          
        # self.reload
        # child.reload
        #
        # if child.root?
        #   raise ActiveRecord::ActiveRecordError, "Adding sub-tree isn\'t currently supported"
        # else
        #   if ( (self[left_col_name] == nil) || (self[right_col_name] == nil) )
        #     # Looks like we're now the root node!  Woo
        #     self[left_col_name] = 1
        #     self[right_col_name] = 4
        #     
        #     # What do to do about validation?
        #     return nil unless self.save
        #     
        #     child[parent_col_name] = self.id
        #     child[left_col_name] = 2
        #     child[right_col_name]= 3
        #     return child.save
        #   else
        #     # OK, we need to add and shift everything else to the right
        #     child[parent_col_name] = self.id
        #     right_bound = self[right_col_name]
        #     child[left_col_name] = right_bound
        #     child[right_col_name] = right_bound + 1
        #     self[right_col_name] += 2
        #     self.class.transaction {
        #       self.class.update_all( "#{left_col_name} = (#{left_col_name} + 2)",  "#{scope_condition} AND #{left_col_name} >= #{right_bound}" )
        #       self.class.update_all( "#{right_col_name} = (#{right_col_name} + 2)",  "#{scope_condition} AND #{right_col_name} >= #{right_bound}" )
        #       self.save
        #       child.save
        #     }
        #   end
        # end                                   
        end
        
        # Move the node to the left of another node (you can pass id only)
        def move_to_left_of(node)
            self.move_to node, :left
        end
        
        # Move the node to the left of another node (you can pass id only)
        def move_to_right_of(node)
            self.move_to node, :right
        end
        
        # Move the node to the child of another node (you can pass id only)
        def move_to_child_of(node)
            self.move_to node, :child
        end
        
        protected 
        def move_to(target, position)
          raise ActiveRecord::ActiveRecordError, "You cannot move a new node" if new_record?
          raise ActiveRecord::ActiveRecordError, "You cannot move a node if left or right is nil" unless self[left_col_name] && self[right_col_name]
          
          transaction do # prevent the lft/rgt values from being altered before we run the update statement
            self.reload # if the lft/rgt values have been changed since the object was loaded
            target.reload
            
            # use shorter names for readability: current left and right
            cur_left, cur_right = self[left_col_name], self[right_col_name]
          
            # extent is the width of the tree self and children
            extent = cur_right - cur_left + 1
          
            # load object if node is not an object
            if !(self.class === target)
              target = self.class.find(target)
            end
            target_left, target_right = target[left_col_name], target[right_col_name]
          
            # detect impossible move
            if (target_left >= cur_left) && (target_right <= cur_right)
              raise ActiveRecord::ActiveRecordError, "Impossible move, target node cannot be inside moved tree."
            end
          
            # compute new left/right for self
            if position == :child
              if target_left < cur_left
                new_left  = target_left + 1
                new_right = target_left + extent
              else
                new_left  = target_left - extent + 1
                new_right = target_left
              end
            elsif position == :left
              if target_left < cur_left
                new_left  = target_left
                new_right = target_left + extent - 1
              else
                new_left  = target_left - extent
                new_right = target_left - 1
              end
            elsif position == :right
              if target_right < cur_right
                new_left  = target_right + 1
                new_right = target_right + extent 
              else
                new_left  = target_right - extent + 1
                new_right = target_right
              end
            else
              raise ActiveRecord::ActiveRecordError, "Position should be either left or right ('#{position}' received)."
            end          
          
            # boundaries of update action
            b_left, b_right = [cur_left, new_left].min, [cur_right, new_right].max
          
            # Shift value to move self to new position
            shift = new_left - cur_left
          
            # Shift value to move nodes inside boundaries but not under self_and_children
            updown = (shift > 0) ? -extent : extent
          
            # change nil to NULL for new parent
            if position == :child
              new_parent = target.id
            else
              new_parent = target[parent_col_name].nil? ? 'NULL' : target[parent_col_name]
            end
          
            # update and that rules
            self.class.update_all( "#{left_col_name} = CASE \
                                        WHEN #{left_col_name} BETWEEN #{cur_left} AND #{cur_right} \
                                          THEN #{left_col_name} + #{shift} \
                                        WHEN #{left_col_name} BETWEEN #{b_left} AND #{b_right} \
                                          THEN #{left_col_name} + #{updown} \
                                        ELSE #{left_col_name} END, \
                                    #{right_col_name} = CASE \
                                        WHEN #{right_col_name} BETWEEN #{cur_left} AND #{cur_right} \
                                          THEN #{right_col_name} + #{shift} \
                                        WHEN #{right_col_name} BETWEEN #{b_left} AND #{b_right} \
                                          THEN #{right_col_name} + #{updown} \
                                        ELSE #{right_col_name} END, \
                                    #{parent_col_name} = CASE \
                                        WHEN #{self.class.primary_key} = #{self.id} \
                                          THEN #{new_parent} \
                                        ELSE #{parent_col_name} END",
                                    scope_condition )
            self.reload
            target.reload
          end
        end
        
      end
      
    end
  end
end
