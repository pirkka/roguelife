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
    
    @height_map[0][0] = seed
    @height_map[0][@size-1] = seed
    @height_map[@size-1][0] = seed
    @height_map[@size-1][@size-1] = seed
    
    self.execute(0, 0, @size-1, @size-1, 1.0)
  end
  
  def execute(x1,y1,x2,y2,h)
    puts "EXECUTING at #{x1},#{y1} - #{x2},#{y2} - h: #{h}"
    # diamond step
    northwest = get_value x1,y1
    northeast = get_value x2,y1
    southwest = get_value x1,y2
    southeast = get_value x2,y2
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
    naive_north = self.avg([get_value(x1,y1), get_value(x2,y1), get_value(x1+x2/2, y1+y2/2), get_value(x1+x2/2, y1+(y1-y2/2))])
    north = naive_north + get_random_component(h)
    @height_map[y1][centerpoint_x] = north
    puts "north: #{north}"

    naive_south = self.avg([get_value(x1,y2), get_value(x2,y2), get_value(x1+x2/2, y1+y2/2), get_value(x1+x2/2, y2+(y2-y1)/2)])
    south = naive_south + get_random_component(h)
    @height_map[y2][centerpoint_x] = south
    puts "south: #{south}"

    naive_west = self.avg([get_value(x1,y1), get_value(x1,y2), get_value(x1+x2/2, y1+y2/2), get_value(x1-(x2-x1)/2, y1+y2/2)])
    west = naive_west + get_random_component(h)
    @height_map[centerpoint_y][x1] = west
    puts "west: #{west}"

    naive_east = self.avg([get_value(x2,y1), get_value(x2,y2), get_value(x1+x2/2, y1+y2/2), get_value(x2+(x2-x1)/2, y1+y2/2)])
    east = naive_east + get_random_component(h)
    @height_map[centerpoint_y][x2] = east
    puts "east: #{east}"
    
    # and finally - recurse...

    # first diamond steps - these need to be done before the square steps :7
    # then square steps
    # execute(x1,y1,(x1+x2)/2,(y1+y2)/2,h/2)
    
  end

  def get_random_component(h)
    rand() * h * 2 - h
  end
  
  def get_value(x,y)
    puts "get value(#{x},#{y})..."
    # returns seed if not found
    # if goes over bounds, goes to the other end of the map (endless world)
    if x > @size-1
      x = x - @size + 1
    end
    if x < 0
      x = @size - 1 + x
    end
    if y > @size-1
      y = y - @size + 1
    end
    if y < 0
      y = @size - 1 + y
    end
    puts "... effective value(#{x},#{y}) --> #{@height_map[x][y]}"
    return @height_map[x][y]
  end
  
  def get_map
    @height_map
  end
  
  def avg(list)
    list.reduce(:+).to_f / list.size
  end
  
end