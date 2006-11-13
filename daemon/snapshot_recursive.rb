class SnapshotRecursive
  attr_reader :snapshots, :stats

  def initialize(directory = nil)
    # These are hashes that map from the name to the properties
    @stats = Hash.new
    @snapshots = Hash.new

    unless directory.nil?
      # Internally store everything as absolute path
      directory = File.expand_path(directory)
      if File.lstat(directory).readable?
        entries = Dir.entries(directory)
        # Ignore all files and directories starting with '.'
        entries.delete_if {|x| x[0,1] == "."}
    
        # Make absolute paths
        entries.map!{|x| File.join(directory, x)}
        
        filenames, subdirectories = entries.partition{|f| File.file?(f)}
        @stats.clear
        filenames.each do |f|
          @stats[f] = File.lstat(f)
        end
        @snapshots.clear
        subdirectories.each do |d|
          snapshot = SnapshotRecursive.new(d)
          @snapshots[d] = snapshot
        end
      end
    end
  end
  
  def subdirectory_names
    @snapshots.keys
  end
  
  def file_names
    @stats.keys
  end

  # Returns the snapshot object which has a particular file
  # Searches recursively down from here
  # If can't be found returns nil
  def snapshot_with_file(path)
    if file_names.include?(path)
      return self
    else
      @snapshots.each_value do |snapshot|
        s = snapshot.snapshot_with_file(path)
        if !s.nil?
          return s
        end
      end
      nil
    end
  end
  
  def exist?(path)
    !snapshot_with_file(path).nil?
  end
  
  def stat(path)
    snapshot_with_file(path).stats[path]
  end
end
