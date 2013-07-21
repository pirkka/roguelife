class Action
  
  attr_reader :agent, :time
  
  def initialize(agent)
    @agent = agent
    @time = 0
  end

  def resolve
    raise 'never attempt to use Action class directly'
  end
  
end