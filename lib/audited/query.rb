module Query
  def exec_query(sql, name = "SQL", binds = [], prepare: false)
    old_connected_sql = ::Audited.store[:sql].dup
    if old_connected_sql
      ::Audited.store[:sql] = old_connected_sql + ";" + sql.dup.force_encoding("UTF-8")
    else
      ::Audited.store[:sql] = sql.dup.force_encoding("UTF-8")
    end
    super(sql, name, binds, prepare: prepare)
  end
end
