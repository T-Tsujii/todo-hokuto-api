namespace :replace_data do
  desc "初期データに置換"
  task initial: :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tasks")
    ActiveRecord::Base.connection.execute("ALTER TABLE tasks AUTO_INCREMENT = 1")
    Task.create!(
      [
        {
          body: "掃除"
        },
        {
          body: "洗濯"
        },
        {
          body: "整理整頓"
        },
        {
          body: "買い物",
          is_completed: true,
          completed_at: Time.current
        }
      ]
    )
  end
end
