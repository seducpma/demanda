class Crianca < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :regiao
  belongs_to :unidade
  has_many :observacao_criancas

  validates_presence_of :unidade_id
  validates_presence_of :regiao_id
  validates_presence_of :nome
  validates_presence_of :nascimento
  validates_presence_of :opcao1
  before_save  :maiusculo
  before_update  :reclassificacao
  
  Status = %w(NA_DEMANDA CANCELADA MATRICULADA)


  def reclassificacao
    data=   (self.nascimento).to_s
    hoje = Date.today.to_s
    final = '2012-07-01'
    if (hoje > data)  and (data >= final)
      if  (data <= Date.today.to_s and data >= '2015-02-01')
           self.grupo_id = 1
      else if(data <= '2015-01-31' and data >= '2014-07-01')
           self.grupo_id = 2
           else if(data <= '2014-06-30' and data >= '2014-01-01')
                  self.grupo_id = 4
                else if (data <= '2013-12-31' and data >= '2013-07-01')
                        self.grupo_id = 8
                      else if (data <= '2013-06-30' and data >= '2012-07-01')
                              self.grupo_id = 5
                            else if (data <= '2012-06-30' and data >= '2011-07-01')
                                  self.grupo_id = 6
                                      else if(data <= '2011-06-30'and data >= '2010-07-01')
                                            self.grupo_id = 7
                                          end
                                  end
                            end
                      end
                end
           end
       end
 end
  
  end

def self.na_demanda
    Crianca.find(:all, :conditions => {:status => 'NA_DEMANDA' })
  end

 def self.matriculada
    Crianca.find(:all, :conditions => {:status => 'MATRICULADA' })
  end


 def self.cancelada
    Crianca.find(:all, :conditions => {:status => 'CANCELADA' })
  end


  def self.total_demanda
    Crianca.find(:all)
  end

 def opcao
    data=self.nascimento

  if  (self.nascimento <= '2015-12-31'.to_date and self.nascimento >= '2015-02-01'.to_date)
       self.grupo_id = 1
  else if(self.nascimento <= '2015-01-31'.to_date and self.nascimento >= '2014-07-01'.to_date)
          self.grupo_id = 2
       else if(self.nascimento <= '2014-06-30'.to_date and self.nascimento >= '2013-07-01'.to_date)
              self.grupo_id = 4
            else if(self.nascimento <= '2013-06-30'.to_date and self.nascimento >= '2012-07-01'.to_date)
                    self.grupo_id = 5
                  else if(self.nascimento <= '2012-06-30'.to_date and self.nascimento >= '2011-07-01'.to_date)
                          self.grupo_id = 6
                        else if(self.nascimento <= '2011-06-30'.to_date and self.nascimento >= '2010-07-01'.to_date)
                               self.grupo_id = 7
                             end
                       end
                 end
            end
       end
  end

 
 end

 def self.alteracao_classe
  @criancas_alteracao = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'"])
 for crianca in @criancas_alteracao
  if  (crianca.nascimento <= '2015-10-31'.to_date and crianca.nascimento >= '2015-02-01'.to_date)
      crianca.grupo_id  = 11
     else if(crianca.nascimento <= '2015-01-31'.to_date and crianca.nascimento >= '2014-07-01'.to_date)
           crianca.grupo_id = 22
         else if(crianca.nascimento <= '2014-06-30'.to_date and crianca.nascimento >= '2013-07-01'.to_date)
               crianca.grupo_id = 44
             else if(crianca.nascimento <= '2013-06-30'.to_date and crianca.nascimento >= '2012-07-01'.to_date)
                    crianca.grupo_id = 54
                  else if(crianca.nascimento <= '2012-06-30'.to_date and crianca.nascimento >= '2011-07-01'.to_date)
                          crianca.grupo_id = 66
                        else if(crianca.nascimento <= '2011-06-30'.to_date and crianca.nascimento >= '2010-07-01'.to_date)
                               crianca.grupo_id = 77
                             end
                       end
                 end
             end
         end
      end
     crianca.save

   end
   end


   def self.nome_unidade(unidade)
    Unidade.find(unidade).nome
  end

  def self.todas_crianca_por_unidade(unidade)
     nome_unidade = Unidade.find(unidade).nome
    Crianca.find(:all, :conditions => ['opcao1 = ?', nome_unidade])
  end

  def self.matriculas_crianca_por_unidade(unidade)
    nome_unidade = Unidade.find(unidade).nome
    Crianca.find(:all, :conditions => ['opcao1 = ? and status = "MATRICULADA"',nome_unidade])
  end

  def self.nao_matriculas_crianca_por_unidade(unidade)
     nome_unidade = Unidade.find(unidade).nome
    Crianca.find(:all, :conditions => ['opcao1 = ? and status = "NA_DEMANDA"',nome_unidade])
  end

  def self.cancelada_crianca_por_unidade(unidade)
     nome_unidade = Unidade.find(unidade).nome
    Crianca.find(:all, :conditions => ['opcao1 = ? and status = "CANCELADA"',nome_unidade])
  end




  def self.demanda_total
    Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'"])

  end


   def self.matricula_total
    Crianca.find(:all, :conditions => ["status = 'MATRICULADA'"])
  end
  def maiusculo
    self.nome.upcase!
    self.bairro.upcase!
    self.complemento.upcase!
    self.mae.upcase!
    self.necessidade.upcase!
    self.pai.upcase!
    self.endereco.upcase!
    self.responsavel_n.upcase!
    self.parentesco.upcase!
    self.local_trabalho.upcase!
    self.servidor_local.upcase!
    self.nomerecado.upcase!
    self.status.upcase!
  end

 
end
