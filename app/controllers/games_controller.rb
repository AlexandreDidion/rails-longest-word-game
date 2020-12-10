require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word_proposed = params[:answer]
    @letters_given = params[:letters_given]
    @answer = ''
    session[:score] = 0 if session[:score].nil?
    if @word_proposed.upcase.split('').all? { |letter| @letters_given.include? letter }
      if valid_word?(@word_proposed)
        score = @word_proposed.length
        @answer = "You win - You scored #{score}"
        session[:score] += score
      else
        @answer = 'Not an english word'
      end
    else
      @answer = "You used letter(s) we didn't give"
    end
  end

  private

  def valid_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
