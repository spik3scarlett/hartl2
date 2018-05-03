class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 50 },
                        format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def activate
   update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end


   def self.digest(string) # hashuje stringa
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember # tworzy token bedacy atrybutem usera (uzywajac wczesniej zdefiniowanych metod) i zapamietuje jeg zhaszowana wersje w bazie userow
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
   digest = self.send("#{attribute}_digest") # to jest w zasadzie to samo co user.activation_digest tylko ze
   #  wprowadzamy metaprogramowanie aby mozna bylo uzyc attribute do wywolania metody remember_digest oraz activation_digest
   return false if digest.nil?
   BCrypt::Password.new(digest).is_password?(token)
  end

 # Forgets a user. Likwiduje remember digest z bazy, czyli wymagane jest stworzenie nowego, bo starym cookie sie nie zaloguje juz
 def forget
   update_attribute(:remember_digest, nil)
 end

   private
     # Converts email to all lower-case.
     def downcase_email
       self.email = email.downcase
     end

     # Creates and assigns the activation token and digest.
     def create_activation_digest
       self.activation_token  = User.new_token
       self.activation_digest = User.digest(activation_token)
     end

end
