module Query
	def exec_query(sql, name = "SQL", binds = [], prepare: false)
		old_connected_sql = ::Audited.store[:sql]
		if old_connected_sql
			::Audited.store[:sql] = old_connected_sql + " / " + sql
		else
			::Audited.store[:sql] = sql
		end
		super(sql, name, binds, prepare: prepare)
	end
end
