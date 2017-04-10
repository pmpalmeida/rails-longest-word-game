require 'open-uri'
require 'json'


class PagesController < ApplicationController
  def game
    @start_time = Time.now
    @grid = generate_grid(9)
  end

  def score
    @grid = params[:grid].split("")
    @attempt = params[:attempt]
    @start_time = DateTime.parse(params[:start_time])
    @end_time = Time.now
    @result = run_game(@attempt, @grid, @start_time, @end_time)
  end
end







def generate_grid(grid_size)
  # TODO: generate random grid of letters

  i = 0
  grid = []

  while i < grid_size do

    grid << (65 + rand(25)).chr
    i += 1
  end

  grid

end

#------------------------------------

def comparar(grid, palavra)

grid_hash = Hash.new(0)
  grid.each do |x|
    grid_hash[x] =+1
  end

palavra_hash = Hash.new(0)

  pal = palavra.split(//)
  pal.each do |x|
    palavra_hash[x] =+1
  end

  grid.each do |x|
    if palavra_hash[x] == 0
      return false

    elsif palavra_hash[x] > grid_hash[x]
      return false

    else
      return true
    end
  end

end

#--------------------------------------------

def palavra_existe (palavra)

  words = File.read('/usr/share/dict/words').upcase.split("\n")

  #puts words
  if words.include?(palavra)
    return "true"
  else
    return "false"
  end

end


def traduzir(palavra)


url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=1c6be710-bcd2-4bfc-a1fc-76d58c288a7a&input=#{palavra}"
user_serialized = open(url).read
user = JSON.parse(user_serialized)

return user["outputs"][0]["output"]

end


#-----------------------------------------------------------

def score(palavra, start_time, end_time)

  score = (palavra.size*50) - (end_time - start_time).to_i

  return score

end




#Here is your free API key: 5c048479-d1d2-47d2-a911-e5ce31cc0d72
#testetttt
#testetttt@@


def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result


message = ""
i = 0


if palavra_existe(attempt)

  if comparar(grid, attempt)
    message = "well done"
    score_result = score(attempt,start_time, end_time)
  else
    message = "not in the grid"
    score_result = 0
  end

else
  message = "not an english word"
  score_result = 0

end



result = Hash.new

result[:time] = (end_time.to_i - start_time.to_i)
result[:translation] = traduzir(attempt)
result[:score] = score_result
result[:message] = message

return result


end





