module ChartsHelper
  ActiveRecord::Base.default_timezone = :utc
  def recent_users_line_data
    Rails.cache.fetch('recent_users_line_data', expires_in: 10.minutes) do
      User.group_by_day(:created_at,
                        range: 2.weeks.ago.midnight..Time.now,
                        format: '%m-%d').count
    end
  end

  def recent_weeks_users_column_data
    Rails.cache.fetch('recent_weeks_users_column_data', expires_in: 10.minutes) do
      User.group_by_week(:created_at, format: '%m-%d', last: 8).count
    end
  end

  def recent_users_login_data
    Rails.cache.fetch('recent_users_line_data', expires_in: 10.minutes) do
      User.group_by_day(:updated_at,
                        range: 2.weeks.ago.midnight..Time.now,
                        format: '%m-%d').count
    end
  end

  def recent_weeks_users_login_data
    Rails.cache.fetch('recent_weeks_users_column_data', expires_in: 10.minutes) do
      User.group_by_week(:updated_at, format: '%m-%d', last: 8).count
    end
  end
end
