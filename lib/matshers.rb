module Matshers
  module ActiveRecord
    def have_attached_file(attachment)
      klass = self.name.gsub(/Test$/, '').constantize

      context "#{klass}" do
        should have_db_column("#{attachment}_file_name").of_type(:string)
        should have_db_column("#{attachment}_content_type").of_type(:string)
        should have_db_column("#{attachment}_file_size").of_type(:integer)
      end

      should "have attachment ##{attachment}" do
        assert klass.new.respond_to?(attachment.to_sym), "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
        assert_equal ::Paperclip::Attachment, klass.new.send(attachment.to_sym).class
      end
    end
  end
end

class Test::Unit::TestCase
  extend Matshers::ActiveRecord
end