require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"

class App
	def initialize
		@state = Model::initial_state
		#Atributo inicial de velocidad
		@speed = 0.5
	end

	def start
		@view = View::Ruby2dView.new(self)
		timer_thread = Thread.new { init_timer(@view) }
		@view.start(@state)
		timer_thread.join
	end

	def init_timer(view)
		# Capturamos la longitud inicial de la serpiente
    snake_length = @state.snake.positions.length
		loop do
			if @state.game_finished
				puts "Juego finalizado"
				puts "Puntaje: #{@state.snake.positions.length}"
				break
			end
			@state = Actions::move_snake(@state)
			@view.render_game(@state)
			# Se evalúa si la longitud de la serpiente ha cambiado, lo que indica si ha comido
      if snake_length < @state.snake.positions.length
        # Se actualiza la longitud de la serpiente para estar al día con la próxima iteración
        snake_length = @state.snake.positions.length
        # Se recalcula la velocidad, restando un %5 de la velocidad actual por cada llamado, resultando en una disminución gradual que nunca llega a cero
        calculate_speed_increment
        # puts "Current speed: #{@speed}"
      end
      sleep @speed
		end
	end

	def send_action(action, params)
		new_state = Actions.send(action, @state, params)
		if new_state.hash != @state.hash
			@state = new_state 
			@view.render_game(@state)
		end
	end

	def calculate_speed_increment
    if @speed > 0.001
      # "Reduce la velocidad de la serpiente en un %5"
      @speed = @speed - (@speed * 0.05)
      if(@speed < 0.001)
        @speed = 0.001
      end
    end
  end
end

app = App.new
app.start