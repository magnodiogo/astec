class User < ActiveRecord::Base
  self.table_name = 'users'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :timeoutable, 
         :recoverable, :trackable,  :validatable,  :lockable, :authentication_keys => [:login] #, :encryptor => :restful_authentication_sha1

  belongs_to :imobiliaria 
  has_many :documentos
  has_many :seguros
  has_and_belongs_to_many :mensagens
  before_destroy {|user| user.mensagens.clear}

  #belongs_to :entregador, class_name: "Fornecedor", primary_key: "Código"
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
  validate :validate_username

  before_save :set_role
  #attr_accessor :login

  ROLES = %w(administrador usuario)

  # in models/user.rb
  def is?(role)
    role = (role == :admin ? :administrador : role)
    self.role.eql?(role.to_s)
  end

  def administrador?
    self.tipo == "A"
  end

  def imobiliaria?
    self.tipo == "I"
  end

  def tipo_desc
    return  case self.tipo
      when "A" then "Administrador"
      when "I" then "Imobiliária"
      else
        "Indefinido"
    end
  end

  def tipo_desc_min
    self.tipo_desc.slice(0,5) + '.'
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def set_role
    if self.administrador?
      self.role = 'administrador'
    else
      self.role = 'usuario'
    end
  end
end
