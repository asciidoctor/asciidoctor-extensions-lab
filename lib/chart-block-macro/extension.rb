require 'asciidoctor'
require 'asciidoctor/extensions'
require 'csv'

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

  def process(parent, target, attrs)
    c3js_line parent, target, attrs
  end

  def c3js_line(parent, target, attrs)
    data = CSV.read(File.join parent.document.base_dir, attrs['data-uri'])
    labels = data[0]
    data.shift
    data.map.with_index do |row, index|
      row.unshift "#{index}"
    end
    # TODO http or https ? asset_uri_scheme ?
    c3js_stylesheet = '<link href="http://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css" rel="stylesheet" type="text/css">'
    d3js_script = '<script src="http://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js" charset="utf-8"></script>'
    c3js_script = '<script src="http://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>'
    # TODO Generate unique id (or read from attributes)
    chart_id = 'chart1'
    chart_div = %(<div id="#{chart_id}"></div>)
    # #{data.to_s}
    chart_generate_script = %(
<script type="text/javascript">
console.log("1");
window.onload = function() {
  console.log("2");
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
  console.log("3");
}
</script>)
    html = %(
    #{c3js_stylesheet}
    #{d3js_script}
    #{c3js_script}
    #{chart_div}
    #{chart_generate_script}
    )

    create_pass_block parent, html, attrs, subs: nil
  end

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
    chart_id = 'chart1'
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
