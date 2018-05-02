class PodajSlowkoController < ApplicationController
  protect_from_forgery with: :exception

  def losuj_obrazek
    @i = rand(0..2)
    @obrazki = {
      transport: []
      animals: [["s.jpg", "shark"], ]
      food: [["wm.png", "watermelon"], ]
      places: []
      body:[]
      plants: [["t.png", "tree"]]
    }
    if session[:points] == nil then session[:points] = 0 end
    $nr_obrazka = @obrazki[@i][0]
    $solution = @obrazki[@i][1]
  end

  def check

  end

end
