require "rails_helper"

RSpec.describe User, type: :model do
  context "名前とアドレスとパスワードが入力されている時" do
    it "ユーザー登録完了" do

      user = build(:user)
      expect(user).to be_valid
    end
  end

  context "名前が入力されていない場合" do
    it "エラーする" do
      user = build(:user, name: nil)
      user.valid?

      expect(user.errors.messages[:name]).to include "can't be blank"
    end
  end

  context "アドレスが入力されていない場合" do
    it "エラーする" do
      user = build(:user, email: nil)
      user.valid?

      expect(user.errors.messages[:email]).to include "can't be blank"
    end
  end

  context "パスワードが未設定の場合" do
    it "エラーする" do
      user = build(:user, password: nil)
      user.valid?

      expect(user.errors.messages[:password]).to include "can't be blank"
    end
  end

  context "登録済みのアドレスが入力された場合" do
    it "エラーする" do
      create(:user, email: "haruka@ayase.com")
      user = build(:user, email: "haruka@ayase.com")
      user.valid?

      expect(user.errors.messages[:email]).to include "has already been taken"
    end
  end

  context "パスワードが短すぎる場合" do
    it "エラーする" do

      user = build(:user, password: "math")
      user.valid?
      expect(user.errors.messages[:password]).to include "is too short (minimum is 8 characters)"
    end
  end

  context "パスワードが長すぎる場合" do
    it "エラーする" do
      user = build(:user, password: Faker::Internet.password(min_length: 129, max_length: 250, mix_case: true))
      user.valid?

      expect(user.errors.messages[:password]).to include "is too long (maximum is 128 characters)"
    end
  end
end
