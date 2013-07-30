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

    @max_x = @world_width - 1 - @width
    @max_y = @world_height - 1 - @width
    
  end
  
  def end_x
    @x + @width - 1
  end
  
  def end_y
    @y + @height - 1
  end
  
  def move_horizontal(amount_x)
    @x += amount_x
    if @x > @max_x
      @x = @max_x
    end
    if @x < 0
      @x = 0
    end
    puts "viewport x is #{@x}"
  end

  def move_vertical(amount_y)
    @y += amount_y
    if @y > @max_y
      @y = @max_y
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
    puts "x: x min_distance_to_border: #{min_distance_to_border} end_x: #{self.end_x} @max_x: #{@max_x}"
    if x + min_distance_to_border > self.end_x && x < @max_x
      puts 'skroll to increment x'
      # self.move_horizontal(min_distance_to_border)
      self.move_horizontal(1)
    end
    if x - min_distance_to_border < @x && @x > 0
      puts 'skroll to decrement'
      # self.move_horizontal(- min_distance_to_border)
      self.move_horizontal(-1)
    end
    if y + min_distance_to_border > self.end_y && y < @max_y
      puts 'skroll to increment y'
      # self.move_vertical(min_distance_to_border)
      self.move_vertical(1)
    end
    if y - min_distance_to_border < @y && @y > 0
      puts 'skroll to decrement'
      # self.move_vertical(- min_distance_to_border)
      self.move_vertical(-1)
    end
  end
  
end