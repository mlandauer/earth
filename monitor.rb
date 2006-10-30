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
    @filenames, dirs = Dir.entries(@directory).partition{|f| File.file?(File.join(@directory, f))}
    @filenames.map!{|f| File.join(@directory, f)}
    dirs.delete(".")
    dirs.delete("..")
    @monitors = dirs.map{|d| Monitor.new(File.join(@directory, d))}
    @monitors.each{|m| m.update}
  end
end
