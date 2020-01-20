ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: I18n.t('active_admin.dashboard') do
    h3 '以下图表数据每10分钟更新一次', style: 'text-align: center; padding: 20px'
    columns do
      column do
        span do
          "Total Register: #{User.count}"
        end
      end
    end

    columns do
      column do
        panel '最近两周新增app用户数' do
          ul do
            line_chart recent_users_line_data
          end
        end
      end

      column do
        panel '最近八周新增app用户数' do
          ul do
            column_chart recent_weeks_users_column_data
          end
        end
      end
    end

    columns do
      column do
        panel '最近两周登录app用户数' do
          ul do
            line_chart recent_users_login_data
          end
        end
      end

      column do
        panel '最近八周登录app用户数' do
          ul do
            column_chart recent_weeks_users_login_data
          end
        end
      end
    end
  end # content
end
