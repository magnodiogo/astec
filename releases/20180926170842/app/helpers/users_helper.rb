module UsersHelper
  def users
    User.joins(:imobiliaria).order(:login).select("imobiliarias.estipulante, name, username, users.id").
         collect{|u| [u['estipulante'].to_s + ' - ' + (u.name || u.username).to_s, u.id]}.sort
  end
end
