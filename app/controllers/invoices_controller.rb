require 'query_report/helper'

class InvoicesController < ApplicationController
  before_filter :load_code, only: [:index]
  include QueryReport::Helper

  def index
    invoices = Invoice.scoped

    reporter(invoices, template_class: PdfReportTemplate) do
      filter :title, type: :text, default: 'Invoice'
      filter :invoiced_on, type: :date
      filter :paid, type: :boolean

      column :title do |invoice|
        link_to invoice.title, invoice
      end
      column :invoiced_on
      column :total_paid
      column :total_charged
      column :paid
      column :received_by_id do |invoice|
        invoice.received_by.name
      end

      column_chart('Unpaid VS Paid') do
        add 'Unpaid' do |query|
          (query.sum('total_charged').to_f - query.sum('total_paid').to_f).to_f
        end
        add 'Paid' do |query|
          query.sum('total_paid').to_f
        end
      end
    end
  end

  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  private
  def load_code
    code = <<-EOF
  def index
    invoices = Invoice.scoped

    reporter(invoices, template_class: PdfReportTemplate) do
      filter :title, type: :text, default: 'Invoice'
      filter :invoiced_on, type: :date
      filter :paid, type: :boolean

      column :title do |invoice|
        link_to invoice.title, invoice
      end
      column :invoiced_on
      column :total_paid
      column :total_charged
      column :paid
      column :received_by_id do |invoice|
        invoice.received_by.name
      end

      column_chart('Unpaid VS Paid') do
        add 'Unpaid' do |query|
          (query.sum('total_charged').to_f - query.sum('total_paid').to_f).to_f
        end
        add 'Paid' do |query|
          query.sum('total_paid').to_f
        end
      end
    end
  end
    EOF
    @html_code = CodeRay.scan(code, :ruby).div(:line_numbers => :table)
  end
end
