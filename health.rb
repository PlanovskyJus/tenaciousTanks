class Health 

	def initialize(window)
    @x = 90
    @y = 25
    @health5 = Gosu::Image.new('health(5).png')
    @health4 = Gosu::Image.new('health(4).png')
    @health3 = Gosu::Image.new('health(3).png')
    @health2 = Gosu::Image.new('health(2).png')
    @health1 = Gosu::Image.new('health(1).png')
    @health0 = Gosu::Image.new('health(0).png')
    @window = window
	end 

	def draw_5
		@health5.draw(@x, @y, 3)
	end

	def draw_4
		@health4.draw(@x, @y, 3)
	end

	def draw_3
		@health3.draw(@x, @y, 3)
	end

	def draw_2
		@health2.draw(@x, @y, 3)
	end

	def draw_1
		@health1.draw(@x, @y, 3)
	end

	def draw_0
		@health0.draw(@x, @y, 3)
	end
end 


