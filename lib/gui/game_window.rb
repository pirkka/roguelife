require 'gosu'

module UISettings
  TileSize = 32
  WindowWidth = 910
  WindowHeight = 910
  TileMode = :fuzzed
  TileGradient = 5
end

module ZOrder
  Background, Tiles, Agents, Player, UI = *0..4
end

class GameWindow < Gosu::Window
  
  attr_accessor :game
  
  def initialize(game)
    super UISettings::WindowWidth, UISettings::WindowHeight, false
    self.caption = "Roguelife"
    @font = Gosu::Font.new(self, Gosu::default_font_name, UISettings::TileSize-2)
    @game = game
    @viewport = Viewport.new(0,0,UISettings::WindowWidth/UISettings::TileSize,UISettings::WindowHeight/UISettings::TileSize,@game.world.get_height_map.size,@game.world.get_height_map[0].size)
  end
  
  def update
    unless @game.world.player_with_turn # this is a roguelike so game world freezes when player has turn
      game.update # move the ai characters and generally advance the world state
    end
  end
  
  def draw
    update_viewport
    draw_tiles
    draw_agents
    draw_time
  end
  
  def scroll_amount
    UISettings::WindowWidth/UISettings::TileSize/2
  end
  
  def button_down(id)
    puts 'button down'
    if id == Gosu::KbEscape
      close
    end
    if id == Gosu::KbD
      @game.debug
    end
    if id == Gosu::KbA
      if @game.paused?
        if @game.world.player_with_turn
          return # doing nothing because it is player turn
        end
        @game.world.resolve_next_action
        @game.debug
      end
    end
    if id == Gosu::KbSpace
      if @game.paused?
        @game.unpause
      else
        @game.pause
      end
    end
    if id == Gosu::KbH
      @viewport.move_horizontal(-self.scroll_amount)
    end
    if id == Gosu::KbL
      @viewport.move_horizontal(self.scroll_amount)
    end
    if id == Gosu::KbJ
      @viewport.move_vertical(-self.scroll_amount)
    end
    if id == Gosu::KbK
      @viewport.move_vertical(self.scroll_amount)
    end
    
    if id == Gosu::KbUp
      @game.move_north
    end
    if id == Gosu::KbDown
      @game.move_south
    end
    if id == Gosu::KbLeft
      @game.move_west
    end
    if id == Gosu::KbRight
      @game.move_east
    end
    
    
  end
  
  # viewport
  def update_viewport
    if @game.player
      @viewport.update_for_player_at(@game.player.x, @game.player.y)
    end
  end
  
  # drawing
  def draw_tiles
    # puts "drawing tiles #{self.game.world.tiles.size}"
    tile_map = @game.world.get_height_map

    for y in @viewport.y..@viewport.end_y
      for x in @viewport.x..@viewport.end_x
        # draw_tile(x,y,tile_map[y][x])
      end
    end
    
    case UISettings::TileMode
    when :fuzzed
      # puts "fuzzing tiles"
      for y in @viewport.y..@viewport.end_y
        for x in @viewport.x..@viewport.end_x
          draw_fuzzed_tile(x,y,tile_map[y][x])
        end
      end
    when :square
      # do nothing
    end

    # test
    # c = define_background_color(90)
    # draw_quad(90, 100, c, 100, 200, c, 200, 134, c, 203, 150, c, 0)    
  end
  
  def draw_tile(x,y,a)
    pixel_x = (x - @viewport.x) * UISettings::TileSize
    pixel_y = (y - @viewport.y) * UISettings::TileSize
    c = define_background_color(a)
    draw_square(pixel_x,pixel_y,c)
    # @font.draw(a, UISettings::TileSize*x + 2, UISettings::TileSize*y + 1, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end

  def draw_fuzzed_tile(x,y,a)
    fuzz_randomizer = Random.new(x+y) # i feel more comfy seeding the randomizer with the map x,y instead of pixel x,y
    pixel_x = (x - @viewport.x) * UISettings::TileSize
    pixel_y = (y - @viewport.y) * UISettings::TileSize

    c = define_background_color(a)
    c_bright = define_background_color(a,UISettings::TileGradient)
    c_dim = define_background_color(a,-UISettings::TileGradient)

    x1 = pixel_x
    y1 = pixel_y
    x2 = pixel_x
    y2 = pixel_y + UISettings::TileSize
    x3 = pixel_x + UISettings::TileSize
    y3 = pixel_y + UISettings::TileSize
    x4 = pixel_x + UISettings::TileSize
    y4 = pixel_y
    
    x1 = x1 - fuzz_amount(fuzz_randomizer.rand)
    x2 = x2 - fuzz_amount(fuzz_randomizer.rand)
    x3 = x3 + fuzz_amount(fuzz_randomizer.rand)
    x4 = x4 + fuzz_amount(fuzz_randomizer.rand)
    y1 = y1 - fuzz_amount(fuzz_randomizer.rand)
    y2 = y2 + fuzz_amount(fuzz_randomizer.rand)
    y3 = y3 + fuzz_amount(fuzz_randomizer.rand)
    y4 = y4 - fuzz_amount(fuzz_randomizer.rand)
    
    #puts "#{x1},#{y1} #{x2},#{y2} #{x3},#{y3} #{x4},#{y4}"
    
    draw_quad(x1, y1, c_bright, x2, y2, c, x3, y3, c_dim, x4, y4, c, 0)    

  end
  
  def fuzz_amount(rando)
    (UISettings::TileSize * rando * 0.1).round
  end
  
  def draw_square(x,y,c)
    draw_quad(x, y, c, x, y+UISettings::TileSize, c, x+UISettings::TileSize, y+UISettings::TileSize, c, x+UISettings::TileSize, y, c, 0)    
  end


  
  # create semirandom fuzz for less square squares
  def fuzz(value, x, y)
    amount = (x+y) % 19
    retval = value + amount - (amount/2)
    puts "fuzz #{value} -> #{retval}"
    return retval
  end

  def draw_gradient_tile(x,y,a1,a2,a3,a4)
    pixel_x = (x - @viewport.x) * UISettings::TileSize + UISettings::TileSize/2
    pixel_y = (y - @viewport.y) * UISettings::TileSize + UISettings::TileSize/2
    c1 = define_background_color(a1)
    c2 = define_background_color(a2)
    c3 = define_background_color(a3)
    c4 = define_background_color(a4)
    draw_gradient_square(pixel_x,pixel_y,c1,c2,c3,c4)
    # @font.draw(a, UISettings::TileSize*x + 2, UISettings::TileSize*y + 1, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end
  
  def draw_gradient_square(x,y,c1,c2,c3,c4)
    draw_quad(x, y, c1, x, y+UISettings::TileSize, c2, x+UISettings::TileSize, y, c3, x+UISettings::TileSize, y+UISettings::TileSize, c4, 0)    
  end
  
  def draw_agents
    # @font.draw("@", 200, 200, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @game.world.agents.each do |agent|
      if @viewport.contains(agent)
        # shadow
        @font.draw(agent.char, UISettings::TileSize*(agent.x - @viewport.x) + 4, UISettings::TileSize*(agent.y - @viewport.y) + 3, ZOrder::UI, 1.0, 1.0, 0xff765613)
        # foreground
        @font.draw(agent.char, UISettings::TileSize*(agent.x - @viewport.x) + 2, UISettings::TileSize*(agent.y - @viewport.y) + 1, ZOrder::UI, 1.0, 1.0, 0xffffffff)
      end
    end
  end

  def draw_time
    @font.draw("Time: #{@game.world.time}", 10, 860, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Actions scheduled: #{@game.world.actions.size}", 10, 880, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Altitude: #{@game.player_altitude}", 10, 840, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end

  def define_background_color(altitude, brightness_modifier=0)  
    if !altitude
      altitude = 0
    end
    saturation = 100
    brightness = altitude
    hue = 130 #green
    if altitude < 10
      hue = 200 # blue
      brightness += 40
    end
    if altitude > 70
      hue = 30 # brown
      saturation = 50
      brightness -= 30
    end
    if altitude > 90
      brightness = 100 #ice
      saturation = 0
    end
    
    brightness += brightness_modifier
    brightness = 100 if brightness > 100
    brightness = 0 if brightness < 0
    
    
    ColorConversion.hsl_to_gosu(hue, saturation, brightness)
  end
      
end
