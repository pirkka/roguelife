class Viewport
  
  attr_reader :x, :y, :width, :height, :world_width, :world_height
  
  def initialize(x,y,width,height,world_width,world_height)
    @x = x
    @y = y
    @width = width
    @height = height
    @world_width = world_width
    @world_height = world_height
    
    # sanity check for small worlds
    if @width > @world_width
      @width = @world_width
    end
    if @height > @world_height
      @height = @world_height
    end
    
  end
  
  def end_x
    @x + @width - 1
  end
  
  def end_y
    @y + @height - 1
  end
  
  def move_horizontal(new_x)
    @x += new_x
    @x_max = @world_width - 1 - @width
    if @x > @x_max
      @x = @x_max
    end
    if @x < 0
      @x = 0
    end
    puts "viewport x is #{@x}"
  end

  def move_vertical(new_y)
    @y += new_y
    @y_may = @world_height - 1 - @width
    if @y > @y_may
      @y = @y_may
    end
    if @y < 0
      @y = 0
    end
    puts "viewport y is #{@y}"
  end
  
  #utility function
  def contains(thing)
    thing.x >= @x && thing.x <= self.end_x && thing.y >= @y && thing.y <= self.end_y
  end
  
end