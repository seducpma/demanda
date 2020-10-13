class CriancasController < ApplicationController
  #require_role ["rh","administrador"], :for => [:destroy,:update,:index,:listagem_por_curso]
  before_filter :load_unidades
  before_filter :load_grupos
  before_filter :load_regiaos
  before_filter :load_unidades
  before_filter :load_criancas
  before_filter :load_criancas_mat
  # require_role ["seduc","admin","escola","secretaria"], :for => :update # don't allow contractors to update
  require_role ["seduc","admin"], :for => :destroy # don't allow contractors to destroy
  require_role ["seduc"], :for => [:atualiza_grupo,:matric,:config,:confirma] #

def sobre

end

def close
  render :action => "window_closer"
end

# GET /criancas
  # GET /criancas.xml
  def index
    @criancas = Crianca.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @criancas }
    end
  end

  def relatorio_crianca
    @crianca = "Filtre pela criança desejada"
  end

  def search
    @crianca = Crianca.find(:all, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"], :include => ['grupo','unidade'])
    render :action => 'relatorio_crianca'
  end

  
  def mat2pre_edit

    @unidade_regiao= Unidade.find(:all , :conditions=>[' ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)'])
     session[:sim]= 1
    @crianca = Crianca.find(params[:id])
    data=@crianca.nascimento

    session[:status] = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    session[:id_crianca] = params[:id]
    session[:nome] = params[:nome]
    session[:recadastrada]= 'edit'
    session[:show]=1
    session[:acerto]=1
    session[:acertorecadastrada]=2
    



    #w=session[:crianca_id]=params[:id]
     #@crianca = Crianca.find(params[:id])
    #unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca.regiao_id])
  end


def show_pre
     @crianca = Crianca.find(session[:crianca_id])
     @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca.regiao_id])
##  VERJA O SHOW EM BAIXO VVVVV
  end


  # GET /criancas/1
  # GET /criancas/1.xml
  def show
     @crianca = Crianca.find(params[:id])
     @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca.regiao_id])
   #  w1=session[:grupo_nome]=@crianca.grupo.nome
   #  w2=session[:regiao_nome]=@crianca.regiao.nome
t=0
  #   if (session[:ficha_pre]==1) or (@crianca.nascimento < (DATAN1).to_date)
  #     render :action => 'show_pre'
  #     session[:ficha_pre]=0
  #   else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @crianca }
      end
  #  end
  end

  

  def show_recadastramento
     @crianca = Crianca.find(session[:id_crianca])
     @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8) ',@crianca.regiao_id])
     
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crianca }
    end
  end

    def show_transferencia

     @criancas=Crianca.find(session[:id_anterior])

     @crianca = Crianca.find(session[:id_crianca_trans])
     @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8) ',@crianca.regiao_id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crianca }
    end
  end



  # GET /criancas/new
  # GET /criancas/new.xml
  def new
     @crianca = Crianca.new
     session[:nasc]=0
     session[:show]=1
     session[:show_transferencia]=0
     session[:show_recadastramento]=0
     session[:novo_cadastrar]=2  # cadastrar após recadstramento
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crianca }
    end
  end

  def new_pre
     @crianca = Crianca.new
     session[:nasc]=0
     session[:show]=1
     session[:show_transferencia]=0
     session[:show_recadastramento]=0
     session[:novo_cadastrar]=2  # cadastrar após recadstramento
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crianca }
    end
  end



  def transferencia
     session[:id_anterior]=params[:id]
     @criancas=Crianca.find(params[:id])
     @unidade_regiao= Unidade.find(:all , :conditions=>['ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)'], :order => 'nome ASC')
     #@unidade_regiao= Unidade.find(:all , :joins=> 'JOIN vagas on  vagas.unidade_id = unidades.id JOIN criancas on  vagas.crianca_id = criancas.id ',   :conditions=>['vagas.crianca_id = ? AND unidades.ativo = 1 AND ( unidades.tipo = 1 or unidades.tipo = 3 or unidades.tipo = 7 or unidades.tipo = 8) AND criancas.recadastrata = 1', session[:id_anterior].to_i])
     session[:nasc]=1
     @crianca = Crianca.new
     session[:tnome]=@criancas.nome
     session[:tnascimento]=@criancas.nascimento.strftime("%d/%m/%Y")
     session[:tmae]=@criancas.mae
     session[:tpai]=@criancas.pai

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crianca }
    end
  end


def transferenciacrianca
    data = (Time.now.year-6).to_s
    data = data + ' 00:00:00'

           if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                 @criancas = Crianca.find( :all,:conditions => ["nome like ? AND status = 'MATRICULADA' and  nascimento > ? AND nome NOT IN (SELECT nome  FROM criancas WHERE nome LIKE ? AND status='NA_DEMANDA'  )" , "%" + params[:searchtrans].to_s + "%", data, "%" + params[:searchtrans].to_s + "%"],:order => 'nome ASC, unidade_id ASC')
           else
                 @criancas = Crianca.find( :all,:conditions => ["nome like ? AND status = 'MATRICULADA'", "%" + params[:searchtrans].to_s + "%" ],:order => 'nome ASC')
           end
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancastrans"
        end
end




  # GET /criancas/1/edit
  def edit
     @unidade_regiao= Unidade.find(:all , :conditions=>[' ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)'])
     session[:sim]= 1
    @crianca = Crianca.find(params[:id])

    data=@crianca.nascimento

    session[:status] = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    wq=session[:id_crianca] = params[:id]
    t=0
    @crianca1 = Crianca.find(:all, :conditions => ['id=?', session[:id_crianca]])
    w=session[:id_grupo]= @crianca.grupo_id
    w1=session[:grupo_nome]=@crianca.grupo.nome
    if !@crianca.regiao_id.nil?
        w2=session[:regiao_nome]=@crianca.regiao.nome
    end
    
    session[:nome] = params[:nome]
    session[:recadastrada]= 'edit'
    session[:show]=1
    session[:acerto]=1
    session[:acertorecadastrada]=2
  end

  def edit_pre
    @unidade_regiao= Unidade.find(:all , :conditions=>[' ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)'])
     session[:sim]= 1
    @crianca = Crianca.find(params[:id])
    data=@crianca.nascimento

    session[:status] = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    session[:id_crianca] = params[:id]
    session[:nome] = params[:nome]
    session[:recadastrada]= 'edit'
    session[:show]=1
    session[:acerto]=1
    session[:acertorecadastrada]=2
  end


def recadastrar_crianca
    s= params[:crianca_id]
   @criancas = Crianca.find( :all,:conditions => ["id =?" , params[:crianca_id]],:order => 'nome ASC')
               
       render:partial => "recadastrar_criancas"
               
end

 
 def recadastrar
    
    @crianca = Crianca.find(params[:id])
    data=@crianca.nascimento
    session[:status] = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    session[:id_crianca] = params[:id]
    session[:nome] = params[:nome]
    session[:recadastrada]= 'recadastrar'

  end

 def alteracao_status
    @crianca = Crianca.find(params[:id])
    w1=params[:id]
    w=@crianca.regiao_id
    @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca.regiao_id])


    data=@crianca.nascimento

    session[:status] = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    session[:id_crianca] = params[:id]
    session[:nome] = params[:nome]
        session[:show]=1
  end

 def alteracao_grupo
   @crianca = Crianca.find(params[:id])
    w1=params[:id]
    w=@crianca.regiao_id
    @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca.regiao_id])


    data=@crianca.nascimento

    session[:status] = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    session[:id_crianca] = params[:id]
    session[:nome] = params[:nome]
        session[:show]=1
  end

def aviso
end

def aviso_pre
end

def aviso_pre2
end

def erro
end

def fora_ar
end


  def status

  end

def reclassifica
  $novadata= params[:crianca_nascimento]
  t=0
end

def opcao1
  t=0
   if params[:opcao1] ==  'x1'
     session[:servidor_publico] = 1
     t=0
   end

end

  # POST /criancas
  # POST /criancas.xml
  def create
    @crianca = Crianca.new(params[:crianca])
      if session[:nasc]==1
          session[:nasc]=0
          t=0
                  # ALTERAR TAMBÈM AS DATAS NO ALETRACAOS_CONTROLER def alterar_classe e no def update
                    @crianca.unidade_id = current_user.unidade_id
                    if session[:show_transferencia]==1
                        @crianca.nascimento = session[:dataN]
                        @crianca.save
                        data = @crianca.nascimento.strftime("%Y-%m-%d")
                    else
                        data=@crianca.nascimento.strftime("%Y-%m-%d")
                    end
                     @crianca.recadastrada = 2
                    hoje = Date.today.to_s
                    final = '2012-07-01'
                    if (hoje > data)  and (data >= final)
                       if  (data <= Date.today.to_s and data >= DATAB1)
                       @crianca.grupo_id = 1
                        else if(data < DATAB1 and data >= DATAB2)
                           @crianca.grupo_id = 2
                           else if(data < DATAB2 and data >= DATAM1A)
                                  @crianca.grupo_id = 4
                                  else if(data < DATAM1A and data >= DATAM1B)
                                      @crianca.grupo_id = 8
                                      else if(data < DATAM1B and data >= DATAM2)
                                              @crianca.grupo_id = 5
                                            else if(data < DATAM2 and data >= DATAN1)
                                                    @crianca.grupo_id = 6
                                                  else if(data < DATAN1 and data >= DATAN2)
                                                        @crianca.grupo_id = 7
                                                       end
                                                 end
                                           end
                                      end
                                 end
                           end
                       end

                  $flag_imp = 0
                  $flag_btimp = 0
                  session[:sim]= 0
                   if session[:show_transferencia]==1
                          @crianca.transferencia = true
                   end
                    respond_to do |format|
                      if @crianca.save
                      w=  @crianca.local_trabalho
                        flash[:notice] = 'Criança cadastrada com sucesso.'
                          if session[:show]==1
                            format.html { redirect_to(@crianca) }
                            @crianca.recadastrada=session[:novo_cadastrar]
                            @crianca.save
                            @crianca.recadastrada=session[:novo_cadastrar]
                            format.xml  { render :xml => @crianca, :status => :created, :location => @crianca }
                              session[:show]=0
                         end
                         if session[:show_transferencia]==1
                               session[:id_crianca_trans]= @crianca.id
                               @crianca.grupo_id=session[:trans_grupo_id]
                               @crianca.save
                              format.html { redirect_to(show_transferencia_path) }
                              format.xml  { head :ok }
                              session[:show_recadastramento]==0
                         end

                      else
                        format.html { redirect_to(erro_path)}
                      end
                    end

                  else
                    respond_to do |format|
                        flash[:notice] = 'Verificar DATA DE NASCIMENTO .'
                        format.html { render :action => "new" }
                        format.xml  { render :xml => @crianca.errors, :status => :unprocessable_entity }
                    end
                  end

      else

    #inscrição permitida para crianças após outubro/2020

              if @crianca.nascimento.strftime("%Y%m%d").to_i > 20191103
                   respond_to do |format|
                        flash[:notice] = 'INSCRIÇÃO NÃO PERMITIDA.'
                        format.html { render :action => "aviso" }
                        format.xml  { render :xml => @crianca.errors, :status => :unprocessable_entity }
                    end
              else
                  # ALTERAR TAMBÈM AS DATAS NO ALETRACAOS_CONTROLER def alterar_classe e no def update
                    if current_user.present?
                       @crianca.unidade_id = current_user.unidade_id
                    end
                    if session[:show_transferencia]==1
                        @crianca.nascimento = session[:dataN]
                        @crianca.save
                        data = @crianca.nascimento.strftime("%Y-%m-%d")
                    else
                        data=@crianca.nascimento.strftime("%Y-%m-%d")
                    end
                     @crianca.recadastrada = 1
                    hoje = Date.today.to_s
                    final = '2012-07-01'
                    if (hoje > data)  and (data >= final)
                       if  (data <= Date.today.to_s and data >= DATAB1)
                       @crianca.grupo_id = 1
                        else if(data < DATAB1 and data >= DATAB2)
                           @crianca.grupo_id = 2
                           else if(data < DATAB2 and data >= DATAM1A)
                                  @crianca.grupo_id = 4
                                  else if(data < DATAM1A and data >= DATAM1B)
                                      @crianca.grupo_id = 8
                                      else if(data < DATAM1B and data >= DATAM2)
                                              @crianca.grupo_id = 5
                                            else if(data < DATAM2 and data >= DATAN1)
                                                    @crianca.grupo_id = 6
                                                  else if(data < DATAN1 and data >= DATAN2)
                                                        @crianca.grupo_id = 7
                                                       end
                                                 end
                                           end
                                      end
                                 end
                           end
                       end

                      $flag_imp = 0
                      $flag_btimp = 0
                      session[:sim]= 0
                       if session[:show_transferencia]==1
                          @crianca.transferencia = true
                       end
                    respond_to do |format|
                      if @crianca.save
                        flash[:notice] = 'Criança cadastrada com sucesso.'

                        w1=@crianca.local_trabalho

                          if session[:show]==1
                            if session[:ficha_pre]!=1
                                  format.html { redirect_to(@crianca) }
                            end
                            @crianca.recadastrada=session[:novo_cadastrar]
                            @crianca.save
                            @crianca.recadastrada=session[:novo_cadastrar]

                               if @crianca.opcao1=='servidor'
                                      @crianca.servidor_publico = true
                                else if @crianca.opcao1=='trabalho'
                                          @crianca.trabalho = true
                                     else if @crianca.opcao1=='declaracao'
                                          @crianca.declaracao = true
                                          else if @crianca.opcao1=='autonomo'
                                                  @crianca.autonomo = true
                                               end
                                          end
                                     end
                                end
                            @crianca.save
                              if session[:ficha_pre]==1
                                   if @crianca.nascimento.strftime("%Y%m%d").to_i < DATA_FIM_PRE.to_i    #   20170630 LIMITE PRE
                                             @crianca.destroy
                                                    flash[:notice] = 'INSCRIÇÃO NÃO PERMITIDA.'
                                                    format.html { render :action => "aviso_pre1" }
                                   else
                                          if @crianca.nascimento.strftime("%Y%m%d").to_i >= DATAPRE.to_i    #   20170630 LIMITE PRE
                                      
                                             @crianca.destroy
                                                    flash[:notice] = 'INSCRIÇÃO NÃO PERMITIDA.'
                                                    format.html { render :action => "aviso_pre" }
                                          else if @crianca.photo_file_name.nil?

                                                   @crianca.destroy
                                                    flash[:notice] = 'INSCRIÇÃO NÃO PERMITIDA.'
                                                    format.html { render :action => "aviso_pre2" }
                                              else
                                                  @crianca.recadastrada = 2
                                                  mes=@crianca.nascimento.strftime("%m")
                                                  ano=@crianca.nascimento.strftime("%Y")
                                                  teste = ano+'-'+mes   ### veja abaixo VVVVV
                                                 if  teste == '2017-04' or  teste == '2017-05' or teste == '2017-06' or teste == '2016-04' or  teste == '2016-05' or teste == '2016-06' or teste == '2015-04' or  teste == '2015-05' or teste == '2015-06'
                                                    @crianca.regiao_id=999
                                                 end

                                                  if @crianca.opcao2== '1'
                                                       @crianca.opcao2='estudou em outra unidade'
                                                  end
                                                  if @crianca.declaracao==true or @crianca.trabalho==true
                                                    @crianca.opcao1='trabalha'
                                                  else
                                                    @crianca.opcao1='não trabalha'
                                                  end
                                                  @crianca.save
                                                   session[:crianca_id]=@crianca.id
                                                   format.html { redirect_to(show_pre_path) }
                                                   format.xml  { head :ok }
                                                   #format.html { redirect_to(@crianca) }
                                             end
                                         end
                                   end

                              else
                                   format.xml  { render :xml => @crianca, :status => :created, :location => @crianca }
                                   format.xml  { head :ok }
                                   session[:show]=0
                              end
                         end
                         if session[:show_transferencia]==1
                               session[:id_crianca_trans]= @crianca.id
                               @crianca.grupo_id=session[:trans_grupo_id]
                               @crianca.save
                             if @crianca.opcao1=='servidor'
                                @crianca.servidor_publico = true
                                @crianca.trabalho = false
                                @crianca.declaracao = false
                                @crianca.autonomo = false

                             else if @crianca.opcao1=='trabalho'
                                      @crianca.trabalho = true
                                      @crianca.servidor_publico = false
                                      @crianca.declaracao = false
                                      @crianca.autonomo = false

                                 else if @crianca.opcao1=='declaracao'
                                         @crianca.declaracao = true
                                         @crianca.servidor_publico = false
                                         @crianca.trabalho = false
                                         @crianca.autonomo = false

                                      else if @crianca.opcao1=='autonomo'
                                              @crianca.autonomo = true
                                              @crianca.servidor_publico = false
                                              @crianca.trabalho = false
                                              @crianca.declaracao = false
                                            else if @crianca.opcao1=='não trabalha'
                                                @crianca.servidor_publico = false
                                                @crianca.trabalho = false
                                                @crianca.declaracao = false
                                                @crianca.autonomo = false
                                               end
                                          end
                                      end
                                 end
                             end
                            @crianca.save
                              format.html { redirect_to(show_transferencia_path) }
                              format.xml  { head :ok }
                              session[:show_recadastramento]==0
                           end
                        else
                        format.html { redirect_to(erro_path)}
                        end
                    end
                  else
                    respond_to do |format|
                        flash[:notice] = 'Verificar DATA DE NASCIMENTO .'
                        format.html { render :action => "new" }
                        format.xml  { render :xml => @crianca.errors, :status => :unprocessable_entity }
                    end
                  end
        end
    end
end
  # PUT /criancas/1
  # PUT /criancas/1.xml
  
  def update
    @crianca = Crianca.find(params[:id])
    if session[:acerto] = 1
        w=@crianca.recadastrada = session[:acertorecadastrada]
        session[:acerto]=0
    end
   id=@crianca.id
   @crianca.update_attributes(params[:crianca])
#   @crianca.save
#   w=@crianca.servidor_publico
#   w1=@crianca.trabalho
#   w2=@crianca.declaracao
###   w3=@crianca.autonomo
#   w4=@crianca.opcao1
#   t=0
   @crianca = Crianca.find(id)
   w=@crianca.declaracao

 
      if session[:sim]== 1
 
          if @crianca.servidor_publico == true
            session[:servidor_publico] = 1
            if session[:ser]== 1
                 session[:servidor_publico] = 0
                 session[:ser]=0
            end
          else
           session[:servidor_publico] = 0

          end
         if @crianca.trabalho == true
             session[:trabalho] = 1
            if session[:trab]== 1
               session[:trabalho] = 0
               session[:trab]= 0
            end
         else
             session[:trabalho] = 0
         end
         if @crianca.declaracao==true
              session[:declaracao]= 1
              
             if session[:dec]== 1
                  session[:declaracao]= 0
                 session[:dec]=0
             end
         else
             
               session[:declaracao]= 0
          end
          if @crianca.autonomo==true
              session[:autonomo]=1
              if session[:aut]== 1
                  session[:autonomo]=0
                  session[:aut]= 0
              end
         else
             session[:autonomo]=0
         end
         if @crianca.transferencia==true
             session[:transferencia]=1
             if session[:tra]== 1
                 session[:transferencia]=0
                 session[:aut]= 0
             end
         else
             session[:transferencia]=0
         end
        session[:sim]= 0
      end

   
    hoje = Date.today.to_s
    final = '2012-07-01'
    data=@crianca.nascimento.strftime("%Y-%m-%d")
if  (data <= Date.today.to_s and data >= DATAB1)
       @crianca.grupo_id = 1
        else if(data < DATAB1 and data >= DATAB2)
           @crianca.grupo_id = 2
           else if(data < DATAB2 and data >= DATAM1A)
                  @crianca.grupo_id = 4
                  else if(data < DATAM1A and data >= DATAM1B)
                      @crianca.grupo_id = 8
                      else if(data < DATAM1B and data >= DATAM2)
                              @crianca.grupo_id = 5
                            else if(data < DATAM2 and data >= DATAN1)
                                    @crianca.grupo_id = 6
                                  else if(data < DATAN1 and data >= DATAN2)
                                        @crianca.grupo_id = 7
                                       end
                                 end
                           end
                      end
                 end
           end
       end

  #      if params[:recadastrarX].to_i == 1
     #   else
     #     if session[:recadastrada]== 'recadastrar'
     #              @crianca.recadastrada = 1
     #              @crianca.data_rec= Time.now
     #              @crianca.local_rec= current_user.unidade.nome
    #               session[:recadastrada]= 0
   #                @crianca.save
   #           session[:recadastrada]= 0
   #       else  if (session[:recadastrada]== 'edit') and (@crianca.recadastrada != 2)
   #                @crianca.recadastrada = 1
   #                @crianca.data_rec= Time.now
   #                @crianca.local_rec= current_user.unidade.nome
   #                session[:recadastrada]= 0
   #                @crianca.save

  #           end
  #        end
  #      end
  # ^^  após recadastramento comentar estes comandos ^^

      wc1=@crianca.declaracao

      respond_to do |format|
      if @crianca.update_attributes(params[:crianca])
        if  session[:sim]== 1
            wc=@crianca.servidor_publico= session[:servidor_publico]
            wc1=@crianca.trabalho = session[:trabalho]
            wc2=@crianca.declaracao= session[:declaracao]
            wc3=@crianca.autonomo= session[:autonomo]
            wc4=@crianca.transferencia= session[:transferencia]
            session[:sim]= 0
            t=0
            @crianca.save

        end
        session[:id]=@crianca.id
        @crianca = Crianca.find(session[:id])
                        if @crianca.servidor_publico == true
                               @crianca.opcao1=  'servidor'
                        else if @crianca.trabalho == true
                                    @crianca.opcao1=  'trabalho'
                             else if @crianca.declaracao == true
                                         @crianca.opcao1=  'declaracao'
                                  else if @crianca.autonomo == true
                                         @crianca.opcao1=='autonomo'
                                      else
                                          @crianca.opcao1='não trabalha'
                                      end
                                  end
                             end
                        end
                        t=0
                       @crianca.save
                       if session[:ficha_pre]==1
                                  @crianca.recadastrada = 2
                                  @crianca.status = 'NA_DEMANDA'
                                  if @crianca.opcao2== '1'
                                       @crianca.opcao2='estudou em outra unidade/cidade'
                                  else
                                     @crianca.opcao2= nil
                                  end
                                  if @crianca.declaracao==true or @crianca.trabalho==true
                                    @crianca.opcao1='trabalha'
                                  else
                                    @crianca.opcao1='não trabalha'
                                  end
                                  @crianca.save
                       end
        flash[:notice] = 'Atualizado com sucesso.'
         if session[:show]==1
             if session[:creche]==1
                #@crianca.regiao_id= nil
                session[:creche]=0
                t=0
             else
                 @crianca.regiao_id= nil
               t=0
             end
              @crianca.save
              format.html { redirect_to(@crianca) }
              format.xml  { head :ok }
              session[:show]=0
         end
         if session[:show_recadastramento]==1
              format.html { redirect_to(show_recadastramento_path) }
              format.xml  { head :ok }
              session[:show_recadastramento]==0
         end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crianca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /criancas/1
  # DELETE /criancas/1.xml
  def destroy
    @crianca = Crianca.find(params[:id])
    @crianca_log = Log.new
    @crianca_log.user_id = current_user.id
    @crianca_log.obs = "Apagado"
    @crianca_log.data = (Time.now().strftime("%d/%m/%y %H:%M")).to_s
    @crianca_log.crianca_id = @crianca.id
    @crianca_log.save
    @crianca.destroy

    respond_to do |format|
      format.html { redirect_to(criancas_url) }
      format.xml  { head :ok }
    end
  end

  def create_observacao_crianca
   t=params[:observacao_crianca]
    @observacao_crianca = ObservacaoCrianca.new(params[:observacao_crianca])
      t1=params[:observacao_crianca]
      @crianca = Crianca.find(session[:id_crianca])
      @observacao_crianca.crianca_id =@crianca.id
      @observacao_crianca.data = Time.now
      @observacao_crianca.funcionario = @observacao_crianca.funcionario + '('+ current_user.unidade.nome + ')'

      if @observacao_crianca.save
        render :update do |page|
          page.replace_html 'dados', :partial => "observacoes"
          page.replace_html 'edit'
        end
       end

end

  def create_vaga_crianca
   t=params[:vaga_crianca]
    @vaga_crianca = VagaCrianca.new(params[:vaga_crianca])
      t1=params[:vaga_crianca]
      @crianca = Crianca.find(session[:id_crianca])
      @vaga_crianca.crianca_id =@crianca.id
      @vaga_crianca.data = Time.now
      @vaga_crianca.funcionario = @vaga_crianca.funcionario + '('+ current_user.unidade.nome + ')'

      if @vaga_crianca.save
        render :update do |page|
          page.replace_html 'dados_vaga', :partial => "vagas"
          page.replace_html 'edit'
        end
       end

end

  def autentica_matricula
    session[:unidade_matricula] = params[:crianca_unidade_matricula]
    #@teste = Crianca.find(params[:id])
    @existe = Crianca.find(:all, :conditions => ["((id= "+ session[:id_crianca] +" and (opcao1 = " + session[:unidade_matricula] + " or opcao2 = " + session[:unidade_matricula] + " or opcao3 = " + session[:unidade_matricula] + " or opcao4 = " + session[:unidade_matricula] +")))"])
    if @existe.empty? then
     render :update do |page|
      page.replace_html 'unidade', :text => "OPÇÃO NÃO ESCOLHIDA NO CADASTRO DE PREFERÊNCIA DE UNIDADE. ESCOLHA UMA DAS OPÇÕES LISTADA ACIMA."
      page.replace_html 'Certeza', :text =>  'PREFERÊNCIA DE MATRÍCULA INVÁLIDA, FAVOR REFAZER A OPÇÃO DE MATRÍCULA.'
     end


    else
      render :update do |page|
        page.replace_html 'unidade', :text => "OPÇÃO PREVISTA DURANTE O CADASTRO DA CRIANÇA NAS PREFERÊNCIA DE UNIDADE"
        page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Atualizar' />"
      end
    end
  end

   def consultacrianca
     t=0
     if params[:type_of].to_i == 1
      if current_user.present?
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                 #@criancas = Crianca.find( :all,:conditions => ["nome like ? AND status = 'NA_DEMANDA' AND recadastrada!=0" , "%" + params[:search1].to_s + "%"],:order => 'nome ASC, unidade_id ASC')
                  @criancas = Crianca.find( :all,:conditions => ["nome like ? AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7) " , "%" + params[:search1].to_s + "%", DATAN2],:order => 'nome ASC, unidade_id ASC')
                  
              else
                 #@criancas = Crianca.find( :all,:conditions => ["nome like ? AND status = 'NA_DEMANDA' AND recadastrada!=0 ", "%" + params[:search1].to_s + "%" ],:order => 'nome ASC')
                  @criancas = Crianca.find( :all,:conditions => ["nome like ?AND nascimento >= ?   AND (grupo_id <> 6 AND  grupo_id <> 7) ", "%" + params[:search1].to_s + "%", DATAN2 ],:order => 'nome ASC')
                 
         end
      else
        @criancas = Crianca.find( :all,:conditions => ["nome like ?AND nascimento >= ?   AND (grupo_id <> 6 AND grupo_id <> 7) ", "%" + params[:search1].to_s + "%", DATAN2 ],:order => 'nome ASC')
       
      end
              @canceladas = Crianca.find( :all,:conditions => [" nome like ? AND status =? AND nascimento >= ?   AND (grupo_id <> 6 AND  grupo_id <> 7)",  "%" + params[:search1].to_s + "%" , 'CANCELADA', DATAN2],:order => 'nome ASC')
              @demandas = Crianca.find( :all,:conditions => [" nome like ? and status =? AND nascimento >= ?   AND (grupo_id <> 6 AND  grupo_id <> 7)",  "%" + params[:search1].to_s + "%" , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
              @matriculadas = Crianca.find( :all,:conditions => [" nome like ? and status =? AND nascimento >= ?    AND (grupo_id <> 6 AND  grupo_id <> 7) ",  "%" + params[:search1].to_s + "%" , 'MATRICULADA', DATAN2],:order => 'nome ASC')
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancas"
        end
     else if params[:type_of].to_i == 2
              if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                 @criancas = Crianca.find( :all,:conditions => ['status = ? AND recadastrada!=0 AND nascimento >= ?   AND (grupo_id <> 6 AND  grupo_id <> 7)', params[:crianca][:status], DATAN2],:order => 'nome ASC, unidade_id ASC')
              else
                 @criancas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , params[:crianca][:status], DATAN2],:order => 'nome ASC')
              end
              @canceladas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'CANCELADA', DATAN2],:order => 'nome ASC')
              @demandas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
              @matriculadas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'MATRICULADA', DATAN2],:order => 'nome ASC')
             render :update do |page|
                page.replace_html 'criancas', :partial => "criancas"
              end
         else if params[:type_of].to_i == 6
                @criancas = Crianca.find( :all, :conditions=>[' recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND grupo_id <> 7)', DATAN2 ],:order => 'nome ASC')
                @canceladas = Crianca.find( :all,:conditions => ["status =? AND recadastrada!=0 AND nascimento >= ?", 'CANCELADA  AND (grupo_id <> 6 AND  grupo_id <> 7)', DATAN2],:order => 'nome ASC')
                @demandas = Crianca.find( :all,:conditions => ["status =? AND recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
                @matriculadas = Crianca.find( :all,:conditions => ["status =? AND recadastrada!=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)",'MATRICULADA', DATAN2],:order => 'nome ASC')
                  render :update do |page|
                   page.replace_html 'criancas', :partial => "criancas"
                  end
               else if params[:type_of].to_i == 3
                          if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                                @criancas = Crianca.find( :all,:conditions => ["nome like ?  AND recadastrada=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)" , "%" + params[:searchrec].to_s + "%", DATAN2],:order => 'nome ASC, unidade_id ASC')
                          else
                                @criancas = Crianca.find( :all,:conditions => ["nome like ?  AND recadastrada=0 AND nascimento >= ?   AND (grupo_id <> 6 AND  grupo_id <> 7)", "%" + params[:searchrec].to_s + "%", DATAN2 ],:order => 'nome ASC')
                           end

                          @canceladas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'CANCELADA', DATAN2],:order => 'nome ASC')
                          @demandas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
                          @matriculadas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'MATRICULADA', DATAN2],:order => 'nome ASC')
                         render :update do |page|
                            page.replace_html 'criancas', :partial => "criancas"
                          end
                     else if params[:type_of].to_i == 5
                          if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                                @criancas = Crianca.find( :all,:conditions => ["mae like ?  AND recadastrada=0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)" , "%" + params[:searchmae].to_s + "%", DATAN2],:order => 'nome ASC, unidade_id ASC')
                          else
                                @criancas = Crianca.find( :all,:conditions => ["mae like ?  AND recadastrada=0 AND nascimento >= ?   AND (grupo_id <> 6 AND  grupo_id <> 7)", "%" + params[:searchmae].to_s + "%", DATAN2 ],:order => 'nome ASC')
                           end
t=0
                          @canceladas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'CANCELADA', DATAN2],:order => 'nome ASC')
                          @demandas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
                          @matriculadas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  AND (grupo_id <> 6 AND  grupo_id <> 7)", current_user.unidade_id , 'MATRICULADA', DATAN2],:order => 'nome ASC')
                         render :update do |page|
                            page.replace_html 'criancas', :partial => "criancas"
                          end




                           end

                     end
             end
        end
     end
  end


def consultacriancaedicao

     t=0
     if params[:type_of].to_i == 1
      if current_user.present?
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                 #@criancas = Crianca.find( :all,:conditions => ["nome like ? AND status = 'NA_DEMANDA' AND recadastrada!=0" , "%" + params[:search1].to_s + "%"],:order => 'nome ASC, unidade_id ASC')
                  @criancas = Crianca.find( :all,:conditions => ["nome like ? AND nascimento >= ?  " , "%" + params[:search1].to_s + "%", DATAN2],:order => 'nome ASC, unidade_id ASC')

              else
                 #@criancas = Crianca.find( :all,:conditions => ["nome like ? AND status = 'NA_DEMANDA' AND recadastrada!=0 ", "%" + params[:search1].to_s + "%" ],:order => 'nome ASC')
                  @criancas = Crianca.find( :all,:conditions => ["nome like ?AND nascimento >= ?  ", "%" + params[:search1].to_s + "%", DATAN2 ],:order => 'nome ASC')

         end
      else
        @criancas = Crianca.find( :all,:conditions => ["nome like ?AND nascimento >= ?  ", "%" + params[:search1].to_s + "%", DATAN2 ],:order => 'nome ASC')

      end
              @canceladas = Crianca.find( :all,:conditions => [" nome like ? AND status =? AND nascimento >= ?  ",  "%" + params[:search1].to_s + "%" , 'CANCELADA', DATAN2],:order => 'nome ASC')
              @demandas = Crianca.find( :all,:conditions => [" nome like ? and status =? AND nascimento >= ?   ",  "%" + params[:search1].to_s + "%" , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
              @matriculadas = Crianca.find( :all,:conditions => [" nome like ? and status =? AND nascimento >= ?   ",  "%" + params[:search1].to_s + "%" , 'MATRICULADA', DATAN2],:order => 'nome ASC')
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancas"
        end
     else if params[:type_of].to_i == 2
              if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                 @criancas = Crianca.find( :all,:conditions => ['status = ? AND recadastrada!=0 AND nascimento >= ?   ', params[:crianca][:status], DATAN2],:order => 'nome ASC, unidade_id ASC')
              else
                 @criancas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ?  )", current_user.unidade_id , params[:crianca][:status], DATAN2],:order => 'nome ASC')
              end
              @canceladas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ? )", current_user.unidade_id , 'CANCELADA', DATAN2],:order => 'nome ASC')
              @demandas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ? ", current_user.unidade_id , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
              @matriculadas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada!=0 AND nascimento >= ?  ", current_user.unidade_id , 'MATRICULADA', DATAN2],:order => 'nome ASC')
             render :update do |page|
                page.replace_html 'criancas', :partial => "criancas"
              end
         else if params[:type_of].to_i == 6
                @criancas = Crianca.find( :all, :conditions=>[' recadastrada!=0 AND nascimento >= ?  ', DATAN2 ],:order => 'nome ASC')
                @canceladas = Crianca.find( :all,:conditions => ["status =? AND recadastrada!=0 AND nascimento >= ?", 'CANCELADA  AND (grupo_id <> 6 AND  grupo_id <> 7)', DATAN2],:order => 'nome ASC')
                @demandas = Crianca.find( :all,:conditions => ["status =? AND recadastrada!=0 AND nascimento >= ?  ", 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
                @matriculadas = Crianca.find( :all,:conditions => ["status =? AND recadastrada!=0 AND nascimento >= ? ",'MATRICULADA', DATAN2],:order => 'nome ASC')
                  render :update do |page|
                   page.replace_html 'criancas', :partial => "criancas"
                  end
               else if params[:type_of].to_i == 3
                          if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                                @criancas = Crianca.find( :all,:conditions => ["nome like ?  AND recadastrada=0 AND nascimento >= ?  " , "%" + params[:searchrec].to_s + "%", DATAN2],:order => 'nome ASC, unidade_id ASC')
                          else
                                @criancas = Crianca.find( :all,:conditions => ["nome like ?  AND recadastrada=0 AND nascimento >= ?  ", "%" + params[:searchrec].to_s + "%", DATAN2 ],:order => 'nome ASC')
                           end

                          @canceladas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ? ", current_user.unidade_id , 'CANCELADA', DATAN2],:order => 'nome ASC')
                          @demandas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  ", current_user.unidade_id , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
                          @matriculadas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ? )", current_user.unidade_id , 'MATRICULADA', DATAN2],:order => 'nome ASC')
                         render :update do |page|
                            page.replace_html 'criancas', :partial => "criancas"
                          end
                     else if params[:type_of].to_i == 5
                          if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                                @criancas = Crianca.find( :all,:conditions => ["mae like ?  AND recadastrada=0 AND nascimento >= ?  " , "%" + params[:searchmae].to_s + "%", DATAN2],:order => 'nome ASC, unidade_id ASC')
                          else
                                @criancas = Crianca.find( :all,:conditions => ["mae like ?  AND recadastrada=0 AND nascimento >= ?   ", "%" + params[:searchmae].to_s + "%", DATAN2 ],:order => 'nome ASC')
                           end
t=0
                          @canceladas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?", current_user.unidade_id , 'CANCELADA', DATAN2],:order => 'nome ASC')
                          @demandas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  ", current_user.unidade_id , 'NA_DEMANDA', DATAN2],:order => 'nome ASC')
                          @matriculadas = Crianca.find( :all,:conditions => [" unidade_id = ? and status =? AND recadastrada = 0 AND nascimento >= ?  ", current_user.unidade_id , 'MATRICULADA', DATAN2],:order => 'nome ASC')
                         render :update do |page|
                            page.replace_html 'criancas', :partial => "criancas"
                          end




                           end

                     end
             end
        end
     end
  end

   def criancamat2pre
     t=0
     if params[:type_of].to_i == 1
        @criancas = Crianca.find( :all,:conditions => ["nome like ?  AND nascimento >= ? AND (grupo_id = 5 ) AND (regiao_id <> 999 AND regiao_id is not null ) AND status= 'NA_DEMANDA' AND regiao_id > 99", "%" + params[:search1].to_s + "%", DATAN2 ],:order => 'nome ASC')
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancasmat2pre"
        end
     else if params[:type_of].to_i == 2

              @criancas = Crianca.find( :all,:conditions => ['regiao_id = ? AND recadastrada!=0 AND nascimento >= ?   AND (grupo_id = 5 ) and status= "NA_DEMANDA"', params[:crianca][:regiao], DATAN2],:order => 'nome ASC, unidade_id ASC')
              #@criancas = Crianca.find( :all,:conditions => ["nome like ?AND nascimento >= ? AND (grupo_id = 5 ) AND (regiao_id <> 999 AND regiao_id is not null ) AND status= 'NA_DEMANDA'", "%" + params[:search1].to_s + "%", DATAN2 ],:order => 'nome ASC')

             render :update do |page|
                page.replace_html 'criancas', :partial =>  "criancasmat2pre"
              end
         else if params[:type_of].to_i == 6
                
                @criancas = Crianca.find( :all,:conditions => ["recadastrada!=0 AND nascimento >= ? AND (grupo_id = 5 ) AND (regiao_id <> 999 AND regiao_id is not null ) AND status= 'NA_DEMANDA' AND regiao_id > 99",  DATAN2 ],:order => 'nome ASC' )
                  render :update do |page|
                   page.replace_html 'criancas', :partial => "criancasmat2pre"
                  end
               else if params[:type_of].to_i == 3

                     else if params[:type_of].to_i == 5

                          end

                     end
             end
        end
     end
  end

  def consultatransferencias
     if params[:type_of].to_i == 1
                @criancas = Crianca.find( :all,:conditions => ["recadastrada!=0 AND status = 'NA_DEMANDA' AND transferencia = 1" ],:order => "servidor_publico DESC, transferencia DESC, trabalho DESC, declaracao DESC, autonomo DESC,  created_at ASC")
             session[:transf]=1
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancas_transf"
        end
     else if params[:type_of].to_i == 2

              @criancasR = Crianca.find( :all,:conditions => ["unidade_ref = ? AND recadastrada!=0 AND status = 'NA_DEMANDA' AND transferencia = 1 AND recadastrada!=0 ", params[:crianca][:unidade_ref]],:order => "servidor_publico DESC, trabalho DESC, declaracao DESC, autonomo DESC, transferencia DESC, created_at ASC")
              #@criancasNR = Crianca.find( :all,:conditions => ["unidade_ref = ? AND recadastrada = 0 AND status = 'NA_DEMANDA' AND transferencia = 1 AND recadastrada!=0 ", params[:crianca][:unidade_ref]],:order => "servidor_publico DESC, trabalho DESC, declaracao DESC, autonomo DESC, transferencia DESC, created_at ASC")
              session[:opcao]= params[:crianca][:unidade_ref]
             @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao1=?  AND transferencia=1",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
             @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao2=?  AND transferencia=1",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
             @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=?  AND transferencia=1 ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
             @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao1=?  AND transferencia=1 ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
             @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao2=?  AND transferencia=1 ",  session[:opcao] ],:order => "servidor_publico DESC,transferencia DESC, created_at ASC")
             @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao3=?  AND transferencia=1 ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
             @criancasNR = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6
             render :update do |page|
                page.replace_html 'criancas', :partial => "criancas_transf2"
              end

           else if params[:type_of].to_i == 3
                #@criancas = Crianca.find( :all,:conditions => ["recadastrada = 0 AND status = 'NA_DEMANDA' AND transferencia = 1" ],:order => "servidor_publico DESC, trabalho DESC, declaracao DESC, autonomo DESC, transferencia DESC, created_at ASC")

                     @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1  AND transferencia=1 AND recadastrada = 0",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
                     #@criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1  AND transferencia=1 AND recadastrada = 0",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
                     #@criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1  AND transferencia=1 AND recadastrada = 0 ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
                     @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0  AND transferencia=1 AND recadastrada = 0",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
                     #@criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0  AND transferencia=1 AND recadastrada = 0",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
                     #@criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0  AND transferencia=1 AND recadastrada = 0",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
                     #@criancasNR = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6
                     @criancasNR = @criancas1 + @criancas4 
                      session[:transf]=1
                         render :update do |page|
                            page.replace_html 'criancas', :partial => "criancas_transf2"
                          end
                 else if params[:type_of].to_i == 6
                         t=0
                       @criancas = Crianca.find( :all,:conditions => ["regiao_id= ? AND recadastrada!=0 AND status = 'NA_DEMANDA' AND transferencia = 1 AND recadastrada!=0 ", params[:crianca][:regiao_id]],:order => "servidor_publico DESC, transferencia DESC, trabalho DESC, declaracao DESC, autonomo DESC, created_at ASC")
                        render :update do |page|
                          page.replace_html 'criancas', :partial => "criancas_transf"
                        end

                 end
             end
        end
     end
  end


 def consulta_geral
      @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ],:order => "trabalho DESC, servidor_publico DESC,  transferencia DESC, created_at ASC")
 end

 def consulta_mae
      @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ],:order => "trabalho DESC, servidor_publico DESC,  transferencia DESC, created_at ASC")
 end


def consulta_unidade_status

end



def classificao_unidade_status

#  session[:opcao]=Unidade.find_by_id(params[:crianca_unidade_id]).nome

 @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao1=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao2=? ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao1=? ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao2=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao3=? ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")

 #@criancas1 = Crianca.find( :all,:conditions => ["status ='NA_DEMANDA' and opcao1=?",session[:opcao] ],:order => " trabalho DESC, servidor_publico DESC,  transferencia DESC, created_at ASC, opcao1")
 #@criancas1 = @criancas1.sort_by{|e| -e.trabalho}
 #@criancas1 = @criancas1.sort_by{|e| -e.servidor_publico}
 #@criancas1 = @criancas1.sort_by{|e| -e.irmao}
 #@criancas1 = @criancas1.sort_by{|e| -e.transferencia}

  @criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6

  render :partial => 'criancas_unidade_status'

end


def consulta_unidade

end

def consulta
    render :partial => 'consultas'
end

def consulta_status
     if params[:type_of].to_i == 1
           @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0"],:order => 'nome ASC, unidade_id ASC')
     else if params[:type_of].to_i == 2
              @criancas = Crianca.find( :all,:conditions => ["status = 'CANCELADA' AND recadastrada!=0"],:order => 'nome ASC, unidade_id ASC')
             render :update do |page|
                page.replace_html 'criancas', :partial => "criancas_unidade_status"
              end
         else if params[:type_of].to_i == 3
                @criancas = Crianca.find( :all,:conditions => ["status = 'MATRICULADA' AND recadastrada!=0"],:order => 'nome ASC, unidade_id ASC')
                render :update do |page|
                   page.replace_html 'criancas', :partial => "criancas_unidade_status"
                 end
              end
          end
     end
    
end

def consulta_status_demanda
 unidade =(params[:criancaD_unidade_idD])
  session[:opcaos] = Unidade.find(unidade).nome
  #@criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND opcao1 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND opcao2 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND opcao3 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas = @criancas1 + @criancas2 + @criancas3
  @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND unidade_ref = ? AND recadastrada!=0", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
    render :update do |page|
         page.replace_html 'criancas', :partial => "criancas_unidade_status"
     end
end


def consulta_status_regiao
  regiao =(params[:criancaR_regiao_idR])

  
  @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND regiao_id = ? AND recadastrada!=0", regiao],:order => 'nome ASC, unidade_id ASC')
    render :update do |page|
         page.replace_html 'criancas', :partial => "criancas_unidade_status"
     end
end




def consulta_status_cancelada
 unidade =(params[:criancaC_unidade_idC])
  session[:opcaos] = Unidade.find(unidade).nome
  #@criancas1 = Crianca.find( :all,:conditions => ["status = 'CANCELADA' AND opcao1 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas2 = Crianca.find( :all,:conditions => ["status = 'CANCELADA' AND opcao2 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas3 = Crianca.find( :all,:conditions => ["status = 'CANCELADA' AND opcao3 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas = @criancas1 + @criancas2 + @criancas3
  @criancas = Crianca.find( :all,:conditions => ["status = 'CENCELADA' AND unidade_ref = ? AND recadastrada!=0", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  render :update do |page|
         page.replace_html 'criancas', :partial => "criancas_unidade_status"
     end
end

def consulta_status_matriculada
 unidade =(params[:criancaM_unidade_idM])
 session[:opcaos] = Unidade.find(unidade).nome
  #@criancas1 = Crianca.find( :all,:conditions => ["status = 'MATRICULADA' AND opcao1 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas2 = Crianca.find( :all,:conditions => ["status = 'MATRICULADA' AND opcao2 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas3 = Crianca.find( :all,:conditions => ["status = 'MATRICULADA' AND opcao3 = ?", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')
  #@criancas = @criancas1 + @criancas2 + @criancas3
  @criancas = Crianca.find( :all,:conditions => ["status = 'MATRICULADA' AND unidade_ref = ? AND recadastrada!=0", session[:opcaos]],:order => 'nome ASC, unidade_id ASC')

     render :update do |page|
         page.replace_html 'criancas', :partial => "criancas_unidade_status"
     end
end



def consulta_altera_status
     if params[:type_of].to_i == 1
        @criancas = Crianca.find(:all,:conditions => ["nome like ?", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancas_unidade_status"
        end

     else if params[:type_of].to_i == 2
              @criancas = Crianca.find( :all,:conditions => ["recadastrada != 0 "],:order => 'nome ASC, unidade_id ASC')
             render :update do |page|
                page.replace_html 'criancas', :partial => 'criancas_unidade_status'

              end
         end
     end
end

def matricula_unidade
    t=0
    if params[:matricula_status]=='MATRICULADA'
    t=0
     render :update do |page|
         page.replace_html 'matricula_unidade', :partial => "matricula_unidade"
     end

    end
end



def classificao_unidade

    w = session[:unidade]=(params[:crianca_unidade_id])
    w1 = session[:classe]=(params[:crianca_grupo_id])


 #w3= session[:opcao]=Unidade.find_by_id(params[:crianca_unidade_id]).nome
 #w4= session[:regiao]=Unidade.find_by_id(params[:crianca_unidade_id]).regiao_id
 #@criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao1=? ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 #@criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao2=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
 #@criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? ",  session[:opcao] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 #@criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao1=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
 #@criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao2=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
 #@criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao3=? ",  session[:opcao] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")

 #@criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6

# @criancas1 = @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND servidor_publico = 1 AND unidade_ref = ? ",  session[:opcao] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, autonomo DESC, created_at ASC")
# @criancas2 = @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND servidor_publico = 0 AND unidade_ref = ? ",  session[:opcao] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, autonomo DESC, created_at ASC")
# @criancas11 = (@criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 AND unidade_ref = ? ",  session[:opcao] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, autonomo DESC, created_at ASC")) - (@criancas1 + @criancas2)
# @criancas12 = (@criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND unidade_ref = ? ",  session[:opcao] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, autonomo DESC, created_at ASC")) - (@criancas1 + @criancas2)
# @criancas21 = (@criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND autonomo = 1 AND unidade_ref = ? ",  session[:opcao] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, autonomo DESC, created_at ASC")) - (@criancas1 + @criancas2 + @criancas11 + @criancas12)
# @criancas22 = (@criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND autonomo = 0 AND unidade_ref = ? ",  session[:opcao] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, autonomo DESC, created_at ASC")) - (@criancas1 + @criancas2 + @criancas11 + @criancas12)

# @criancas = @criancas1 + @criancas2 + @criancas11 + @criancas12 + @criancas21 + @criancas22
#t=0
#  render :partial => 'criancas_unidade'
 
end

#def classifica_grupo
#  w1=session[:grupo]=params[:crianca_grupo_id]
#  t=0

#end

#def classif_regiao
#  w2=session[:regiao]=params[:crianca_regiao_id]
#  t=0
#end


#def consulta_classe

#  session[:opcao] = Unidade.find_by_id(params[:crianca][:unidade_id]).nome
#  session[:classe] =(params[:crianca][:grupo_id])

# @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 AND opcao1=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
# @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 AND opcao2=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
# @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
# @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND opcao1=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
# @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND opcao2=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")
# @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND opcao3=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC,  transferencia DESC, created_at ASC")

# @criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6

#render :update do |page|
#  page.replace_html 'criancas', :partial => "criancas_classe"
#end
#end


def consulta_classe

    if params[:type_of].to_i == 1
        w=session[:grupo]=params[:crianca][:grupo4_id]
        w1=session[:regiao]=params[:crianca][:regiao4_id]
        t=0
         @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'  AND regiao_id=? AND grupo_id=? ",  session[:regiao], session[:grupo] ],:order => "servidor_publico DESC, transferencia DESC, trabalho DESC, declaracao DESC, autonomo DESC,  created_at ASC")
         render :update do |page|
           page.replace_html 'criancas', :partial => 'criancas_regiao'
         end
     else if params[:type_of].to_i == 2
              w=session[:opcao] = params[:crianca][:regiao2_id]
              w1=session[:classe] =(params[:crianca][:classe_id])
              @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'  AND regiao_id=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, trabalho DESC, declaracao DESC, autonomo DESC, created_at ASC")
              render :update do |page|
                 page.replace_html 'criancas', :partial => "criancas_regiao"
               end
         else if params[:type_of].to_i == 3
              session[:grupo] = params[:crianca][:grupo3_id]
              session[:unidade_ref] =(params[:crianca][:unidade_ref])
              @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'  AND grupo_id=? AND unidade_ref=?",  session[:grupo], session[:unidade_ref] ],:order => "servidor_publico DESC, transferencia DESC, trabalho DESC, declaracao DESC, autonomo DESC,  created_at ASC")
              render :update do |page|
                 page.replace_html 'criancas', :partial => "criancas_regiao"
               end

              end
          end
     end


def relatorio_geral_ant
t=0
  @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'" ], :order => 'nome')
  t=0
  @unidades11 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CC " +"%"], :order => 'nome')
  @unidades12 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CR " +"%"], :order => 'nome')
  @unidades13 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"FIL. " +"%"], :order => 'nome')
  @unidades14 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CONV. " +"%"], :order => 'nome')
  @unidades15 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"EMEI " +"%"], :order => 'nome')



 end
end

#def relatorio_geral
#  @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'" ], :order => 'nome')
#  @unidades11 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CC " +"%"], :order => 'nome')
#  @unidades12 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CR " +"%"], :order => 'nome')
#  @unidades13 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"FIL. " +"%"], :order => 'nome')
#  @unidades14 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CONV. " +"%"], :order => 'nome')
#  @unidades15 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"EMEI " +"%"], :order => 'nome')
#end


def relatorio_geral

#   @regiaos1= Regiao.find(:all, :joins=> 'JOIN criancas on  criancas.regiao_id = regiaos.id', :conditions=>['regiaos.id > 99 AND regiaos.id < 108 AND criancas.recadastrada!=0' ], :order => 'regiaos.nome')
#   @regiaos2= Regiao.find(:all, :joins=> 'JOIN criancas on  criancas.regiao_id = regiaos.id', :conditions=>['regiaos.id > 107 AND regiaos.id < 115 AND criancas.recadastrada!=0' ], :order => 'regiaos.nome')
#   @regiaos3= Regiao.find(:all, :joins=> 'JOIN criancas on  criancas.regiao_id = regiaos.id', :conditions=>['regiaos.id > 114 AND regiaos.id < 201 AND criancas.recadastrada!=0' ], :order => 'regiaos.nome')

   @regiaos1= Regiao.find(:all, :conditions=>['regiaos.id > 99 AND regiaos.id < 108 ' ], :order => 'regiaos.nome')
   @regiaos2= Regiao.find(:all, :conditions=>['regiaos.id > 107 AND regiaos.id < 115 ' ], :order => 'regiaos.nome')
   @regiaos3= Regiao.find(:all, :conditions=>['regiaos.id > 114 AND regiaos.id < 201 AND id != 120' ], :order => 'regiaos.nome')
   @regiaos11= @regiaos1+@regiaos2+@regiaos3

   @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome')
t=0
   #@regiaos11= Regiao.find(:all, :joins=> 'INNER JOIN criancas  on  criancas.regiao_id = regiaos.id', :conditions=>['regiaos.id > 99 AND regiaos.id < 108 AND criancas.recadastrada!=0' ], :order => 'regiaos.nome')
   #@regiaos11= Regiao.find(:all,  :conditions=>['regiaos.id > 99 AND regiaos.id < 201 AND id !=120' ], :order => 'regiaos.nome')
   #@nidades12 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1  AND id > 99", "%"+"CR " +"%"], :order => 'nome')
   #@unidades13 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 AND id > 99", "%"+"FIL. " +"%"], :order => 'nome')
   #@unidades14 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 AND id > 99", "%"+"CONV. " +"%"], :order => 'nome')
   #@unidades15 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 AND id > 99 ", "%"+"EMEI " +"%"], :order => 'nome')


end


def relatorio_mae
  @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'" ],:order => 'nome')
  @regiao11 = Regiao.find(:all, :conditions => ["id !=120"], :order => 'nome')
  @unidades11 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CC " +"%"], :order => 'nome')
  @unidades12 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CR " +"%"], :order => 'nome')
  @unidades13 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1", "%"+"FIL. " +"%"], :order => 'nome')
  @unidades14 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CONV. " +"%"], :order => 'nome')

end

  def nome_crianca
    $consulta = 6
    $crianca = params[:crianca_crianca_id]
    @crianca = Crianca.find(:all, :conditions => ['id=' + $crianca ])
    render :partial => 'listar_todas_criancas'
  end


  def regiao_unidade
    @unidades = Unidade.find :all, :conditions => {:regiao_id => params[:cr_id]}
    render :update do |page|
    page.replace_html 'regiao', :partial => 'regiao_unidade'
    end
  end




 def matric
    render :partial => 'matricular'
  end


  def mesmo_nome
    w=session[:nome] = params[:crianca_nome]
    @verifica = Crianca.find(:all, :conditions=> ['nome =? and (recadastrada = 2 OR recadastrada = 1 )',params[:crianca_nome]])
        t=0
    if @verifica.present? then
      render :update do |page|
        page.replace_html 'nome_aviso', :text => '<font color="red" id="pisca1"> NOME JÁ CADASTRADO NO SISTEMA </font>'
        page.replace_html 'aviso_mae', :text => '<font color="red" id="pisca1">  MÃE:' +  @verifica[0].mae
        
    end
    else
      render :update do |page|
        page.replace_html 'nome_aviso', :text => ''
        page.replace_html 'aviso_mae', :text => ''
      end

    end
  end

    def mesmo_nome_pre
    w=session[:nome] = params[:crianca_nome]
    @verifica = Crianca.find(:all, :conditions=> ['nome =? and (recadastrada = 2 OR recadastrada = 1 ) and (grupo_id = 6 or grupo_id = 7)',params[:crianca_nome]])
        t=0
    if @verifica.present? then
      render :update do |page|
        page.replace_html 'nome_aviso', :text => '<font color="red" id="pisca1"> NOME JÁ CADASTRADO NO SISTEMA </font>'
        page.replace_html 'aviso_mae', :text => '<font color="red" id="pisca1">  MÃE:' +  @verifica[0].mae

    end
    else
      render :update do |page|
        page.replace_html 'nome_aviso', :text => ''
        page.replace_html 'aviso_mae', :text => ''
      end

    end
  end

  def mesma_mae

     @verifica_mae = Crianca.find(:all, :conditions=> ['mae =?  and nome = ?',params[:crianca_mae], session[:nome]])
    # @verifica = Crianca.find(:all, :conditions=> ['nome =? AND (recadastrada = 2 OR recadastrada = 1) AND status != "MATRICULADA"',params[:crianca_nome]])

     if @verifica_mae.present? then

       if Crianca.find_by_nome(session[:nome]) then
          @status_cri = Crianca.find(:all, :conditions=> ['nome =? and (status ="MATRICULADA" or status ="CANCELADA (Recadastramento)") ',session[:nome]])
          if !@status_cri.present?
            render :update do |page|
                page.replace_html 'nome_mae', :text => 'Criança já cadastrada no sistema '
                page.replace_html 'Certeza', :text =>  'Criança ja cadastrada'
                page.replace_html 'matricula', :text => ''
              end
          else
             render :update do |page|
                 page.replace_html 'nome_mae', :text => ''
                 page.replace_html 'matricula', :text => 'CRIANÇA JÁ POSSUI INSCRIÇÂO, TEM CERTEZA QUE DESEJA SALVAR NOVA FICHA DE INSCRIÇÃO?'
                page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Salvar' />"
              end
          end
      else
          render :update do |page|
             page.replace_html 'nome_mae', :text => ''
             page.replace_html 'matricula', :text => 'CRIANÇA JÁ POSSUI INSCRIÇÂO, TEM CERTEZA QUE DESEJA SALVAR NOVA FICHA DE INSCRIÇÃO?'
             page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Salvar' />"
          end
       end
     else
       render :nothing => true
     end
  end

  def mesma_mae_pre

     @verifica_mae = Crianca.find(:all, :conditions=> ['mae =?  and nome = ?  and (grupo_id = 6 or grupo_id = 7)',params[:crianca_mae], session[:nome]])
      if @verifica_mae.present? then
       if Crianca.find_by_nome(session[:nome]) then
          @status_cri = Crianca.find(:all, :conditions=> ['nome =? and (status ="MATRICULADA" or status ="CANCELADA (Recadastramento)") ',session[:nome]])
          if !@status_cri.present?
            render :update do |page|
                page.replace_html 'nome_mae', :text => 'Criança já cadastrada no sistema '
                page.replace_html 'Certeza', :text =>  'Criança ja cadastrada'
                page.replace_html 'matricula', :text => ''
              end
          else
             render :update do |page|
                 page.replace_html 'nome_mae', :text => ''
                 page.replace_html 'matricula', :text => 'CRIANÇA JÁ POSSUI INSCRIÇÂO, TEM CERTEZA QUE DESEJA SALVAR NOVA FICHA DE INSCRIÇÃO?'
                page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Salvar' />"
              end
          end
      else
          render :update do |page|
             page.replace_html 'nome_mae', :text => ''
             page.replace_html 'matricula', :text => 'CRIANÇA JÁ POSSUI INSCRIÇÂO, TEM CERTEZA QUE DESEJA SALVAR NOVA FICHA DE INSCRIÇÃO?'
             page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Salvar' />"
          end
       end
     else
       render :nothing => true
     end
  end


  def same_birthday
    data_nasc = params[:ano].to_s + '-' + params[:mes].to_s + '-' + params[:dia].to_s
    if !Crianca.by_nome(params[:nome]).by_nascimento(data_nasc).empty? then
      render :text => 'Mesma data e mesmo nome'
    else
      render :text => 'Nenhuma data igual...'
    end
  end

 def verifica_data
   if not params[:crianca_nascimento_3i].nil? then
     ano = params[:crianca_nascimento_3i].to_s
   end
   if not params[:crianca_nascimento_1i].nil? then
     dia = params[:crianca_nascimento_1i].to_s
   end
   if not params[:crianca_nascimento_2i].nil? then
     mes = params[:crianca_nascimento_2i].to_s
   end
   data = dia.to_s + " " + mes.to_s + " " + ano.to_s
   render :text => data.to_s

 end

 def impressao
       @crianca = Crianca.find(:all,:conditions => ["id = ?",   session[:child]])
       @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca[0].regiao_id])
      render :layout => "impressao"
end

def impressao_pre
       @crianca = Crianca.find(:all,:conditions => ["id = ?",   session[:child]])
       @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca[0].regiao_id])
      render :layout => "impressao"
end

  def impressao_nao_logado
       @crianca = Crianca.find(:all,:conditions => ["id = ?",   session[:child]])
       @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca[0].regiao_id])
      render :layout => "impressao"
end

def impressao_recadastramento
       #@crianca = Crianca.find(:all,:conditions => ["id = ?",  session[:id_crianca]])
       @crianca = Crianca.find(:all,:conditions => ["id = ?",  session[:child]])
       @unidade_regiao= Unidade.find(:all , :conditions=>['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)',@crianca[0].regiao_id])

      render :layout => "impressao"
end


 def impressao_class_unidade
 @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao1=? ",  session[:opcao] ],:order => " servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao2=? ",  session[:opcao] ],:order => " servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? ",  session[:opcao] ],:order => " servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao1=? ",  session[:opcao] ],:order => " servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao2=? ",  session[:opcao] ],:order => " servidor_publico DESC,  transferencia DESC, created_at ASC")
 @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao3=? ",  session[:opcao] ],:order => " servidor_publico DESC,  transferencia DESC, created_at ASC")
 
 @criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6

 render :layout => "impressao"
 end

 def impressao_class_classe
 @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 AND opcao1=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 AND opcao2=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND opcao1=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC,transferencia DESC, created_at ASC")
 @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND opcao2=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")
 @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 AND opcao3=? AND grupo_id=?",  session[:opcao], session[:classe] ],:order => "servidor_publico DESC, transferencia DESC, created_at ASC")

 @criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6

 render :layout => "impressao"
 end

def impressao_geral

#   @regiaos1= Regiao.find(:all, :conditions=>['regiaos.id > 99 AND regiaos.id < 108 ' ], :order => 'regiaos.nome')
#   @regiaos2= Regiao.find(:all, :conditions=>['regiaos.id > 107 AND regiaos.id < 115 ' ], :order => 'regiaos.nome')
#   @regiaos3= Regiao.find(:all, :conditions=>['regiaos.id > 114 AND regiaos.id < 201 AND id != 120' ], :order => 'regiaos.nome')
#   @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome')

   @regiaos11= Regiao.find(:all,  :conditions=>['regiaos.id > 99 AND regiaos.id < 201 AND id !=120' ], :order => 'regiaos.nome')

  #@criancas = Crianca.find(:all, :order => 'nome')
#  @unidades11 = Unidade.find(:all, :conditions=> ["nome like?", "%"+"CC " +"%"], :order => 'nome')
#  @unidades12 = Unidade.find(:all, :conditions=> ["nome like?", "%"+"CR " +"%"], :order => 'nome')
#  @unidades13 = Unidade.find(:all, :conditions=> ["nome like?", "%"+"FIL. " +"%"], :order => 'nome')
#  @unidades14 = Unidade.find(:all, :conditions=> ["nome like?", "%"+"CONV. " +"%"], :order => 'nome')
#  @unidades15 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"EMEI " +"%"], :order => 'nome')

  @regiaos1= Regiao.find(:all, :conditions=>['regiaos.id > 99 AND regiaos.id < 108 ' ], :order => 'regiaos.nome')
   @regiaos2= Regiao.find(:all, :conditions=>['regiaos.id > 107 AND regiaos.id < 115 ' ], :order => 'regiaos.nome')
   @regiaos3= Regiao.find(:all, :conditions=>['regiaos.id > 114 AND regiaos.id < 201 AND id != 120' ], :order => 'regiaos.nome')
   @regiaos11= @regiaos1+@regiaos2+@regiaos3

   @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome')

      render :layout => "impressao"
end
def impressao_maeTrabalha
  @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'" ],:order => 'nome')
  @unidades11 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CC " +"%"], :order => 'nome')
  @unidades12 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CR " +"%"], :order => 'nome')
  @unidades13 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1", "%"+"FIL. " +"%"], :order => 'nome')
  @unidades14 = Unidade.find(:all, :conditions=> ["nome like? AND ativo = 1 ", "%"+"CONV. " +"%"], :order => 'nome')

      render :layout => "impressao"
end
  
 def altera_nascimento
   params[:id]=1
   @crianca = Crianca.find(params[:id])
 end

#  def altera_classe
#  Crianca.alteracao_classe
 # t=1
 # render :update do |page|
#     page.replace_html 'nome_mae', :text => 'tete'

#  end

#
#  Crianca.connection.execute("CALL alteracao_classe")
#   render :update do |page|
#      page.replace_html 'confirma', :text => "<strong>Processo concluído com sucesso</strong>"
#   end
#  end

#  def alteracao_classe
#    @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ],:order => 'nome ASC')
#
#   @criancas.each do |crianca|
#   if  (crianca.nascimento <= '2015-10-31'.to_date and crianca.nascimento >= '2015-02-01'.to_date)
#       crianca.grupo_id = 10
#   else if(crianca.nascimento <= '2015-01-31'.to_date and crianca.nascimento >= '2014-07-01'.to_date)
#          crianca.grupo_id = 20
#       else if(crianca.nascimento <= '2014-06-30'.to_date and crianca.nascimento >= '2013-07-01'.to_date)
#              crianca.grupo_id = 40
#            else if(crianca.nascimento <= '2013-06-30'.to_date and crianca.nascimento >= '2012-07-01'.to_date)
#                    crianca.grupo_id = 50
#                  else if(crianca.nascimento <= '2012-06-30'.to_date and crianca.nascimento >= '2011-07-01'.to_date)
#                          crianca.grupo_id = 60
#                        else if(crianca.nascimento <= '2011-06-30'.to_date and crianca.nascimento >= '2010-07-01'.to_date)
#                               crianca.grupo_id = 70
#                             end
 #                      end
#                 end
#            end
#       end
#  end
# end
# @criancas.save
# t1=0
 #end


#def reclassifica_crianca
#    @criancas = Crianca.find(:all)
#    t=0
#    for crianca in @criancas
#        data= (crianca.nascimento).to_s
#        hoje = Date.today.to_s
#        # Alterei a data abaixo de 2012-07-01 para 2011-07-01 ###Alex 03-07-2017 10:20
#        final = '2011-07-01'
#              if (hoje > data)  and (data >= final)
#                # Alterei a data abaixo de 2015-02-01 para 2016-07-01 ###Alex 03-07-2017 10:20
#                if  (data <= Date.today.to_s and data >= '2016-07-01')
#                     crianca.grupo_id = 1
#                # Alterei a data abaixo de 2015-01-31 para 2016-06-30 ###Alex 03-07-2017 10:20
#                # Alterei a data abaixo de 2014-07-01 para 2015-07-01 ###Alex 03-07-2017 10:20
#                else if(data <= '2016-06-30' and data >= '2015-07-01')
#                     crianca.grupo_id = 2
#                     # Alterei a data abaixo de 2013-12-31 para 2015-06-30 ###Alex 03-07-2017 10:20
#                     # Alterei a data abaixo de 2013-07-01 para 2015-01-01 ###Alex 03-07-2017 10:20
#                     else if(data <= '2015-06-30' and data >= '2015-01-01')
#                            crianca.grupo_id = 4
#                          # Alterei a data abaixo de 2014-06-30 para 2014-12-31 ###Alex 03-07-2017 10:20
#                          # Alterei a data abaixo de 2014-01-01 para 2014-07-01 ###Alex 03-07-2017 10:20
#                          else if (data <= '2014-12-31' and data >= '2014-07-01')
#                                  crianca.grupo_id = 8
#                                # Alterei a data abaixo de 2013-06-30 para 2014-06-30 ###Alex 03-07-2017 10:20
#                                # Alterei a data abaixo de 2012-07-01 para 2013-07-01 ###Alex 03-07-2017 10:20
#                                else if (data <= '2014-06-30' and data >= '2013-07-01')
#                                        crianca.grupo_id = 5
#                                      # Alterei a data abaixo de 2012-06-30 para 2013-06-30 ###Alex 03-07-2017 10:20
#                                      # Alterei a data abaixo de 2011-07-01 para 2012-07-01 ###Alex 03-07-2017 10:20
#                                      else if (data <= '2013-06-30' and data >= '2012-07-01')
#                                            crianca.grupo_id = 6
#                                                # Alterei a data abaixo de 2011-06-30 para 2012-06-30 ###Alex 03-07-2017 10:50
#                                                # Alterei a data abaixo de 2010-07-01 para 2011-07-01 ###Alex 03-07-2017 10:50
#                                                else if(data <= '2012-06-30'and data >= '2011-07-01')
#                                                      crianca.grupo_id = 7
#                                                    end
#                                            end
#                                      end
#                                end
#                          end
#                     end
#                 end
#           end
#      @crianca.update_attributes(params[:crianca])
#    end
#   if @criancas.update_attributes(params[:crianca])
#   end
#   t=0
#end


 def lista_bairros
    @unidade_regiao = Unidade.find(:all, :conditions => ['regiao_id=? AND ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)', params[:crianca_regiao_id]])
     
    render :partial => 'lista_unidade_regiao'
  end




 def servidor_action
     if params[:crianca_servidor_publico] == '1'
        render :partial => 'servidor'
      else
          session[:ser]= 1
       render :partial => 'nada'
      end
 end

  def transferencia_action
      t=0
     @unidade_regiao= Unidade.find(:all , :conditions=>['ativo = 1 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)'])
     t=0
     if params[:crianca_transferencia] == '1'
        render :partial => 'transferencia'
      else
          session[:tra]= 1
          t=0
       render :partial => 'nada'
      end
 end


  def trabalho_action
     if params[:crianca_trabalho] == '1'
        render :partial => 'trabalho'
      else
       session[:trab]= 1
       render :partial => 'nada'
      end
 end

 def trabalho_action_pre
     if params[:crianca_trabalho] == '1'
        render :partial => 'pre_trabalho'
      else
       session[:trab]= 1
       render :partial => 'nada'
      end
 end
  def declaracao_action
     if params[:crianca_declaracao] == '1'
        render :partial => 'declaracao'
      else
        session[:dec]= 1
       render :partial => 'nada'
      end
 end

 def irmao_action_pre
      if params[:crianca_irmao] == '1'
        render :partial => 'pre_irmao'
      else
        session[:dec]= 1
       render :partial => 'nada'
      end
 end
  def declaracao_action_pre
     if params[:crianca_declaracao] == '1'
        render :partial => 'pre_declaracao'
      else
        session[:dec]= 1
       render :partial => 'nada'
      end
 end


 def autonomo_action
     if params[:crianca_autonomo] == '1'
        render :partial => 'autonomo'
      else
          session[:aut]= 1
       render :partial => 'nada'
      end
 end


  def estudo_action_pre

     if params[:crianca_opcao2] == '1'
        render :partial => 'pre_estudo'
      else
        session[:dec]= 1
       render :partial => 'nada'
      end
 end
 def pre_criancas

     if params[:type_of].to_i == 1
         data_pre = (DATAPRE2).to_s  #  data nascimento da criança que limita  matriculada na pré escola  a aprtir de ....
         data_pre = data_pre + ' 00:00:00'
         w=params[:search1]
         #@criancas_pre = Crianca.find( :all,:conditions => ["nome like ?  and  nascimento <= ?  and recadastrada > 0" , "%" + params[:search1].to_s + "%", data_pre ],:order => 'nome ASC, unidade_id ASC')
         @criancas_pre = Crianca.find( :all,:conditions => ["nome like ?  and  (grupo_id = 6 or grupo_id = 7  or (grupo_id = 5 and  regiao_id= 999 )) and recadastrada > 0" , "%" + params[:search1].to_s + "%"],:order => 'nome ASC, unidade_id ASC')
          render :update do |page|
              page.replace_html 'criancas', :partial => "criancas_pre"
           end
     else if params[:type_of].to_i == 2
             data_pre = (DATAPRE2).to_s  #  data nascimento da criança que limita  matriculada na pré escola  a aprtir de ....
             data_pre = data_pre + ' 00:00:00'
             #@criancas_pre = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 6)and (status='NA_DEMANDA')" ,data_pre ],:order => 'grupo_id ASC, nome ASC')
                 @criancas_pre  = Crianca.find( :all,:conditions => ["recadastrada > 0 and ( grupo_id =6 )and (status='NA_DEMANDA') and created_at > '2020-09-09 00:00:00'"  ],:order => 'nome ASC, grupo_id ASC')
                 @criancas_pre2 = Crianca.find( :all,:conditions => ["recadastrada > 0 and ( grupo_id =6 )and (status='NA_DEMANDA') and created_at < '2020-09-09 00:00:00'" ],:order => 'nome ASC, grupo_id ASC')

                 render :update do |page|
                  page.replace_html 'criancas', :partial => "criancas_pre"
               end
         else if params[:type_of].to_i == 6
                 data_pre = (DATAPRE2).to_s  #  data nascimento da criança que limita  matriculada na pré escola  a aprtir de ....
                 data_pre = data_pre + ' 00:00:00'
                 #@criancas_pre = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 6 or grupo_id = 7  or (grupo_id = 5 and  regiao_id= 999 )  )and (status='NA_DEMANDA')" ,data_pre ],:order => 'nome ASC, grupo_id ASC ')
                 @criancas_pre  = Crianca.find( :all,:conditions => ["recadastrada > 0 and ( grupo_id =6 OR grupo_id =7 OR (grupo_id =5 AND regiao_id = 999))and (status='NA_DEMANDA') and created_at > '2020-09-09 00:00:00'"  ],:order => 'nome ASC, grupo_id ASC')
                 @criancas_pre2 = Crianca.find( :all,:conditions => ["recadastrada > 0 and ( grupo_id =6 OR grupo_id =7 OR (grupo_id =5 AND regiao_id = 999))and (status='NA_DEMANDA') and created_at < '2020-09-09 00:00:00'" ],:order => 'nome ASC, grupo_id ASC')

                 @criancas_pre_mat = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 6 or grupo_id = 7  or (grupo_id = 5 and  regiao_id= 999 ))and (status='MATRICULADA')" ,data_pre ],:order => 'nome ASC, grupo_id ASC')
                 @criancas_pre_canc = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 6 or grupo_id = 7 or (grupo_id = 5 and  regiao_id= 999 ) )and (status='CANCELADA')" ,data_pre ],:order => 'nome ASC, grupo_id ASC')
                 @criancas_pre_duplic = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 6 or grupo_id = 7 or (grupo_id = 5 and  regiao_id= 999 ) )and (status='DUPLICIDADE')" ,data_pre ],:order => 'nome ASC, grupo_id ASC')
                 @criancas_pre_rec = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 6 or grupo_id = 7  or (grupo_id = 5 and  regiao_id= 999 ))and (status='RECUSOU')" ,data_pre ],:order => 'nome ASC, grupo_id ASC')
                 t=0
                  render :update do |page|
                      page.replace_html 'criancas', :partial => "criancas_pre"
                   end
               else if params[:type_of].to_i == 3
                     data_pre = (DATAPRE2).to_s  #  data nascimento da criança que limita  matriculada na pré escola  a aprtir de ....
                     data_pre = data_pre + ' 00:00:00'
                     #@criancas_pre = Crianca.find( :all,:conditions => ["nascimento <= ?  and recadastrada > 0 and (grupo_id = 7)and (status='NA_DEMANDA')" ,data_pre ],:order => 'grupo_id ASC, nome ASC')
                     @criancas_pre  = Crianca.find( :all,:conditions => ["recadastrada > 0 and ( grupo_id =7 )and (status='NA_DEMANDA') and created_at > '2020-09-09 00:00:00'"  ],:order => 'nome ASC, grupo_id ASC')
                     @criancas_pre2 = Crianca.find( :all,:conditions => ["recadastrada > 0 and ( grupo_id =7 )and (status='NA_DEMANDA') and created_at < '2020-09-09 00:00:00'" ],:order => 'nome ASC, grupo_id ASC')

                         render :update do |page|
                          page.replace_html 'criancas', :partial => "criancas_pre"
                       end

                     else if params[:type_of].to_i == 4
                           @criancas_pre = Crianca.find( :all,:conditions => ["(regiao_id= 999) and (status='NA_DEMANDA')" ],:order => 'grupo_id ASC, nome ASC')
                               render :update do |page|
                                page.replace_html 'criancas', :partial => "criancas_pre_4_5_6"
                             end





                           end

                     end
             end
        end
     end




 end

 def criancas_pre
   
   data_pre = (DATAN1).to_s  #  data nascimento da criança que limita  matriculada na pré escola  a aprtir de ....
   data_pre = data_pre + ' 00:00:00'
t=0
    #@criancas_pre = Crianca.find(:all, :conditions => ["matricula = 0" ], :order => "nome ASC")
    @criancas_pre = Crianca.find( :all,:conditions => ["nome like ?  and  nascimento < ?  and recadastrada > 0" , "%" + params[:crianca].to_s + "%", data_pre ],:order => 'nome ASC, unidade_id ASC')
    t=0
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancas_pre"
        end

end



 protected
    #Inicialização variavel / combobox grupo

  def load_grupos
    @grupos =  Grupo.find(:all, :order => "nome")
    @grupos1 =  Grupo.find(:all, :conditions => ["id <> 3"], :order => "nome")

  end

  def load_regiaos
    @regiaos =  Regiao.find(:all, :order => "nome")
  end

  def load_unidades
   if current_user.present?
    if current_user.unidade_id== 53 or current_user.unidade_id==52
       session[:unidade] = current_user.unidade_id
       @unidades1 =  Unidade.find(:all,  :conditions => ["(tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8) AND ativo = 1" ],:order => "nome")
       @unidades2 =  Unidade.find(:all,  :conditions => ["(tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8) and (id not between 70 and 83)  and (id <> 54) AND ativo = 1" ],:order => "nome")
    else
       
          session[:unidade] = current_user.unidade_id
       
       @unidades1 =  Unidade.find(:all,  :conditions => ["(tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8)AND (ativo = 1) and id=?", session[:unidade]  ],:order => "nome")
      @unidades2 =  Unidade.find(:all,  :conditions => ["(tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8) and (id not between 70 and 83) and (id <> 54) AND ativo = 1 "  ],:order => "nome")
       
    end
  end
    @unidades =  Unidade.find(:all,  :conditions => ["(tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8) AND ativo = 1" ],:order => "nome")

  end

    


  def load_criancas
    @criancas = Crianca.find(:all, :order => "nome ASC")
    @criancas_s = Crianca.find(:all, :select => 'distinct(status)', :order => "nome ASC")

  end

  def load_criancas_mat
#    @criancasmat = Crianca.find(:all, :conditions => ["matricula = 0" ], :order => "nome ASC")
  end


end

