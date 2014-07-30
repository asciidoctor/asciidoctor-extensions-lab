require "minitest/autorun"

class Minitest::Test

  def render_embedded_string(src, opts = {})
    opts[:header_footer] = false
    document_from_string(src, opts).render
  end

  def document_from_string(src, opts = {})
    assign_default_test_options opts
    if opts[:parse]
      (Asciidoctor::Document.new src.lines.entries, opts).parse
    else
      Asciidoctor::Document.new src.lines.entries, opts
    end
  end

  def assign_default_test_options(opts)
    opts[:header_footer] = true unless opts.key? :header_footer
    opts[:parse] = true unless opts.key? :parse
    if opts[:header_footer]
      # don't embed stylesheet unless test requests the default behavior
      if opts.has_key? :linkcss_default
        opts.delete(:linkcss_default)
      else
        opts[:attributes] ||= {}
        opts[:attributes]['linkcss'] = ''
      end
    end
    if (template_dir = ENV['TEMPLATE_DIR'])
      opts[:template_dir] = template_dir unless opts.has_key? :template_dir
      #opts[:template_dir] = File.join(File.dirname(__FILE__), '..', '..', 'asciidoctor-backends', 'erb') unless opts.has_key? :template_dir
    end
    nil
  end
end

class Minitest::Test
  def self.setup(&block)
    define_method :setup do
      super(&block)
      instance_eval(&block)
    end
  end

  def self.teardown(&block)
    define_method :teardown do
      instance_eval(&block)
      super(&block)
    end
  end

  def self.context(*name, &block)
    subclass = Class.new(self)
    remove_tests(subclass)
    subclass.class_eval(&block) if block_given?
    const_set(context_name(name.join(" ")), subclass)
  end

  def self.test(name, &block)
    define_method(test_name(name), &block)
  end

  class << self
    alias_method :should, :test
    alias_method :describe, :context
  end

private

  def self.context_name(name)
    "Test#{sanitize_name(name).gsub(/(^| )(\w)/) { $2.upcase }}".to_sym
  end

  def self.test_name(name)
    "test_#{sanitize_name(name).gsub(/\s+/,'_')}".to_sym
  end

  def self.sanitize_name(name)
    name.gsub(/\W+/, ' ').strip
  end

  def self.remove_tests(subclass)
    subclass.public_instance_methods.grep(/^test_/).each do |meth|
      subclass.send(:undef_method, meth.to_sym)
    end
  end
end

def context(*name, &block)
  Minitest::Test.context(name, &block)
end
