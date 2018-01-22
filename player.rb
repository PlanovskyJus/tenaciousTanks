class Player
	ROTATION_SPEED = 3
	ACCELERATION = 1.2
  REVERSE = ACCELERATION * 0.7
	FRICTION = 0
  attr_accessor :x, :y, :angle, :radius

  def initialize(window)
    @x = 600
    @y = 400
    @angle = 90
    @image = Gosu::Image.new('player_tank.png')
    @velocity_x = 0
    @velocity_y = 0
    @window = window
    @radius = 20
  end

  def draw
    @image.draw_rot(@x, @y, 2, @angle)
  end

	def turn_right
  	@angle += ROTATION_SPEED
  end

  def turn_left
  	@angle -= ROTATION_SPEED
  end

  def move
	@x += @velocity_x
	@y += @velocity_y
	@velocity_x *= FRICTION
	@velocity_y *= FRICTION
  if @x > @window.width - @radius
    @x = @radius
  end
  if @x < @radius
    @x = @window.width - @radius
  end
  if @y > @window.height - @radius
    @velocity_y = 0
    @y = @window.height - @radius
  end 
  if @y < @radius
    @velocity_y = 0
    @y = @radius
  end
  end


  def accelerate
	@velocity_x += Gosu.offset_x(@angle, ACCELERATION)
	@velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end

  def backwards
  @velocity_x -= Gosu.offset_x(@angle, REVERSE)
  @velocity_y -= Gosu.offset_y(@angle, REVERSE)
  end

end
