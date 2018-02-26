module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ error: "#{ e.message } with id: #{ params[:id] }" }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ error: e.record.errors }, :unprocessable_entity)
    end

    rescue_from ActionController::ParameterMissing do |e|
      json_response({ error: e.message }, :bad_request)
    end

    rescue_from ActionController::UnpermittedParameters do |e|
      json_response({ error: e.message }, :bad_request)
    end
  end
end