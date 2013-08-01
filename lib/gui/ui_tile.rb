# Immutable instances plz
class Point
  
  attr_reader :x, :y
  
  def initialize(x,y)
    @x = x
    @y = y
  end
  
  def to_s
    "Point (#{@x},#{@y})"  
  end
end

class UITile

  attr_reader :x, :y, :altitude, :p1, :p2, :p3, :p4, :f1, :f2, :f3, :f4, :fs1, :fs2, :fs3, :fs4

  def initialize(x, y, altitude, viewport_x, viewport_y, viewport_end_x, viewport_end_y)
    @x = x
    @y = y
    @altitude = altitude
    
    # square tile corners
    
    pixel_x = (x - viewport_x) * UISettings::TileSize
    pixel_y = (y - viewport_y) * UISettings::TileSize
    
    
    @p1 = Point.new(pixel_x, pixel_y) 
    @p2 = Point.new(pixel_x, pixel_y+UISettings::TileSize)
    @p3 = Point.new(pixel_x+UISettings::TileSize,pixel_y+UISettings::TileSize)
    @p4 = Point.new(pixel_x+UISettings::TileSize,pixel_y)

    # puts "square tile points: #{p1} #{p2} #{p3} #{p4}"

    # not implemented: square tile shadows

    # fuzzed tile corners
    fuzz_randomizer = Random.new(x+y) # i feel more comfy seeding the randomizer with the map x,y instead of pixel x,y
    @f1 = Point.new(@p1.x - fuzz_amount(fuzz_randomizer.rand), @p1.y - fuzz_amount(fuzz_randomizer.rand))
    @f2 = Point.new(@p2.x - fuzz_amount(fuzz_randomizer.rand), @p2.y + fuzz_amount(fuzz_randomizer.rand))
    @f3 = Point.new(@p3.x + fuzz_amount(fuzz_randomizer.rand), @p3.y + fuzz_amount(fuzz_randomizer.rand))
    @f4 = Point.new(@p4.x + fuzz_amount(fuzz_randomizer.rand), @p4.y - fuzz_amount(fuzz_randomizer.rand))    

    # fuzzed tile corners - TODO: make size independent of fuzz amount
    fuzz_randomizer = Random.new(x+y) # i feel more comfy seeding the randomizer with the map x,y instead of pixel x,y
    @fs1 = Point.new(@p1.x - fuzz_amount(fuzz_randomizer.rand * 2), @p1.y - fuzz_amount(fuzz_randomizer.rand) * 2)
    @fs2 = Point.new(@p2.x - fuzz_amount(fuzz_randomizer.rand * 2), @p2.y + fuzz_amount(fuzz_randomizer.rand) * 2)
    @fs3 = Point.new(@p3.x + fuzz_amount(fuzz_randomizer.rand * 2), @p3.y + fuzz_amount(fuzz_randomizer.rand) * 2)
    @fs4 = Point.new(@p4.x + fuzz_amount(fuzz_randomizer.rand * 2), @p4.y - fuzz_amount(fuzz_randomizer.rand) * 2)    

    # base color
    @c = background_color

    # gradient colors
    @c_bright = background_color(UISettings::TileGradient)
    @c_dim = background_color(-UISettings::TileGradient)
    
  end

  def fuzz_amount(rando)
    (UISettings::TileSize * rando * 0.1).round
  end
 
  def draw_square_tile
    @@game_window.draw_quad(@p1.x, @p1.y, @c_bright, @p2.x, @p2.y, @c, @p3.x, @p3.y, @c_dim, @p4.x, @p4.y, @c, 0)    
  end
 
  
  def to_s
    "UITile at (#{@x},#{@y}) with altitude #{@altitude}"
  end
  
  # def color
  #   @color = Gosu::Color.new(0xff000000)
  #   @color.red = rand(256 - 40) + 40
  #   @color.green = rand(256 - 40) + 40
  #   @color.blue = rand(256 - 40) + 40
  # end

  def background_color(brightness_modifier=0)  
    if !@altitude
      @altitude = 0
    end
    saturation = 100
    brightness = @altitude
    hue = 130 #green
    if @altitude < 10
      hue = 200 # blue
      brightness += 40
    end
    if @altitude > 70
      hue = 30 # brown
      saturation = 50
      brightness -= 30
    end
    if @altitude > 90
      brightness = 100 #ice
      saturation = 0
    end
    
    brightness += brightness_modifier
    brightness = 100 if brightness > 100
    brightness = 0 if brightness < 0
    
    
    ColorConversion.hsl_to_gosu(hue, saturation, brightness)
  end

  
  # takes an input of game world tiles and creates a height-sorted array of UITiles
  def self.create_set(game_window, height_map, viewport_x, viewport_y, viewport_end_x, viewport_end_y)
    
    @@game_window = game_window
    
    arr = []
    for y in viewport_y..viewport_end_y
      for x in viewport_x..viewport_end_x
        arr << UITile.new(x,y,height_map[y][x], viewport_x, viewport_y, viewport_end_x, viewport_end_y)
      end
    end
    
    retval = arr.sort{|x,y| x.altitude <=> y.altitude}
    
#    puts "UI TILE SET: #{retval}"
    
    return retval
  end
  
end