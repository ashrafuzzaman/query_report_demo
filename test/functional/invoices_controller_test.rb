require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { invoiced_on: @invoice.invoiced_on, paid: @invoice.paid, paid_on: @invoice.paid_on, received_by: @invoice.received_by, title: @invoice.title, total_charged: @invoice.total_charged, total_paid: @invoice.total_paid }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    put :update, id: @invoice, invoice: { invoiced_on: @invoice.invoiced_on, paid: @invoice.paid, paid_on: @invoice.paid_on, received_by: @invoice.received_by, title: @invoice.title, total_charged: @invoice.total_charged, total_paid: @invoice.total_paid }
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
