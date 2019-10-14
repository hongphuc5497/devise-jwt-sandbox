Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3001',
            'localhost:4200',
            'vn-auth-fe.sakuramobile.jp'
    # origins Settings.cors.origins
    resource '*',
             :headers => :any,
             :methods => [:get, :post, :put, :patch, :delete, :options, :head], credentials: true
  end
end
