require 'query_report/helper'

class InvoicesController < ApplicationController
  before_filter :load_code
  include QueryReport::Helper

  # GET /invoices
  # GET /invoices.json
  def index
    invoices = Invoice.scoped

    reporter(invoices, template_class: PdfReportTemplate) do
      filter :title, type: :text, default: 'Invoice'
      filter :invoiced_on, type: :date, default: [2.weeks.ago.to_date.to_s(:db), Date.current.to_s(:db)]
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

      pie_chart('Unpaid VS Paid') do
        add 'Unpaid' do |query|
          (query.sum('total_charged').to_f - query.sum('total_paid').to_f).to_f
        end
        add 'Paid' do |query|
          query.sum('total_paid').to_f
        end
      end
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  private
  def load_code
    code = <<-EOF
  def index
    invoices = Invoice.scoped

    reporter(invoices, template_class: PdfReportTemplate) do
      filter :title, type: :text, default: 'Invoice'
      filter :invoiced_on, type: :date, default: [2.weeks.ago.to_date.to_s(:db), Date.current.to_s(:db)]
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

      pie_chart('Unpaid VS Paid') do
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
