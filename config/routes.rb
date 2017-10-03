require 'hyrax/preservation'

Rails.application.routes.draw do

  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Hyrax::Preservation::Engine, at: '/preservation'
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new

  # Adds routes to large file interactions provided through Phydo::StorageControllerBehavior
  get '/concern/file_sets/:id/file_status' => 'hyrax/file_sets#file_status', as: :file_status_hyrax_file_set
  get '/concern/file_sets/:id/stage' => 'hyrax/file_sets#stage', as: :stage_hyrax_file_set
  get '/concern/file_sets/:id/unstage' => 'hyrax/file_sets#unstage', as: :unstage_hyrax_file_set
  get '/concern/file_sets/:id/fixity' => 'hyrax/file_sets#fixity', as: :fixity_hyrax_file_set

end
