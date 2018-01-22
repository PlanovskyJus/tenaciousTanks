require "gosu"


class tankGame < Gosu::Window
	WIDTH = 1200
	HEIGHT = 800

	def initialize
		super(WIDTH, HEIGHT)
		self.caption = "tank.Game"
		
	end 
end

window = tankGame.new
window.show