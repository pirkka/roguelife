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
    
    self.recurse_squares
    
    #self.execute(0, 0, @size-1, @size-1, 1.0)
  end
  
  def recurse_squares(level=1,h=1.0)

    # let's drill down the whole map part by part
    puts "------------------------------------"
    puts "Drilldown #{level} / #{h}"
    segment_size = (@size.to_f/(2**(level-1))).ceil
    puts "segment size is #{segment_size}"

    if segment_size < 3
      puts "end recurse"
      return
    end

    sections_per_dimension = (@size-1)/(segment_size-1)
    puts "Applying diamond to #{sections_per_dimension**2} segments"

    x1 = 0
    y1 = 0

    while y1 < @size-1 do 
      y2 = y1 + segment_size - 1
      while x1 < @size-1 do 
        x2 = x1 + segment_size - 1
        puts "<><><><>"
        self.execute_diamond_step(x1, y1, x2, y2, h)
        x1 = x2
      end
      y1 = y2
      x1 = 0
    end


    puts "Applying square to #{sections_per_dimension**2} segments"

    x1 = 0
    y1 = 0

    while y1 < @size-1 do 
      y2 = y1 + segment_size - 1
      while x1 < @size-1 do 
        x2 = x1 + segment_size - 1
        puts "[][][][]"
        self.execute_square_step(x1, y1, x2, y2, h)
        x1 = x2
      end
      y1 = y2
      x1 = 0
    end


    
    recurse_squares(level+1, h/2)
  end
  
  def execute_diamond_step(x1,y1,x2,y2,h)
    puts "Diamond Step at #{x1},#{y1} - #{x2},#{y2} - h: #{h}"
    # diamond step
    northwest = get_value x1,y1
    northeast = get_value x2,y1
    southwest = get_value x1,y2
    southeast = get_value x2,y2
    naive_centerpoint = self.avg [northwest,northeast,southwest,southeast]
    random_component = rand() * h * 2 - h
    centerpoint = naive_centerpoint + random_component
    centerpoint_x = (x1+x2)/2
    centerpoint_y = (y1+y2)/2
    set(centerpoint_x, centerpoint_y, centerpoint)
  end
  
  def set(x,y,v)
    puts "setting (#{x},#{y}) --> #{v}"
    @height_map[y][x] = v
  end
  
  def execute_square_step(x1,y1,x2,y2,h)
    puts "Square Step at #{x1},#{y1} - #{x2},#{y2} - h: #{h}"
    # square step
    centerpoint_x = (x1+x2)/2
    centerpoint_y = (y1+y2)/2
    # calculate n,w,e,s
    # first north
    puts 'north'
    naive_north = self.avg([get_value(x1,y1), get_value(x2,y1), get_value((x1+x2)/2, (y1+y2)/2), get_value((x1+x2)/2, y1-((y2-y1)/2))])
    north = naive_north + get_random_component(h)
    @height_map[y1][centerpoint_x] = north
    # puts "north: #{north}"

    puts 'south'
    naive_south = self.avg([get_value(x1,y2), get_value(x2,y2), get_value((x1+x2)/2, (y1+y2)/2), get_value((x1+x2)/2, y2+(y2-y1)/2)])
    south = naive_south + get_random_component(h)
    @height_map[y2][centerpoint_x] = south
    # puts "south: #{south}"

    puts 'west'
    naive_west = self.avg([get_value(x1,y1), get_value(x1,y2), get_value((x1+x2)/2, (y1+y2)/2), get_value(x1-(x2-x1)/2, (y1+y2)/2)])
    west = naive_west + get_random_component(h)
    @height_map[centerpoint_y][x1] = west
    # puts "west: #{west}"

    puts 'east'
    naive_east = self.avg([get_value(x2,y1), get_value(x2,y2), get_value((x1+x2)/2, (y1+y2)/2), get_value(x2+(x2-x1)/2, (y1+y2)/2)])
    east = naive_east + get_random_component(h)
    @height_map[centerpoint_y][x2] = east
    # puts "east: #{east}"
        
  end

  def get_random_component(h)
    rand() * h * 2 - h
  end
  
  def get_value(x,y)
    initial_x = x
    initial_y = y
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
    retval = @height_map[x][y]
    unless retval
      puts "VALUE NOT FOUND get(#{initial_x},#{initial_y}) -> effective value(#{x},#{y}) --> #{@height_map[x][y]}"
    end
    return @height_map[x][y]
  end
  
  def get_map
    @height_map
  end
  
  def avg(list)
    begin
      list.reduce(:+).to_f / list.size
    rescue
      raise 'x'
      puts "ERROR"
      return 0
    end
  end
  
end