ActiveAdmin.register User do
  menu priority: 1

  actions :all, except: [:destroy, :edit]

  filter :user_uuid
  filter :nickname
  filter :mobile
  filter :email
  filter :reg_date

  index do
    render 'index', context: self
  end
end
