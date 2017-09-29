require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

require 'rugged'
require 'pathname'

class GitMetadataPreprocessor < Asciidoctor::Extensions::Preprocessor
  def process document, reader

    begin
      repo = Rugged::Repository.discover(".")
    rescue
      $stderr.puts('Failed to find repository, git-metadata extension terminating')
      return
    end

    if repo.empty? or repo.bare?
      $stderr.puts('Repository is empty or bare repository, git-metadata extension terminating')
      return
    end

    head = repo.head

    document.attributes['git-metadata-sha'] = head.target_id
    document.attributes['git-metadata-sha-short'] = head.target_id[0,7]
    document.attributes['git-metadata-author-name'] = head.target.author[:name]
    document.attributes['git-metadata-author-email'] = head.target.author[:email]
    document.attributes['git-metadata-date'] = head.target.time.strftime("%Y-%m-%d")
    document.attributes['git-metadata-time'] = head.target.time.strftime("%H:%M:%S")
    document.attributes['git-metadata-timezone'] = head.target.time.strftime("%Z")
    document.attributes['git-metadata-commit-message'] = head.target.message

    if repo.head_detached?
      document.attributes['git-metadata-branch'] = 'HEAD detached'
    elsif repo.head_unborn?
      document.attributes['git-metadata-branch'] = 'HEAD unborn'
    else
      document.attributes['git-metadata-branch'] = repo.branches[head.name].name
    end

    tags = []
    t = Rugged::TagCollection.new(repo)
    t.each do |tag|
      if tag.target_id == head.target_id
        tags << tag.name
      end
    end
    if tags != []
      document.attributes['git-metadata-tag'] = tags.join(', ')
    end

    file_location = Pathname.new Dir.pwd
    repo_location = Pathname.new File.join(repo.path, '..') # repo.path uses the .git directory
    document.attributes['git-metadata-relative-path'] = repo_location.relative_path_from file_location
    document.attributes['git-metadata-repo-path'] = repo_location.realpath

    if repo.remotes['origin']
      document.attributes['git-metadata-remotes-origin'] = repo.remotes['origin'].url
    end

    reader
  end
end
