require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

class NavigationTocPostprocessor < Asciidoctor::Extensions::Postprocessor
  def process document, output
    content = ""
    if document.attr 'nav-home'
      content << "<a href=\"#{(document.attr 'nav-home')}\"><i class=\"fa fa-home\" aria-hidden=\"true\"></i></a>&nbsp;"
    end
    if document.attr 'nav-prev'
      content << "<a href=\"#{(document.attr 'nav-prev')}\"><i class=\"fa fa-arrow-left\" aria-hidden=\"true\"></i></a>&nbsp;"
    end
    if document.attr 'nav-up'
      content << "<a href=\"#{(document.attr 'nav-up')}\"><i class=\"fa fa-arrow-up\" aria-hidden=\"true\"></i></a>&nbsp;"
    end
    if document.attr 'nav-down'
      content << "<a href=\"#{(document.attr 'nav-down')}\"><i class=\"fa fa-arrow-down\" aria-hidden=\"true\"></i></a>&nbsp;"
    end
    if document.attr 'nav-next'
      content << "<a href=\"#{(document.attr 'nav-next')}\"><i class=\"fa fa-arrow-next\" aria-hidden=\"true\"></i></a>&nbsp;"
    end
    if document.basebackend? 'html'
      replacement = %(\\1<div id="toc-nav">\n#{content}</div>)
      output = output.sub(/(<div id="toctitle".*?<\/div>)/m, replacement)
    end
    output
  end
end
