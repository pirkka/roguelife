require 'gosu'

module ZOrder
  Background, Stars, Player, UI = *0..3
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
  end
  
  def button_down(id)
    puts 'button down'
    if id == Gosu::KbEscape
      close
    end
  end
  
end
