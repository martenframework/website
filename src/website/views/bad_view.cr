module Website
  class BadView < Marten::View
    def dispatch
      1 // 0
      respond "bad"
    end
  end
end
