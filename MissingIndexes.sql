DECLARE @sqlserver_start_time DATETIME
SELECT @sqlserver_start_time = sqlserver_start_time FROM sys.dm_os_sys_info
SELECT @sqlserver_start_time as StatsSince, 
    @@servername AS [PhysicalServerName], DB_NAME(mid.database_id) AS DatabaseName, ROUND(migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans),2) AS IndexAdvantage,
	migs.user_seeks AS UserSeeks, migs.user_scans AS UserScans, migs.last_user_seek AS LastUserSeek, migs.user_scans AS LastUserScan, migs.avg_total_user_cost AS AvgTotalCost, migs.avg_user_impact AS AvgUserImpact,
	mid.equality_columns, mid.inequality_columns, mid.included_columns, mid.statement AS TableName,
    'CREATE INDEX [IX__' + LEFT (PARSENAME(mid.statement, 1), 32) + '__' 
	+ CASE WHEN mid.equality_columns IS NOT NULL THEN REPLACE(REPLACE(REPLACE(mid.equality_columns,'[',''),']',''),', ','__') ELSE '' END
	+ CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN '__' ELSE '' END
	+ CASE WHEN mid.inequality_columns IS NOT NULL THEN REPLACE(REPLACE(REPLACE(mid.inequality_columns,'[',''),']',''),', ','__') ELSE '' END 
	+ ']'
    + ' ON ' + mid.statement
    + ' (' 
	+ ISNULL (mid.equality_columns,'')
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
    + ISNULL (mid.inequality_columns, '')
    + ')'
    + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') 
	-- + ' ON [NCNDX]' 
	AS CreateIndexStatement
FROM sys.dm_db_missing_index_groups mig
       INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
       INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
--WHERE 
--       (      
--              migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 100
--              or
--              migs.unique_compiles > 100
--              or
--              migs.user_seeks > 100
--       ) and migs.avg_user_impact > 50
WHERE mid.statement like '%flowsheet_component%'
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC
GO


DECLARE @sqlserver_start_time DATETIME
SELECT @sqlserver_start_time = sqlserver_start_time FROM sys.dm_os_sys_info
SELECT @sqlserver_start_time as StatsSince, 
    @@servername AS [PhysicalServerName], DB_NAME(mid.database_id) AS DatabaseName, ROUND(migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans),2) AS IndexAdvantage,
	migs.user_seeks AS UserSeeks, migs.user_scans AS UserScans, migs.last_user_seek AS LastUserSeek, migs.user_scans AS LastUserScan, migs.avg_total_user_cost AS AvgTotalCost, migs.avg_user_impact AS AvgUserImpact,
	mid.equality_columns, mid.inequality_columns, mid.included_columns, mid.statement AS TableName,
    'CREATE INDEX [IX__' + LEFT (PARSENAME(mid.statement, 1), 32) + '__' 
	+ CASE WHEN mid.equality_columns IS NOT NULL THEN REPLACE(REPLACE(REPLACE(mid.equality_columns,'[',''),']',''),', ','__') ELSE '' END
	+ CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN '__' ELSE '' END
	+ CASE WHEN mid.inequality_columns IS NOT NULL THEN REPLACE(REPLACE(REPLACE(mid.inequality_columns,'[',''),']',''),', ','__') ELSE '' END 
	+ ']'
    + ' ON ' + mid.statement
    + ' (' 
	+ ISNULL (mid.equality_columns,'')
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
    + ISNULL (mid.inequality_columns, '')
    + ')'
    + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') 
	-- + ' ON [NCNDX]' 
	AS CreateIndexStatement
FROM sys.dm_db_missing_index_groups mig
       INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
       INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE 
       (      
              migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 300
              or
              migs.unique_compiles > 100
              or
              migs.user_seeks > 100
       ) and migs.avg_user_impact > 50
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC


