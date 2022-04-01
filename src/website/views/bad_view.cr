module Website
  class BadView < Marten::View
    def get
      1 // 0
      respond "bad"
    end
  end
end
