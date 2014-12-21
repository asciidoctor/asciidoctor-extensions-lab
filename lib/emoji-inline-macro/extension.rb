require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

class EmojiBlockMacro < Extensions::InlineMacroProcessor
  use_dsl
  named :emoji

  SIZE_MAP = {'1x' => 17, 'lg' => 24, '2x' => 34, '3x' => 50, '4x' => 68, '5x' => 85}
  SIZE_MAP.default = 24

  def process parent, target, attributes
    doc = parent.document
    if doc.attributes['emoji'] == 'tortue'
      slash = (doc.attr? 'htmlsyntax', 'xml') ? '/' : nil
      size = SIZE_MAP[attributes['size']]
      cdn = (attributes.key? 'cdn') ? attributes['cdn'] : 'http://www.tortue.me/emoji/'
      qtarget = %(#{cdn}#{target}.png)
      %(<img src="#{parent.image_uri qtarget, nil}" height="#{size}px" width="#{size}px"#{slash}>)
    else
      # By default twemoji
      slash = (doc.attr? 'htmlsyntax', 'xml') ? '/' : nil
      size = (attributes.key? 'size') ? attributes['size'] : nil
      emojiTag = target.tr('_', '-')
      if size == nil
        %(<i class="twa twa-#{emojiTag}"></i>)
      else
        %(<i class="twa twa-#{size} twa-#{emojiTag}"></i>)
      end
    end
  end
end

class TwemojiCssDocinfoProcessor < Extensions::DocinfoProcessor
  use_dsl
  at_location :header

  def process doc
    unless doc.attributes['emoji'] == 'tortue'
      currentdir = File.join File.dirname(__FILE__)
      stylesheet_name = "twemoji-awesome.css"
      if doc.attr('data-uri')
        content = doc.read_asset "#{currentdir}/#{stylesheet_name}"
        %(<style>#{content}</style>)
      else
        stylesheet_href = handle_stylesheet doc, currentdir, stylesheet_name
        %(<link rel="stylesheet" href="#{stylesheet_href}">)
      end
    end
  end

  def handle_stylesheet doc, currentdir, stylesheet_name
    outdir = doc.attr? 'outdir' ? doc.attr('outdir') : doc.attr('docdir')
    stylesdir = doc.attr('stylesdir')
    stylesoutdir = doc.normalize_system_path(stylesdir, outdir, doc.safe >= SafeMode::SAFE ? outdir : nil)
    if doc.safe < SafeMode::SECURE && doc.attr? 'copycss' && stylesoutdir != currentdir
      destination = doc.normalize_system_path stylesheet_name, stylesdir, (doc.safe >= SafeMode::SAFE ? outdir : nil)
      content = doc.read_asset "#{currentdir}/#{stylesheet_name}"
      ::File.open(destination, 'w') {|f|
        f.write content
      }
      destination
    else
      "./#{stylesheet_name}"
    end
  end
end
