# Pirkka's diamond square algorithm
class BlingSquare
  
  def initialize(n)
    @size = 2**n + 1
    puts "BlingSquare size #{@size}"
    @height_map = Array.new(@size) { Array.new(@size) }
    puts "Height map rows: #{@height_map.size}"
    puts "Height map cols: #{@height_map[0].size}"
    self.execute(0, 0, @size-1, @size-1, 0, 1.0)
  end
  
  def execute(x1,y1,x2,y2,seed,h)
    # diamond step
    northwest = @height_map[x1][y1] ? @height_map[x1][y1] : seed
    northeast = @height_map[x2][y1] ? @height_map[x2][y1] : seed
    southwest = @height_map[x1][y2] ? @height_map[x1][y2] : seed
    southeast = @height_map[x2][y2] ? @height_map[x2][y2] : seed
    naive_centerpoint = self.avg [northwest,northeast,southwest,southeast]
    puts "---"
    puts "naive_centerpoint: #{naive_centerpoint}"
    random_component = rand() * h * 2 - h
    puts "random component: #{random_component}"
    centerpoint = naive_centerpoint + random_component
    puts "centerpoint: #{centerpoint}"
    centerpoint_x = x1+x2/2
    centerpoint_y = y1+y2/2
    @height_map[centerpoint_x][centerpoint_y] = centerpoint
    # square step
    
  end
  
  def get_map
    @height_map
  end
  
  def avg(list)
    list.reduce(:+).to_f / list.size
  end
  
end