module Website
  class BadHandler < Marten::Handler
    def dispatch
      1 // 0
      respond "bad"
    end
  end
end
