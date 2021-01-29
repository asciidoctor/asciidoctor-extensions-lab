require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

class NavigationTocPostprocessor < Asciidoctor::Extensions::Postprocessor

  def process document, output
    if document.attributes.key? 'navicons'
      case document.attributes['navicons'].downcase
      when "", 'toc' # default or axplicit toc placement
        # TODO handle various placementoptions here
        html = NavIconsBackend.gen_nav_icons(document)
        output = NavIconsBackend.insert_at(document, output, 'toc', html)
      when 'macro'
        # do nothing on this level,block macro is handled in a different stage
      end
    output #fallback
    end
    output #always passthrough
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
</style>)

  def process doc
    %(
#{FONTAWESOME_SCRIPT}
#{NAVICION_STYLESHEET})
  end

end

class NavIconsBackend

  def self.gen_icon(link=nil, fa_name='fa-home', render_inactive=false)
    # generates an icon and link HTML syntax, only if the URL could be extracted
    # filter link
    # TODO check if this is consistent with asciidoctor.rb internal handling

    if url_parse = /link\:(.*?)\[(.*?)\]/.match(link)
      # link: [ ] inline macro
      url = url_parse[1] || ""
      desc = url_parse[2] || nil
    elsif ref_parse = /&lt;&lt;(([^#]*?)(\.\w+?)?(#(\w*?))?)(?:,(.*?))?&gt;&gt;/.match(link)
      # << # , >> cross reference
      url = (ref_parse[2] + '.html') || ""
      if ref_parse[4] # add attribute link
        url << ref_parse[4]
      end
      desc = ref_parse[6] || nil
    else # fallback to direct link mode
      url = link
      desc = nil
    end

    # render HTML
    content = "<div id=\"toc-nav-item\">"
    icon = "<i class=\"fa #{fa_name}\" aria-hidden=\"true\"></i>"

    if url # URL detected
      content << %(<a href="#{url}" #{desc ? "title=\"#{desc}\"" : nil}>#{icon}</a></div>)
    elsif render_inactive # No URL but render icon anyway
      content << "#{icon}</div>"
    else # Render nothing
      content = ""
    end
    content
  end

  def self.gen_nav_icons(document)
    # TODO reduce scope by accepting attributes rather than document
    render_inactive = false # default setting
    content = "" # initilize output

    content << self.gen_icon((document.attr 'nav-home'), 'fa-home',        render_inactive)
    content << self.gen_icon((document.attr 'nav-prev'), 'fa-arrow-left',  render_inactive)
    content << self.gen_icon((document.attr 'nav-up'),   'fa-arrow-up',    render_inactive)
    content << self.gen_icon((document.attr 'nav-down'), 'fa-arrow-down',  render_inactive)
    content << self.gen_icon((document.attr 'nav-next'), 'fa-arrow-right', render_inactive)

    # return complete HTML
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

class NavBlockMacroProcessor < Asciidoctor::Extensions::BlockMacroProcessor
  # TODO this is an experiment to get to a custom inline nav definition, similar
  #       to the way in which manual TOC placement is handled.
  #  nav::[]
  # maybe this will expand to custom definitions
  #  nav::[home="link:http://asciidoctor.org[]", next="", prev="", up="", down=""]
  #  nav::["link:http://asciidoctor.org[]", "<<post2.adoc#>>", "<<post0.adoc#>>"]

  use_dsl
  named :nav

  def process(parent, reader, attrs)
    nav_html = NavIconsBackend.gen_nav_icons parent.document
    create_pass_block parent, nav_html, attrs, subs: nil
  end
end
