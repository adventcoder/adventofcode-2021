class Heap
  def self.[](*values)
    new(values)
  end

  def initialize(values = [], &block)
    @values = values
    @block = block
    if @values.size > 1
      parent(@values.size - 1).downto(0) do |i|
        heapify_down(i)
      end
    end
  end

  def empty?; @values.empty?; end
  def size; @values.size; end

  def peek
    @values[0]
  end

  def pop
    return @values.pop if @values.size <= 1
    value = @values[0]
    @values[0] = @values.pop
    heapify_down(0)
    value
  end

  def <<(value)
    @values << value
    heapify_up(@values.size - 1)
    self
  end

  def heapify_up(i)
    value = @values[i]
    while i > 0
      p = parent(i)
      break if compare(value, @values[p]) >= 0
      @values[i] = @values[p]
      i = p
    end
    @values[i] = value
  end

  def heapify_down(i)
    value = @values[i]
    loop do
      l = left_child(i)
      break unless l < @values.size
      r = right_child(i)
      if r < @values.size && compare(@values[r], @values[l]) < 0
        break if compare(value, @values[r]) <= 0
        @values[i] = @values[r]
        i = r
      else
        break if compare(value, @values[l]) <= 0
        @values[i] = @values[l]
        i = l
      end
    end
    @values[i] = value
  end

  def compare(a, b)
    @block.nil? ? a <=> b : @block.call(a, b)
  end

  def parent(i); (i - 1) / 2; end
  def left_child(i); 2 * i + 1; end
  def right_child(i); 2 * i + 2; end
end
