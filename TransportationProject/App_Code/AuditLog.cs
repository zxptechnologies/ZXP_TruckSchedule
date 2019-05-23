using Microsoft.ApplicationBlocks.Data;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;


namespace TransportationProject
{
    public class AuditLog
    {
        public string IPAddress { get; private set; }
        public int UserID { get; private set; }
        public DateTime TimeStamp { get; private set; }
        public string PageAddress { get; private set; }
        public int UserAgentStringID { get; private set; }

        public AuditLog(int userID)
        {
            initialize(userID);
        }

        public void initialize(int userID)
        {

            this.UserID = userID;
            this.IPAddress = GetUser_IP();
            this.TimeStamp = DateTime.UtcNow;
            this.PageAddress = HttpContext.Current.Request.Url.AbsolutePath;
            string devicebrowserInfo = HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"].ToString();
            UserAgentString uaString = new UserAgentString(devicebrowserInfo);
            this.UserAgentStringID = uaString.getUserAgentStringID();
            if (0 == this.UserAgentStringID)
            {
                this.UserAgentStringID = uaString.createNewUserAgentStringEntry();
            }
        }

        protected string GetUser_IP()
        {
            string VisitorsIPAddr = string.Empty;
            if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
            {
                VisitorsIPAddr = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            else if (HttpContext.Current.Request.UserHostAddress.Length != 0)
            {
                VisitorsIPAddr = HttpContext.Current.Request.UserHostAddress;
            }
            return VisitorsIPAddr;
        }


        public bool createNewAuditLogEntry(AuditLog aLog)
        {
            bool didSucceed = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_createNewAuditLogEntry", new SqlParameter("@pIPAddress", aLog.IPAddress),
                                                                                                                                   new SqlParameter("@pUserID", aLog.UserID),
                                                                                                                                   new SqlParameter("@pTimeStamp", aLog.TimeStamp),
                                                                                                                                   new SqlParameter("@pPageAddress", aLog.PageAddress),
                                                                                                                                   new SqlParameter("@pUserAgentStringID", aLog.UserAgentStringID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in AuditLog createNewAuditLogEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            }
            finally
            {
            }
            return didSucceed;
        }

    }
}