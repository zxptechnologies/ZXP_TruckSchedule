using Microsoft.ApplicationBlocks.Data;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;

namespace TransportationProject
{
    public class UserAgentString
    {
        public int id { get; private set; }
        public string userAgentString { get; private set; }

        public UserAgentString(string userAgentString) 
        {
            this.userAgentString = userAgentString;
        }

        public int getUserAgentStringID()
        {
            int userAgentStringID;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    userAgentStringID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.StoredProcedure, "sp_truckscheduleapp_getUserAgentStringID", new SqlParameter("@pUserAgentString", this.userAgentString)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in UserAgentString getUserAgentStringID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }
            finally
            {
            }
            return userAgentStringID;
        }


        public int createNewUserAgentStringEntry()
        {
            
            int newUserAgentStringID;
            SQLDataConnectionHelper sqlConnHelper = new SQLDataConnectionHelper();
            
            try
            {
                using (var scope = new TransactionScope())
                {
                sqlConnHelper.setSqlConnectionStringUsingConfiguration();
                sqlConnHelper.openConnection();
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                newUserAgentStringID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.StoredProcedure, "sp_truckscheduleapp_insertNewUserAgentString", new SqlParameter("@pUserAgentString", this.userAgentString)));
                scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in UserAgentString getUserAgentStringID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }

            finally
            {
                if (sqlConnHelper.doesConnectionExist())
                {
                    sqlConnHelper.closeConnection();
                }
            }

            return newUserAgentStringID;
        }
    }

   
}