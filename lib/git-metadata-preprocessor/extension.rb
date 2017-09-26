require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

require 'rugged'

class GitMetadataPreprocessor < Asciidoctor::Extensions::Preprocessor
  def process document, reader

    begin
      repo = Rugged::Repository.discover(".")
    rescue
      $stderr.puts('Failed to find repository, git-metadata extension terminating')
      return
    end

    head = repo.head

    document.attributes['git-metadata-sha'] = head.target_id
    document.attributes['git-metadata-sha-short'] = head.target_id[0,8]
    document.attributes['git-metadata-author-name'] = head.target.author[:name]
    document.attributes['git-metadata-author-email'] = head.target.author[:email]
    document.attributes['git-metadata-date'] = head.target.time.strftime("%Y-%m-%d")
    document.attributes['git-metadata-commit-message'] = head.target.message

    begin
      document.attributes['git-metadata-branch'] = repo.branches[head.name].name
    rescue
      document.attributes['git-metadata-branch'] = repo.branches[head.name]
    end

    tags = []
    a = Rugged::TagCollection.new(repo)
    a.each do |tag|
      if tag.target_id == head.target_id
        tags << tag.name
      end
    end

    document.attributes['git-metadata-tag'] = tags.join(', ')

    reader
  end
end
