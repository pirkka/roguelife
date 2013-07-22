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
  
  def initialize
    super UISettings::WindowWidth, UISettings::WindowHeight, false
    self.caption = "Roguelife"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 14)
  end
  
  def update
    game.update
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
  end
  
  # drawing
  def draw_tiles
    # puts "drawing tiles #{self.game.world.tiles.size}"
    tile_map = @game.world.get_height_map
    x = y = 0
    tile_map.each do |row| 
      row.each do |column|
        draw_tile(x,y,column)
        x += 1
      end
      y += 1
      x = 0
    end
  end
  
  def draw_tile(x,y,a)
    pixel_x = x * UISettings::TileSize
    pixel_y = y * UISettings::TileSize
    c = define_background_color(a)
    draw_square(pixel_x,pixel_y,c)
  end
  
  def draw_square(x,y,c)
    draw_quad(x, y, c, x, y+UISettings::TileSize, c, x+UISettings::TileSize, y+UISettings::TileSize, c, x+UISettings::TileSize, y, c, 0)    
  end
  
  def draw_agents
    # @font.draw("@", 200, 200, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @game.world.agents.each do |agent|
      @font.draw(agent.char, UISettings::TileSize*agent.x + 1, UISettings::TileSize*agent.y + 0, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    end
  end

  def draw_time
    @font.draw("Time: #{@game.world.time}", 10, 860, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Actions scheduled: #{@game.world.actions.size}", 10, 880, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end

  def define_background_color(altitude)  
    ColorConversion.hsl_to_gosu(110, 100, 50+altitude*4)
  end
    
end
