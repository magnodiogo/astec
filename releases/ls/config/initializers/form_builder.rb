class ActionView::Helpers::FormBuilder
  alias :label_old :label
  def label(method, content_or_options = nil, options = nil, &block)
    if content_or_options && content_or_options.class == Hash
      options = content_or_options
    else
      content = content_or_options
    end
    options = options || {}
    content ||= object.class.human_attribute_name(method)
    content = content


    required_mark = ''
    required_text = options[:"field-required"] || ' *'
    required_mark = object.class.validators_on(method).map(&:class).include?(ActiveRecord::Validations::PresenceValidator) ? "#{required_text}" : ""
    content = content

    self.label_old(method, options) do
      (content + required_mark).html_safe
    end
  end
end