require 'net/https'

class PygmentWorker
  include Sidekiq::Worker
   
  def perform(snippet_id)
  　snippet = Snippet.find(snippet_id)
  　#uri = URI.parse("https://pygments.simplabs.com/")
  　#request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
  　#snippet.update_attribute(:highlighted_code, request.body)
    snippet.update_attribute(:highlighted_code, "unkounko")
  end
end
