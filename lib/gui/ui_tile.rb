class UITile
  
  def color
    @color = Gosu::Color.new(0xff000000)
       @color.red = rand(256 - 40) + 40
       @color.green = rand(256 - 40) + 40
       @color.blue = rand(256 - 40) + 40
  end
end