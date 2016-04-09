
class Scraper
  @@documents = []

  def self.add_to_document(document)
    @@documents << document
  end

  def self.get_from_document
    @@documents.shift
  end

  def self.remove_useless_tags(document)
    %w(style noscript script form img).each { |tag| document.search(tag).remove}
  end

  def self.documents_empty?
    @@documents.empty?
  end

  def self.process(document_params)
    document = document_params[:document]
    title =  document.css('title').inner_text
    Scraper.remove_useless_tags(document)
    text = document.at('body').inner_text
    words = text.scan(/\w+/)
    url = document_params[:url]
    words.each do |word|
      new_stem = Word.find_or_create_by(stem: Lingua.stemmer(word))
      word_id = new_stem.id
      page = Page.find_or_create_by(url: url, title: title)
      page_id = page.id
      position = words.find_index(word)
      puts word
      Location.create position: position, word_area: Scraper.set_word_area(word, text), word_id: word_id, page_id: page_id
    end
  end


  def self.set_word_area(word, text)
    position = text =~ /\b#{word}\b/ || 0
    if position < 10
      left_position = position
    elsif position < 50
      left_position = 10
    elsif position < 100
      left_position = 30
    else
      left_position = 50
    end

    text_length = text.length

    if (text_length-position) < 10
      right_position = position
    elsif (text_length-position) < 50
      right_position = 10
    elsif (text_length-position) < 100
      right_position = 30
    else
      right_position = 50
    end

    text[position - left_position..position + right_position]
  end

  def self.start
    while true
      unless Scraper.documents_empty?
        Scraper.process(Scraper.get_from_document)
      end
    end
  end

end