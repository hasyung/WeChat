# encoding: utf-8
OneTripWeChat::Application.routes.draw do

  captcha_route

  devise_for :admin_users, path: 'admin',
    path_names: { sign_in: :login, sign_out: :logout, password: :secret },
    controllers: { sessions: 'admin/admin_users/sessions', passwords: 'admin/admin_users/passwords' }

  scope path: 'weixin' do
    resources :articles, :audios, :kits, :albums, :merchants, :guides, only: [:show]
    resources :maps, only: [:index, :show]
    match '/:alias/albums/:type_cd' => 'albums#index'
    match '/:alias/merchants' => 'merchants#index'
  end

  # weixin server routes
  namespace :api do
    namespace :v1 do
      match 'accounts/:alias', to: 'accounts#authorization', as: :alias, via: :get
      scope path: 'accounts/:alias', via: :post, defaults: { format: :xml } do
        root to: 'accounts#authorization', via: :get, defaults: { format: :html }
        root to: 'accounts#request_subscribe', constraints: Weixin::Router.new(:event) { |xml| xml[:Event] == 'subscribe' and xml[:Ticket].blank? }
        root to: 'accounts#request_unsubscribe', constraints: Weixin::Router.new(:event) { |xml| xml[:Event] == 'unsubscribe' }
        root to: 'accounts#request_subscribe_qrcode', constraints: Weixin::Router.new(:event) { |xml| xml[:Event] == 'subscribe' and xml[:Ticket].present? }
        root to: 'accounts#request_qrcode', constraints: Weixin::Router.new(:event) { |xml| xml[:Event] == 'SCAN' }
        root to: 'accounts#request_event', constraints: Weixin::Router.new(:event)
        root to: 'accounts#request_vote', constraints: Weixin::Router.new(:text, content: /^4\w{1}\d{2}.\d{11}$/)
        root to: 'accounts#request_number', constraints: Weixin::Router.new(:text, content: /^[a-zA-Z]?\d+$/)
        root to: 'accounts#request_text', constraints: Weixin::Router.new(:text)
        root to: 'accounts#request_image', constraints: Weixin::Router.new(:image)
        root to: 'accounts#request_location', constraints: Weixin::Router.new(:location)
        root to: 'accounts#request_video', constraints: Weixin::Router.new(:video)
        root to: 'accounts#request_voice', constraints: Weixin::Router.new(:voice)
        root to: 'accounts#request_link', constraints: Weixin::Router.new(:link)
      end
    end
  end

  namespace :admin do
    root to: 'home#index'
    resources :home, only: [] do
      post :account, on: :collection
    end
    resources :accounts, only: [:edit, :update] do
      match :menus, on: :member, via: [:get, :post, :delete]
    end
    resources :messages, only: [:index, :show]
    resources :resources, only: [:index]
    resources :menus do
      get :category, on: :member
      match :resources, on: :member, via: [:get, :post]
      post :sort, on: :collection
    end
    resources :members, only: [:index, :destroy] do
      get :info, on: :member
    end

    resources :replies do
      get :category, on: :member
      get :map, on: :collection
      get :qrcode, on: :member
      post :create_qrcode, on: :member
      delete :cancel_qrcode, on: :member
      match :assign, on: :member, via: [:get, :put]
      match :resources, on: :collection, via: [:get, :post]
    end
    scope path: 'resources' do
      resources :audios do
        match :assign, on: :member, via: [:get, :put]
      end
      resources :kits do
        match :assign, on: :member, via: [:get, :put]
        put :images_sort, on: :member
        resources :images do
          get :list, on: :collection
        end
      end
      resources :directories do
        match :assign, on: :member, via: [:get, :put]
      end
      resources :articles do
        match :assign, on: :member, via: [:get, :put]
      end
      resources :albums do
        match :assign, on: :member, via: [:get, :put]
        put :images_sort, on: :member
        resources :images do
          get :list, on: :collection
        end
      end
      resources :maps do
        match :assign, on: :member, via: [:get, :put]
      end
      resources :merchants do
        match :assign, on: :member, via: [:get, :put]
        put :images_sort, on: :member
        resources :merchant_images do
          get :list, on: :collection
        end
      end
    end
    scope path: 'settings' do
      resources :system_replies, path: 'replies', only: [:index]
    end
    resources :weathers
    resources :guides
    resources :audits, only: [:index, :show]
    resources :admin_users do
      match 'setting', to: 'admin_users#setting', via: [:get, :post], on: :collection
    end
    resources :exceptions, path: '', only: [] do
      match 'unauthorized', to: 'exceptions#unauthorized', via: [:get, :delete], on: :collection
    end
    resources :votes, only: [:index, :new, :edit, :destroy] do
      post :edit, on: :collection
      get :export, on: :collection
      match 'setting', to: 'votes#setting', via: [:get, :put], on: :collection
    end
  end

  root to: redirect('/admin')
end