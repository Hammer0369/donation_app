class DonationAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture, :city, :house_number, :building_name, :price, :user_id

  with_options presence: true do
    # 1以上、1000000以下の整数を許可する
    validates :price, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000000, message: 'is invalid'}
    # このクラスではアソシエーションを定義できないため、belongs_toに代わり新たにバリデーションを追記
    validates :user_id
    # 数字3桁、ハイフン、数字4桁の並びのみ許可する
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
  end
  # 0以外の整数を許可する
  validates :prefecture, numericality: {other_than: 0, message: "can't be blank"}

  def save
    # 寄付情報を保存し、変数donationに代入する
    donation = Donation.create(price: price, user_id: user_id)
    # 住所を保存する
    # donation_idには、変数donationのidと指定する
    Address.create(postal_code: postal_code, prefecture: prefecture, city: city, house_number: house_number, building_name: building_name, donation_id: donation.id)
  end
end