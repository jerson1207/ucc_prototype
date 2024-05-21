Rails.application.routes.draw do
  get 'transmitted/index'
  root 'dashboard#index'

  resources :dashboard, only: [:index] do
    collection do
      get 'download_excel_remaining_volume' 
    end
  end
  get 'transmitted/index', to: 'transmitted#index', as: 'transmitted_index_with_params'


  resources :datasets, only: [] do
    collection do
      get 'inventory_files'
      get 'qc_files'
    end
  end

  resources :uploads, only: [:index]
  post '/upload', to: 'uploads#upload'
  post '/qc_upload', to: 'uploads#qc_upload'
  get '/delete/inventory_file/:filename', to: 'uploads#destroy_inventory_file', as: 'delete_inventory_file'
  get '/delete/qc_file/:filename', to: 'uploads#destroy_qc_file', as: 'delete_qc_file'
  get 'uploads/inventory_file/:filename', to: 'uploads#inventory_file', as: 'show_inventory_file_upload'
  get 'uploads/qc_file/:filename', to: 'uploads#qc_file', as: 'show_qc_file_upload'
  get '/download_excel_qc_file', to: 'uploads#download_excel_qc_file', as: 'download_excel_qc_file'
  get '/data', to: 'uploads#data'
end
