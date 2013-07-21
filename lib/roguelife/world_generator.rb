module Roguelife
  class WorldGenerator 

    @@world_height = 26
    @@world_width = 90
  
    def self.generate
      puts 'Generating world...'
      @world = World.new
      @world.tiles = self.generate_tiles
      self.generate_agents
      return @world
    end
  
    def self.generate_tiles
      tiles = []
      rc = 0 
      cc = 0
      (1..@@world_height).each do 
        row = []
        (1..@@world_width).each do 
          height = 0
          (1..10).each do
            height += rand(10)
          end
          row << height
          cc +=1
        end
        tiles << row
        rc +=1
      end
      return tiles    
    end

    def self.generate_agents
      # let's just create one "egg" agent to start the proceedings. it will eventually create the player as well
      @world.insert_agent Roguelife::Egg.new(3,7)
      # @world.insert_agent Roguelife::Egg.new(5,7)
    end
  end
end