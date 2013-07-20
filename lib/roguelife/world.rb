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
    unless agent_actions.empty?
      return agent_actions.first.resolve
    else
      return nil
    end
  end
  
end