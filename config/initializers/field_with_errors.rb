ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  element = html.at_css("input, select, textarea")

  if element
    # Aquí es donde ocurre la magia: agregamos la clase de Bootstrap
    element.add_class("is-invalid")
    html.to_s.html_safe
  else
    html_tag
  end
end
