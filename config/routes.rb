QueryReportDemo::Application.routes.draw do
  root :to => 'invoices#index'
  resources :invoices
  resources :users
end