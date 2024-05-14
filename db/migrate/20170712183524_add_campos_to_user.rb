class AddCamposToUser < ActiveRecord::Migration
  def change
    #encrypting passwords and authentication related fields
    rename_column :users, "crypted_password", "encrypted_password"
    change_column :users, "encrypted_password", :string, :limit => 128, :default => "", :null => false
    rename_column :users, "salt", "password_salt"
    change_column :users, "password_salt", :string, :default => "", :null => false
    
    #confirmation related fields
    add_column :users, "confirmation_token", :string
    rename_column :users, "activated_at", "confirmed_at"
    #change_column :users, "confirmation_token", :string
    add_column    :users, "confirmation_sent_at", :datetime

    #reset password related fields
    add_column :users, "reset_password_token", :string
    
    #rememberme related fields
    add_column :users, "remember_created_at", :datetime #additional field required for devise.
  
    add_column :users, :role, :string
    ## Trackable
    add_column :users, :sign_in_count, :integer, { default: 0, null: false}
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :reset_password_sent_at, :string

    ## Confirmable
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

    ## Lockable
    add_column :users, :failed_attempts, :integer, { default: 0, null: false } # Only if lock strategy is :failed_attempts
    add_column :users, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :users, :locked_at, :datetime
  end
end
