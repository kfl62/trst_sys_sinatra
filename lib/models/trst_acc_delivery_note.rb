# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccDeliveryNote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => String
  field :id_date,       :type => Date
  field :id_intern,     :type => Boolean,   :default => false
  field :id_main_doc,   :type => String
  field :id_delegate_c, :type => String
  field :id_delegate_t, :type => String
  field :id_platte,     :type => String
  field :charged,       :type => Boolean,   :default => false

  alias :file_name :name

  has_many   :freights,   :class_name => "TrstAccFreightOut", :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartner",       :inverse_of => :delivery_notes
  belongs_to :transporter,:class_name => "TrstPartner",       :inverse_of => :delivery_pprss
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :delivery_notes
  belongs_to :invoice,    :class_name => "TrstAccInvoice",    :inverse_of => :delivery_notes
  belongs_to :doc_grn,    :class_name => "TrstAccGrn",        :inverse_of => :delivery_notes
  belongs_to :signed_by,  :class_name => "TrstUser",          :inverse_of => :delivery_notes

  before_create  :increment_name_date
  before_destroy :destroy_freights

  class << self
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)).asc(:name)
    end
    # @todo
    def daily(day = nil)
      day ||= Date.today.to_s
      where(:id_date => DateTime.strptime("#{day}","%F").to_time).asc(:name)
    end
    # @todo
    def monthly(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      mb = DateTime.new(y, m)
      me = m.to_i == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time).asc(:name)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
    # todo
    def nin(nin = true)
      where(:id_intern => !nin)
    end
    # #todo
    def by_client_id(id)
      where(:client_id => id).asc(:name)
    end
    # @todo
    def by_freights_p03(tax = false)
      ids = []
      all.each do |dn|
        tmp = []
        dn.freights.each{|f| tmp << f.freight.p03}
        ids << dn.id if tmp.uniq[0] == tax
      end
      any_in(:_id  => ids)
    end
    # @todo
    def by_charged(status = false)
      where(:charged => status)
    end
    # @todo
    def sum_freights_inv
      all.each_with_object({}) do |dn,s|
        dn.freights.each_with_object(s) do |f,s|
          key = f.freight.name
          s[key].nil? ?  s[key] = [f.freight.id_stats,f.qu] : s[key][1] += f.qu
        end
      end
    end
     # @todo
    def sum_freights_grn
      all.each_with_object({}) do |dn,s|
        dn.freights.each_with_object(s) do |f,s|
          key = "#{f.id_stats}_#{"%05.2f" % f.pu}"
          if s[key].nil?
            s[key] = [f.freight.name,f.freight.id_stats,f.pu,f.qu,(f.pu * f.qu).round(2)]
          else
            s[key][3] += f.qu
            s[key][4] += (f.pu * f.qu).round(2)
          end
        end
      end
    end
   # @todo
    def to_txt
      all.each{|dn| p "#{dn.name} --- #{dn.id_main_doc} --- #{dn.id_date.to_s}"}
    end
  end

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def delegate_transp
    TrstPartner.find(transporter_id).delegates.find(id_delegate_t) rescue TrstPartner.find(transporter_id).delegates.first
  end
  # @todo
  def delegate_client
    TrstPartner.find(client_id).delegates.find(id_delegate_c) rescue TrstPartner.find(client_id).delegates.first
  end
  # @todo
  def pdf_template
    'pdf'
  end
  # @todo
  def freights_list
    self.freights.asc(:id_stats).each_with_object([]) do |f,r|
      r << "#{f.freight.name}: #{"%.2f" % f.qu} kg ( #{"%.2f" % f.pu} )"
    end
  end

  protected
  # @todo
  def increment_name_date
    if TrstAccDeliveryNote.by_unit_id(unit_id).last.freights.empty?
      TrstAccDeliveryNote.by_unit_id(unit_id).last.destroy
    end unless TrstAccDeliveryNote.by_unit_id(unit_id).last.nil?
    self.name = TrstAccDeliveryNote.where(:unit_id => unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_AEA3_001"
    self.id_main_doc = "#{TrstFirm.first.name[0][0..2].upcase}-" rescue "#{unit.firm.name[0][0..2].upcase}-"
    self.id_date = Date.today
    self.id_intern = true if client.firm
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
