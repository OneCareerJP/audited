class <%= migration_class_name %> < <%= migration_parent %>
  def self.up
    add_column :audits, :sql, :text
  end

  def self.down
    remove_column :audits, :sql
  end
end
