require_relative 'framework'

Cube = Struct.new(:x0, :y0, :z0, :x1, :y1, :z1)

class Cube
  def self.parse(str)
    pairs = {}
    for part in str.split(',')
      lhs, rhs = part.split('=')
      pairs[lhs] = rhs.split('..').map(&:to_i)
    end
    new(*pairs.values_at('x', 'y', 'z').transpose.flatten)
  end

  def include?(other)
    common = self & other
    !common.nil? && common.volume == other.volume
  end

  def volume
    (x1 - x0 + 1) * (y1 - y0 + 1) * (z1 - z0 + 1)
  end

  def &(other)
    new_x0 = [x0, other.x0].max
    new_x1 = [x1, other.x1].min
    return nil unless new_x0 <= new_x1
    new_y0 = [y0, other.y0].max
    new_y1 = [y1, other.y1].min
    return nil unless new_y0 <= new_y1
    new_z0 = [z0, other.z0].max
    new_z1 = [z1, other.z1].min
    return nil unless new_z0 <= new_z1
    Cube.new(new_x0, new_y0, new_z0, new_x1, new_y1, new_z1)
  end

  def sub(other)
    common = self & other
    return [self] if common.nil?
    result = []
    xs = [[self.x0, common.x0 - 1], [common.x0, common.x1], [common.x1 + 1, self.x1]].select { |(x0, x1)| x0 <= x1 }
    ys = [[self.y0, common.y0 - 1], [common.y0, common.y1], [common.y1 + 1, self.y1]].select { |(y0, y1)| y0 <= y1 }
    zs = [[self.z0, common.z0 - 1], [common.z0, common.z1], [common.z1 + 1, self.z1]].select { |(z0, z1)| z0 <= z1 }
    for x0, x1 in xs
      for y0, y1 in ys
        for z0, z1 in zs
          cube = Cube.new(x0, y0, z0, x1, y1, z1)
          result << cube unless cube == common
        end
      end
    end
    result
  end
end

class Region
  attr_reader :cubes

  def initialize(*cubes)
    @cubes = cubes
  end

  def volume
    @cubes.inject(0) { |sum, cube| sum + cube.volume }
  end

  def add(other)
    new_region = Region.new(other)
    @cubes.each { |cube| new_region.sub(cube) }
    @cubes.concat(new_region.cubes)
  end

  def sub(other)
    @cubes = @cubes.flat_map { |cube| cube.sub(other) }
  end
end

initialization_cube = Cube.new(-50, -50, -50, 50, 50, 50)
input = get_input(22)
region = Region.new
input.each_line do |line|
  state, line = line.split(' ', 2)
  cube = Cube.parse(line)
  #next unless initialization_cube.include?(cube)
  if state == 'on'
    region.add(cube)
  else
    region.sub(cube)
  end
end
puts region.volume
