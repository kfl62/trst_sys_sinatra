# encoding: utf-8

# #Tilt template
# Render rb files
module Tilt
  class PdfTemplate < Template
    def prepare
    end

    def evaluate(scope, locals, &block)
      super(scope, locals, &block)
    end

    def precompiled_template(locals)
      data.to_str
    end
 end
 register 'rb', PdfTemplate
end
