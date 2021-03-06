require 'gosu'

module UISettings
  TileSize = 32
  WindowWidth = 910
  WindowHeight = 910
  TileMode = :fuzzed # remove as unnecessary (deprecated by TileShadow)
  TileGradient = 5
  TileFuzz = 0.1
  TileShadow = 5
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

    ui_tile_set = UITile.create_set(self, tile_map, @viewport.x, @viewport.y, @viewport.end_x, @viewport.end_y)

    for ui_tile in ui_tile_set
      ui_tile.draw_fuzzed_shadow
      ui_tile.draw_fuzzed_tile
    end
  end

  def draw_agents
    # @font.draw("@", 200, 200, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @game.world.agents.each do |agent|
      if @viewport.contains(agent)
        # shadow
        @font.draw(agent.char, UISettings::TileSize*(agent.x - @viewport.x) + 3, UISettings::TileSize*(agent.y - @viewport.y) + 2, ZOrder::UI, 1.0, 1.0, 0xff765613)
        # foreground
        @font.draw(agent.char, UISettings::TileSize*(agent.x - @viewport.x) + 1, UISettings::TileSize*(agent.y - @viewport.y) + 0, ZOrder::UI, 1.0, 1.0, 0xffffffff)
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
