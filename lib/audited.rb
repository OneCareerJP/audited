require 'active_record'

module Audited
  class << self
    attr_accessor :ignored_attributes, :current_user_method, :max_audits, :auditing_enabled
    attr_writer :audit_class

    def audit_class
      @audit_class ||= Audit
    end

    def store
      Thread.current[:audited_store] ||= {}
    end

    def config
      yield(self)
    end
  end

  @ignored_attributes = %w(lock_version created_at updated_at created_on updated_on)

  @current_user_method = :current_user
  @auditing_enabled = true
end

require 'audited/auditor'
require 'audited/audit'
require 'audited/query'

::ActiveRecord::Base.send :include, Audited::Auditor

ActiveSupport.on_load(:after_initialize) do
  adapters = ActiveRecord::ConnectionAdapters.constants.select{|klass| klass.name.include?("Adapter")}
  for klass in adapters do
    ::ActiveRecord::ConnectionAdapters.const_get(klass).send :prepend, Query
  end
end

require 'audited/sweeper'
