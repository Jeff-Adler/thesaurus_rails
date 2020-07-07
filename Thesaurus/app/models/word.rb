
class Word < ActiveRecord::Base

has_many :synonym_pairs, ->(word) { where("word1_id = ? OR word2_id = ?", word.id, word.id) }
has_many :synonyms, class_name: Word, through: :synonym_pairs

def synonym_pairs

    sql = <<-SQL 
    SELECT synonym_pairs.id, synonym_pairs.word1_id, synonym_pairs.word2_id, words.word FROM synonym_pairs 
    JOIN words ON synonym_pairs.word1_id = words.id WHERE words.word = ? 
    UNION SELECT synonym_pairs.id, synonym_pairs.word1_id, synonym_pairs.word2_id, words.word FROM synonym_pairs 
    JOIN words ON synonym_pairs.word2_id = words.id WHERE words.word = ?
    SQL

    DB[:conn].execute(sql,self.word,self.word).map do |element|
        SynonymPair.find(element[0])
    end
end

    def synonyms
        self.synonym_pairs.map do |element|
            if element.word1 == self
                element.word2
            else
                element.word1
            end
        end
    end
end




