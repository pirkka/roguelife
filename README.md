## Feature ideas
- named mountains, lakes, deserts w/ procedural generation

## Todo
- 

## Notes

### DRAWING PRIMITIVES

draw_quad(x-size, y-size, 0xffffffff, x+size, y-size, 0xffffffff, x-size, y+size, 0xffffffff, x+size, y+size, 0xffffffff, 0)
draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3, z=0, mode=:default)
draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default)

### PSEUDORANDOM NUMBERS
- http://www.ruby-doc.org/core-1.9.3/Random.html

### OpenGL integration
- https://github.com/jlnr/gosu/blob/master/examples/OpenGLIntegration.rb