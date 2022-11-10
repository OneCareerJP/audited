# frozen_string_literal: true

require "active_record"

module Audited
  class << self
    attr_accessor \
      :auditing_enabled,
      :current_user_method,
      :ignored_attributes,
      :max_audits,
      :store_synthesized_enums
    attr_writer :audit_class

    def audit_class
      @audit_class ||= Audit
    end

    def store
      current_store_value = Thread.current.thread_variable_get(:audited_store)

      if current_store_value.nil?
        Thread.current.thread_variable_set(:audited_store, {})
      else
        current_store_value
      end
    end

    def config
      yield(self)
    end
  end

  @ignored_attributes = %w[lock_version created_at updated_at created_on updated_on]

  @current_user_method = :current_user
  @auditing_enabled = true
  @enable_sql_log = false
  @store_synthesized_enums = false
end

require 'audited/auditor'
require 'audited/audit'
require 'audited/query'

ActiveSupport.on_load :active_record do
  require "audited/audit"
  include Audited::Auditor
end

ActiveSupport.on_load(:after_initialize) do
  adapters = ActiveRecord::ConnectionAdapters.constants.select{|klass| klass.to_s.include?("Adapter")}
  for klass in adapters do
    puts klass
    ::ActiveRecord::ConnectionAdapters.const_get(klass).send :prepend, Query
  end
end

require "audited/sweeper"
require "audited/railtie"
