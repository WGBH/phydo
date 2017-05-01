# Generated via
#  `rails generate hyrax:work Work`
class Work < ActiveFedora::Base

  FIXITY_TYPE = :md5
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include Concerns::WorkBehavior
    # validates :title, presence: { message: 'Your work must have a title.' }

  def do_md5_checksum

  end

  def do_fixity_check
    do_md5_checksum if Work::FIXITY_TYPE == :md5
  end

  class << self
    def indexer
      ::WorkIndexer
    end
  end
end
