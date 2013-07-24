class World
  
  attr_accessor :tiles, :agents, :time, :actions, :player_with_turn
  
  def initialize
    @time = 0
    @actions = []
    @agents = []
    @player_with_turn = nil
  end
  
  def get_height_map
    return tiles
  end

  def resolve_next_action
    unless @actions.empty?
      puts ">>> RESOLVING NEXT"
      action = @actions.shift
      @time = action.time # important & planned side effect: advancing the world clock
      agent = action.agent
      action.resolve(self)
      
      if !agent.ai?
        puts "PLAYER TURN"
        @player_with_turn = agent
        # ask for new player action
      end
      
      # if agent is still here - should this actually happen in the action? what if agent has gone away?
      #@actions.push(agent.get_action(self))
    end
  end
  
  def insert_action(action)
    @actions.each do |existing_action|
      if existing_action.time > action.time
        @actions.insert(@actions.index(existing_action), action)
        return
      end
    end
    @actions.push(action)
  end
  
  def insert_agent(agent)
    @agents << agent
    @actions << agent.get_action(self)
  end
  
  def remove_agent(agent)
    @agents.delete(agent)
    @actions.select! {|x| x.agent.object_id != agent.object_id}
  end
  
end