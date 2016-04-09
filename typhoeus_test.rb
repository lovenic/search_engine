require 'typhoeus'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'thread'
require 'byebug'


queue_for_scraper = []
queue_for_crawler = []
queue_for_crawler << {path: 'http://www.yandex.ru'}
mutex = Mutex.new

# Typhoeus::Hydra.new(max_concurrency: 10)
# hydra = Typhoeus::Hydra.new
# request = Typhoeus::Request.new(queue_for_crawler.shift)
# hydra.queue(request)
# hydra.run
2.times.map do 
	Thread.new do
		while true
		  if !queue_for_crawler.empty?
		  	queue_for_crawler = queue_for_crawler and queue_for_crawler 
		    url = queue_for_crawler.shift
		    unless url[:path].match(/http/)
		      work_url = "#{url[:base]}#{url[:path]}"
		    else
		      work_url = url[:path]
		    end
		    document = Nokogiri::HTML(open(work_url, allow_redirections: :all))
		    queue_for_scraper << {url: work_url, document: document}
		    document.css('a')[0..10].each do |anchor|
		      unless anchor.attribute('href').nil? or queue_for_crawler.length > 20 or anchor.eql? work_url
		        unless anchor.attribute('href').value.nil? or anchor.attribute('href').value.start_with?('//')
		        	mutex.synchronize do  
		          		queue_for_crawler << {base: "#{URI.parse(work_url).scheme}://#{URI.parse(work_url).host}", path: anchor.attribute('href').value}
		        	end
		        end
		      end
		    end
		  end
		end
	end
end.each(&:join)






