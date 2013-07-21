class World
  
  attr_accessor :tiles, :agents, :time, :agent_actions
  
  def initialize
    @time = 0
    @agent_actions = []
    @agents = []
  end
  
  def get_height_map
    return tiles
  end

  def resolve_next_agent_action
    unless @agent_actions.empty?
      @time = @agent_actions.first.time # important & planned side effect: advancing the world clock
      agent = @agent_actions.first.agent
      @agent_actions.first.resolve
      @agent_actions.shift
      @agent_actions.push(agent.get_action(self))
    end
  end
  
  def insert_agent_action(agent_action)
    @agent_actions.each do |existing_action|
      if existing_action.time > agent_action.time
        @agent_actions.insert(@agent_actions.index(existing_action), agent_action)
        return
      end
    end
    @agent_actions.push(agent_action)
  end
  
  def insert_agent(agent)
    @agents << agent
    @agent_actions << agent.get_action(self)
  end
  
end