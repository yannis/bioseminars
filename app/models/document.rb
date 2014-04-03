class Document < ActiveRecord::Base
  attr_accessor :readable, :updatable, :destroyable

  DOCUMENT_PAPERCLIP_SYSTEM = (Rails.env.test? ? "test_system" : "system")

  belongs_to :documentable, polymorphic: true

  has_attached_file :data,
    path: ":rails_root/public/#{DOCUMENT_PAPERCLIP_SYSTEM}/documents/:id/:style/:filename",
    url: "/#{DOCUMENT_PAPERCLIP_SYSTEM}/documents/:id/:style/:filename"
  validates_attachment_presence :data
  validates_attachment_content_type :data, content_type: ['application/pdf', 'application/msword', 'text/plain', 'text/rtf', 'application/vnd.ms-excel']
  validates_attachment_size :data, less_than: 10.megabytes

end
