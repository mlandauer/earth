class PosixFileMonitor
  def initialize(directory)
    @directory = directory
  end
  
  def directory_added(directory)
    Snapshot.update(directory, self)
  end

  def update
    @directory.each do |directory|
      Snapshot.update(directory, self)
    end
  end
end
