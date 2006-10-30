class Monitor
  def initialize(directory)
    @directory = directory
    @filenames = []
    @monitors = []
  end
  
  def exist?(path)
    if @filenames.include?(path)
      true
    else
      @monitors.each do |monitor|
        if monitor.exist?(path)
          return true
        end
      end
      false
    end
  end
  
  def update
    entries = Dir.entries(@directory)
    entries.delete(".")
    entries.delete("..")

    # Make absolute paths
    entries.map!{|x| File.join(@directory, x)}
    
    @filenames, dirs = entries.partition{|f| File.file?(f)}
    @monitors = dirs.map {|d| Monitor.new(d)}
    @monitors.each{|m| m.update}
  end
end
