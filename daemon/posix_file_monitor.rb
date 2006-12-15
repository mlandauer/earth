class PosixFileMonitor
  def initialize(directory)
    @directory = directory
  end
  
  def directory_added(directory)
    snapshot = Snapshot.new(directory, self)
    snapshot.update
  end

  def update
    @directory.each do |directory|
      snapshot = Snapshot.new(directory, self)
      snapshot.update
    end
  end
end
