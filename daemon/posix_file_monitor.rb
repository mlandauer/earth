class PosixFileMonitor
  def initialize(directory)
    @directory = directory
  end
  
  def update
    @directory.each do |directory|
      Snapshot.update(directory)
    end
  end
end
