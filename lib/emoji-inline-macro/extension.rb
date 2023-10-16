require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

class EmojiInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :emoji
  name_positional_attributes 'size'

  SIZE_MAP = { '1x' => 17, 'lg' => 24, '2x' => 34, '3x' => 50, '4x' => 68, '5x' => 85 }
  SIZE_MAP.default = 24

  def process parent, target, attributes
    doc = parent.document
    if doc.attr? 'emoji', 'tortue'
      size = SIZE_MAP[attributes['size']]
      cdn = (attributes.key? 'cdn') ? attributes['cdn'] : (doc.attr 'emoji-cdn', 'http://www.tortue.me/emoji/')
      qtarget = %(#{cdn}#{target}.png)
      create_inline parent, :image, nil, target: qtarget, attributes: { 'alt' => target, 'width' => size.to_s, 'height' => size.to_s }
    # Use twemoji by default
    else
      size_class = (size = attributes['size']) ? %( twa-#{size}) : nil
      emoji_name = target.tr '_', '-'
      create_inline_pass parent, %(<i class="twa#{size_class} twa-#{emoji_name}"></i>)
    end
  end
end

class EmojiAssetsDocinfoProcessor < Extensions::DocinfoProcessor
  use_dsl
  at_location :head

  def process doc
    unless doc.attributes['emoji'] == 'tortue'
      extdir = ::File.join ::File.dirname __FILE__
      stylesheet_name = 'twemoji-awesome.css'
      if doc.attr? 'linkcss'
        stylesheet_href = handle_stylesheet doc, extdir, stylesheet_name
        %(<link rel="stylesheet" href="#{stylesheet_href}">)
      else
        content = doc.read_asset %(#{extdir}/#{stylesheet_name})
        ['<style>', content.chomp, '</style>'].join ?\n
      end
    end
  end

  def handle_stylesheet doc, extdir, stylesheet_name
    outdir = (doc.attr? 'outdir') ? (doc.attr 'outdir') : (doc.attr 'docdir')
    stylesoutdir = doc.normalize_system_path((doc.attr 'stylesdir'), outdir, (doc.safe >= SafeMode::SAFE ? outdir : nil))
    if stylesoutdir != extdir && doc.safe < SafeMode::SECURE && (doc.attr? 'copycss')
      destination = doc.normalize_system_path stylesheet_name, stylesoutdir, (doc.safe >= SafeMode::SAFE ? outdir : nil)
      content = doc.read_asset %(#{extdir}/#{stylesheet_name})
      ::File.write destination, content, mode: 'w:UTF-8'
      destination
    else
      %(./#{stylesheet_name})
    end
  end
end
