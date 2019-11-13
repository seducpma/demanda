class GraficoController < ApplicationController
  before_filter :load_unidades
  def index

  end


  def grafico_demanda_regiao
     @regiaos1= Regiao.find(:all, :conditions=>['regiaos.id > 99 AND regiaos.id < 108 ' ], :order => 'regiaos.nome')
     @regiaos2= Regiao.find(:all, :conditions=>['regiaos.id > 107 AND regiaos.id < 115 ' ], :order => 'regiaos.nome')
     @regiaos3= Regiao.find(:all, :conditions=>['regiaos.id > 114 AND regiaos.id < 201 AND id != 120' ], :order => 'regiaos.nome')
     @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome')
     @regiaos11= Regiao.find(:all,  :conditions=>['regiaos.id > 99 AND regiaos.id < 201 AND id !=120' ], :order => 'regiaos.nome')



    @graph = open_flash_chart_object(600,300,"/grafico/graph_code_demanda_geral")

        @static_graph = Gchart.pie(
          :data => [ (Crianca.regiao_centro).length, (Crianca.regiao_jaguari).length, (Crianca.regiao_jbrasil).length, (Crianca.regiao_praia).length,
                     (Crianca.regiao_smanoel).length, (Crianca.regiao_svito).length, (Crianca.regiao_zanaga).length, (Crianca.regiao_jpaz).length,
                     (Crianca.regiao_pgramado).length, (Crianca.regiao_pnacoes).length, (Crianca.regiao_sdomingos).length, (Crianca.regiao_sgeronimo).length,
                     (Crianca.regiao_sluiz).length, (Crianca.regiao_sroque).length, (Crianca.regiao_cjardim).length, (Crianca.regiao_frezarin).length,
                     (Crianca.regiao_jalvorada).length, (Crianca.regiao_spaulo).length, (Crianca.regiao_jipiranga).length],
          :title => "DEMANDA POR REGIÃO - Crianças Cadastradas: #{Crianca.na_demandaR.length}",
          :size => '800x350',
          :format => 'image_tag',
          :labels => ["Centro: #{(Crianca.regiao_centro).length} - #{ (((Crianca.regiao_centro).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Jaguari: #{(Crianca.regiao_jaguari).length} - #{ (((Crianca.regiao_jaguari).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Jd.Brasil: #{(Crianca.regiao_jbrasil).length} - #{ (((Crianca.regiao_jbrasil).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Praia Azul: #{(Crianca.regiao_praia).length} - #{ (((Crianca.regiao_praia).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Manoel: #{(Crianca.regiao_smanoel).length} - #{ (((Crianca.regiao_smanoel).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Vito: #{(Crianca.regiao_svito).length} - #{ (((Crianca.regiao_svito).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Zanaga: #{(Crianca.regiao_zanaga).length} - #{ (((Crianca.regiao_zanaga).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Jd.Paz: #{(Crianca.regiao_jpaz).length} - #{ (((Crianca.regiao_jpaz).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Pq.Gramado: #{(Crianca.regiao_pgramado).length} - #{ (((Crianca.regiao_pgramado).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Pq.Nações: #{(Crianca.regiao_pnacoes).length} - #{ (((Crianca.regiao_pnacoes).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Domingos: #{(Crianca.regiao_sdomingos).length} - #{ (((Crianca.regiao_sdomingos).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Jerônimo: #{(Crianca.regiao_sgeronimo).length} - #{ (((Crianca.regiao_sgeronimo).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Luiz: #{(Crianca.regiao_sluiz).length} - #{ (((Crianca.regiao_sluiz).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Roque: #{ (Crianca.regiao_sroque).length} - #{ (((Crianca.regiao_sroque).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Cd. Jardim: #{(Crianca.regiao_cjardim).length} - #{ (((Crianca.regiao_cjardim).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Frezarin: #{(Crianca.regiao_frezarin).length} - #{ (((Crianca.regiao_frezarin).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Jd.Alvorada: #{(Crianca.regiao_jalvorada).length} - #{ (((Crianca.regiao_jalvorada).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "São Sâo Paulo: #{ (Crianca.regiao_spaulo).length} - #{ (((Crianca.regiao_spaulo).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",
                      "Jd.Ipiranga: #{(Crianca.regiao_jipiranga).length} - #{ (((Crianca.regiao_jipiranga).length).to_f / (Crianca.na_demandaR.length).to_f * 100).round(2)} % ",])
  end



  def grafico_prioridade_geral
    @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome')
     total=Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome').count
     session[:svp]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND servidor_publico= 1"]).count
     session[:ctps]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND trabalho= 1"]).count
     session[:s_ctps]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND declaracao= 1"]).count
     session[:auto]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND autonomo= 1"]).count
     session[:trans]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND transferencia= 1"]).count
     session[:ntrab]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND (transferencia= 0 AND autonomo= 0 AND declaracao= 0 AND trabalho= 0 AND servidor_publico= 0)"]).count


       @graph = open_flash_chart_object(600,300,"/grafico/graph_code_demanda_geral")

        @static_graph = Gchart.pie(
          :data => [session[:svp] ,   session[:ctps],  session[:s_ctps], session[:auto],   session[:trans], session[:ntrab]],
          :title => "DEMANDA POR PRIORIDADE - Crianças Cadastradas: #{total}",
          :size => '800x350',
          :format => 'image_tag',
          :labels => ["Servidor Municipal #{session[:svp]} - #{ (session[:svp].to_f / total.to_f * 100).round(2)} % ",
                      "COM CTPS: #{session[:ctps]} - #{ (session[:ctps].to_f / total.to_f * 100).round(2)} % ",
                      "SEM CTPS : #{session[:s_ctps]} - #{ (session[:s_ctps].to_f / total.to_f * 100).round(2)} % ",
                      "Autonomo: #{session[:auto]} - #{ (session[:auto].to_f / total.to_f * 100).round(2)} % ",
                      "Transferência: #{session[:trans]} - #{ (session[:trans].to_f / total.to_f * 100).round(2)} % ",
                      "NÃO Trabalha: #{session[:ntrab]} - #{ (session[:ntrab].to_f / total.to_f * 100).round(2)} % ",])

 end

def  grafico_prioridade_regiao
end
    def  grafico_prioridade_search_regiao
        t=0
        session[:input] = params[:contact][:grafico_id]
        regiao = session[:input]= params[:contact][:grafico_id]

        session[:svp]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND servidor_publico= 1 AND regiao_id=?", regiao]).size
        session[:ctps]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND trabalho= 1 AND regiao_id=?", regiao]).size
        session[:s_ctps]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND declaracao= 1  AND regiao_id=?", regiao]).size
        session[:auto]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND autonomo= 1 AND regiao_id=?", regiao]).size
        session[:trans]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND transferencia= 1 AND regiao_id=?", regiao]).size
        session[:ntrab]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND (transferencia= 0 AND autonomo= 0 AND declaracao= 0 AND trabalho= 0 AND servidor_publico= 0) AND regiao_id=?", regiao]).size
       total = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'  and vaga_id is null AND recadastrada!=0   AND regiao_id=?", regiao]).size
    @graph = open_flash_chart_object(700,350,"/grafico/graph_por_unidade?unidade=#{session[:input]}",false,'/')
     @static_graph = Gchart.pie(
         :data =>[session[:svp], session[:ctps], session[:s_ctps], session[:auto], session[:trans], session[:ntrab]],
          :title => "DEMANDA POR PRIORIDADE POR REGIÃOO - Crianças Cadastradas: #{total}",
          :size => '800x350',
          :format => 'image_tag',
          :labels => ["Servidor Municipal #{session[:svp]} - #{ (session[:svp].to_f / total.to_f * 100).round(2)} % ",
                      "COM CTPS: #{session[:ctps]} - #{ (session[:ctps].to_f / total.to_f * 100).round(2)} % ",
                      "SEM CTPS : #{session[:s_ctps]} - #{ (session[:s_ctps].to_f / total.to_f * 100).round(2)} % ",
                      "Autonomo: #{session[:auto]} - #{ (session[:auto].to_f / total.to_f * 100).round(2)} % ",
                      "Transferência: #{session[:trans]} - #{ (session[:trans].to_f / total.to_f * 100).round(2)} % ",
                      "NÃO Trabalha: #{session[:ntrab]} - #{ (session[:ntrab].to_f / total.to_f * 100).round(2)} % ",])

      render :action => "grafico_prioridade_regiao"
  end
    def  grafico_prioridade_unidade
t=0
    end

    def  grafico_prioridade_search_unidade
        t=0
        session[:input] = params[:contact][:grafico_id]
        nome_unidade = Unidade.find(session[:input]).nome
        session[:svp]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND servidor_publico= 1 AND unidade_ref=?", nome_unidade]).size
        session[:ctps]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND trabalho= 1 AND unidade_ref=?", nome_unidade]).size
        session[:s_ctps]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND declaracao= 1  AND unidade_ref=?", nome_unidade]).size
        session[:auto]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND autonomo= 1 AND unidade_ref=?", nome_unidade]).size
        session[:trans]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND transferencia= 1 AND unidade_ref=?", nome_unidade]).size
        session[:ntrab]=Crianca.find(:all,:select=> 'id', :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0 AND (transferencia= 0 AND autonomo= 0 AND declaracao= 0 AND trabalho= 0 AND servidor_publico= 0) AND unidade_ref=?", nome_unidade]).size
        total = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'  and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size

       @graph = open_flash_chart_object(700,350,"/grafico/graph_por_unidade?unidade=#{session[:input]}",false,'/')
       @static_graph = Gchart.pie(
            :data =>[session[:svp], session[:ctps], session[:s_ctps], session[:auto], session[:trans], session[:ntrab]],
             :title => "Demanda por Unidade - #{nome_unidade}:  #{total} " ,
            :size => '800x350',
            :format => 'image_tag',
          :labels => ["Servidor Municipal #{session[:svp]} - #{ (session[:svp].to_f / total.to_f * 100).round(2)} % ",
                      "COM CTPS: #{session[:ctps]} - #{ (session[:ctps].to_f / total.to_f * 100).round(2)} % ",
                      "SEM CTPS : #{session[:s_ctps]} - #{ (session[:s_ctps].to_f / total.to_f * 100).round(2)} % ",
                      "Autonomo: #{session[:auto]} - #{ (session[:auto].to_f / total.to_f * 100).round(2)} % ",
                      "Transferência: #{session[:trans]} - #{ (session[:trans].to_f / total.to_f * 100).round(2)} % ",
                      "NÃO Trabalha: #{session[:ntrab]} - #{ (session[:ntrab].to_f / total.to_f * 100).round(2)} % ",])



      render :action => "grafico_prioridade_unidade"
  end


  def grafico_demanda_geral

     @regiaos1= Regiao.find(:all, :conditions=>['regiaos.id > 99 AND regiaos.id < 108 ' ], :order => 'regiaos.nome')
     @regiaos2= Regiao.find(:all, :conditions=>['regiaos.id > 107 AND regiaos.id < 115 ' ], :order => 'regiaos.nome')
     @regiaos3= Regiao.find(:all, :conditions=>['regiaos.id > 114 AND regiaos.id < 201 AND id != 120' ], :order => 'regiaos.nome')
     @criancas = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' AND recadastrada!=0" ], :order => 'nome')
     @regiaos11= Regiao.find(:all,  :conditions=>['regiaos.id > 99 AND regiaos.id < 201 AND id !=120' ], :order => 'regiaos.nome')

    @graph = open_flash_chart_object(600,300,"/grafico/graph_code_demanda_geral")

          @static_graph = Gchart.pie(
            #:data => [(Crianca.matriculadaR).length,(Crianca.na_demandaR).length, (Crianca.canceladaR).length],
            :data => [(Crianca.b1).length,(Crianca.b2).length, (Crianca.m1a).length, (Crianca.m1b).length, (Crianca.m2).length , (Crianca.n1).length, (Crianca.n2).length],
            :title => "Demanda Geral - Crianças Cadastradas: #{Crianca.na_demandaR.length}",
            :size => '700x350',
            :format => 'image_tag',
            :labels => ["BerçarioI: #{(Crianca.b1).length} -  #{(((Crianca.b1).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",
                        "BerçarioII: #{(Crianca.b2).length} -  #{(((Crianca.b2).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",
                        "MaternalIA: #{(Crianca.m1a).length} -  #{(((Crianca.m1a).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",
                        "MaternalIB: #{(Crianca.m1b).length} -  #{(((Crianca.m1b).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",
                        "MaternalII: #{(Crianca.m2).length} -  #{(((Crianca.m2).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",
                        "NIVELI: #{(Crianca.n1).length} -  #{(((Crianca.n1).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",
                        "NIVELII: #{(Crianca.n2).length} -  #{(((Crianca.n2).length.to_f / Crianca.na_demandaR.length.to_f)*100).round(2)} %",])

  end







  def impressao_geral

    if  session[:geral] == 0
      @graph = open_flash_chart_object(600,300,"/grafico/graph_code_demanda_geral")

          @static_graph = Gchart.pie_3d(
            :data => [(Crianca.matriculada).length,(Crianca.na_demanda).length, (Crianca.cancelada).length],
            :title => "Demanda Geral - Crianças Cadastradas: #{Crianca.total_demanda.length}",
            :size => '700x350',
            :format => 'image_tag',
            :labels => ["Matriculadas: #{(Crianca.matriculada).length}", "Demanda: #{(Crianca.na_demanda).length}" , "Canceladas: #{(Crianca.cancelada).length}",])
    else

      @static_graph = Gchart.pie_3d(
            :data => [(Crianca.matriculas_crianca_por_unidade(session[:input])).length,(Crianca.nao_matriculas_crianca_por_unidade(session[:input])).length, (Crianca.cancelada_crianca_por_unidade(session[:input])).length],
            :title => "Demanda por Unidade: #{Crianca.nome_unidade(session[:input])} - #{(Crianca.todas_crianca_por_unidade(session[:input])).length}" ,
            :size => '700x350',
            :format => 'image_tag',
            :labels => ["Matriculadas: #{(Crianca.matriculas_crianca_por_unidade(session[:input])).length}", "Demanda: #{(Crianca.nao_matriculas_crianca_por_unidade(session[:input])).length}", "Canceladas: #{(Crianca.cancelada_crianca_por_unidade(session[:input])).length}"])

    end
      render :layout => "impressao"

end


  def grafico_demanda_unidade


  end

  def search_unidade
    $uni=0
    $menu=1
    session[:input] = params[:contact][:grafico_id]
    nome_unidade = Unidade.find(session[:input]).nome
    session[:b1]=b1 = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 1 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    session[:b2]=b2 =Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 2 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    session[:m1a]=m1a= Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 4 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    session[:m1b]=m1b=Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 8 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    session[:m2]= m2= Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 5 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    session[:n1]=n1=Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 6 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    session[:n2]=n2=Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA' and grupo_id = 7 and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    total = Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'  and vaga_id is null AND recadastrada!=0  AND unidade_ref=?", nome_unidade]).size
    @graph = open_flash_chart_object(700,350,"/grafico/graph_por_unidade?unidade=#{session[:input]}",false,'/')
     @static_graph = Gchart.pie(
          #  :data => [(Crianca.por_unidade_b1(session[:input])).size, (Crianca.por_unidade_b2(session[:input])).size, (Crianca.por_unidade_m1a(session[:input])).size (Crianca.por_unidade_m1b(session[:input])).size(Crianca.por_unidade_m2(session[:input])).size(Crianca.por_unidade_n1(session[:input])).size, (Crianca.por_unidade_n2(session[:input])).size ],
            :data => [b1, b2, m1a , m1b, m1b, m2, n1, n2],
            #:title => "Demanda xxxx  Unidade: #{Crianca.nome_unidade_total(session[:input]).size} " ,
            #:title => "Demanda Unidade:  #{Crianca.nome_unidade_total(session[:input]).size} " ,
             :title => "Demanda por Unidade - #{nome_unidade}:  #{total} " ,
            :size => '800x350',
            :format => 'image_tag',
            :labels => ["Berçario I: #{b1} -  #{((b1.to_f / total.to_f)*100).round(2)} %",
                        "Berçario II: #{b2} -  #{((b2.to_f / total.to_f)*100).round(2)} %",
                         "Maternal I-A: #{m1a} -  #{((m1a.to_f / total.to_f)*100).round(2)} %",
                         "Maternal IB: #{m1b} -  #{((m1b.to_f / total.to_f)*100).round(2)} %",
                         "Maternal II: #{m2} -  #{((m2.to_f / total.to_f)*100).round(2)} %",
                         "Nível I: #{n1} -  #{((n1.to_f / total.to_f)*100).round(2)} %",
                         "Nível II: #{n2} -  #{((n2.to_f / total.to_f)*100).round(2)} %", ])

     
      render :action => "grafico_demanda_unidade"
  end


 def search_regiao
    $uni=0
    $menu=1
    session[:input] = params[:contact][:grafico_id]
    @graph = open_flash_chart_object(600,300,"/grafico/graph_por_regiao?regiao=#{session[:input]}",false,'/')

    @static_graph = Gchart.pie_3d(
        :data => [(Crianca.demanda_por_regiao(session[:input])).length,(Crianca.nao_matriculas_crianca_por_regiao(session[:input])).length, (Crianca.cancelada_crianca_por_regiao(session[:input])).length],
        :title => "Demanda por Regiao: #{Crianca.nome_regiao(session[:input])} - #{(Crianca.todas_crianca_por_regiao(session[:input])).length}" ,
        :size => '600x300',
        :format => 'image_tag',
        :labels => ["Matriculadas: #{(Crianca.demanda_por_regiao(session[:input])).length}", "Demanda: #{(Crianca.nao_matriculas_crianca_por_regiao(session[:input])).length}", "Canceladas: #{(Crianca.cancelada_crianca_por_regiao(session[:input])).length}"])

      render :action => "grafico_demanda_regiao"
  end

  def graph_code_demanda_geral
    title = Title.new("Demanda Geral - Crianças Cadastradas: #{Crianca.total_demanda.length}")
    pie = Pie.new
    pie.start_angle = 0
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
    pie.values  = [PieValue.new(Crianca.matriculada.length,"Crianças Matriculadas"),
                   PieValue.new(Crianca.matriculada.length,"Crianças Não Matriculadas"),
                   PieValue.new(Crianca.cacnelada.length,"Inscrição Cancelada")
                   ]
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)
    chart.x_axis = nil
    render :text => chart.to_s
  end
  
  #def graph_por_unidade
  #  unidade = params[:unidade]
  #  title = Title.new("Demanda por Unidade: #{Crianca.nome_unidade(unidade)} - Criancas Cadastradas: #{Crianca.todas_crianca_por_unidade(unidade).length}" )
  #  pie = Pie.new
  #  pie.start_angle = 0
  #  pie.animate = true
  #  pie.tooltip = '#val# of #total#<br>#percent# of 100%'
  #  pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
  #  matriculada = Crianca.matriculas_crianca_por_unidade(unidade)
  #  nao_matriculada = Crianca.nao_matriculas_crianca_por_unidade(unidade)
  #  pie.values  = [PieValue.new(matriculada.length,"Crianças Matriculadas na unidade: " + (matriculada.length).to_s), PieValue.new(nao_matriculada.length,"Crianças Não Matriculadas: " + (nao_matriculada.length).to_s)]
  #  chart = OpenFlashChart.new
  #  chart.title = title
  #  chart.add_element(pie)
  #  chart.x_axis = nil
  #  render :text => chart.to_s
  #end

  def graph_por_unidade
    unidade = params[:unidade]
    title = Title.new("Demanda por Unidade: #{Crianca.nome_unidade(unidade)} - Criancas Cadastradas: #{Crianca.todas_crianca_por_unidade(unidade).length}" )
    pie = Pie.new
    pie.start_angle = 0
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
    matriculada = Crianca.matriculas_crianca_por_unidade(unidade)
    nao_matriculada = Crianca.nao_matriculas_crianca_por_unidade(unidade)
    pie.values  = [PieValue.new(matriculada.length,"Crianças Matriculadas na unidade: " + (matriculada.length).to_s), PieValue.new(nao_matriculada.length,"Crianças Não Matriculadas: " + (nao_matriculada.length).to_s)]
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)
    chart.x_axis = nil
    render :text => chart.to_s
  end

  def pie_chart poll
    @pie_chart ||= {
      :data => poll.choices.collect(&:votes_count),
      :colors => poll.choices.collect {|c| c.winner? ? "264409" : "8A1F11" }
    }
  end


 def graph_por_regiao
#    unidade = params[:unidade]
    regiao = params[:regiao]
#    title = Title.new("Demanda por Unidade: #{Crianca.nome_unidade(unidade)} - Criancas Cadastradas: #{Crianca.todas_crianca_por_unidade(unidade).length}" )
    title = Title.new("Demanda por Regiao: #{Crianca.nome_regiao(regiao)} - Criancas Cadastradas: #{Crianca.todas_crianca_por_regiao(regiao).length}" )
    pie = Pie.new
    pie.start_angle = 0
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
#    matriculada = Crianca.matriculas_crianca_por_unidade(unidade)
    matriculada = Crianca.matriculas_crianca_por_regiao(regiao)
#    nao_matriculada = Crianca.nao_matriculas_crianca_por_unidade(unidade)
    nao_matriculada = Crianca.nao_matriculas_crianca_por_regiao(regiao)
    pie.values  = [PieValue.new(matriculada.length,"Crianças Matriculadas na regiao: " + (matriculada.length).to_s), PieValue.new(nao_matriculada.length,"Crianças Não Matriculadas: " + (nao_matriculada.length).to_s)]
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)
    chart.x_axis = nil
    render :text => chart.to_s
  end

  def pie_chart poll
    @pie_chart ||= {
      :data => poll.choices.collect(&:votes_count),
      :colors => poll.choices.collect {|c| c.winner? ? "264409" : "8A1F11" }
    }
  end


protected

  def load_unidades
    @unidades =  Unidade.find(:all,  :conditions => ["tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8" ],:order => "nome")
    @regiaos =  Regiao.find(:all,  :conditions => ["id > 99" ],:order => "nome")

   
    $uni=1
    $menu=0
  end
end
