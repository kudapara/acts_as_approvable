require 'active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'acts_as_approvable/model'
require 'acts_as_approvable/approval'
require 'acts_as_approvable/error'
require 'acts_as_approvable/ownership'
require 'acts_as_approvable/version'

if defined?(Rails) && Rails.version =~ /^3\./
  require 'acts_as_approvable/railtie'
elsif defined?(ActiveRecord)
  ActiveRecord::Base.send :extend, ActsAsApprovable::Model
end

$LOAD_PATH.shift

module ActsAsApprovable
  ##
  # Enable the approval queue at a global level.
  def self.enable
    @enabled = true
  end

  ##
  # Disable the approval queue at a global level.
  def self.disable
    @enabled = false
  end

  ##
  # Returns true if the approval queue is enabled globally.
  def self.enabled?
    @enabled = true if @enabled.nil?
    @enabled
  end

  ##
  # Set the referenced Owner class to be used by generic finders.
  #
  # @see Ownership
  def self.owner_class=(klass)
    @owner_class = klass
  end

  ##
  # Get the referenced Owner class to be used by generic finders.
  #
  # @see Ownership
  def self.owner_class
    @owner_class
  end

  ##
  # Set the class used for overriding Ownership retrieval
  #
  # @see Ownership
  def self.owner_source=(source)
    @owner_source = source
  end

  ##
  # Get the class used for overriding Ownership retrieval
  #
  # @see Ownership
  def self.owner_source
    @owner_source
  end

  ##
  # Set the engine used for rendering view files.
  def self.view_language=(lang)
    @lang = lang
  end

  ##
  # Get the engine used for rendering view files. Defaults to 'erb'
  def self.view_language
    if Rails.version =~ /^3\./
      Rails.configuration.generators.rails[:template_engine].try(:to_s) || 'erb'
    else
      @lang || 'erb'
    end
  end

  ##
  # Enable or disable the stale record check when approving updates.
  def self.stale_check=(bool)
    @stale_check = !!bool
  end

  ##
  # Get the state of the stale check.
  def self.stale_check?
    @stale_check || true
  end
end
