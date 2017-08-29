Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "my_devise/registrations" }
	root 'static_pages#index'
	resources :documents
	resources :donations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
