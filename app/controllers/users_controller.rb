require 'query_report/helper'
require 'coderay'

class UsersController < ApplicationController
  before_filter :load_code
  include QueryReport::Helper

  def index
    @users = User.joins(:invoices).select('users.*, count(invoices.id) as invoice_count').
        group('users.id, users.first_name, users.last_name, users.email')

    reporter(@users, template_class: PdfReportTemplate) do
      #filter :search, type: :text do |query, search_text|
      #  query.where('email=:search or email=:search or email=:search')
      #end
      #filter :invoiced_on, type: :date, default: [2.weeks.ago.to_date.to_s(:db), Date.current.to_s(:db)]

      column :name
      column :email
      column :invoice_count
      #column :invoiced_on
      #column :total_paid
      #column :total_charged
      #column :paid
      #column :received_by_id do |invoice|
      #  invoice.received_by.name
      #end
    end
  end

  private
  def load_code
    code = <<-EOF
    def index
      @users = User.joins(:invoices).select('users.*, count(invoices.id) as invoice_count').
          group('users.id, users.first_name, users.last_name, users.email')

      reporter(@users, template_class: PdfReportTemplate) do
        column :name
        column :email
        column :invoice_count
      end
    end
    EOF
    @html_code = CodeRay.scan(code, :ruby).div(:line_numbers => :table)
  end
end
