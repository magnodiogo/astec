class Documento < ActiveRecord::Base
  belongs_to :imobiliaria
  belongs_to :user

  has_attached_file :documento, :url => "/documentos/JVc6wPvAj:id7sXZKYYanDtwVpbWhFKLcdeMxKbAC3EP:idF7jpanDksfjqTtMujhwDn3.:extension",
                                :path => ":rails_root/public/documentos/JVc6wPvAj:id7sXZKYYanDtwVpbWhFKLcdeMxKbAC3EP:idF7jpanDksfjqTtMujhwDn3.:extension"
  do_not_validate_attachment_file_type :documento

end
