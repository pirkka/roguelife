class AgentAction
  
  attr_reader :agent, :time
  
  def initialize(agent)
    @agent = agent
    @time = 0
  end

  def resolve
    "Initial action for #{self.agent}"
  end
  
end