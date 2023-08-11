class ApplicationController < ActionController::Base
# include JsonWebToken
  protect_from_forgery with: :null_session

end
