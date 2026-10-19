require "rails_helper"

RSpec.describe "Identity registration", type: :request do
  let(:params) do
    { registration: { given_name: "Jane", surname: "Doe", user_email: "jane@example.com", user_name: "jane",
                      password: "s3cret-pass", password_confirmation: "s3cret-pass" } }
  end

  it "registers, then confirms into an Identity" do
    events = []
    subscriber = ActiveSupport::Notifications.subscribe("registration_created.identities") { |*, payload| events << payload }

    post "/identities/registrations", params: params, as: :json
    expect(response).to have_http_status(:accepted)
    body = response.parsed_body
    expect(body["status"]).to eq("pending")
    expect(events.size).to eq(1)
    expect(events.first[:token]).to eq(body["confirmation_token"])
    expect(Identity.count).to eq(0)

    post "/identities/registrations/confirmation", params: { token: body["confirmation_token"] }, as: :json
    expect(response).to have_http_status(:created)
    expect(response.parsed_body).to include("user_name" => "jane", "user_email" => "jane@example.com")
    expect(response.parsed_body).not_to have_key("password_digest")
    expect(Identity.find_by(user_name: "jane").authenticate("s3cret-pass")).to be_truthy
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  it "withholds the token from the response when not exposed" do
    allow(Rails.configuration.x.identities).to receive(:expose_confirmation_token).and_return(false)
    post "/identities/registrations", params: params, as: :json
    expect(response).to have_http_status(:accepted)
    expect(response.parsed_body).not_to have_key("confirmation_token")
  end

  it "rejects invalid registrations" do
    post "/identities/registrations", params: { registration: params[:registration].merge(password: "short", password_confirmation: "short") }, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["errors"]).to have_key("password")
  end

  it "rejects a password confirmation mismatch" do
    post "/identities/registrations", params: { registration: params[:registration].merge(password_confirmation: "different-pass") }, as: :json
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "rejects an invalid confirmation token" do
    post "/identities/registrations/confirmation", params: { token: "bogus" }, as: :json
    expect(response).to have_http_status(:unprocessable_content)
  end
end
