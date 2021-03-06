class EnemyBullet

SPEED = 6
attr_accessor :x, :y, :radius, :hit

	def initialize(window, x, y, angle)
		@x = x
		@y = y
		@direction = angle
		@image = Gosu::Image.new("bullet.png")
		@radius = 3
		@window = window
		@hit = 0
	end

	def move
	@x += Gosu.offset_x(@direction, SPEED)
	@y += Gosu.offset_y(@direction, SPEED)
	end

	def draw
		@image.draw_rot(@x - @radius, @y - @radius, 0, @direction)
	end

	def onscreen?
		right = @window.width + @radius
		left = -@radius
		top = -@radius
		bottom = @window.height + @radius
		@x > left and @x < right and @y > top and @y < bottom
	end
end
