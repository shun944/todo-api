require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  # Test suite for POST /todos
  describe 'POST /todos' do
    # valid payload
    let(:valid_attributes) { {user: { username: 'testUser', email: 'testmail@example.com' } } }
    
    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }
      

      it 'creates a user' do
        response_json = JSON.parse(response.body)
        expect(response_json['username']).to eq('testUser')
      end
    end
  end
end