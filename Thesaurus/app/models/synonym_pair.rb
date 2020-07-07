class SynonymPair < ActiveRecord::Base
    belongs_to :word1, class_name: :Word
    belongs_to :word2, class_name: :Word

     def self.synonyms?(word1,word2)
        self.all.any? do |element|
            (element.word1 == word1 && element.word2 == word2) || (element.word2 == word1 && element.word1 == word2)
        end
    end
end

