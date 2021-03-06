# Pirkka's diamond square algorithm
# creates a height map with values between -1 and +1

# TODO: WRAPPING MODE
# Note that two values are highlighted in black. They are actually the same value. Every time you calculate a value on the edge during the square step, make sure to also store it on the opposite side of the array. These points need to be exactly the same in order for seamless wrapping to occur.

class BlingSquare
  
  def initialize(n, seed=0, range=2.0, h=1.0, c=2)
    @min = 0
    @max = 0
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
    
    self.recurse_squares(1, range, h, c)
    
    
  end
  
  def recurse_squares(level=1, range, h, c)

    # let's drill down the whole map part by part
    segment_size = (@size.to_f/(2**(level-1))).ceil
    
    puts "Drilldown #{level} range: -#{range/2} to #{range/2} h: #{h} segment size: #{segment_size}"

    if segment_size < 3
      puts "height map generated - min: #{@min} max: #{@max} "
      return
    end

    sections_per_dimension = (@size-1)/(segment_size-1)
    puts "<><><><> applying diamond to #{sections_per_dimension**2} segments"

    x1 = 0
    y1 = 0

    while y1 < @size-1 do 
      y2 = y1 + segment_size - 1
      while x1 < @size-1 do 
        x2 = x1 + segment_size - 1
        self.execute_diamond_step(x1, y1, x2, y2, range)
        x1 = x2
      end
      y1 = y2
      x1 = 0
    end


    puts "[][][][] applying square to #{sections_per_dimension**2} segments"

    x1 = 0
    y1 = 0

    while y1 < @size-1 do 
      y2 = y1 + segment_size - 1
      while x1 < @size-1 do 
        x2 = x1 + segment_size - 1
        self.execute_square_step(x1, y1, x2, y2, range)
        x1 = x2
      end
      y1 = y2
      x1 = 0
    end


    
    recurse_squares(level+1, range*(c**-h), h, c)
  end
  
  def execute_diamond_step(x1,y1,x2,y2,range)
    # puts "Diamond Step at #{x1},#{y1} - #{x2},#{y2} - h: #{h}"
    # diamond step
    northwest = get_value x1,y1
    northeast = get_value x2,y1
    southwest = get_value x1,y2
    southeast = get_value x2,y2
    naive_centerpoint = self.avg [northwest,northeast,southwest,southeast]
    random_component = rand() * range - range / 2
    centerpoint = naive_centerpoint + random_component
    centerpoint_x = (x1+x2)/2
    centerpoint_y = (y1+y2)/2
    set(centerpoint_x, centerpoint_y, centerpoint)
  end
  
  def set(x,y,v)
    # puts "setting (#{x},#{y}) --> #{v}"
    @height_map[y][x] = v
    
    if v > @max
      @max = v
    end
    if v < @min
      @min = v
    end
  end
  
  def execute_square_step(x1,y1,x2,y2,range)
    # puts "Square Step at #{x1},#{y1} - #{x2},#{y2} - range: #{range}"
    # square step
    centerpoint_x = (x1+x2)/2
    centerpoint_y = (y1+y2)/2
    # calculate n,w,e,s
    # first north
    #puts 'north'
    naive_north = self.avg([get_value(x1,y1), get_value(x2,y1), get_value((x1+x2)/2, (y1+y2)/2), get_value((x1+x2)/2, y1-((y2-y1)/2))])
    north = naive_north + get_random_component(range)
    set(centerpoint_x,y1,north)

    #puts 'south'
    naive_south = self.avg([get_value(x1,y2), get_value(x2,y2), get_value((x1+x2)/2, (y1+y2)/2), get_value((x1+x2)/2, y2+(y2-y1)/2)])
    south = naive_south + get_random_component(range)
    set(centerpoint_x,y2,south)

    #puts 'west'
    naive_west = self.avg([get_value(x1,y1), get_value(x1,y2), get_value((x1+x2)/2, (y1+y2)/2), get_value(x1-(x2-x1)/2, (y1+y2)/2)])
    west = naive_west + get_random_component(range)
    set(x1,centerpoint_y,west)

    #puts 'east'
    naive_east = self.avg([get_value(x2,y1), get_value(x2,y2), get_value((x1+x2)/2, (y1+y2)/2), get_value(x2+(x2-x1)/2, (y1+y2)/2)])
    east = naive_east + get_random_component(range)
    set(x2,centerpoint_y, east)
        
  end

  def get_random_component(range)
    x = rand() * range - range/2
    # puts "random component: #{x}"
    return x
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