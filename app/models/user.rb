class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 50 },
                        format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

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
 def authenticated?(remember_token)
   return false if remember_digest.nil? # ta linijka powoduje, ze po wylogowaniu na innym urzadzeniu (co likwiduje
   #  remember digesta z bazy) przestana byc aktywne cookiesy na innych urzadzeniach (i nie pojawi sie blad zwiazany z tym,
   # ze remeber digest wynosi nil w bazie). Po tym returnie nie jest analizowana dalsza czesc metody

   BCrypt::Password.new(remember_digest).is_password?(remember_token)
 end

 # Forgets a user. Likwiduje remember digest z bazy, czyli wymagane jest stworzenie nowego, bo starym cookie sie nie zaloguje juz
 def forget
   update_attribute(:remember_digest, nil)
 end

end
