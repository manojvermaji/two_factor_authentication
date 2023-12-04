require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:item) {create(:item, name:"abc")}
  
  describe "GET /index" do
    it "returns a 200 Ok response" do 
      get :'/items'
      expect(response).to have_http_status(:ok)
    end  end

  describe "POST /create" do
    it "returns a 201 created response" do
      post :'/items', params: { name: "abc"}
      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /show" do
    it "returns a 200 Ok response" do 
      get :'/items', params: { item_id: item.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /soft_delete" do
    it "returns a 200 Ok response" do 
      patch :'/items/:id/soft_delete', params: { item_id: item.id}
      expect(response).to have_http_status(:ok)
    end
  end


  # describe "PATCH /soft_delete" do
  #   it "returns a 200 Ok response" do 
  #     patch :'/items/:id/restore', params: { item_id: item.id}
  #     expect(response).to have_http_status(:ok)
  #   end
  # end


end
