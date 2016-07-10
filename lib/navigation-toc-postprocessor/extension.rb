require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

class NavigationTocPostprocessor < Asciidoctor::Extensions::Postprocessor

  def process document, output
    content = ""
    if document.attr 'nav-home'
      content << "<div id=\"toc-nav-item\"><a href=\"#{(document.attr 'nav-home')}\"><i class=\"fa fa-home\" aria-hidden=\"true\"></i></a></div>"
    end
    if document.attr 'nav-prev'
      content << "<div id=\"toc-nav-item\"><a href=\"#{(document.attr 'nav-prev')}\"><i class=\"fa fa-arrow-left\" aria-hidden=\"true\"></i></a></div>"
    end
    if document.attr 'nav-up'
      content << "<div id=\"toc-nav-item\"><a href=\"#{(document.attr 'nav-up')}\"><i class=\"fa fa-arrow-up\" aria-hidden=\"true\"></i></a></div>"
    end
    if document.attr 'nav-down'
      content << "<div id=\"toc-nav-item\"><a href=\"#{(document.attr 'nav-down')}\"><i class=\"fa fa-arrow-down\" aria-hidden=\"true\"></i></a></div>"
    end
    if document.attr 'nav-next'
      content << "<div id=\"toc-nav-item\"><a href=\"#{(document.attr 'nav-next')}\"><i class=\"fa fa-arrow-right\" aria-hidden=\"true\"></i></a></div>"
    end

    css_replacement = %(<style>
/*navigation-toc-postprocessor asciidoctor extension*/
div .toc2 #toc-nav{
  font-size: 1.6em;
   display: flex;
   justify-content: space-around;
}
</style>
</head>)

    if document.basebackend? 'html'
      nav_replacement = %(\\1<div id="toc-nav">\n#{content}</div>)
      output = output.sub(/(<div id="toctitle".*?<\/div>)/m, nav_replacement)
      output = output.sub(/<\/head>/m, css_replacement)
    end
    output
  end
end
