require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor


$pad_counter_values = {}
$pad_counter_default = '1'


class PadCounterInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :counter

  def process parent, target, attrs  
    
    value = nil
		
	attrs.each_key do |x|
	  if x =~ /^value$/i
		value = "#{attrs[$&]}"
	    $pad_counter_values["#{target}"] = value
        return value
	  end
	end

    unless $pad_counter_values["#{target}"]
      $pad_counter_values["#{target}"] = $pad_counter_default
	  return $pad_counter_default
	else
	  return $pad_counter_values["#{target}"].succ!
	end
	
  end
end


class PadCounterIncrementInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :incr_cntr

  def process parent, target, attrs  
	
	$pad_counter_values["#{target}"].succ!

	return nil

  end
end


class PadCounterDisplayInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :disp_cntr

  def process parent, target, attrs
  
	return $pad_counter_values["#{target}"]
	
  end
end


class PadCounterConfigureInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :conf_cntrs
  
  using_format :short  # this way, no <target> bit is required--OR EVEN ALLOWED!--in the inline-macro-notation

  def process parent, target, attrs 

  	attrs.each_key do |x|
	  if x =~ /^default$/i
		$pad_counter_default = "#{attrs[$&]}"
        break
	  end
    end
	
	return nil
	
  end
end

