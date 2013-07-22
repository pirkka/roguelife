# Pirkka's diamond square algorithm
# creates a height map with values between -1 and +1
class BlingSquare
  
  def initialize(n, seed=0)
    @seed = 0
    @size = 2**n + 1
    puts "BlingSquare size #{@size}"
    @height_map = Array.new(@size) { Array.new(@size) }
    puts "Height map rows: #{@height_map.size}"
    puts "Height map cols: #{@height_map[0].size}"
    self.execute(0, 0, @size-1, @size-1, seed, 1.0)
  end
  
  def execute(x1,y1,x2,y2,seed,h)
    # diamond step
    northwest = @height_map[x1][y1] ? @height_map[x1][y1] : seed
    northeast = @height_map[x2][y1] ? @height_map[x2][y1] : seed
    southwest = @height_map[x1][y2] ? @height_map[x1][y2] : seed
    southeast = @height_map[x2][y2] ? @height_map[x2][y2] : seed
    naive_centerpoint = self.avg [northwest,northeast,southwest,southeast]
    puts "---"
    puts "naive_centerpoint: #{naive_centerpoint}"
    random_component = rand() * h * 2 - h
    puts "random component: #{random_component}"
    centerpoint = naive_centerpoint + random_component
    puts "centerpoint: #{centerpoint}"
    centerpoint_x = x1+x2/2
    centerpoint_y = y1+y2/2
    @height_map[centerpoint_y][centerpoint_x] = centerpoint
    # square step
    # calculate n,w,e,s
    # first north
    naive_north = self.avg([get_value(x1,y1), get_value(x2,y1), get_value(x1+x2/2, y1+y2/2), get_value(x1+x2/2, y1-y2/2)])
    north = naive_north + get_random_component(h)
    @height_map[y1][centerpoint_x] = north
    puts "north: #{north}"
  end

  def get_random_component(h)
    rand() * h * 2 - h
  end
  
  def get_value(x,y)
    # returns seed if not found
    # if goes over bounds, goes to the other end of the map (endless world)
    if x > @size-1
      x = x - @size
    end
    if y > @size-1
      y = y - @size
    end
    return @height_map[x][y] ? @height_map[x][y] : @seed
  end
  
  def get_map
    @height_map
  end
  
  def avg(list)
    list.reduce(:+).to_f / list.size
  end
  
end