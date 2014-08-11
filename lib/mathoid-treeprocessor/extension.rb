require 'asciidoctor'
require 'asciidoctor/extensions'
require_relative 'mathoid'

include ::Asciidoctor

module Asciidoctor
class AbstractBlock
  def find_by filter_context = nil, options = {}, &block
    result = []
    filter_context = nil if filter_context == '*'
    filter_style = options[:style]
    filter_role = options[:role]
  
    if (filter_context == nil || filter_context == @context) &&
        (filter_style == nil || filter_style == @style) &&
        (filter_role == nil || (has_role? filter_role))
      if block_given?
        puts 'here'
        result << self if yield(self)
      else
        result << self
      end
    end
  
    if @context == :document && (filter_context == nil || filter_context == :section) && header?
      result.concat @header.find_by(filter_context, options, &block) || []
    end
    
    @blocks.each do |b|
      # yuck!
      if b.is_a? ::Array
        unless filter_context == :section # optimization
          b.flatten.each do |li|
            result.concat li.find_by(filter_context, options, &block) || []
          end
        end
      else
        result.concat b.find_by(filter_context, options, &block) || []
      end
    end unless filter_context == :document # optimization
    result.empty? ? nil : result
  end unless respond_to? :find_by
end

class MathoidTreeprocessor < Asciidoctor::Extensions::Treeprocessor
  def process document
    unless (math_blocks = document.find_by :math).empty?
      mathoid = ::Mathoid.new
      mathoid.start
      math_blocks.each do |math|
        equation_data = math.content
        equation_type = math.style.to_sym
        # FIXME auto-generate id if one is not provided
        image_target = %(#{math.id}.svg)
        image_file = math.normalize_system_path image_target, (math.document.attr 'imagesdir')
        mathoid.convert_to_file image_file, equation_data, equation_type
        attrs = { 'target' => image_target, 'alt' => math.id }
        parent = math.parent
        image = Block.new parent, :image, attributes: attrs
        parent.blocks[parent.blocks.index(math)] = image
      end
      mathoid.stop
    end
    document
  end
end
end
