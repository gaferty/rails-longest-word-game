require 'open-uri'
require 'json'


class GamesController < ApplicationController

  def new
    @letters = randomLetters(12)
  end
  def check
    @user_letters = params[:answer].downcase
    @system_letters = params[:system].downcase.split(" ")
    @success = false
    if check_letters?(@user_letters, @system_letters)
      if check_word?(@user_letters)
        @letter_check = "does exist"
        @success = true
      else
        @letter_check = "is not a word"
      end
    else
      @letter_check = "doesn't match those letters given to you"
    end
  end
end


def randomLetters(length=7)
  letter_array = []
  length.times do
    letter_array << (65 + rand(26)).chr
  end
  return letter_array

end

def check_letters?(user_letters, system_letters)
  grid = system_letters
  user_letters.each_char do |letter|
    return false unless grid.include?(letter)
    grid.delete_at(grid.index(letter))
  end
  return true
end

def check_word?(user_word)
  response = URI.open("https://wagon-dictionary.herokuapp.com/#{user_word}").read
  response = JSON.parse(response)
  puts response
  return response["found"]
end
