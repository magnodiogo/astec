class FaqsController < ApplicationController
  def index
    @faqs = Faq.order(:id)
  end
end
