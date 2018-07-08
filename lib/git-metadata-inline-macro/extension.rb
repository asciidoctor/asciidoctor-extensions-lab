require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'rugged'

include Asciidoctor

def commit_info(commit, inf)
    inf = inf.split(",").map do |m|
        if m == 'm'
            commit.message
        elsif m == 'h'
            commit.oid
        elsif m == 'hs'
            commit.oid.slice(0,7)
        elsif m == 'a'
            commit.author[:name]
        elsif m == 'e'
            commit.author[:email]
        elsif m == 't'
            commit.time.strftime '%H:%M:%S'
        elsif m == 'd'
            commit.time.strftime '%Y-%m-%d'
        elsif m == 'z'
            commit.time.strftime '%Z'
        end
    end
    return inf.join(' ')
end

def tag_info(tag, inf)
    inf = inf.split(",").map do |m|
        if m == 'm'
            tag.target.message
        elsif m == 'h'
            tag.target_id
        elsif m == 'hs'
            tag.target_id.slice(0,7)
        elsif m == 'a'
            tag.target.tagger[:name]
        elsif m == 'e'
            tag.target.tagger[:email]
        elsif m == 't'
            tag.target.tagger[:time].strftime '%H:%M:%S'
        elsif m == 'd'
            tag.target.tagger[:time].strftime '%Y-%m-%d'
        elsif m == 'z'
            tag.target.tagger[:time].strftime '%Z'
        elsif m == 'c'
            tag.target.target_id
        end
    end
    return inf.join(' ')
end

def get_git_info(info_type, name, want)
    begin
        repo = Rugged::Repository.discover('.')
    rescue
        $stderr.puts('Failed to find repository, git-metadata extension terminating')
        return
    end

    if repo.empty? || repo.bare?
        $stderr.puts('Repository is empty or bare repository, git-metadata extension terminating')
        return
    end

    if info_type == 'c'
        begin
            commit = repo.lookup(name)
        rescue
            return 'Unknown'
        end

        commit_info commit, want

    elsif info_type == 't'
        ref = repo.references['refs/tags/' + name]
        if ref == nil
          "Unknown"
        elsif ref.target.type == :tag
          tag_info ref, want
        elsif ref.target.type == :commit
          # lightweight tag
          commit_info ref.target, want
        end

    elsif info_type == 'b'
        ref = repo.references['refs/heads/' + name]
        if ref == nil
          "Unknown"
        elsif ref.target.type == :commit
          commit_info ref.target, want
        end

    end
end

class GitMetadataInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :gitget
  name_positional_attributes 'info_type', 'data'

  def process parent, target, attributes
    doc = parent.document
    get_git_info(attributes['info_type'], target, attributes['data'])
  end
end
