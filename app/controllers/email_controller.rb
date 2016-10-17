require 'resolv'
#require 'nokogiri'
require 'net/smtp'
class EmailController < ApplicationController

soap_service namespace: "check_email"

# Declaration of Soap Action
soap_action "verifica_email", :args => {:emails => :string}, :return => :json

# Defining Function of soap action
def lookup(host, type)
Resolv::DNS.new.getresources(host, type)
end

def verifica_email
  respuesta = Array.new
  respuesta1 = Array.new
  valor = params[:emails]

#  respuesta = ""
  if !valor.nil?
    if valor != ""
  correos = valor.split(",")
  email_c = ""
  band = true
  correos.each do |email|
    if email!=""
    #puts "Este email"+email.to_s
    mx_records = lookup(email.split("@").last, Resolv::DNS::Resource::IN::MX)
    #mxs = mx_records.map { |r| [r.exchange.to_s, r.preference] }
    mxs = mx_records.map { |r| r.exchange.to_s }

     if !mxs.empty?
      con_ok = 0
      mxs.each do |mx|
        begin
          t1 = Time.now
          vv = Net::SMTP.start(mx.to_s, 25)
          response = vv.finish
          t2 = Time.now
          delta = (t2 - t1)/60 # in seconds
          if delta<0.1
            con_ok+=1
          end
       rescue Net::SMTPFatalError, Net::SMTPServerBusy
         #puts "Address probably doesn't exist."
       rescue Errno::ECONNREFUSED => ex
       #  puts "Failed to connect "
       rescue Net::OpenTimeout => es
       #  puts "tiempo de conexion agotado"
       rescue Exception => e  #catch todos los errores
      end
       ## FIN NET
       if con_ok > 0
         break
       end
      end
      if con_ok>0
        respuesta.push(email: email.to_s,estado: 1)
      else
        respuesta.push(email: email.to_s,estado: 0)
      end
    #  respuesta.push(email: email.to_s,estado: 1)

     else
      respuesta.push(email: email.to_s,estado: 0)
    end #end second if
  end #end email vacio
  end  ##fin correos

  end ## end ! vacio

  end ## end dif nil
  #respuesta1.push(resultado: respuesta)
  render :soap => respuesta.to_json
end

end
