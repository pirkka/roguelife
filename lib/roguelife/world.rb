class World
  
  attr_accessor :tiles, :agents, :time, :actions
  
  def initialize
    @time = 0
    @actions = []
    @agents = []
  end
  
  def get_height_map
    return tiles
  end

  def resolve_next_action
    unless @actions.empty?
      @time = @actions.first.time # important & planned side effect: advancing the world clock
      puts @actions.map {|x| x.time}
      agent = @actions.first.agent
      @actions.first.resolve(self)
      @actions.shift
      # if agent is still here - should this actually happen in the action? what if agent has gone away?
      @actions.push(agent.get_action(self))
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
    puts @actions
    @actions.select! {|x| x.agent.object_id != agent.object_id}
    puts @actions
  end
  
end