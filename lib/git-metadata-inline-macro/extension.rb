require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'rugged'

include Asciidoctor

def commit_info commit, inf
  inf.split(',').map do |m|
    case m
    when 'm'
      commit.message
    when 'h'
      commit.oid
    when 'hs'
      commit.oid.slice 0, 7
    when 'a'
      commit.author[:name]
    when 'e'
      commit.author[:email]
    when 't'
      commit.time.strftime '%H:%M:%S'
    when 'd'
      commit.time.strftime '%Y-%m-%d'
    when 'z'
      commit.time.strftime '%Z'
    end
  end.join ' '
end

def tag_info tag, inf
  inf.split(',').map do |m|
    case m
    when 'm'
      tag.target.message
    when 'h'
      tag.target_id
    when 'hs'
      tag.target_id.slice 0, 7
    when 'a'
      tag.target.tagger[:name]
    when 'e'
      tag.target.tagger[:email]
    when 't'
      tag.target.tagger[:time].strftime '%H:%M:%S'
    when 'd'
      tag.target.tagger[:time].strftime '%Y-%m-%d'
    when 'z'
      tag.target.tagger[:time].strftime '%Z'
    when 'c'
      tag.target.target_id
    end
  end.join ' '
end

def get_git_info info_type, name, want
  begin
    repo = Rugged::Repository.discover '.'
  rescue
    warn 'Failed to find repository, git-metadata extension terminating'
    return
  end

  if repo.empty? || repo.bare?
    warn 'Repository is empty or bare repository, git-metadata extension terminating'
    return
  end

  case info_type
  when 'c'
    begin
      commit = repo.lookup name
    rescue
      return 'Unknown'
    end

    commit_info commit, want

  when 't'
    ref = repo.references['refs/tags/' + name]
    if ref.nil?
      'Unknown'
    elsif ref.target.type == :tag
      tag_info ref, want
    elsif ref.target.type == :commit
      # lightweight tag
      commit_info ref.target, want
    end

  when 'b'
    ref = repo.references['refs/heads/' + name]
    if ref.nil?
      'Unknown'
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
    get_git_info attributes['info_type'], target, attributes['data']
  end
end
