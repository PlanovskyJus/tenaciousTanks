require "gosu"
require_relative "player"
require_relative "enemy"
require_relative "bullet"
require_relative "explosion"
require_relative "enemy_bullet"
require_relative "health"
require_relative "credit"

class TenaciousTanks < Gosu::Window
	WIDTH = 1200
	HEIGHT = 800

	def initialize
		super(WIDTH, HEIGHT)
		self.caption = "Tenacious Tank"
		@start_image = Gosu::Image.new("start_image.png")
		@scene = :start
		@start_music = Gosu::Song.new("MW3.ogg")
		@start_music.play(true)
	end 

	def draw
		case @scene
		when :start
			draw_start 
		when :game
			draw_game
		when :end
			draw_end
		end
	end

	def draw_start
		@start_image.draw(0,0,0)
	end 

	def draw_game
		@player.draw
		@background.draw(0, 0, 0)
		@enemies.each do |enemy|
    	enemy.draw
    	end
    	@enemy_bullets.each do |e_bullet|
    	e_bullet.draw
    	end
		@bullets.each do |bullet|
		bullet.draw
		end
		@font.draw(@score.to_i, 1100, 20, 2)
		@font.draw(@time_left.to_s, 20, 20, 22)
		@explosions.each do |explosion|
    	explosion.draw
    	end
    	@health_class.draw_5 if @health == 5
    	@health_class.draw_4 if @health == 4
    	@health_class.draw_3 if @health == 3
    	@health_class.draw_2 if @health == 2
    	@health_class.draw_1 if @health == 1
    	@health_class.draw_0 if @health <= 0
	end

	def draw_end 
		clip_to(50,225,700,372) do
			@credits.each do |credit|
				credit.draw
			end
		end
		draw_line(0,225,Gosu::Color::RED,WIDTH,225,Gosu::Color::RED)
		@message_font.draw(@message,40,40,1,1,1,Gosu::Color::FUCHSIA)
		@message_font.draw(@message2,40,75,1,1,1,Gosu::Color::FUCHSIA)
		@message_font.draw(@message3,40,110,1,1,1,Gosu::Color::FUCHSIA)
		@message_font.draw(@message4,40,145,1,1,1,Gosu::Color::FUCHSIA)
		@message_font.draw(@message5,40,180,1,1,1,Gosu::Color::FUCHSIA)
		draw_line(0,600,Gosu::Color::RED,WIDTH,600,Gosu::Color::RED)
		@message_font.draw(@bottom_message,180,700,1,1,1,Gosu::Color::AQUA)
  	end

	def update 
  		case @scene
		when :game
			update_game
		when :end
			update_end
		end
	end

def update_game
	@player.turn_left if button_down?(Gosu::KbLeft)
  	@player.turn_right if button_down?(Gosu::KbRight)
  	@player.accelerate if button_down?(Gosu::KbUp)
  	@player.backwards if button_down?(Gosu::KbDown)
  	@player.move
  	if @enemies.length < @number
  		@enemies.push Enemy.new(self)
  		@enemies_appeared += 1
  	end
  	@enemies.each do |enemy|
  	enemy.move
  	enemy.change_angle
  	end
  	@enemies.dup.each do |enemy|
  		distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
				if distance < 150
					enemy.angle += 5
				end
  			if distance < 60
					enemy.acceleration = 0
				elsif distance > 30
					enemy.acceleration = 1
  			end
  	end
		@bullets.each do |bullet|
  		bullet.move
  		end
  		@enemy_bullets.each do |e_bullet|
  			e_bullet.move
  		end 
  		@enemy_bullets.each do |e_bullet|
  			distance = Gosu.distance(@player.x, @player.y, e_bullet.x, e_bullet.y)
  			if distance < @player.radius + 2 + e_bullet.radius + 2
  				@enemy_bullets.delete e_bullet
  				@explosions.push Explosion.new(self, @player.x, @player.y)
  				@health -= 1
  				@score -= 5
  				@explosion_sound.play
			end
		end
		@enemies.each do |enemy|
			enemy.number 
			@enemy_bullets.push EnemyBullet.new(self, enemy.x, enemy.y, enemy.angle) if enemy.number > 994
		end
  
		@enemies.dup.each do |enemy|
  			@bullets.dup.each do |bullet|
  			distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
  				if distance < enemy.radius + 5 + bullet.radius + 5
  				@enemies.delete enemy
  				@bullets.delete bullet
  				@number += 1
  				@score += 12
  				@explosions.push Explosion.new(self, enemy.x, enemy.y)
  				@enemies_destroyed += 1
  				@explosion_sound.play
				end
			end
		end
		@enemies.dup.each do |enemy|
			if enemy.y > HEIGHT + enemy.radius
				@enemies.delete enemy
			end
		end
	@enemy_bullets.dup.each do |e_bullet|
  		@enemy_bullets.delete(e_bullet) unless e_bullet.onscreen?
  	end
	@bullets.each do |bullet|
		@bullets.delete(bullet) && bullet.hit = 1 unless bullet.onscreen?
		@score -= 3 if bullet.hit == 1
	end
	@frames += 1
	@seconds += 1 if @frames == 60
	@frames = 0 if @frames == 60
		if @health > 0
		@time_left = (@time - @seconds)
		@explosions.dup.each do |explosion|
  		@explosions.delete explosion if explosion.finished 
  		end
  		end
  	if @reload != 0
  		@recharge -= 1
  	end
  	if @recharge == 0
  		@reload = 0
  		@recharge = 30
  	end 
  	initialize_end(:times_up) if @time_left == 0
  	initialize_end(:shot) if @health == 0
	end

	def update_end
      @credits.each do |credit|
        credit.move
      end
      if @credits.last.y < 225
            @credits.each do |credit|
        	credit.reset
      		end
    	end
  	end

	def button_down(id)
		case @scene
		when :start
			button_down_start(id) 
		when :game
			button_down_game(id)
		when :end
			button_down_end(id)
		end
	end

	def button_down_start(id)
		initialize_game
	end

	def button_down_game(id)
		if id == Gosu::KbSpace && @reload == 0
			@bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
			@reload += 1
			@shooting_sound.play(1.5)
		end
	end 

	def button_down_end(id)
    	if id == Gosu::KbP 
      		initialize_game
    	elsif id == Gosu::KbQ 
      		close
    	end
  	end

	def initialize_game
		@player = Player.new(self)
		@background = Gosu::Image.new('map.png')
		@enemy = Enemy.new(self)
		@enemies = []
		@bullets = []
		@enemy_bullets = []
		@explosions = []
		@number = 1
		@font = Gosu::Font.new(45)
		@score = 0
		@health = 5
		@health_class = Health.new(self)
		@reload = 0
		@recharge = 30
		@enemies_appeared = 0
		@enemies_destroyed = 0
		@scene = :game
		@time = 100
		@seconds = 0
		@frames = 0
		@game_music = Gosu::Song.new("whales.ogg")
		@game_music.play(true)
		@explosion_sound = Gosu::Sample.new('explosion.ogg')
		@shooting_sound = Gosu::Sample.new('shoot.ogg')
	end

	def initialize_end(fate)
		case fate
		when :times_up
			@message = "You survived the full 100 seconds!! You rekt #{@enemies_destroyed} tanks"
			@message2 = "out of the #{@enemies_appeared} nice job!"
			@message3 = "You get an extra 20 points for surviving the time and #{@health * 10} points for your health status"
			@message4 = "Your score is #{@score + 10 + @health * 10}"
			@message5 = ""
		when :shot			
			@message = "Your tank was blown up by the enemy tanks before time was up."
			@message2 = "Before your tank was destroyed, you rekt #{@enemies_destroyed} tanks"
			@message3 = "out of the #{@enemies_appeared}"
			@message4 = "You get #{(100 - @time_left)/10} for surviving #{100 - @time_left} seconds"
			@message5 = "Your score is #{@score + ((100 - @time_left)/10)}"
		end
		@bottom_message = "Press P to play again, or Q to quit."
		@message_font = Gosu::Font.new(28)
		@credits = []
		y = 700
		File.open('credits.txt').each do |line|
			@credits.push(Credit.new(self, line.chomp, 100 ,y))
			y+=30
		end
		@scene = :end
		@end_music = Gosu::Song.new("sad_violin.ogg")
		@end_music.play(true)
	end 

end 

window = TenaciousTanks.new
window.show
