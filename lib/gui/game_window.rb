require 'gosu'

module ZOrder
  Background, Tiles, Agents, Player, UI = *0..4
end

class GameWindow < Gosu::Window
  def initialize
    super 800, 800, false
    self.caption = "Roguelife"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end
  
  def update
  end
  
  def draw
    @font.draw("@", 200, 200, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    
    draw_quad(0,0,0xFFFFFF00, 0,20, 0xFFFFFF00, 20,20, 0xFFFFFF00, 20,0, 0xFFFFFF00, 0)
  end
  
  def button_down(id)
    puts 'button down'
    if id == Gosu::KbEscape
      close
    end
  end
  
end
