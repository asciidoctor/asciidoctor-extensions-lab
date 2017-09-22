require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

require 'git'
#require 'logger'

class GitMetadataPreprocessor < Asciidoctor::Extensions::Preprocessor
  def process document, reader
    #g = Git.open(document.attributes['git-directory']) # :log => Logger.new(STDOUT)
    output=`git rev-parse --is-inside-work-tree`
    result=$?.success?
    puts(output.strip().class)
    puts(result.class)
    if result == true and output.strip() == 'true'
      mypath = `git rev-parse --show-toplevel`
      mypath = mypath.gsub('/','\\') #.gsub(/^\//,'//')
      puts(mypath)
      g = Git.open(mypath)
    else
      abort("She cannot take any more of this, Captain!")

      exit
    end
    # git
    # true then
    # git rev-parse --show-toplevel

    document.sourcemap = true
    $stderr.puts(document.attributes) # outputs environment, not document attributes
    # how do I get the document attributes?

    # not like this...
    header_attr_names = (document.instance_variable_get :@attributes_modified).to_a
    header_attr_names.each {|k| $stderr.puts(k) }

    head = g.object('HEAD')
    document.attributes['git-metadata-sha'] = head.sha
    document.attributes['git-metadata-sha-short'] = head.sha[0,7]
    document.attributes['git-metadata-author-name'] = head.author.name
    document.attributes['git-metadata-author-email'] = head.author.name
    document.attributes['git-metadata-date-mdy'] = head.date.strftime("%m-%d-%y")
    document.attributes['git-metadata-date-dmy'] = head.date.strftime("%d-%m-%y")
    document.attributes['git-metadata-commit-message'] = head.message
    document.attributes['git-metadata-branch'] = g.current_branch
    #document.attributes['git-metadata-tag'] = g.describe(head,{:tags => true})

    reader
  end
end

Asciidoctor::Extensions.register do
  preprocessor GitMetadataPreprocessor
end
