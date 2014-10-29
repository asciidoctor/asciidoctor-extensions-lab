require 'asciidoctor'
require 'asciidoctor/extensions'
require 'csv'
require 'securerandom'

include ::Asciidoctor

# A block macro that embeds a Chart into the output document
#
# Usage
#
#   chart::line[data-uri=sample.csv]
#
class ChartBlockMacro < Extensions::BlockMacroProcessor
  use_dsl

  named :chart

  # TODO http or https ? asset_uri_scheme ?
  C3JS_STYLESHEET = '<link href="http://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css" rel="stylesheet" type="text/css">'
  D3JS_SCRIPT = '<script src="http://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js" charset="utf-8"></script>'
  C3JS_SCRIPT = '<script src="http://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>'

  def process(parent, target, attrs)
    case target
      when 'bar' then c3js_bar parent, attrs
      when 'line' then  c3js_line parent, attrs
      when 'step' then c3js_step parent, attrs
      when 'spline' then c3js_spline parent, attrs
      else
        # By default chart line
        c3js_line parent, attrs
    end
  end

  # c3.js

  def c3js_bar(parent, attrs)
    data, labels = c3js_prepare_data(attrs, parent)
    chart_id = get_chart_id
    chart_div = c3js_create_chart_div(chart_id)
    chart_generate_script = c3js_chart_bar_script(chart_id, data, labels)
    html = c3js_html(chart_div, chart_generate_script)

    create_pass_block parent, html, attrs, subs: nil
  end

  def c3js_line(parent, attrs)
    data, labels = c3js_prepare_data(attrs, parent)
    chart_id = get_chart_id
    chart_div = c3js_create_chart_div(chart_id)
    chart_generate_script = c3js_chart_line_script(chart_id, data, labels)
    html = c3js_html(chart_div, chart_generate_script)

    create_pass_block parent, html, attrs, subs: nil
  end

  def c3js_step(parent, attrs)
    data, labels = c3js_prepare_data(attrs, parent)
    chart_id = get_chart_id
    chart_div = c3js_create_chart_div(chart_id)
    chart_generate_script = c3js_chart_step_script(chart_id, data, labels)
    html = c3js_html(chart_div, chart_generate_script)

    create_pass_block parent, html, attrs, subs: nil
  end

  def c3js_spline(parent, attrs)
    data, labels = c3js_prepare_data(attrs, parent)
    chart_id = get_chart_id
    chart_div = c3js_create_chart_div(chart_id)
    chart_generate_script = c3js_chart_spline_script(chart_id, data, labels)
    html = c3js_html(chart_div, chart_generate_script)

    create_pass_block parent, html, attrs, subs: nil
  end

  def c3js_create_chart_div(chart_id)
    %(<div id="#{chart_id}"></div>)
  end

  def get_chart_id
    # TODO Read from attributes ?
    'chart' + SecureRandom.uuid
  end

  def c3js_prepare_data(attrs, parent)
    data = CSV.read(File.join parent.document.base_dir, attrs['data-uri'])
    labels = data[0]
    data.shift
    data.map.with_index do |row, index|
      row.unshift "#{index}"
    end
    return data, labels
  end

  def c3js_chart_bar_script(chart_id, data, labels)
    %(
<script type="text/javascript">
c3.generate({
  bindto: '##{chart_id}',
  size: { height: 200 },
  data: {
    columns: #{data.to_s},
    type: 'bar'
  },
  axis: {
    x: {
      type: 'category',
      categories: #{labels}
    }
  }
});
</script>)
  end

  def c3js_chart_line_script(chart_id, data, labels)
    %(
<script type="text/javascript">
c3.generate({
  bindto: '##{chart_id}',
  data: {
    columns: #{data.to_s}
  },
  axis: {
    x: {
      type: 'category',
      categories: #{labels}
    }
  }
});
</script>)
  end

  def c3js_chart_step_script(chart_id, data, labels)
    %(
<script type="text/javascript">
c3.generate({
  bindto: '##{chart_id}',
  data: {
    columns: #{data.to_s},
    type: 'step'
  },
  axis: {
    x: {
      type: 'category',
      categories: #{labels}
    }
  }
});
</script>)
  end

  def c3js_chart_spline_script(chart_id, data, labels)
    %(
<script type="text/javascript">
c3.generate({
  bindto: '##{chart_id}',
  data: {
    columns: #{data.to_s},
    type: 'spline'
  },
  axis: {
    x: {
      type: 'category',
      categories: #{labels}
    }
  }
});
</script>)
  end

  def c3js_html(chart_div, chart_script)
    %(
    #{C3JS_STYLESHEET}
    #{D3JS_SCRIPT}
    #{C3JS_SCRIPT}
    #{chart_div}
    #{chart_script}
    )
  end

  # Chart.js

  def chartjs_line(parent, target, attrs)
    data = CSV.read(File.join parent.document.base_dir, attrs['data-uri'])
    labels = data[0]
    data.shift
    default_colors = [{r:220,g:220,b:220}, {r:151,g:187,b:205}]
    datasets = data.map do |set|
      color = default_colors[data.index(set) % 2]
      color_rgba = "rgba(#{color[:r]},#{color[:g]},#{color[:b]},1.0)"
      %(
{
  fillColor: "#{color_rgba.gsub('1.0', '0.2')}",
  strokeColor: "#{color_rgba}",
  pointColor: "#{color_rgba}",
  pointHighlightStroke: "#{color_rgba}",
  pointStrokeColor: "#fff",
  pointHighlightFill: "#fff",
  data: #{set.to_s}
}
      )
    end.join(',')
    # TODO Replace with CDN when the 1.0 version will be available
    chartjs_script = %(<script src="#{File.join File.dirname(__FILE__), 'Chart.js'}"></script>)
    # TODO Generate unique id (or read from attributes)
    chart_id = 'chart' + SecureRandom.uuid
    # TODO Read with percent from attributes
    chart_width_percent = 50
    chart_canvas = %(<div style="width:#{chart_width_percent}%"><canvas id="#{chart_id}"></canvas></div>)
    chart_init_ctx_script = %(var ctx = document.getElementById("#{chart_id}").getContext("2d");)
    chart_init_data_script = %(var data = {
  labels: #{labels.to_s},
  datasets: [
    #{datasets}
  ]
};)
    chart_init_script = 'var chart = new Chart(ctx).Line(data, {responsive : true});'
    html = %(
    #{chartjs_script}
    #{chart_canvas}<script type="text/javascript">window.onload = function() {
    #{chart_init_ctx_script}
    #{chart_init_data_script}
    #{chart_init_script}
}
</script>)

    create_pass_block parent, html, attrs, subs: nil
  end
end
