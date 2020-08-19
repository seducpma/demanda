# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
    
    
  def set_current_user
    User.current = current_user

# Inicio - Alex 2018-09-12
   if RAILS_ENV=='production'
       session[:base]= 'sisgered_production'
       session[:baseinfo]= 'infoseduc_production'
   end
   if RAILS_ENV=='development'
       session[:base]= 'sisgered_development'
       session[:baseinfo]= 'infoseduc_development'
   end

end






  private

#  def current_classe
#    if current_user.unidade_id == 53
#      @classes = Aluno.all(:select => "id_classe, classe_descricao, classe_ano, id_escola",:conditions => ["classe_ano = ?", Date.today.strftime("%Y").to_i], :group => ["id_classe,classe_descricao, classe_ano,id_escola"] , :order => "classe_descricao")
#    else
#      @classes = Aluno.all(:select => "id_classe, classe_descricao, classe_ano, id_escola",:conditions => ["classe_ano = ? and id_escola = ?", Date.today.strftime("%Y").to_i, current_user.unidade.unidades_gpd_id], :group => ["id_classe,classe_descricao, classe_ano,id_escola"] , :order => "classe_descricao")
#    end

#  end

  def current_cart
    @current_cart ||= Cart.first(:conditions => ["user_id = ?", current_user]) || Cart.create(:user_id => current_user.id)
  end

end
CARGO = {'Diretor Ed. Básica'=> 'Diretor Ed. Básica',
          'Prof. Coordenador'=>'Prof. Coordenador',
          'Pedagogo'=> 'Pedagogo',
          'ADI'=>'ADI',
          'Prof. de Creche'=>'Prof. de Creche',
          'PEB1 - Ed. Infantil'=> 'PEB1 - Ed. Infantil',
          'PEB1 - Ensino Fundamental'=> 'PEB1 - Ensino Fundamental',
          'PEB2 - Artes'=> 'PEB2 - Artes',
          'PEB2 - Ed. Física'=> 'PEB2 - Ed. Física',
          'PEB2 - História'=> 'PEB2 - História',
          'PEB2 - Geografia'=> 'PEB2 - Geografia',
          'PEB2 - Matemática'=> 'PEB2 - Matemática',
          'PEB2 - Português'=> 'PEB2 - Português',
          'PEB2 - Inglês'=> 'PEB2 - Inglês',
          'PEB2 - Ciências'=> 'PEB2 - Ciências',
          'PEB - Ed. Especial'=> 'PEB - Ed. Especial',
          'TODOS' => 'TODOS'
          }

CLASSE = {'

BERCARIO I
BERCARIO II
BERCARIO III
MATERNAL I - A
MATERNAL II
NIVEL I
NIVEL II
MATERNAL I - B

Diretor Ed. Básica'=> 'Diretor Ed. Básica',
          'Prof. Coordenador'=>'Prof. Coordenador',
          'Pedagogo'=> 'Pedagogo'}

GRAU = { 'Pai/Mãe'=> 'Pai/Mãe',
         'Padastro/Madastra'=> 'Padastro/Madastra',
         'Irmão(ã)' => 'Irmão(ã)',
         'Avô/Avó' => 'Avô/Avó',
         'Tio/Tia'=> 'Tio/Tia',
         'Enteado(a)'=> 'Enteado(a)',
         'Primo(a)'=> 'Primo(a)',
         'Outros' => 'Outros'
        }

GRAU1 = {'Padastro/Madastra'=> 'Padastro/Madastra',
         'Irmão(ã)' => 'Irmão(ã)',
         'Avô/Avó' => 'Avô/Avó',
         'Tio/Tia'=> 'Tio/Tia',

         'Primo(a)'=> 'Primo(a)',
         'Outros' => 'Outros'
        }

REFERENCIA = { 'Residência'=> 'Residencia',
               'Avô/Avó' => 'Avô/Avó',
               'Trabalho'=> 'Trabalho',
               'Outros'=> 'Outros',
               'Familiar'=> 'Familiar',
               'Cuidador'=> 'Cuidador',
        }

PERIODO = { '         ' => '         ',
            'INTEGRAL'=> 'INTEGRAL',
            'INTEGRAL / MANHÃ / TARDE' => 'INTEGRAL / MANHÃ / TARDE',
            'INTEGRAL / MANHÃ' => 'INTEGRAL / MANHÃ',
            'INTEGRAL / TARDE' => 'INTEGRAL / TARDE',
            'MANHÃ / TARDE'=> 'MANHÃ / TARDE',
            'MANHÃ'=> 'MANHÃ)',
            'TARDE'=> 'TARDE',
        }
PERIODO1 = { '         ' => '         ',
            'MATUTINO' => 'MATUTINO',
            'VESPERTINO' => 'VESPERTINO',
        }
PERIODO2 = { '         ' => '         ',
            'MANHÃ' => 'MANHÃ',
            'TARDE' => 'TARDE',
        }


OPCAO ={ 'SIM '=>'SIM',
         'NÃO'=> 'NÃO'
        }

OPCAOSN ={ 'SIM '=> 1,
            'NÃO'=> 0
         }


# Variáveis de data para classificação das crianças

# 2º Bimestre
#DATAB1 ='2018-04-01'
#DATAB2 ='2017-04-01'
#DATAM1A='2016-10-01'
#DATAM1B='2016-04-01'
#DATAM2 ='2015-04-01'
#DATAN1 ='2014-04-01'
#DATAN2 ='2013-04-01'

#1ª Bimestre
DATAB1 ='2020-01-01'
DATAB2 ='2019-04-01'
DATAM1A='2018-10-01'
DATAM1B='2018-04-01'
DATAM2 ='2017-04-01'
DATAN1 ='2016-04-01'
DATAN2 ='2015-04-01'


BAIRRO = {
'CENTRO' => 'CENTRO',
'ANTONIO ZANAGA' => 'ANTONIO ZANAGA',
'BELA VISTA' => 'BELA VISTA',
'BELVEDERE'=>'BELVEDERE',
'BOA VISTA'=>'BOA VISTA',
'CAMPO VERDE' => 'CAMPO VERDE',
'CARIOBINHA' => 'CARIOBINHA',
'CATARINA ZANAGA' => 'CATARINA ZANAGA',
'CECHIO' => 'CECHIO',
'CIDADE JARDIM' => 'CIDADE JARDIM',
'CORDENONSI'=>'CORDENONSI',
'JAGUARI'=>'JAGUARI',
'JD ALVORADA' =>'JD ALVORADA',
'JD DAS FLORES' => 'JD DAS FLORES',
'JD DAS PAINEIRAS' =>'JD DAS PAINEIRAS',
'JD DOS LIRIOS' =>'JD DOS LIRIOS',
'JD JACYRA' =>'JD JACYRA',
'JD PAULISTA' =>'JD PAULISTA',
'JD PRIMAVERA' =>'JD PRIMAVERA',
'JD BELA VISTA' =>'JD BELA VISTA',
'JD BERTONI' =>'JD BERTONI',
'JD BOER' => 'JD BOER',
'JD BRASIL' => 'JD BRASIL',
'JD BRASILIA'=>'JD BRASILIA',
'JD DA MATA'=>'JD DA MATA',
'JD DA PAZ'=>'JD DA PAZ',
'JD ESPERANÇA'=>'JD ESPERANÇA',
'JD GIRASSOL'=>'JD GIRASSOL',
'JD GLORIA'=>'JD GLORIA',
'JD GUANABARA'=>'JD GUANABARA',
'JD IPIRANGA'=>'JD IPIRANGA',
'JD N.SRA.APARECIDA'=>'JD N.SRA.APARECIDA',
'JD N.SRA DO CARMO'=>'JD N.SRA DO CARMO',
'JD NILESEN'=>'JD NILESEN',
'JD PAULISTANO'=>'JD PAULISTANO',
'JD SANTA ELIZA'=>'JD SANTA ELIZA',
'JD. SANTANA'=>'JD. SANTANA',
'JD SÃO PAULO'=>'JD SÃO PAULO',
'MARIO COVAS'=>'MARIO COVAS',
'MORADA DO SOL'=> 'MORADA DO SOL',
'NOVA CARIOBA'=>'NOVA CARIOBA',
'PQ NOVO MUNDO'=>'PQ NOVO MUNDO',
'PQ DA LIBERDADE'=>'PQ DA LIBERDADE',
'PQ DAS NAÇÕES'=>'PQ DAS NAÇÕES',
'PQ GRAMADO'=>'PQ GRAMADO',
'PRAIA AZUL' => 'PRAIA AZUL',
'PRAIA DOS NAMORADOS'=>'PRAIA DOS NAMORADOS',
'PROFILUB'=>'PROFILUB',
'SANTA ROSA'=>'SANTA ROSA',
'SANTA SOFIA'=>'SANTA SOFIA',
'SÃO DOMINGOS'=>'SÃO DOMINGOS',
'SÃO JERONIMO'=>'SÃO JERONIMO',
'SÃO JOSE'=>'SÃO JOSE',
'SÃO LUIZ'=>'SÃO LUIZ',
'SÃO MANOEL'=>'SÃO MANOEL',
'SÃO ROQUE'=>'SÃO ROQUE',
'SÃO VITO'=>'SÃO VITO',
'VALE DAS NOGUEIRAS'=>'VALE DAS NOGUEIRAS',
'VALE DAS PAINEIRAS'=>'VALE DAS PAINEIRAS',
'VILA AMORIN'=>'VILA AMORIN',
'VILA BELA'=>'VILA BELA',
'VILA DAINESE'=>'VILA DAINESE',
'VILA GALO'=>'VILA GALO',
'VILA JONES'=>'VILA JONES',
'VILA MARINA'=>'VILA MARINA',
'VILA MAHIESEN'=>'VILA MAHIESEN',
'VILA MEDON'=>'VILA MEDON',
'VILA RIO BRANCO'=>'VILA RIO BRANCO',
'VILA SANTA MARIA'=>'VILA SANTA MARIA',
'VILA SANTA CATARINA'=>'VILA SANTA CATARINA'

}

