Rails.application.routes.draw do
  resources :invoice_items, only: %i[index show update]

  resources :merchants do
    resources :items
    resources :invoices, only: %i[index show update]
    resources :discounts, only: %i[index show]
    get '/dashboard', to: 'merchants_dashboard#index'
  end

  namespace :admin do
    resources :invoices, only: %i[index show update]
    resources :merchants, only: %i[index show edit update new create]
    get '/', to: 'admin#dashboard'
  end
end
