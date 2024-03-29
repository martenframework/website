module Website
  class CodeOfConductHandler < Marten::Handlers::Template
    @code_of_conduct_html : String?

    template_name "code_of_conduct.html"

    before_render :prepare_context

    private def code_of_conduct_html
      {% begin %}
      @code_of_conduct_html ||= begin
        source = Cmark.commonmark_to_html({{ read_file("lib/marten/CODE_OF_CONDUCT.md") }})
        source.gsub(/<h1>.*<\/h1>/, "")
      end
      {% end %}
    end

    private def prepare_context
      context[:code_of_conduct_html] = code_of_conduct_html
    end
  end
end
