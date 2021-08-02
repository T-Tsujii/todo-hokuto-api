Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # 開発環境
  allow do
    origins "http://localhost:3000"

    resource "*",
             headers: :any,
             expose: ["access-token", "client", "uid"],
             methods: [:get, :post, :patch, :delete]
  end

  # 本番環境
  allow do
    origins "https://t-tsujii.github.io"

    resource "*",
             headers: :any,
             expose: ["access-token", "client", "uid"],
             methods: [:get, :post, :patch, :delete]
    #  credentials: true
  end
end
