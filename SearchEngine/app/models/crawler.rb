require 'open-uri'

class Crawler
  @@urls = [{base: '', path: 'http://www.yandex.by'},{base: '', path: 'http://www.livejournal.com'},{base: '', path: 'https://www.tumblr.com/dashboard'}]

  def self.append_url(url)
    @@urls << url
  end

  def self.shift_url
    @@urls.shift
  end

  def self.uniq_urls!
    @@urls.uniq!
  end

  def self.urls_length
    @@urls.length
  end

  def self.urls_empty?
    @@urls.empty?
  end

  def self.start
    mutex = Mutex.new
    2.times do
      Thread.new do
        while true
          if !Crawler.urls_empty?
            Crawler.uniq_urls!
            url = Crawler.shift_url
            unless url[:path].match(/http/)
              work_url = "#{url[:base]}#{url[:path]}"
            else
              work_url = url[:path]
            end
            puts work_url
            if Page.find_by_url(work_url).nil?
              document = Nokogiri::HTML(open(work_url, allow_redirections: :all))
              mutex.synchronize do
                Scraper.add_to_document({url: work_url, document: document})
              end
              document.css('a').first(15).each do |anchor|
                unless anchor.nil?
                  unless anchor.attribute('href').nil? or Crawler.urls_length > 20 or anchor.eql? work_url
                    unless anchor.attribute('href').value.nil? or anchor.attribute('href').value.start_with?('//') or anchor.attribute('href').value.end_with?('void(0)')
                      mutex.synchronize do
                        Crawler.append_url({base: "#{URI.parse(work_url).scheme}://#{URI.parse(work_url).host}", path: anchor.attribute('href').value})
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end.each(&:join)
  end

end