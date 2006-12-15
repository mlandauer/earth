class PosixFileMonitor
  def PosixFileMonitor.update_recursive(directory)
    directory.each do |d|
      Snapshot.update(d)
    end
  end
end
