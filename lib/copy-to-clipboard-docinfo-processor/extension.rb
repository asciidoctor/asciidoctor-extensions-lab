class CopyToClipboardTreeProcessor < Asciidoctor::Extensions::TreeProcessor
  def process doc
    doc.add_role 'doc' unless doc.has_role? 'doc'
    nil
  end
end

class CopyToClipboardStylesDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl
  at_location :head

  def process doc
    extdir = ::File.join ::File.dirname __FILE__
    <<-EOS
<style>
#{doc.read_asset %(#{extdir}/styles.css)}
</style>
    EOS
  end
end

class CopyToClipboardBehaviorDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl
  at_location :footer

  def process doc
    extdir = ::File.join ::File.dirname __FILE__
    <<-EOS
<script id="site-script">
#{doc.read_asset %(#{extdir}/behavior.js)}
</script>
    EOS
  end
end
