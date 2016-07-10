require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

class NavigationTocPostprocessor < Asciidoctor::Extensions::Postprocessor

  def process document, output
    if document.attr 'navicons-toc'
      html = NavIconsBackend.gen_nav_icons(document)
      output = NavIconsBackend.insert_at(document, output, 'toc', html)
    end
    output
  end
end

class NavIconsDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  # DocinfoProcessor as used in the chart-block-macro extension for adding HTML in head or footer
  use_dsl
  at_location :head

  # inlusion of FontAwesome script, equal to the inclusion by the `:icons: font` attribute
  FONTAWESOME_SCRIPT = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">'

  # custom stylesheet for rendering the navigation icons
  NAVICION_STYLESHEET = %(<style>
/*navigation-toc-postprocessor asciidoctor extension*/
div #toc-nav{
font-size: 1.6em;
display: flex;
justify-content: space-around;
padding-bottom: 10px;
}
</style>
</head>)

  def process doc
    %(
#{FONTAWESOME_SCRIPT}
#{NAVICION_STYLESHEET})
  end

end

class NavIconsBackend

  def self.gen_icon(link="", fa_name='fa-home')
    # filter link
    # TODO check if this is consistent with asciidoctor.rb internal handling
    url_parse = /link\:(.*?)\[(.*?)\]/.match(link)
    ref_parse = /<<(([^#]*?)(\.\w+?)?(#(\w*?))?)(?:,(.*?))?>>/.match(link)
    if url_parse
      url = url_parse[1] || ""
      desc = url_parse[2] || nil
    elsif ref_parse
      url = (ref_parse[2] + '.html') || ""
      if ref_parse[4] # add attribute link
        url << ref_parse[4]
      end
      desc = ref_parse[6] || nil
    else
      url = link
      desc = nil
    end

    # render HTML
    content = "<div id=\"toc-nav-item\">"
    icon = "<i class=\"fa #{fa_name}\" aria-hidden=\"true\"></i>"
    if url
      content << "<a href=\"#{url}\""
      if desc
        content << " title=\"#{desc}\""
      end
      content << ">" + icon + "</a>"
    else
      content << icon
    end
    content << "</div>"

    content
  end

  def self.gen_nav_icons(document)
    content = ""

    content << self.gen_icon((document.attr 'nav-home'), 'fa-home')
    content << self.gen_icon((document.attr 'nav-prev'), 'fa-arrow-left')
    content << self.gen_icon((document.attr 'nav-up'),   'fa-arrow-up')
    content << self.gen_icon((document.attr 'nav-down'), 'fa-arrow-down')
    content << self.gen_icon((document.attr 'nav-next'), 'fa-arrow-right')

    "<div id =\"toc-nav\">" + content + "</div>"
  end

  def self.insert_at(document, output, location='toc', html='nil')
    if html
      case location
      when 'toc'
        # place behind the div with id 'toctitle'
        output = output.sub(/(<div id="toctitle".*?<\/div>)/m, %(\\1\n#{html}))
      when 'top'
        #TODO implement
      when 'bottom'
        #TODO implement
      end
    end
    output
  end
end


######
# TODO WIP

class NavBlockProcessor < Asciidoctor::Extensions::BlockProcessor
  # TODO this is an experiment to get to a custom inline NavIcons defition like:
  # [NAVICONS]
  # ----
  # nav-home link:http://asciidoctor.org[]
  # nav-next <<post2.adoc#>>
  # nav-prev <<post0.adoc#>>
  # ----
  use_dsl
  named :NAVICONS
  # on_context :literal
  # name_positional_attributes 'type', 'width', 'height'
  # parse_content_as :raw

  HTML_TEST_FIXED = %(<div id="toc-nav"><div id="toc-nav-item"><a href="<<index.adoc#,test1>>"><i class="fa fa-home" aria-hidden="true"></i></a></div><div id="toc-nav-item"><a href="http://asciidoctor.org/"><i class="fa fa-arrow-left" aria-hidden="true"></i></a></div><div id="toc-nav-item"><a href="../index.html"><i class="fa fa-arrow-up" aria-hidden="true"></i></a></div><div id="toc-nav-item"><a href="http://asciidoctor.org/" title="test2"><i class="fa fa-arrow-down" aria-hidden="true"></i></a></div><div id="toc-nav-item"><a href="http://asciidoctor.org/docs/user-manual/"><i class="fa fa-arrow-right" aria-hidden="true"></i></a></div></div>)

  def process(parent, reader, attrs)
    # engine = ChartBackend.resolve_engine attrs, parent.document
    # raw_data = PlainRubyCSV.parse(reader.source)
    # html = ChartBackend.process engine, attrs, raw_data
    create_pass_block parent, HTML_TEST_FIXED, attrs, subs: nil
  end
end
