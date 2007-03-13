class Size
  include Comparable
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
  
  def ==(size)
    bytes == size.bytes && blocks == size.blocks && count == size.count
  end

  def <=>(anOther)
    bytes <=> anOther.bytes
  end

  def to_s
    units = ApplicationHelper::human_units_of(bytes)
    "#{ApplicationHelper::human_size_in(units, bytes)} #{units}"
  end
end
