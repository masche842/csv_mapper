Dummy::Application.routes.draw do
  resources :people do
    get 'import', :on => :collection
    post 'import', :on => :collection
  end
end
