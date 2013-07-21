class Action
  
  attr_reader :agent, :time
  
  def initialize(agent, time)
    @agent = agent
    @time = time + 1
  end

  def resolve(world)
    raise 'never attempt to use Action class directly'
  end
  
end