class Monitor
  def initialize(directory)
  end
  
  def exist?(file)
    File.exist?(file)
  end
end
