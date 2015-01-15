class Game < ActiveRecord::Base
    scope :active, -> { where(active: true) }
    serialize :phrases, Array

    before_create :generate_room_code

    before_create :set_active

    # before_create :generate_first_player_phrase


    class << self


    end


    def generate_room_code
       begin
            self.room_code = (0...4).map { (65 + rand(26)).chr }.join
       end while self.class.active.exists?(room_code: room_code)
    end

    def set_active
        self.active = true
    end


    def generate_first_player_phrase
        self.generate_phrase(1)
    end

    def generate_phrase(player_num)
        begin
            phrases = Phrase.where(category: self.category)
            our_phrase = phrases[rand(phrases.count - 1)].text
            while self.phrases.include?(our_phrase) == false
                self.send("player_#{player_num}_phrase=", our_phrase)
                self.phrases << self.send("player_#{player_num}_phrase")
                our_phrase = phrases[rand(phrases.count - 1)].text
            end

        end
        # while self.phrases.include? self.send("player_#{player_num}_phrase")

    end




end

