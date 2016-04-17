Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      scope '/employees' do
        get '/' => 'api_employees#index'
        post '/' => 'api_employees#create'
          scope '/:employee_id' do
            get '/' => 'api_employees#show'
            put '/' => 'api_employees#update'
              scope '/timesheets' do
                put '/' => 'api_timesheets#index'
                post '/' => 'api_timesheets#create'
                scope '/time' do
                  post '/' => 'api_time#index'
                end
              end
           end
        end
        scope '/employers' do
          get '/' => 'api_employers#index'
          post '/' => 'api_employers#create'
            scope '/:employer_id' do
              get '/' => 'api_employers#show'
              put '/' => 'api_employers#update'
                scope '/timesheets' do
                  put '/' => 'api_timesheets#index'
                end
                scope '/addresses' do
                  get '/' => 'api_addresses#index'
                  post '/' => 'api_addresses#create'
                    scope '/:address' do
                      get '/' => 'api_addresses#show'
                      put '/' => 'api_addresses#update'
                    end
                end
            end
        end
      post '/login' => 'login#index'
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
