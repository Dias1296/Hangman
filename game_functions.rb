module Game_Functions
    require 'yaml'

    #ToDo -> Add serialization of games to savefiles (use YAML)
    #ToDO -> Ask player at beginning of each round if he would like to save the game
    #ToDO -> At beginning of game, ask if player would like to start a new game or load a new one
    #ToDO -> Each save game should be a new YAML file

    @show_word = ""

    def start_new_game
            turn = 0
            tracked_words = ''
            secret_word = get_secret_word.downcase
            @show_word = "_ " * secret_word.length
            game_turn(turn, secret_word, tracked_words)
        
    end

    def load_game
        puts "Choose a save file to load:"
        save_files = get_save_file_names
        if save_files.empty?
            puts "No save files found"
        else
            chosen_filename = gets.chomp
            while true
                if File.file?("Savegames/#{chosen_filename}.yml")
                    save_hash = load_save_file(chosen_filename)
                    break
                else
                    puts "Save file does not exist! Choose another one"
                    chosen_filename = gets.chomp
                end
            end
            @show_word = "_ " * save_hash[:secret_word].length
            show_array = @show_word.split('')
            secret_array = save_hash[:secret_word].split('')
            secret_array.each_with_index{ |element, index|
                if save_hash[:guessed_letters].include? element
                    show_array[index*2] = element
                end 
            }
            @show_word = show_array.join("")
            game_turn(save_hash[:turn], save_hash[:secret_word], save_hash[:guessed_letters])
        end 
    end

    def game_turn(turn, secret_word, tracked_words)
        while true 
            if turn > 10
                puts "You have run out of tries!"
                break
            else
                puts "Turn number #{turn}. You have #{10 - turn} turns left"
                puts "Guessed letters: #{tracked_words}"
                puts
                puts "Try and guess a letter! Or if you are feeling brave, guess the entire word..."
                puts "hint: to save your game, type save"
                guess = gets.chomp.downcase
                if guess.to_i.to_s == guess
                    puts
                    puts
                    puts "Numbers are not a viable option. Guess again!"
                elsif guess == "save"
                    save_game(secret_word, turn, tracked_words)
                elsif guess.length == 1
                    if tracked_words.include?(guess)
                        puts
                        puts
                        puts "Letter has already been played!"
                        puts
                    else
                        compare_letter(secret_word, guess)
                        tracked_words << guess
                        turn += 1
                        if check_if_word_is_complete(secret_word, @show_word)
                            puts
                            puts
                            puts "You have won the game! Congratulations!"
                            puts
                            break
                        end
                    end    
                else
                    if compare_words(secret_word, guess)
                        puts
                        puts
                        puts "YOU HAVE WON!"
                        puts
                        break
                    else
                        puts 
                        puts
                        puts "You risked it all, and lost..."
                        puts
                        break
                    end
                end
            end
        end
    end
    
    def get_secret_word
        filename = "5desk.txt"
        names_array = Array.new
        File.open(filename, 'r') do |file|
            names_array = file.read.split(' ')
        end
        return names_array.sample
    end

    def compare_letter(secret_word, guess)
        matching_array = secret_word.split('').each_with_index.filter_map{ |element, index| index if element == guess}
        if matching_array.empty?
            puts
            puts
            puts "The letter you guessed is not in the word. Try again!"
            @show_word = show_word(secret_word, @show_word, matching_array)
            puts @show_word
            puts
            return false
        else
            puts 
            puts
            puts "You guessed a correct letter!"
            @show_word = show_word(secret_word, @show_word, matching_array)
            puts @show_word
            puts
            return true
        end
    end

    def check_if_word_is_complete(secret_word, show)
        if show.tr(' ','') == secret_word
            return true
        else
            return false
        end
    end

    def compare_words(secret_word, guess)
        if secret_word == guess
            return true
        else return false
        end
    end

    def show_word(secret_word, show_word, result)
        secret_word_array = secret_word.split('')
        show_word_array = show_word.split('')
        result.each_with_index{ |element, index| show_word_array[element*2] = secret_word_array[element] }
        return show_word_array.join('')
    end

    def save_game(secret_word, turn, guessed_letters)
        puts "Choose a savename:"
        savename = gets.chomp
        yaml_hash = Hash.new
        teste_hash = Hash.new
        yaml_hash[:savename] = savename
        yaml_hash[:turn] = turn
        yaml_hash[:guessed_letters] = guessed_letters
        yaml_hash[:secret_word] = secret_word
        File.open("Savegames/#{savename}.yml", "w"){ |file| file.write(yaml_hash.to_yaml)}
    end

    def load_save_file(save_file_name)
        return YAML.load(File.read("Savegames/#{save_file_name}.yml"))
    end

    def get_save_file_names
        save_files = Dir["Savegames/*"]
        save_files = save_files.each.filter_map { |filename|
            filename.gsub('Savegames/', '').gsub('.yml','')
        }
        save_files.each{ |element| puts "-" + element}
        return save_files
    end
    
end

puts File.file?("Savegames/testeasdsad.yml")
