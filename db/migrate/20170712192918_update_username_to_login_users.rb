class UpdateUsernameToLoginUsers < ActiveRecord::Migration
  def change
    User.all.each do |u|
      u.username = u.login
      u.save!
    end
  end
end
