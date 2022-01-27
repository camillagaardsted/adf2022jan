SELECT      *
FROM        SalesLT.SalesOrderHeader

-- USE fungerer ikke her!!
USE master

--Microsoft SQL Azure (RTM) - 12.0.2000.8  	Jan  6 2022 09:47:07  	Copyright (C) 2019 Microsoft Corporation 
SELECT @@VERSION

-- session Id er 78
SELECT @@spid

CREATE DATABASE proddb

-- firewall regler er her
-- Alle som sidder på en Azure Ipadresse har adgang nu 0.0.0.0
SELECT      *
FROM        sys.firewall_rules

---------------------------------------------------------------
-- Azure Synapse Analytis
---------------------------------------------------------------
-- Paralelle DW - og meget mere end det -derfor navnet med analytics


-- Serverless pool
-- Spark pool
-- Dedicated pool  - det svarer til en database



