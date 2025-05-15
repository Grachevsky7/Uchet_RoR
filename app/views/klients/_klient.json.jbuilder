json.extract! klient, :id, :name_komp, :kontakt_lico, :telef_kl, :pochta_kl, :adres_kl, :status, :s_delete, :created_at, :updated_at
json.url klient_url(klient, format: :json)
