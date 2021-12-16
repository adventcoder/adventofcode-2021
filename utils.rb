class Heap
  def initialize(values = nil, &block)
    @array = [nil]
    @block = block
    unless values.nil?
      @array.concat(values)
      last_parent = (@array.size - 1) << 1
      last_parent.downto(1) { |i| heapify_down(i) }
    end
  end

  def empty?
    @array.size == 1
  end

  def size
    @array.size - 1
  end

  def peek
    @array[1]
  end

  def pop
    return nil if @array.size == 1
    swap(1, @array.size - 1)
    value = @array.pop
    heapify_down(1)
    value
  end

  def <<(value)
    @array << value
    heapify_up(@array.size - 1)
    self
  end

  def heapify_up(i)
    while i > 1
      p = i >> 1
      return if min(i, p) == p
      swap(i, p)
      i = p
    end
  end

  def heapify_down(i)
    loop do
      l = (i << 1) | 0
      r = (i << 1) | 1
      if r < @array.size
        c = min(l, r)
      elsif l < @array.size
        c = l
      else
        break
      end
      return if min(i, c) == i
      swap(i, c)
      i = c
    end
  end

  def min(l, r)
    if @block.nil?
      @array[l] < @array[r] ? l : r
    else
      @block.call(@array[l], @array[r]) < 0 ? l : r
    end
  end

  def swap(l, r)
    t = @array[l]
    @array[l] = @array[r]
    @array[r] = t
  end
end
