Rails.application.routes.draw do
  get 'kl_obsh_sum_zak/index'
  get 'obsh_summa_zak/index'
  get 'po_max_dohod/index'
  get 'avg_vypoln_obr/index'
  get 'avg_vypoln_zak/index'

  resources :new_zakazs

  root 'home_page#index'
  get 'home_page/backup', to: 'home_page#backup', as: :backup_home_page
  get 'home_page/restore', to: 'home_page#restore', as: :restore_home_page
  get 'home_page/index'
  get 'po/index'
  get 'avg_vypoln_zak/index'
  get 'avg_vypoln_obr/index'
  get 'po_max_dohod/index'
  get 'obsh_summa_zak/index'
  get 'kl_obsh_sum_zak/index'

  resources :obrashenies
  resources :new_zakazs
  resources :specialists
  resources :klients
  resources :pos

  # Добавляем маршруты для экспорта отчетов
  get 'po_max_dohod/export_to_excel', to: 'po_max_dohod#export_to_excel', as: :export_to_excel_po_max_dohod
  get 'po_max_dohod/export_to_word', to: 'po_max_dohod#export_to_word', as: :export_to_word_po_max_dohod

  get 'obsh_summa_zak/export_to_excel', to: 'obsh_summa_zak#export_to_excel', as: :export_to_excel_obsh_summa_zak
  get 'obsh_summa_zak/export_to_word', to: 'obsh_summa_zak#export_to_word', as: :export_to_word_obsh_summa_zak

  get 'kl_obsh_sum_zak/export_to_excel', to: 'kl_obsh_sum_zak#export_to_excel', as: :export_to_excel_kl_obsh_sum_zak
  get 'kl_obsh_sum_zak/export_to_word', to: 'kl_obsh_sum_zak#export_to_word', as: :export_to_word_kl_obsh_sum_zak

  get 'avg_vypoln_obr/export_to_excel', to: 'avg_vypoln_obr#export_to_excel', as: :export_to_excel_avg_vypoln_obr
  get 'avg_vypoln_obr/export_to_word', to: 'avg_vypoln_obr#export_to_word', as: :export_to_word_avg_vypoln_obr

  get 'avg_vypoln_zak/export_to_excel', to: 'avg_vypoln_zak#export_to_excel', as: :export_to_excel_avg_vypoln_zak
  get 'avg_vypoln_zak/export_to_word', to: 'avg_vypoln_zak#export_to_word', as: :export_to_word_avg_vypoln_zak

  get "up" => "rails/health#show", as: :rails_health_check
end
