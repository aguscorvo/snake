module Actions
	def self.move_snake(snake)
		next_direction = state.next_direction
		# verificar que la siguiente casilla sea valida
		next_position = calc_next_position(state)
		if position_is_valid?(state, next_position)
			move_snake_to(state, next_position)
		else
			end_game(state)
		end
		# si no es valida -> terminar el juego
		# si es valida -> movemos la serpiente
	end

	private

	def calc_next_position(state)
		curr_position = state.snake.positions.first
		case state.next_direction
		when UP
			#decrementar fila
			return Model::Coord.new(curr_position.row -1, curr_position.col)
		when RIGHT
			#incrementar col
			return Model::Coord.new(curr_position.row, curr_position.col + 1)
		when DOWN
			#incrementar fila
			return Model::Coord.new(curr_position.row +1, curr_position.col)
		when LEFT
			#decrementar col
			return Model::Coord.new(curr_position.row, curr_position.col -1)
		end
	end

	def position_is_valid?(state, position)
		# verificar que este en la grilla
		is_invalid = ((position.row >= state.grid.rows || position.row <0) ||
			(position.col >= state.grid.col || position.col <0))
		return false is is_invalid
		# verificar que no este superpuniendo a la serpiente
		return !(state.snake.positions.include? position)
	end

	def move_snake_to(state, next_position)
		new_positions = [next_position] + state.snake.positions[0...-1]
		state.snake.positions = new_positions
		state
	end

	def end_game(state)
		state.game_finished = true
		state
	end
end