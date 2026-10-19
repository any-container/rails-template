module Identities
  # Step 1 of sign-up: POST /identities/registrations
  # Step 2 of sign-up: POST /identities/registrations/confirmation
  class RegistrationsController < ApplicationController
    def create
      registration = IdentityRegistration.start(registration_params)

      if registration.save
        ActiveSupport::Notifications.instrument(
          "registration_created.identities",
          registration: registration, token: registration.confirmation_token
        )
        body = { id: registration.id, status: "pending", expires_at: registration.expires_at }
        body[:confirmation_token] = registration.confirmation_token if Rails.configuration.x.identities.expose_confirmation_token
        render json: body, status: :accepted
      else
        render json: { errors: registration.errors }, status: :unprocessable_content
      end
    end

    def confirm
      identity = IdentityRegistration.confirm(params[:token])

      if identity.nil?
        render json: { errors: { token: [ "is invalid or expired" ] } }, status: :unprocessable_content
      elsif identity.persisted?
        render json: identity_json(identity), status: :created
      else
        render json: { errors: identity.errors }, status: :unprocessable_content
      end
    end

    private

    def registration_params
      params.expect(registration: [ :given_name, :surname, :user_email, :user_name, :password, :password_confirmation ])
    end

    def identity_json(identity)
      identity.slice(:id, :given_name, :surname, :user_email, :user_name, :created_at)
    end
  end
end
