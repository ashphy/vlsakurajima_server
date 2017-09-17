# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resource :pubsubhubbub, only: %i(show create)
  resources :jobs, only: %i(create)
end
