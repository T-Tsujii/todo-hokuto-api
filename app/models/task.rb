class Task < ApplicationRecord
  validates :body, presence: true

  def attribute_slice
    slice(:id, :body, :is_completed).transform_keys { |k| k.camelize(:lower) }
  end

  def self.enemy_message
    [
      "汚物は消毒だ～!",
      "おれの名をいってみろ!",
      "力こそが正義, いい時代になったものだ",
      "この体には北斗神拳はきかぬ!!",
      "望みどおり相手をしてやるわ"
    ].sample
  end
end
