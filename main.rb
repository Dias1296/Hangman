require_relative 'game_functions.rb'

include Game_Functions

puts "Welcome to Hangman! Would you like to load a saved game or start a new one? [Y/N]"
game_load = gets.chomp

while true
    case game_load.upcase
    when 'Y'
        load_game
    else
        start_new_game
    end

    puts "Would you like to play again? [Y/N]"
    case gets.chomp.upcase 
    when 'Y'
        puts "Load a previously saved game? [Y/N]"
        game_load = gets.chomp.upcase
    else
        break
    end
end




