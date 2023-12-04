require 'rails_helper'

RSpec.describe "Authentications", type: :request do
 

  describe 'POST #login' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password', two_factor_authentication: false) }
      context 'with valid credentials and without two-factor authentication' do
      it 'returns a JWT token' do
        post :'/auth/login', params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with valid credentials and with two-factor authentication' do
      it 'returns an OTP and sends an email' do
        user.update(two_factor_authentication: true)
        post :'/auth/login', params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('Otp')
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized status' do
        post :'/auth/login', params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

  describe 'POST #otp_confirmation' do
    let(:user) { create(:user, email: 'test@example.com', otp: '123456') }

    context 'with valid OTP' do
      it 'returns a JWT token' do
        post :'/auth/otp_confirmation', params: { email: user.email, otp: '123456' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid OTP' do
      it 'returns an unauthorized status' do
        post :'/auth/otp_confirmation', params: { email: user.email, otp: '654321' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

  describe 'POST #password_change' do
    let(:user) { create(:user, email: 'test@example.com', two_factor_authentication: false) }

    context 'with two-factor authentication enabled' do
      it 'sends an OTP and returns it in the response' do
        user.update(two_factor_authentication: true)
        post :'/auth/password_change', params: { email: user.email }
        user.reload 
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('Otp')
      end
    end

    context 'with two-factor authentication disabled' do
      it 'changes the password and returns a success message' do
        post :'/auth/password_change', params: { email: user.email, password: 'new_password' }
        user.reload 
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #otp_confirmation_for_password_change' do
    let(:user) { create(:user, email: 'test@example.com', otp: '123456') }

    context 'with valid OTP' do
      it 'changes the password and returns a success message' do
        post :'/auth/otp_confirmation_for_password_change', params: { email: user.email, otp: '123456', password: 'new_password'}
        user.reload 
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid OTP' do
      it 'returns an unauthorized status' do
        post :'/auth/otp_confirmation_for_password_change', params: { email: user.email, otp: '654321', password: 'new_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

end
