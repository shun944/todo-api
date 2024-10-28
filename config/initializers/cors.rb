# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

allow do
  origins 'localhost:3000', 'https://web.mon944.com'
  resource '*',
    headers: :any,
    methods: [:get, :post, :put, :delete, :options, :head],
    expose: ['Content-Length', 'Access-Control-Allow-Origin', 'Access-Control-Allow-Credentials', 'Access-Control-Allow-Methods', 'Access-Control-Allow-Headers'],
    max_age: 600,
    credentials: true
end
