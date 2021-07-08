require 'asciidoctor'
require 'asciidoctor/extensions'
counter = 'a'

Asciidoctor::Extensions.register do
  block do
    named :gallery
    on_context :open
    # A bit hacky. Each image gallery needs a unique string:
    # http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby#88341
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    process do |parent, reader, attrs|
      lines = []
      wrapper = create_open_block parent, [], {}
      parse_content wrapper, reader
      counter = (0...50).map { o[rand(o.length)] }.join
      wrapper.find_by(context: :image).each do |img|
        src = img.attr 'target'
        alt = img.attr 'alt'
        thumb_src = src.sub(/\.[^.]+$/, '-thumb\0')
        #lines << %(image:#{thumb_src}[#{alt}, title="#{img.attr 'title'}", role=fancybox-effects, link=#{parent.image_uri src}])
        lines << %(<a class="fancybox" rel="fancybox-#{counter}" href="#{parent.image_uri src}" title="#{img.attr 'title'}"><img src="#{parent.image_uri thumb_src}" alt="#{alt}"></a>)
      end
      create_paragraph parent, lines, {}, subs: nil
    end
  end

  docinfo_processor do
    at_location :head
    process do |doc|
      result = []
      backend = doc.backend
      if backend == 'html5'
        result << %(
        <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.css" type="text/css" media="screen" />
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.pack.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-buttons.css" type="text/css" media="screen" />
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-buttons.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-media.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-thumbs.css" type="text/css" media="screen" />
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-thumbs.js"></script>
        <script type="text/javascript">
        	$(document).ready(function() {
        		$(".fancybox").fancybox();
        	});
        </script>)
      elsif backend == 'xhtml5'
        result << %(
        <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.css" type="text/css" media="screen" />
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.pack.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-buttons.css" type="text/css" media="screen" />
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-buttons.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-media.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-thumbs.css" type="text/css" media="screen" />
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/helpers/jquery.fancybox-thumbs.js"></script>
        <script type="text/javascript">
        	$(document).ready(function() {
        		$(".fancybox").fancybox();
        	});
        </script>)
      end
    end
  end

end
