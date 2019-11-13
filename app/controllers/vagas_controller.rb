class VagasController < ApplicationController
  # GET /vagas
  # GET /vagas.xml
  def index
    @vagas = Vaga.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vagas }
    end
  end

  # GET /vagas/1
  # GET /vagas/1.xml
  def show
    @vaga = Vaga.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vaga }
    end
  end

  # GET /vagas/new
  # GET /vagas/new.xml
  def new
    @vaga = Vaga.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vaga }
    end
  end

  # GET /vagas/1/edit
  def edit
    @vaga = Vaga.find(params[:id])
  end

  # POST /vagas
  # POST /vagas.xml
  def create
      repeticao= session[:rep]= (params[:quantidade]).to_i

      while repeticao > 0

      @vaga = Vaga.new(params[:vaga])

#    @classe=  Classe.find(:all, :conditions => ['id =?',@vaga.classe_id ])
#    classe= @classe[0].classe_classe
#    classe1=classe[0,classe.index(" ")]
#    letra=classe[classe.index(" "),]

#    if (classe1 == 'BI')
#      @vaga.grupo_id = 1
#    else if (classe1 == 'BII')
#             @vaga.grupo_id = 2
#         else if (classe1 == 'BIII')
#                  @vaga.grupo_id = 3
#              else  if (classe1 == 'MI')
#                  @vaga.grupo_id = 4
#                  else  if (classe1 == 'MII')
#                          @vaga.grupo_id = 5
#                       else if (classe1 == 'NI')
#                              @vaga.grupo_id = 6
#                            else if (classe1 == 'NII')
#                                  @vaga.grupo_id = 7
#                                else
#                                end
#                            end
#                       end
#                 end
#              end
#         end
#    end
    


   @vaga.save
   repeticao=repeticao-1
  end




    respond_to do |format|
      if @vaga.save
        flash[:notice] = 'Vaga was successfully created.'
        format.html { redirect_to(@vaga) }
        format.xml  { render :xml => @vaga, :status => :created, :location => @vaga }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vaga.errors, :status => :unprocessable_entity }
      end
    end
   end


  # PUT /vagas/1
  # PUT /vagas/1.xml
  def update
    @vaga = Vaga.find(params[:id])

    respond_to do |format|
      if @vaga.update_attributes(params[:vaga])
        flash[:notice] = 'Vaga was successfully updated.'
        format.html { redirect_to(@vaga) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vaga.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vagas/1
  # DELETE /vagas/1.xml
  def destroy
    @vaga = Vaga.find(params[:id])
    @vaga.destroy

    respond_to do |format|
      format.html { redirect_to(vagas_url) }
      format.xml  { head :ok }
    end
  end

  def classediv
      @classediv =  Classe.find(:all,  :conditions => ["classe_ano_letivo=? AND unidade_id=?", Time.now.year, params[:vaga_unidade_id]],:order => "classe_classe")
      render :partial => 'classe'

  end

    def grupodiv
      w=params[:vaga_grupo]
      t=0
      @grupo =  Grupo.find(:all,  :conditions => ["nome =?", params[:vaga_grupo]])
      session[:descricao]= @grupo[0].descricao
      render :partial => 'grupo'

  end

   def consulta_vaga
   if params[:type_of].to_i == 1
       w=params[:vaga][:grupo_id]
       t=0
       @unidades = Unidade.find(:all, :conditions => ['regiao_id > 99'], :order=> 'tipo,nome')
       @grupos = Grupo.find(:all, :conditions=>['id !=3'], :order=>'nome')
       @vagas = Vaga.find(:all, :conditions => ["grupo_id= ? AND disponivel= 0", (params[:vaga][:grupo_id])],:order => 'unidade_id ASC')
       @vagas_unidade =  Vaga.find_by_sql("SELECT unidade_id, grupo_id, count(id) as quantidade FROM vagas where grupo_id = '"+ (params[:vaga][:grupo_id]) +"' AND disponivel = 0 GROUP BY unidade_id ORDER BY unidade_id ")
       @vagas_regiao =  Vaga.find_by_sql("SELECT vg.unidade_id, vg.grupo_id, count(vg.id) as quantidade FROM vagas vg INNER JOIN unidades uni ON vg.unidade_id = uni.id INNER JOIN regiaos reg ON uni.regiao_id = reg.id WHERE vg.grupo_id = '"+ (params[:vaga][:grupo_id]) +"' AND vg.disponivel = 0 GROUP BY reg.id ORDER BY reg.id ")
        render :update do |page|
             page.replace_html 'vaga', :partial => "vaga_unidade"
        end
   else if params[:type_of].to_i == 2
            @unidades = Unidade.find(:all, :conditions => ['regiao_id > 99 AND ( tipo = 1 or tipo = 3 or tipo = 7 or tipo = 8)'], :order=> 'tipo,nome')
            @grupos = Grupo.find(:all, :conditions=>['id !=3'], :order=>'nome')
            @vagas = Vaga.find(:all, :conditions => ["disponivel = 0"],:order => 'unidade_id ASC')
            @vagas_unidade =  Vaga.find_by_sql("SELECT unidade_id, grupo_id, count(id) as quantidade FROM vagas where disponivel = 0 GROUP BY unidade_id, grupo_id  ORDER BY unidade_id ")
            @vagas_regiao =  Vaga.find_by_sql("SELECT vg.unidade_id, vg.grupo_id, count(vg.id) as quantidade FROM vagas vg INNER JOIN unidades uni ON vg.unidade_id = uni.id INNER JOIN regiaos reg ON uni.regiao_id = reg.id WHERE  vg.disponivel = 0 GROUP BY reg.id , vg.grupo_id ORDER BY  reg.id ")
            @regiaos1= Regiao.find(:all, :conditions=>['regiaos.id > 99 AND regiaos.id < 111 ' ])
            @regiaos2= Regiao.find(:all, :conditions=>['regiaos.id > 110 AND regiaos.id < 120 ' ])
        render :update do |page|
             page.replace_html 'vaga', :partial => "vaga_seduc"
        end

         else if params[:type_of].to_i == 3
                t=params[:vaga][:unidade_id]
               @vagas = Vaga.find(:all, :conditions => ["unidade_id = ? AND disponivel = 0", params[:vaga][:unidade_id]],:order => 'unidade_id ASC')
               @vagas_unidade =  Vaga.find_by_sql("SELECT unidade_id, grupo_id, count(id) as quantidade FROM vagas where unidade_id = '"+ (params[:vaga][:unidade_id].to_s) +"' AND disponivel = 0 GROUP BY grupo_id ORDER BY unidade_id ")
               @vagas_regiao =  Vaga.find_by_sql("SELECT vg.unidade_id, vg.grupo_id, count(vg.id) as quantidade FROM vagas vg INNER JOIN unidades uni ON vg.unidade_id = uni.id INNER JOIN regiaos reg ON uni.regiao_id = reg.id WHERE  unidade_id = '"+ (params[:vaga][:unidade_id].to_s) +"' AND vg.disponivel = 0 GROUP BY reg.id , vg.grupo_id  ORDER BY reg.id ")
                 render :update do |page|
                      page.replace_html 'vaga', :partial => "vaga_unidade"
                 end
              end
          end
  end
end

def vaga_crianca
end



def unidade_id
    session[:vaga_unidade]=params[:vaga_unidade_id]
    @unidade= Unidade.find(:all, :conditions=>['id=?',params[:vaga_unidade_id]   ])
    session[:vaga_regiao_id]=@unidade[0].regiao_id
    session[:vaga_unidade_nome]=@unidade[0].nome
    session[:vaga_unidade_id]=@unidade[0].id
end

def grupo_id
    session[:vaga_grupo]=(params[:vaga_grupo_id]).to_i
    session[:vaga_unidade_nome]
    @unidade=Unidade.find(:all, :conditions => ['nome =?', session[:vaga_unidade_nome]])
    session[:quant_vaga]= (Vaga.find(:all, :conditions => ['unidade_id =? AND grupo_id=?  AND crianca_id is null', session[:vaga_unidade_id], session[:vaga_grupo]])).count
    session[:regiao_id]= @unidade[0].regiao_id

    @criancasP = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND ( servidor_publico = 1 OR trabalho = 1 OR declaracao=1 OR autonomo = 1  OR transferencia = 1)  AND unidade_ref = ?  AND grupo_id = ? AND recadastrada!=0",  session[:vaga_unidade_nome], session[:vaga_grupo] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, declaracao DESC, transferencia, autonomo DESC, created_at ASC")

    @criancasR = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND regiao_id = ?  AND grupo_id = ? AND recadastrada!=0 AND unidade_ref != ? ", session[:regiao_id],  session[:vaga_grupo],  session[:vaga_unidade_nome] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, declaracao DESC, autonomo DESC, transferencia DESC, created_at ASC")

    @criancasU = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND unidade_ref = ?  AND grupo_id = ? AND recadastrada!=0",  session[:vaga_unidade_nome], session[:vaga_grupo] ],:order => "regiao_id DESC, servidor_publico DESC, trabalho DESC, declaracao DESC, autonomo DESC, transferencia DESC, created_at ASC")

    @criançastt= (@criancasR + @criancasU) - @criancasP

    @divisao=Crianca.find(:all,  :conditions => ["id = 1"])
    @divisao[0].nome="========> NA REGIÃO <========="
    @divisao[0].id = 0

    @criancasT =  @criancasU  + @divisao +(@criancasR - @criancasU)

    # testa para exibir mensagem no _crianca_vaga <=========================================
    @testavaga = Vaga.find(:all,:joins => :unidade, :conditions => ["vagas.grupo_id = ? AND vagas.unidade_id =? AND  vagas.disponivel = 0",session[:vaga_grupo], session[:vaga_unidade]])
     if !@testavaga.empty?
      session[:vaga_id]= @testavaga[0].id
       if @criancasT.count > 1
           session[:crianca_id]= @criancasT[0].id
       else
           session[:crianca_id]  = 0
       end
    else if @criancasT.count > 1
            session[:crianca_id]= @criancasT[0].id
         else
            session[:crianca_id]  = 0
          end
       session[:vaga_id]  = 0
    end

     render :partial => 'crianca_vaga'

end



def crianca_id
   w=session[:crianca_id]=params[:vaga_crianca_id]
end


def salvar
q=session[:vaga_id]
    @vaga = Vaga.find(session[:vaga_id])
    @vaga.disponivel=1
    @vaga.crianca_id=session[:crianca_id]
    @crianca = Crianca.find(session[:crianca_id])
    w=@crianca.nome
    @crianca.status = 'MATRICULADA'
    @crianca.vaga_id = @vaga.id
    @crianca.save
    
    if @vaga.update_attributes(params[:vaga])
        redirect_to(show_salvar_path)
    end

end


def show_salvar

    @vaga = Vaga.find(session[:vaga_id])

    respond_to do |format|
      format.html#  show_salvar.html.erb
      format.xml  { render :xml => @vaga }
    end

end




def atendimento_vaga
    grupo_id = params[:vaga_id]
    @crianca = Crinca.find(:all, :conditions =>['status  ="NA_DEMANDA", and grupo_id=?',params[:vaga_id]], :order => 'nome')

end
end



