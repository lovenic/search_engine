class Digger

  def self.dig(words)
    pages_ids = []
    words_ids = []
    words = words.split
    words.each do |word|
      if Word.exists?(stem: word)
        stem_id = Word.find_by_stem(Lingua.stemmer(word)).id
        words_ids << stem_id
        pages_ids << Location.where(word_id: stem_id).map {|location| location.page_id}
      end
    end
    unless words_ids.length == 0
      pages_ids = pages_ids.flatten.uniq
      pages_with_index = []
      pages_ids.each do |page|
        len = Location.where(page_id: page).map {|location| location.word_id}.length
        word_area = Location.where(page_id: page, word_id: [words_ids]).first.word_area
        positions = []
        words_ids.each do |word_id|
          positions << Location.where(page_id: page, word_id: word_id).first.position
        end
        pages_with_index << {page: Page.find(page), length: len, word_area: word_area, closeness: Digger.calculate_closeness(positions)}
      end
      pages_with_index
    else
      []
    end
  end

  def self.calculate_closeness(positions)
    positions.sort
    positions.each_cons(2).map { |a,b| b-a }
    positions.inject(:+)
  end

  def self.set_order(pages_list)
    pages_list.order_by { |page| page[:length] }.order_by { |page| page[:closeness] }
  end

end