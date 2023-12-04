require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, email: 'test@example.com', password: 'password', two_factor_authentication: true) }


  before do
    jwt_token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
    @headers = { 'Authorization' => "Bearer #{jwt_token}" }
  end


  describe "GET /index" do
    it "returns a 200 Ok response" do 
      get :'/users', headers: @headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    it "returns a 200 Ok response" do 
      post :'/users', params: { email: 'test@example.com', password: 'password', two_factor_authentication: true }
      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /show" do
    it "returns a 200 Ok response" do 
      get :'/users', params: { user_id: user.id}, headers: @headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /update" do
    it "returns a 200 Ok response" do 
      put "/users/#{user.id}", params: { email: 'test@example.com', password: 'password', two_factor_authentication: true }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe "DELETE /destroy" do
    it "returns a 200 Ok response" do 
      delete "/users/#{user.id}", headers: @headers
      expect(response).to have_http_status(204)
    end
  end


end
