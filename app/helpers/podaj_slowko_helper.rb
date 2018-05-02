module PodajSlowkoHelper
  def checkuj
    if params[:slowko].downcase == $solution
      session[:points] += 1

      render html: "Excellent! You get a point! You already have #{session[:points]} points."

    else

      render html: "Try again!"
    end
  end
end
