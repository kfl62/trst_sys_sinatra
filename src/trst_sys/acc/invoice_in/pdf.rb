# encoding: utf-8
# Template for Invoice
require 'prawn/measurement_extensions'
require 'prawn/measurement_extensions'
supplier  = TrstFirm.first
unit      = TrstPartner.first.units.first
data = Hash.new
sum_100 = @object.sum
@object.delivery_notes.each do |dn|
  dn. freights. each do |f|
    key = "#{f.freight.id_stats}"
    if data[key].nil?
      data[key] = [f.freight.name, f.um, f.qu, f.pu_invoice, (f.pu_invoice * f.qu).round(2), ["#{dn.id_main_doc} #{ "%.2f" % f.qu}"]]
    else
      data[key][2] += f.qu
      data[key][4] += (f.pu_invoice * f.qu).round(2)
      data[key][5] << ["#{dn.id_main_doc} #{ "%.2f" % f.qu}"]
    end
  end
end
data = data.values.sort.each_with_index { |d, i| d.unshift("#{i + 1}.") }
data.map!{|e| [e[0],e[1],e[2],"%.2f" %e[3],"%.2f" %e[4],"%.2f" %e[5], e[6].join('; ')]}
data.push(["","TOTAL","","","","%.2f" %sum_100,""])

pdf = Prawn::Document.new(
  :page_size => 'A4',
  :page_layout => :landscape,
  :background => "public/images/pdf/nir.jpg",
  :margin => [0.mm],
  :info => {
    :Title => "Notă de recepţie",
    :Author => "kfl62",
    :Subject => "Formular \"Notă de recepţie\"",
    :Keywords => "Diren Exim Continent Impex Notă de recepţie ",
    :Creator => "http://diren.trst.ro (using Sinatra, Prawn)",
    :CreationDate => Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {:bold => 'public/fonts/verdanab.ttf',
                :italic => 'public/fonts/verdanai.ttf',
                :bold_italic => 'public/fonts/verdanaz.ttf',
                :normal => 'public/fonts/verdana.ttf'})
pdf.font 'Verdana'
pdf.text_box unit.partner.name[2],
             :at => [33.mm, pdf.bounds.top - 8.mm], :style => :bold
# pdf.text_box @object.name,
#              :at => [179.mm, pdf.bounds.top - 8.mm], :size => 10, :style => :bold
# pdf.text_box @object.id_date.to_s,
#              :at => [230.mm, pdf.bounds.top - 8.mm], :size => 10, :style => :bold
pdf.text_box "Factură fiscală",
             :at => [13.mm, pdf.bounds.top - 30.mm], :width => 63.mm, :align => :center, :size => 10
pdf.text_box @object.id_main_doc,
             :at => [75.mm, pdf.bounds.top - 30.mm], :width => 28.mm, :align => :center, :size => 10
pdf.text_box @object.id_date.to_s,
             :at => [100.mm, pdf.bounds.top - 30.mm], :width => 37.mm, :align => :center, :size => 10
pdf.text_box supplier.name[2],
             :at => [138.mm, pdf.bounds.top - 30.mm], :width => 45.mm, :align => :center, :size => 10
pdf.text_box supplier.identities["fiscal"],
             :at => [183.mm, pdf.bounds.top - 30.mm], :width => 38.mm, :align => :center, :size => 10
pdf.text_box @object.payment_doc,
             :at => [220.mm, pdf.bounds.top - 30.mm], :width => 63.mm, :align => :center, :size => 10
pdf.text_box @object.delegate.name,
             :at => [43.mm, pdf.bounds.top - 48.mm], :width => 92.mm, :align => :center, :size => 10
# pdf.text_box @object.main_doc_plat,
#              :at => [175.mm, pdf.bounds.top - 48.mm], :width => 105.mm, :align => :center, :size => 10
pdf.text_box unit.chief,
             :at => [195.mm, 12.mm], :size => 10
pdf.text_box unit.chief,
             :at => [250.mm, 12.mm], :size => 10

pdf.bounding_box([15.mm, pdf.bounds.top - 69.mm], :width  => pdf.bounds.width) do
  pdf.table(data, :cell_style => {:borders => []}, :column_widths => [12.mm,60.mm,10.mm,20.mm,20.mm,25.mm,120.mm]) do
    pdf.font_size = 9
    column(0).style(:align => :right, :padding => [5,10,5,0])
    column(3..5).style(:align => :right)
    row(data.length - 1).columns(1).style(:align => :center)
    (0..data.length - 1).each do |i|
      if data[i].last.length > 160
        row(i).columns(6).style(:size => 7,:height => 14.mm, :padding => [2,0,0,5])
      else data[i].last.split('; ').length > 10
        row(i).columns(6).style(:size => 7,:height => 7.mm, :padding => [2,0,0,5])
      end
    end
  end
end
pdf.render()