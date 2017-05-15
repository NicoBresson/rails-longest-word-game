require 'open-uri'
require 'json'
require 'date'

class GameController < ApplicationController
  def game
    @grid = generate_grid(10)
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @answer = params[:answer]
    @start_time = DateTime.parse(params[:time]).to_time
    @grid = params[:grid]
    @result = run_game(@answer,@grid,@start_time,@end_time)
  end

private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end


  def included?(guess, grid)
    guess.split('').all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time }
    result[:translation] = attempt
    result[:score]
    result[:message] = score_and_message(attempt, result[:translation], grid, result[:time])
    result
  end

  def score_and_message(attempt, translation, grid, time)
    if included?(attempt.upcase, grid)
      if translation
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end
end
