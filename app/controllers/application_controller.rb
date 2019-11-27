# frozen_string_literal: true

class ApplicationController < ActionController::Base

  include Response
  include ExceptionHandler

  before_action :ensure_json

  def ensure_json
    unless request.content_type == 'application/json'
      render(json: { message: 'Wrong content-type header' },
             status: 406) && return
    end
  end

end

