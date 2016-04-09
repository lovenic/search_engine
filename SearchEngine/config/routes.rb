Rails.application.routes.draw do
  root to: 'application#home'
  post 'dig', to: 'application#dig'
end
