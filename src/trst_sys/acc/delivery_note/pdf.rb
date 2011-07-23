# st: font_face consolas; font_size 9
# encoding: utf-8
# Template for AdeverintaPredarePrimire.pdf
require 'prawn/measurement_extensions'

firm        = TrstFirm.first
client      = TrstPartner.find(@object.client_id)
transporter = TrstPartner.find(@object.transporter_id)

pdf = Prawn::Document.new(
  :page_size => 'A4',
  :page_layout => :landscape,
  :margin => [0.mm],
  #:background => "public/images/pdf/ae_a3.jpg",
  :info => {
    :Title => "Formular de încărcare-descărcare deşeuri nepericuloase",
    :Author => "kfl62",
    :Subject => "Formular \"Încărcare-descărcare deşeuri nepericuloase\"",
    :Keywords => "#{firm.name[1].titleize} Formular de încărcare-descărcare deşeuri nepericuloase",
    :Creator => "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    :CreationDate => Time.now
  }
)

pdf.font_families.update(
  'Verdana' => {:bold => 'public/fonts/verdanab.ttf',
                :italic => 'public/fonts/verdanai.ttf',
                :bold_italic => 'public/fonts/verdanaz.ttf',
                :normal => 'public/fonts/verdana.ttf'})
pdf.font 'Verdana'

# Ex. 1
top = pdf.bounds.top - 10.mm
left = 10.mm
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Formular de încărcare-descărcare deşeuri nepericuloase", :style => :bold, :size => 10, :align => :center, :valign => :center
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.indent 10.mm do
    pdf.text "Serie şi număr: #{@object.name} din #{@object.id_date.to_s}", :style => :bold, :size => 8, :valign => :center
  end
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 110.mm, :height => 14) do
  pdf.text "Caracteristici deşeuri", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 80.mm, :height => 14) do
  pdf.text "Denumire", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 80.mm,top], :width => 30.mm, :height => 14) do
  pdf.text "Cod", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 110.mm,top + 14 ], :width => 20.mm, :height => 28) do
  pdf.move_down 6
  pdf.text "Cantitate", :style => :bold, :size => 8, :align => :center
  pdf.text "-to-", :style => :bold, :size => 8, :align => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 80.mm, :height => 56) do
  # Freight
  pdf.move_down 4
  pdf.indent 10.mm do
    @object.freights.each_with_index do |f,i|
      pdf.text "#{i + 1}.) Deşeuri #{f.freight.name.downcase}", :style => :bold, :size => 8
    end
  end
  pdf.stroke_bounds
end
pdf.bounding_box([left + 80.mm,top], :width => 30.mm, :height => 56) do
  # Cod
  pdf.move_down 4
  @object.freights.each_with_index do |f,i|
    pdf.text "-#{f.freight.descript[0]}-", :style => :bold, :size => 8, :align => :center
  end
  pdf.stroke_bounds
end
pdf.bounding_box([left + 110.mm,top], :width => 20.mm, :height => 56) do
  # Quantity
  pdf.move_down 4
  pdf.indent 0,3.mm do
    @object.freights.each_with_index do |f,i|
      pdf.text "%.3f" % (f.qu / 1000).round(3), :style => :bold, :size => 8, :align => :right
    end
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Destinat", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 28) do
  pdf.text "Colectării |_| Stocării temp. |_| Tratării |_| Valorificării |_| Eliminării |_|", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 28
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Documente însoţitoare", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 65.mm, :height => 14) do
  pdf.text "Încărcare", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 65.mm,top], :width => 65.mm, :height => 14) do
  pdf.text "Descărcare", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 65.mm, :height => 28) do
  # id_main_doc
  pdf.text "AE nr. #{@object.id_main_doc}/#{@object.id_date.to_s}", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 65.mm,top], :width => 65.mm, :height => 28) do
  pdf.stroke_bounds
  top -= 28
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Date identificare expeditor", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 56) do
  pdf.bounding_box([5.mm, 50], :width => 25.mm) do
    pdf.text "Firma:", :style => :bold, :size => 8
    pdf.text "CCI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "CUI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Punct de lucru:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Aut. mediu:", :style => :bold, :size => 8,:leading => 2
  end
  pdf.bounding_box([30.mm, 50], :width => 105.mm) do
    pdf.text firm.name[2], :style => :bold, :size => 8
    pdf.text firm.identities['chambcom'], :style => :bold, :size => 8,:leading => 2
    pdf.text firm.identities['fiscal'], :style => :bold, :size => 8,:leading => 2
    pdf.text @object.unit.name[1], :style => :bold, :size => 8,:leading => 2
    pdf.text @object.unit.env_auth, :style => :bold, :size => 8,:leading => 2
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 42) do
  pdf.bounding_box([0.mm,30], :width => 80.mm) do
    pdf.text "Gestionar\n#{ @object.unit.chief}", :style => :bold, :size => 8, :align => :center
  end
  pdf.bounding_box([80.mm,25], :width => 50.mm) do
    pdf.indent 0,3.mm do
      pdf.text "Semnătură/Ştampilă", :style => :bold, :size => 8, :align => :right
    end
  end
  pdf.stroke_bounds
  top -= 42
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Date identificare destinatar", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 56) do
  pdf.bounding_box([5.mm, 50], :width => 25.mm) do
    pdf.text "Firma:", :style => :bold, :size => 8
    pdf.text "CCI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "CUI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Punct de lucru:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Aut. mediu:", :style => :bold, :size => 8,:leading => 2
  end
  pdf.bounding_box([30.mm, 50], :width => 105.mm) do
    pdf.text client.name[2], :style => :bold, :size => 8
    pdf.text client.identities['chambcom'], :style => :bold, :size => 8,:leading => 2
    pdf.text client.identities['fiscal'], :style => :bold, :size => 8,:leading => 2
    pdf.text client.units.first.name[1], :style => :bold, :size => 8,:leading => 2
    pdf.text client.units.first.env_auth, :style => :bold, :size => 8,:leading => 2
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 42) do
  pdf.indent 0,3.mm do
    pdf.text "Semnătură/Ştampilă", :style => :bold, :size => 8, :align => :right, :valign => :center
  end
  pdf.stroke_bounds
  top -= 42
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.stroke_bounds
  pdf.text "Date identificare transportator", :style => :bold, :size => 8, :align => :center, :valign => :center
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 56) do
  pdf.bounding_box([5.mm, 50], :width => 25.mm) do
    pdf.text "Firma:", :style => :bold, :size => 8
    pdf.text "Delegat:", :style => :bold, :size => 8,:leading => 2
    pdf.text "CNP:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Auto Nr:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Licenţa de tran", :style => :bold, :size => 8,:leading => 2
  end
  pdf.bounding_box([30.mm, 50], :width => 105.mm) do
    pdf.text transporter.name[2], :style => :bold, :size => 8
    pdf.text @object.delegate_transp.name, :style => :bold, :size => 8,:leading => 2
    pdf.text @object.delegate_transp.id_pn, :style => :bold, :size => 8,:leading => 2
    pdf.text @object.id_platte.upcase, :style => :bold, :size => 8,:leading => 2
    pdf.text "sport expiră la date de:", :style => :bold, :size => 8,:leading => 2
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 42) do
  pdf.indent 0,3.mm do
    pdf.text "Semnătură/Ştampilă", :style => :bold, :size => 8, :align => :right, :valign => :center
  end
  pdf.stroke_bounds
end

# Ex. 2
top = pdf.bounds.top - 10.mm
left = 160.mm
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Formular de încărcare-descărcare deşeuri nepericuloase", :style => :bold, :size => 10, :align => :center, :valign => :center
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.indent 10.mm do
    pdf.text "Serie şi număr: #{@object.name} din #{@object.id_date.to_s}", :style => :bold, :size => 8, :valign => :center
  end
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 110.mm, :height => 14) do
  pdf.text "Caracteristici deşeuri", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 80.mm, :height => 14) do
  pdf.text "Denumire", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 80.mm,top], :width => 30.mm, :height => 14) do
  pdf.text "Cod", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 110.mm,top + 14 ], :width => 20.mm, :height => 28) do
  pdf.move_down 6
  pdf.text "Cantitate", :style => :bold, :size => 8, :align => :center
  pdf.text "-to-", :style => :bold, :size => 8, :align => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 80.mm, :height => 56) do
  # Freight
  pdf.move_down 4
  pdf.indent 10.mm do
    @object.freights.each_with_index do |f,i|
      pdf.text "#{i + 1}.) Deşeuri #{f.freight.name.downcase}", :style => :bold, :size => 8
    end
  end
  pdf.stroke_bounds
end
pdf.bounding_box([left + 80.mm,top], :width => 30.mm, :height => 56) do
  # Cod
  pdf.move_down 4
  @object.freights.each_with_index do |f,i|
    pdf.text "-#{f.freight.descript[0]}-", :style => :bold, :size => 8, :align => :center
  end
  pdf.stroke_bounds
end
pdf.bounding_box([left + 110.mm,top], :width => 20.mm, :height => 56) do
  # Quantity
  pdf.move_down 4
  pdf.indent 0,3.mm do
    @object.freights.each_with_index do |f,i|
      pdf.text "%.3f" % (f.qu / 1000).round(3), :style => :bold, :size => 8, :align => :right
    end
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Destinat", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 28) do
  pdf.text "Colectării |_| Stocării temp. |_| Tratării |_| Valorificării |_| Eliminării |_|", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 28
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Documente însoţitoare", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 65.mm, :height => 14) do
  pdf.text "Încărcare", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 65.mm,top], :width => 65.mm, :height => 14) do
  pdf.text "Descărcare", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 65.mm, :height => 28) do
  # id_main_doc
  pdf.text "AE nr. #{@object.id_main_doc}/#{@object.id_date.to_s}", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
end
pdf.bounding_box([left + 65.mm,top], :width => 65.mm, :height => 28) do
  pdf.stroke_bounds
  top -= 28
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Date identificare expeditor", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 56) do
  pdf.bounding_box([5.mm, 50], :width => 25.mm) do
    pdf.text "Firma:", :style => :bold, :size => 8
    pdf.text "CCI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "CUI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Punct de lucru:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Aut. mediu:", :style => :bold, :size => 8,:leading => 2
  end
  pdf.bounding_box([30.mm, 50], :width => 105.mm) do
    pdf.text firm.name[2], :style => :bold, :size => 8
    pdf.text firm.identities['chambcom'], :style => :bold, :size => 8,:leading => 2
    pdf.text firm.identities['fiscal'], :style => :bold, :size => 8,:leading => 2
    pdf.text @object.unit.name[1], :style => :bold, :size => 8,:leading => 2
    pdf.text @object.unit.env_auth, :style => :bold, :size => 8,:leading => 2
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 42) do
  pdf.bounding_box([0.mm,30], :width => 80.mm) do
    pdf.text "Gestionar\n#{ @object.unit.chief}", :style => :bold, :size => 8, :align => :center
  end
  pdf.bounding_box([80.mm,25], :width => 50.mm) do
    pdf.indent 0,3.mm do
      pdf.text "Semnătură/Ştampilă", :style => :bold, :size => 8, :align => :right
    end
  end
  pdf.stroke_bounds
  top -= 42
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Date identificare destinatar", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 56) do
  pdf.bounding_box([5.mm, 50], :width => 25.mm) do
    pdf.text "Firma:", :style => :bold, :size => 8
    pdf.text "CCI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "CUI:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Punct de lucru:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Aut. mediu:", :style => :bold, :size => 8,:leading => 2
  end
  pdf.bounding_box([30.mm, 50], :width => 105.mm) do
    pdf.text client.name[2], :style => :bold, :size => 8
    pdf.text client.identities['chambcom'], :style => :bold, :size => 8,:leading => 2
    pdf.text client.identities['fiscal'], :style => :bold, :size => 8,:leading => 2
    pdf.text client.units.first.name[1], :style => :bold, :size => 8,:leading => 2
    pdf.text client.units.first.env_auth, :style => :bold, :size => 8,:leading => 2
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 42) do
  pdf.indent 0,3.mm do
    pdf.text "Semnătură/Ştampilă", :style => :bold, :size => 8, :align => :right, :valign => :center
  end
  pdf.stroke_bounds
  top -= 42
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 14) do
  pdf.text "Date identificare transportator", :style => :bold, :size => 8, :align => :center, :valign => :center
  pdf.stroke_bounds
  top -= 14
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 56) do
  pdf.bounding_box([5.mm, 50], :width => 25.mm) do
    pdf.text "Firma:", :style => :bold, :size => 8
    pdf.text "Delegat:", :style => :bold, :size => 8,:leading => 2
    pdf.text "CNP:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Auto Nr:", :style => :bold, :size => 8,:leading => 2
    pdf.text "Licenţa de tran", :style => :bold, :size => 8,:leading => 2
  end
  pdf.bounding_box([30.mm, 50], :width => 105.mm) do
    pdf.text transporter.name[2], :style => :bold, :size => 8
    pdf.text @object.delegate_transp.name, :style => :bold, :size => 8,:leading => 2
    pdf.text @object.delegate_transp.id_pn, :style => :bold, :size => 8,:leading => 2
    pdf.text @object.id_platte.upcase, :style => :bold, :size => 8,:leading => 2
    pdf.text "sport expiră la date de:", :style => :bold, :size => 8,:leading => 2
  end
  pdf.stroke_bounds
  top -= 56
end
pdf.bounding_box([left,top], :width => 130.mm, :height => 42) do
  pdf.indent 0,3.mm do
    pdf.text "Semnătură/Ştampilă", :style => :bold, :size => 8, :align => :right, :valign => :center
  end
  pdf.stroke_bounds
end

pdf.stroke_line(148.mm,5.mm,148.mm,10.mm)
pdf.stroke_line(148.mm,200.mm,148.mm,205.mm)

pdf.render()
