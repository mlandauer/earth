class Size
  attr_accessor :bytes, :blocks, :count
  
  def initialize(bytes, blocks, count)
    @bytes = bytes
    @blocks = blocks
    @count = count
  end
  
  def +(size)
    Size.new(bytes + size.bytes, blocks + size.blocks, count + size.count)
  end

  def -(size)
    Size.new(bytes - size.bytes, blocks - size.blocks, count - size.count)
  end
end
