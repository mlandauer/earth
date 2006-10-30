class Monitor
  def initialize(directory)
    @directory = directory
    @filenames = []
  end
  
  def exist?(relative_path)
    @filenames.include?(relative_path)
  end
  
  def update
    @filenames = Dir.entries(@directory)
  end
end
