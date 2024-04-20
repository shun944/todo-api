require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  # Test suite for POST /todos
  describe 'POST /user' do
    # valid payload
    let(:valid_attributes) { { user: { username: 'testUser', email: 'testmail@example.com' } } }
    
    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }
      

      it 'creates a user' do
        response_json = JSON.parse(response.body)
        expect(response_json['username']).to eq('testUser')
      end
    end
  end

  describe 'PUT /user/:id' do
    let(:valid_attributes) { { user: { username: 'updatedUser', email: 'updated@example.com' } } }

    context 'when the request is valid' do
      before { put "/users/#{user_id}", params: valid_attributes }

      it 'updates a user' do
        expect(response.body).to include('"email":"updated@example.com"')
      end
      
      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /user/:id' do
    before { delete "/users/#{user_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end