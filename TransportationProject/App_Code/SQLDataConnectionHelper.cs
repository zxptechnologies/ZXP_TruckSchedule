using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

namespace TransportationProject
{
    
    public class SQLDataConnectionHelper
    {
        protected static String sql_connStr;
        SqlConnection sqlConn;


        public void setSqlConnectionStringUsingConfiguration() 
        {
            TruckScheduleConfigurationKeysHelper TSCKHelper = new TruckScheduleConfigurationKeysHelper();
            try
            {
                sql_connStr = TSCKHelper.sql_connStr;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper getSqlConnectionStringFromConfiguration(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
        }

        public void setSqlConnectionString(string newConnectionString)
        {
           
            try
            {
                sql_connStr = newConnectionString;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper setSqlConnectionString(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
        }

        public bool setConnection(SqlConnection newConnection)
        {
            bool didSucceed = false;
            try
            {
                if (newConnection.State != ConnectionState.Closed && newConnection != null)
                {
                    throw new Exception("Connection does not exist.");
                }
                else
                {
                    this.sqlConn = newConnection;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper setConnection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
            return didSucceed;
        
        }
        public SqlConnection getConnection()
        {
            try
            {
                if (sqlConn == null || sqlConn.State != ConnectionState.Open)
                {
                    throw new Exception("Connection does not exist.");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper getConnection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }

            return this.sqlConn;
        }
        public bool openConnection()
        {
            bool didSucceed = false; 
            try 
            {
                if (sql_connStr == string.Empty)
                {
                    throw new Exception("Connection string not set.");
                }
                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                    didSucceed = true;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper openConnection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
            return didSucceed;
        }
        public bool closeConnection()
        {
            bool didSucceed = false;
            try
            {
                    sqlConn.Close();
                    sqlConn.Dispose();
                    didSucceed = true;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper closeConnection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
            return didSucceed;
        }
        public bool doesConnectionExist()
        {
            bool doesExist = false;

            try
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    doesExist = true;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in SQLDataConnectionHelper doesConnectionExist(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
            return doesExist;
        
        }

    }
}