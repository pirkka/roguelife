require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 800, 800, false
    self.caption = "Roguelife"
  end
  
  def update
  end
  
  def draw
  end
  
  def button_down(id)
    puts 'button down'
    if id == Gosu::KbEscape
      close
    end
  end
  
end
