Rails.application.routes.draw do
  wash_out :email
  root "email#_generate_wsdl"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
