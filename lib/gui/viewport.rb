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
  
  def move_horizontal(amount_x)
    @x += amount_x
    @x_max = @world_width - 1 - @width
    if @x > @x_max
      @x = @x_max
    end
    if @x < 0
      @x = 0
    end
    puts "viewport x is #{@x}"
  end

  def move_vertical(amount_y)
    @y += amount_y
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
  
  def min_distance_to_border
    smaller_viewport_size = [@width, @height].min
    return smaller_viewport_size / 4 # one quarter of the viewport size
  end
  
  def update_for_player_at(x,y)
    if x + min_distance_to_border > self.end_x
      puts 'skroll to increment x'
      # self.move_horizontal(min_distance_to_border)
      self.move_horizontal(1)
    end
    if x - min_distance_to_border < @x
      puts 'skroll to decrement'
      # self.move_horizontal(- min_distance_to_border)
      self.move_horizontal(-1)
    end
    if y + min_distance_to_border > self.end_y
      puts 'skroll to increment y'
      # self.move_vertical(min_distance_to_border)
      self.move_vertical(1)
    end
    if y - min_distance_to_border < @y
      puts 'skroll to decrement'
      # self.move_vertical(- min_distance_to_border)
      self.move_vertical(-1)
    end
  end
  
end