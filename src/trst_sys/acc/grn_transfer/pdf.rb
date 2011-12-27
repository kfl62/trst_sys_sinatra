# encoding: utf-8
# Template for GRN Transfer
require 'prawn/measurement_extensions'
supplier  = TrstPartner.intern.first
unit      = TrstFirm.unit_by_unit_id(@object.unit_id)
signed_by = unit.chief.include?(',') ? @object.signed_by.name : unit.chief
platte    = @object.main_doc_plat.nil? ? "XX 00 XXX" : @object.main_doc_plat.empty? ? "XX 00 XXX" : @object.main_doc_plat
data = Hash.new
sum_100 = @object.sum_100
@object.delivery_notes.each do |dn|
  dn. freights. each do |f|
    key = "#{f.id_stats}_#{"%05.2f" % f.pu}"
    if data[key].nil?
      data[key] = [f.freight.name, f.um, f.qu, f.pu, (f.pu * f.qu).round(2), ["#{dn.id_main_doc} #{ "%.2f" % f.qu}"]]
    else
      data[key][2] += f.qu
      data[key][4] += (f.pu * f.qu).round(2)
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
    :Subject => "Formular \"Notă de recepţie\" - Transfer gestiune",
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
pdf.text_box unit.firm.name[2],
             :at => [33.mm, pdf.bounds.top - 8.mm], :style => :bold
pdf.text_box "Nr. intern: #{@object.name}",
             :at => [172.mm, pdf.bounds.top - 13.mm], :size => 9
pdf.text_box @object.id_date.to_s,
             :at => [230.mm, pdf.bounds.top - 8.mm], :size => 10, :style => :bold
pdf.text_box "Aviz exp. #{@object.main_doc_name}",
             :at => [15.mm, pdf.bounds.top - 30.mm], :width => 91.mm, :size => 9
# pdf.text_box @object.id_date.to_s,
#              :at => [100.mm, pdf.bounds.top - 30.mm], :width => 37.mm, :align => :center, :size => 10
pdf.text_box supplier.name[2],
             :at => [138.mm, pdf.bounds.top - 30.mm], :width => 45.mm, :align => :center, :size => 10
pdf.text_box supplier.identities["fiscal"],
             :at => [183.mm, pdf.bounds.top - 30.mm], :width => 38.mm, :align => :center, :size => 10
pdf.text_box @object.main_doc_paym,
             :at => [220.mm, pdf.bounds.top - 30.mm], :width => 63.mm, :align => :center, :size => 10
pdf.text_box @object.delegate.name,
             :at => [43.mm, pdf.bounds.top - 48.mm], :width => 92.mm, :align => :center, :size => 10
pdf.text_box platte,
             :at => [175.mm, pdf.bounds.top - 48.mm], :width => 105.mm, :align => :center, :size => 10
pdf.text_box signed_by,
             :at => [195.mm, 12.mm], :size => 10
pdf.text_box signed_by,
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
