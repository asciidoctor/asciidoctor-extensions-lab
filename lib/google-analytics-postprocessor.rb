require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

# A postprocessor that appends the Google Analytics code to the bottom of the HTML.
#
# Usage
#
#   :google-analytics-account: UA-XXXXXXXX-1
#
Extensions.register do
  if @document.basebackend? 'html'
    # As of Asciidoctor 1.5.2, you can use a docinfo_processor to accomplish the same
    #docinfo_processor do
    #  at_location :footer
    #  process do |doc|
    #    # content here
    #  end
    #end
    postprocessor do
      process do |doc, output|
        next output unless doc.attr? 'google-analytics-account'
        account_id = doc.attr 'google-analytics-account'
        %(#{output.rstrip.chomp('</html>').rstrip.chomp('</body>').chomp}
<script>
 (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
  ga('create', '#{account_id}', 'auto');
  ga('send', 'pageview');
</script>
</body>
</html>)
      end
    end
  end
end
