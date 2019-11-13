ActionController::Routing::Routes.draw do |map|
  map.resources :vagas,:collection => { :consultas => :get}

  map.resources :observacao_criancas

  map.resources :logs
  map.resources :roles_users
  map.resources :users, :collection => {:aviso => :get}

  map.resource :session
  map.resources :unidades
  map.resources :criancas, :collection => {:impressao => :get, :consultas => :get, :impressao_class_unidade => :get, :impressao_class_classe => :get, :status => :get, :impressao_geral => :get, :recadastrar => :get,  :update => :put, :impressao_recadastramento => :get, :transferencia_crianca => :get}
  map.resources :grupos
  map.resources :regiaos
  map.resources :regiaos
  map.resources :graficos
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "home"
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.grafico '/grafico', :controller => 'grafico'
  map.grafico_geral '/grafico/grafico_demanda_geral', :controller => 'grafico', :action => 'grafico_geral_demanda'
  map.grafico_por_unidade '/grafico/crianca_por_unidade', :controller => 'grafico', :action => 'crianca_por_unidade'
  map.grafico_prioridade_geral '/grafico_prioridade_geral', :controller => 'grafico', :action => 'grafico_prioridade_geral'
  map.grafico_prioridade_unidade '/grafico_prioridade_unidade', :controller => 'grafico', :action => 'grafico_prioridade_unidade'
  map.grafico_prioridade_regiao '/grafico_prioridade_regiao', :controller => 'grafico', :action => 'grafico_prioridade_regiao'
  map.relatorio_crianca '/crianca/relatorio_crianca', :controller => 'criancas', :action => 'relatorio_crianca'
  map.consulta_geral '/geral', :controller => 'criancas', :action => 'relatorio_geral'
  map.consulta_mae '/mae', :controller => 'criancas', :action => 'relatorio_mae'
  map.consulta_unidade '/unidade', :controller => 'criancas', :action => 'consulta_unidade'
  map.transferencias '/transferencias', :controller => 'criancas', :action => 'transferencias'
  map.transferenciacrianca '/transferenciacrianca', :controller => 'criancas', :action => 'transferenciacrianca'
  map.relatorio_geral_ant '/relatorio_geral_ant', :controller => 'criancas', :action => 'relatorio_geral_ant'
  map.teste '/teste', :controller => 'criancas', :action => 'teste'
  map.consulta_regiao '/regiao', :controller => 'criancas', :action => 'consulta_regiao'
  map.consulta_unidade_status '/unidade_status', :controller => 'criancas', :action => 'consulta_unidade_status'
  map.consulta_classe '/consulta_classe', :controller => 'criancas', :action => 'consulta_classe'
  map.consulta_status '/consulta_status', :controller => 'criancas', :action => 'consulta_status'
  map.consulta_altera_status '/consulta_altera_status', :controller => 'criancas', :action => 'consulta_altera_status'
  map.consulta_vaga '/consulta_vaga', :controller => 'vagas', :action => 'consulta_vaga'
  map.vaga_crianca '/vaga_crianca', :controller => 'vagas', :action => 'vaga_crianca'
  map.show_preenchimento'/show_preenchimento', :controller => 'vagas', :action => 'show_preenchimento'
  map.preenchimento'/preenchimento', :controller => 'vagas', :action => 'preenchimento'
  map.show_salvar'/show_salvar', :controller => 'vagas', :action => 'show_salvar'
  map.preenche_vaga '/preenche_vaga', :controller => 'vagas', :action => 'preenche_vaga'
  map.recadastrar_consultas '/recadastrar_consultas', :controller => 'criancas', :action => 'recadastrar_consultas'
  #map.consultas '/consultas', :controller => 'vagas', :action => 'consultas'
  map.altera_classe '/altera_classe', :controller => 'criancas', :action => 'altera_classe'
  map.altera_nascimento '/altera_nascimento', :controller => 'criancas', :action => 'altera_nascimento'
  map.sobre '/sobre', :controller => 'criancas', :action => 'sobre'
  map.aviso_senha'/aviso_senha', :controller => 'roles_users', :action => 'aviso_senha'
  map.altera_senha'/altera_senha', :controller => 'roles_users', :action => 'altera_senha'
  map.show_recadastramento'/show_recadastramento', :controller => 'criancas', :action => 'show_recadastramento'
  map.show_transferencia'/show_transferencia', :controller => 'criancas', :action => 'show_transferencia'

  map.alterar '/alterar', :controller => 'alteracaos', :action => 'alterar'
  map.altera_status 'altera_status', :controller => 'alteracaos', :action => 'alterar_classe'
  map.alteracao_status 'alteracao_status', :controller => 'criancas', :action => 'alteraracao_status'


  map.grafico '/grafico', :controller => 'grafico'
  map.grafico_geral '/grafico/grafico_demanda_geral', :controller => 'grafico', :action => 'grafico_demanda_geral'
  map.grafico_unidade '/grafico/grafico_demanda_unidade', :controller => 'grafico', :action => 'grafico_demanda_unidade'
  map.grafico_regiao '/grafico/grafico_demanda_regiao', :controller => 'grafico', :action => 'grafico_demanda_regiao'

  map.impressao_geral '/grafico/impressao_geral', :controller => 'grafico', :action => 'impressao_geral'

  map.alteracao '/altera', :controller => 'alteracaos', :action => 'altera'
  
  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resources :unidades
  map.resources :fichas

  

  
  map.consultacrianca '/consultacrianca', :controller => 'criancas', :action => 'consultacrianca'
  map.consultatransferencias '/consultatransferencias', :controller => 'criancas', :action => 'consultatransferencias'
  
  
  
  #map.edicao :criancas, :path_prefix => '/criancas/:crianca/edit'
  
  

  map.resources :roles_users, :collection => {:lista_users => :get}
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  #map.resource :password
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.resource :password


  map.resources :users
  map.resource :session
  map.home '', :controller => 'home', :action => 'index'
  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.geo "/geos/geo/:id", :controller => "geos", :action => "geo"
  
end
