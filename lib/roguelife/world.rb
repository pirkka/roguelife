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
      puts "agent action: #{agent_actions.first}"
      @time = @agent_actions.first.time
      agent = @agent_actions.first.agent
      puts @agent_actions.first
      puts "agent: #{agent}"
      @agent_actions.first.resolve
      @agent_actions.pop
      @agent_actions.push(agent.get_action(self))
    end
  end
  
end