module Roguelife
  class WorldGenerator 
    
    def self.generate_tiles_with_diamond_square
      ds = BlingSquare.new(4)
      map = ds.get_map
      map.each do |row|
        row.map! {|x| ((x+0.9)/2*10).round}
      end
      return map
    end

    def self.generate_tiles_with_height_map
      h = HeightMap.new @@world_width, @@world_height
      h.static
      h.set 10,10,10
      h.set 10,20,10
      h.set 15,30,10
      h.set 20,22,-10
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      h.smooth_grid
      return h.get_grid
    end
  
    def self.generate_tiles_with_ruby_quiz
      return DiamondSquare.go(6)
    end
  
    def self.generate
      puts 'Generating world...'
      @world = World.new
      @world.tiles = self.generate_tiles_with_diamond_square
      # @world.tiles = self.generate_tiles      
      # @world.tiles = self.generate_tiles_with_height_map
      # @world.tiles = self.generate_tiles_with_ruby_quiz
      
      self.generate_agents
      return @world
    end
  
    def self.generate_tiles
      
      @@world_width = 65
      @@world_height = 65
      
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
      @world.insert_agent Roguelife::Egg.new(5,7)
    end
  end
end