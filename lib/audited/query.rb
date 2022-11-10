module Query
  def exec_query(sql, name = "SQL", binds = [], prepare: false)
    if self.class.enable_sql_log
      old_connected_sql = ::Audited.store[:sql].dup
      if old_connected_sql
        ::Audited.store[:sql] = old_connected_sql + ";" + sql.dup.force_encoding("UTF-8")
      else
        ::Audited.store[:sql] = sql.dup.force_encoding("UTF-8")
      end
    end

    super(sql, name, binds, prepare: prepare)
  end
end
