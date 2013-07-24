require 'gosu'

module UISettings
  TileSize = 14
  WindowWidth = 910
  WindowHeight = 910
end

module ZOrder
  Background, Tiles, Agents, Player, UI = *0..4
end

class GameWindow < Gosu::Window
  
  attr_accessor :game
  
  def initialize(game)
    super UISettings::WindowWidth, UISettings::WindowHeight, false
    self.caption = "Roguelife"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 14)
    @game = game
    @viewport = Viewport.new(0,0,60,60,@game.world.get_height_map.size,@game.world.get_height_map[0].size)
  end
  
  def update
    unless @game.world.player_with_turn # this is a roguelike so game world freezes when player has turn
      game.update # move the ai characters and generally advance the world state
    end
  end
  
  def draw
    draw_tiles
    draw_agents
    draw_time
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
      @viewport.move_horizontal(-10)
    end
    if id == Gosu::KbL
      @viewport.move_horizontal(10)
    end
    if id == Gosu::KbJ
      @viewport.move_vertical(-10)
    end
    if id == Gosu::KbK
      @viewport.move_vertical(10)
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
  
  # drawing
  def draw_tiles
    # puts "drawing tiles #{self.game.world.tiles.size}"
    tile_map = @game.world.get_height_map

    for y in @viewport.y..@viewport.end_y
      for x in @viewport.x..@viewport.end_x
        draw_tile(x,y,tile_map[x][y])
      end
    end

  end
  
  def draw_tile(x,y,a)
    pixel_x = (x - @viewport.x) * UISettings::TileSize
    pixel_y = (y - @viewport.y) * UISettings::TileSize
    c = define_background_color(a)
    draw_square(pixel_x,pixel_y,c)
    #@font.draw(a, UISettings::TileSize*x + 2, UISettings::TileSize*y + 1, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end
  
  def draw_square(x,y,c)
    draw_quad(x, y, c, x, y+UISettings::TileSize, c, x+UISettings::TileSize, y+UISettings::TileSize, c, x+UISettings::TileSize, y, c, 0)    
  end
  
  def draw_agents
    # @font.draw("@", 200, 200, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @game.world.agents.each do |agent|
      if @viewport.contains(agent)
        @font.draw(agent.char, UISettings::TileSize*(agent.x - @viewport.x) + 2, UISettings::TileSize*(agent.y - @viewport.y) + 1, ZOrder::UI, 1.0, 1.0, 0xffffffff)
      end
    end
  end

  def draw_time
    @font.draw("Time: #{@game.world.time}", 10, 860, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Actions scheduled: #{@game.world.actions.size}", 10, 880, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end

  def define_background_color(altitude)  
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
    
    ColorConversion.hsl_to_gosu(hue, saturation, brightness)
  end
      
end
