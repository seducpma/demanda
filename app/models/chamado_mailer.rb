class ChamadoMailer < ActionMailer::Base
#  def forgot_password(user)
#		setup_email(user)
#		@subject    += '. Você solicitou a mudança da sua senha'
#    if RAILS_ENV == "production"
#      @body[:url]  = "http://demanda.seducpma.com/reset_password/#{user.password_reset_code}"
#    else
#      @body[:url]  = "http://localhost:3000/reset_password/#{user.password_reset_code}"
#    end

#	end

#  protected
#    def setup_email(user)
#      @recipients  = "#{user.email}"
#      @from        = "no-reply@informatica@seducpam.com"
#      @subject     = "Esqueceu sua senha "
#      @sent_on     = Time.now
#      @body[:user] = user
#    end



def notificar_chamado(chamado)
  recipients chamado.user.email
  subject "Você solicitou a mudança da sua senha"
  from  "administrador@seducpma.com"

  body :chamado => chamado
end


def enviar_email(chamado,email)
  recipients email
  subject "Secretaria de Educação  - Solicitiação de alteração de senha - DEMANDA  "
  from  "no-replay@seducpma.com"
      @sent_on     = Time.now
      @body[:user] = user

#  body :email => email, :chamado => chamado
end

end