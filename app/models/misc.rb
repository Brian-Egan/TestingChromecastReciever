class Misc < ActiveRecord::Base

    before_create :generate_babble




    def generate_babble
        begin
            self.babble = (0...6).map { (65 + rand(26)).chr }.join
        end
    end

end
