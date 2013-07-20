require 'gosu'

module UISettings
  TileSize = 25
  WindowWidth = 800
  WindowHeight = 800
end

module ZOrder
  Background, Tiles, Agents, Player, UI = *0..4
end

class GameWindow < Gosu::Window
  
  attr_accessor :game
  
  def initialize
    super UISettings::WindowWidth, UISettings::WindowHeight, false
    self.caption = "Roguelife"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end
  
  def update
  end
  
  def draw
    draw_tiles
    draw_agents
  end
  
  def button_down(id)
    puts 'button down'
    if id == Gosu::KbEscape
      close
    end
  end
  
  # drawing
  def draw_tiles
    puts "drawing tiles #{self.game.world.tiles.size}"
    tile_map = @game.world.get_height_map
    x = y = 0
    tile_map.each do |row| 
      row.each do |column|
        draw_tile_logic(x,y,column)
        x += 1
      end
      y += 1
      x = 0
    end
  end
  
  def draw_tile_logic(x,y,a)
    pixel_x = x * UISettings::TileSize
    pixel_y = y * UISettings::TileSize
    c = define_background_color(a)
    draw_tile(pixel_x,pixel_y,c)
  end
  
  def draw_tile(x,y,c)
    draw_quad(x, y, 0xFFFFFF00, x, y+UISettings::TileSize, 0xFFFFFF00, x+UISettings::TileSize, y+UISettings::TileSize, 0xFFFFFF00, x+UISettings::TileSize, y, 0xFFFFFF00, 0)    
  end
  
  def draw_agents
    @font.draw("@", 200, 200, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def define_background_color(column)  
    ColorConversion.hue_to_rgb(110, 100, column)
  end
  
  
end
