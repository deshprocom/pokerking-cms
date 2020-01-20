ActiveAdmin.register_page "Logger" do

  menu priority: 100, label: 'Logs'

  content title: 'History List' do
    columns do
      column do
        section 'Recently updated content' do
          table_for PaperTrail::Version.order('id desc').limit(20) do # Use PaperTrail::Version if this throws an error
            # column ("Item") do |v|
            #   if v.item
            #     link_to v.item.id, [:admin, v.item]
            #   end
            # end
            column(:item)
            column(:type) { |v| v.item_type.underscore.humanize }
            column(:event)
            column(:modified_at) { |v| v.created_at.to_s :long }
            column(:admin) do |v|
              if v.whodunnit.blank?
                ''
              else
                link_to AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)]
              end
            end
          end
        end
      end
    end
  end # content
end
