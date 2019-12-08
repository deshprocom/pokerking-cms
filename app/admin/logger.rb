ActiveAdmin.register_page "Logger" do

  menu priority: 100, label: 'Logs'

  content title: 'History List' do
    columns do
      column do
        section 'Recently updated content' do
          table_for PaperTrail::Version.order('id desc') do # Use PaperTrail::Version if this throws an error
            column ('Item') { |v| v.item }
            column ('Type') { |v| v.item_type.underscore.humanize }
            column ('Modified at') { |v| v.created_at.to_s :long }
            column ('Admin') { |v| link_to AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)] }
          end
        end
      end
    end
  end # content
end
