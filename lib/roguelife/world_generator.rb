module WorldGenerator 

  @@world_height = 26
  @@world_width = 90
  
  def self.generate
    puts 'Generating world...'
    world = World.new
    world.tiles = self.generate_tiles
    return world
  end
  
  def self.generate_tiles
    tiles = []
    (1..@@world_height).each do 
      row = []
      (1..@@world_width).each do 
        row << rand(5)
      end
      tiles << row
    end
    return tiles    
  end

end
