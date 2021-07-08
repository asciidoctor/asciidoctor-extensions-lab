require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'fastimage'

include ::Asciidoctor

class ImageSizingTreeprocessor < Extensions::Treeprocessor
  def process document

    images = document.find_by context: :image

    images.each do |img|
      adjust_image img, document
    end

    # we also need to image images in a| table cells
    # this is not very elegant...
    tables = document.find_by context: :table
    tables.each do |t|
      for acell in (t.rows.body + t.rows.foot).flatten.select {|c| c.attr? 'style', :asciidoc }
        for img in acell.inner_document.find_by context: :image
          adjust_image img, document
        end
      end
    end

  end

  def adjust_image(img, document)

    attrs = img.attributes

    # is this necessarily constant? could it be removed out of the loop or passed in?
    basedir =  (document.attr 'outdir') || ((document.respond_to? :options) && document.options[:to_dir])

    uri = img.image_uri attrs['target']
    uri_starts = ['http://', 'https://', 'ftp://']
    # absolute path for local files
    if ! uri.start_with? *uri_starts
      uri = File.join basedir, uri
    end

    width_w, height_w = nil

    width_w = (attrs['2'] if attrs.key? '2') \
                 || (attrs['width'] if attrs.key? 'width')

    height_w = (attrs['3'] if attrs.key? '3') \
                 || (attrs['height'] if attrs.key? 'height')

    # this might fail due to e.g. no network connection
    # potentially timeout parameters might be useful?
    begin
      width, height = FastImage.size uri
    rescue
      $stderr.puts('Unable to get image parameters for: ' + uri)
      return
    end

    # this always uses the image aspect ratio and any any user input
    # width (obviously) dominates
    if width_w
      attrs['width'] = width_w
      attrs['height'] = width_w.to_f/width*height
    elsif height_w
      attrs['width'] = height_w.to_f/height*width
      attrs['height'] = height_w
    else
      attrs['width'] = width
      attrs['height'] = height
    end

  end
end
