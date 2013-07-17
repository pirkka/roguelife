module WorldGenerator 

  @@world_size = 50

  def self.generate
    puts 'Generating world...'
    world = World.new
    return world
  end

end
