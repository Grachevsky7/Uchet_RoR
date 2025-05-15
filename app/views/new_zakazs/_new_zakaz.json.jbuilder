json.extract! new_zakaz, :id, :po_id, :klient_id, :data_zak, :stat_zak, :specialist_id, :data_vypoln_zak, :stoimost_v_god, :srok_arendy, :stoimost_zak, :dok_vypoln_zak_path, :chek_opl_zak_path, :status, :s_delete, :created_at, :updated_at
json.url new_zakaz_url(new_zakaz, format: :json)
