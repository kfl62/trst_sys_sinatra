# encoding: utf-8
=begin
#Invoices (Accounting)
=end

class TrstAccInvoice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String
  field :id_date,           :type => Date
  field :id_main_doc,       :type => String
  field :id_delegate_c,     :type => String
  field :sum,               :type => Float,       :default => 0.00
  field :payed,             :type => Boolean,     :default => false
  field :payment_doc,       :type => String
  field :payment_deadline,  :type => Date
  field :payment_date,      :type => Array,       :default => []

  belongs_to  :client,        :class_name => "TrstPartner",         :inverse_of => :invoices
  has_many    :delivery_notes,:class_name => "TrstAccDeliveryNote", :inverse_of => :invoice
  embeds_many :freights,      :class_name => "TrstAccInvoiceFreight"

  before_create :increment_name_date
  after_destroy :restore_delivery_notes

  class << self
    # @todo
    def daily(d)
      where(:id_date => DateTime.strptime("#{d}","%F").to_time)
    end
    # @todo
    def monthly(month = nil)
      y = Date.today.year
      m = month.nil? ? Date.today.month : month.to_i
      mb = DateTime.new(y, m)
      me = m.to_i == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
    end
  end # Class methods
  # @todo
  def delegate
    TrstPartner.find(client_id).delegates.find(id_delegate_c) rescue TrstPartner.find(client_id).delegates.first
  end
  # @todo
  def update_delivery_notes(add = true)
    self.delivery_notes.each do |dn|
      dn.charged = add
      dn.save
    end
    self.freights.each do |f|
      self.delivery_notes.each do |dn|
        dn.freights.each do |df|
          if add
            df.pu_invoice = f.pu if df.freight.id_stats == f.id_stats
          else
            df.pu_invoice = 0.00 if df.freight.id_stats == f.id_stats
          end
          df.val_invoice = (df.pu_invoice * df.qu).round(2)
          df.save
        end
      end
    end
  end
  # @todo
  def file_name
    "NIR_INV_#{id_main_doc}"
  end
  # @todo
  def pdf_template
    'pdf'
  end

  protected
  # @todo
  def increment_name_date
    if TrstAccInvoice.last.freights.empty?
      TrstAccInvoice.last.destroy
    end unless TrstAccInvoice.last.nil?
    self.name = TrstAccInvoice.asc(:name).last.name.next rescue "#{TrstFirm.first.name[0][0..2].upcase}_INV_001"
    self.id_main_doc = TrstAccInvoice.asc(:name).last.id_main_doc.next rescue "#{TrstFirm.first.name[0][0..2].upcase}-"
    self.id_date = Date.today
  end
  # @todo
  def restore_delivery_notes
    self.update_delivery_notes(false)
  end
end
