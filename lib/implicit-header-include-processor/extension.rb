require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

# An include processor that skips the implicit author line below
# the document title in included documents.
class ImplicitHeaderIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
  AuthorInfoLineRx = /^(\p{Word}[\p{Word}\-'.]*)(?: +(\p{Word}[\p{Word}\-'.]*))?(?: +(\p{Word}[\p{Word}\-'.]*))?(?: +<([^>]+)>)?$/

  def process doc, reader, target, attributes
    inc_path = doc.normalize_system_path target, reader.dir, nil, target_name: 'include file'
    return reader unless File.exist? inc_path
    ::File.open inc_path, 'r' do |fd|
      # FIXME handle case where doc id is specified above title
      if (first_line = fd.readline) && (first_line.start_with? '= ')
        # HACK reset counters for each article for Editions
        if doc.attr? 'env', 'editions'
          doc.counters.each do |counter_key, counter_val|
            doc.attributes.delete counter_key
          end
          doc.counters.clear
        end
        if (second_line = fd.readline)
          if ::Asciidoctor::AuthorInfoLineRx =~ second_line
            # FIXME temporary hack to set author and e-mail attributes; this should handle all attributes in header!
            author = [$1, $2, $3].compact.join ' '
            email = $4
            reader.push_include fd.readlines, inc_path, target, 3, attributes unless fd.eof?
            reader.push_include first_line, inc_path, target, 1, attributes
            lines = [%(:author: #{author})]
            lines << %(:email: #{email}) if email
            reader.push_include lines, inc_path, target, 2, attributes
          else
            lines = [second_line]
            lines += fd.readlines unless fd.eof?
            reader.push_include lines, inc_path, target, 2, attributes
            reader.push_include first_line, inc_path, target, 1, attributes
          end
        else
          reader.push_include first_line, inc_path, target, 1, attributes
        end
      else
        lines = [first_line]
        lines += fd.readlines unless fd.eof?
        reader.push_include lines, inc_path, target, 1, attributes
      end
    end
    reader
  end

  def handles? target
    true
  end
end
