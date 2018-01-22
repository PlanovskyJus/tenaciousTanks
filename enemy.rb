class Enemy

attr_accessor :x, :y, :angle, :radius, :speed, :acceleration, :number

	def initialize(window)
		@acceleration = 1
		@radius = 14
		@x = rand(60...window.width - 60)
		@y = rand(60..window.height - 60)
		@velocity_x = 0
    	@velocity_y = 0
    	@width = 26
    	@height = 28
    	@speed = rand(2..5)
    	@window = window
		@image = Gosu::Image.new("enemy_tank.png")
		@angle = rand(1..360)
		@number = 0
	end

	def draw
		@image.draw_rot(@x, @y, 1, @angle)
	end

    def move
		@x += Gosu.offset_x(@angle, @acceleration)
		@y += Gosu.offset_y(@angle, @acceleration)
	end

	def change_angle
		@angle += 2.5 if @x + 60 > @window.width || @x - 60 < @width || @y + 60 > @window.height || @y - 60 < @height
	end

	def number
		@number = rand(1..1000)
	end

end
