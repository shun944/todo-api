require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:user) { create(:user) }
  let!(:user_id) { user.id }
  let!(:user2) { create(:user) }
  let!(:user_id2) { user2.id }
  let!(:todos) { create_list(:todo, 10, user: user) }
  let!(:todos_second) { { create_list(:todo, 5, user:user2 ) } }
  let(:todo_id) { todos.first.id }

  describe 'GET /todos' do
    before { get '/todos' }

    it 'returns todo' do
      response_json = JSON.parse(response.body)
      expect(response_json).not_to be_empty
      expect(response_json.size).to eq 10
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /todos/:user_id' do
    before { get 'todos/' }
  end

  describe 'GET /todos:/:id' do
    before { get "/todos/#{todo_id}" }

    context 'when the record exists' do
      it 'returns the todo' do
        response_json = JSON.parse(response.body)
        expect(response_json).not_to be_empty
        expect(response_json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /todos' do
    let(:valid_attributes) { { todo: {
        title: 'testTitle',
        description: 'testDescription',
        due_date: '2011-01-11',
        completed: 0,
        category: 'testCategory',
        user_id: user_id
    } } }

    let(:invalid_attributes) { { todo: { 
      due_date: '2011-01-11',
      completed: 0,
      category: 'testCategory',
      user_id: user_id
    } } }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes }

      it 'creates a todo' do
        response_json = JSON.parse(response.body)
        expect(response_json['title']).to eq('testTitle')
      end
    end

    context 'when the request is invalid' do
      before { post '/todos', params: invalid_attributes }

      it 'returns a validation error' do
        response_json = JSON.parse(response.body)
        expect(response_json["message"]).to match(/Validation failed: Title can't be blank, Description can't be blank/)
      end
    end
  end

  describe 'PUT /todo/:id' do
    let(:valid_attributes) { { todo: { title: 'updatedTitle', description: 'updatedDescription' } } }

    context 'when the request is valid' do
      before {put "/todos/#{todo_id}", params: valid_attributes }

      it 'updates a todo' do
        response_json = JSON.parse(response.body)
        expect(response_json["title"]).to eq('updatedTitle')
        expect(response_json["description"]).to eq('updatedDescription')
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204);  
    end

    it 'removes the todo from the database' do
      expect(Todo.find_by(id: todo_id)).to be_nil
    end
  end
end