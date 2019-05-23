using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;
using Microsoft.ApplicationBlocks.Data;

namespace TransportationProject.AdminSubPages
{
    public partial class Admin_UserAlerts : System.Web.UI.Page
    {
        protected static String sql_connStr;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                //if (null != cookie && !string.IsNullOrEmpty(cookie.Value))

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (zxpUD._uid != new ZXPUserData()._uid)
                {

                    //ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();

                    if (zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
                    {
                        sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                        if (sql_connStr == String.Empty)
                        {
                            throw new Exception("Missing SQLConnectionString in web.config");
                        }
                    }
                    else
                    {
                        Response.BufferOutput = true;
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false);//zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_UserAlerts Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getUserAlerts(int USERID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT USRALRT.AlertType, USRALRT.AlertID, USRALRT.AlertUserID " +
                                    "FROM dbo.UserAlerts as USRALRT " +
                                    "WHERE (USRALRT.isDisabled = 'false') AND (USRALRT.UserID = @USERID)";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@USERID", USERID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getUserAlerts(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getCapacityAlertsGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TankID, A.Percentage, A.isEmailAlert, A.isSMSAlert " +
                                                    "FROM dbo.Alerts AS A " +
                                                    "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 2 ";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getCapacityAlertsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDemurrageAlertsGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert, A.ProductID_CMS, " +
                                            "(SELECT PCMS.ProductName_CMS FROM dbo.ProductsCMS as PCMS WHERE PCMS.ProductID_CMS = A.ProductID_CMS) as ProductName  " +
                                            "FROM dbo.Alerts AS A  " +
                                            "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 1";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getDemurrageAlertsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInactiveAlertsGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert " +
                                            "FROM dbo.Alerts AS A " +
                                               "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 3";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getInactiveAlertsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getEventGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.ProductID_CMS, A.isEmailAlert, A.isSMSAlert, E.EventTypeDescription, PROD.ProductName_CMS " +
                                            "FROM dbo.Alerts AS A " +
                                            "INNER JOIN dbo.EventAlerts AS EA ON A.AlertID = EA.AlertID " +
                                            "LEFT JOIN dbo.ProductsCMS AS PROD ON A.ProductID_CMS = PROD.ProductID_CMS " +
                                            "INNER JOIN dbo.EventTypes AS E ON E.EventTypeID = EA.EventTypeID " +
                                            "WHERE A.isDisabled = 'false' and AlertTypeID = 1007";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getEventGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInspectionDealBreakerGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.InspectionHeaderID, A.isEmailAlert, A.isSMSAlert " +
                                            "FROM dbo.Alerts AS A  " +
                                            "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 4 ";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getInspectionDealBreakerGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static Object getDropTrailerGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.ProductID_CMS, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert " +
                                            "FROM dbo.Alerts AS A " +
                                            "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 5 ";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getDropTrailerGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getCOFAUploadGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert " +
                                            "FROM dbo.Alerts AS A " +
                                            "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 6 ";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts getCOFAUploadGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void disableUserAlert(int AlertUserID)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "UserAlerts", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "AlertUserID", AlertUserID.ToString(), "UserID", zxpUD._uid.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.UserAlerts SET isDisabled = 'true' WHERE AlertUserID = @AlertUserID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@AlertUserID", AlertUserID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts disableUserAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static int setNewUserAlert(int USERID, int ALERTID, int ALERTTYPE)
        {
            Int32 userAlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.UserAlerts (UserID, AlertID, AlertType, isDisabled) VALUES (@UserID, @AlertID, @AlertType, 'false')" +
                                    "SELECT CAST(scope_identity() AS int)";
                    userAlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UserID", USERID),
                                                                                                                     new SqlParameter("@AlertID", ALERTID),
                                                                                                                     new SqlParameter("@AlertType", ALERTTYPE)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "UserAlerts", "UserID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, USERID.ToString(), null, "AlertUserID", userAlertID.ToString(), "UserID", zxpUD._uid.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "UserAlerts", "AlertID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, ALERTID.ToString(), null, "AlertUserID", userAlertID.ToString(), "UserID", zxpUD._uid.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "UserAlerts", "AlertType", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, ALERTTYPE.ToString(), null, "AlertUserID", userAlertID.ToString(), "UserID", zxpUD._uid.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "UserAlerts", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "AlertUserID", userAlertID.ToString(), "UserID", zxpUD._uid.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_UserAlerts setNewUserAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return userAlertID;
        }

        [System.Web.Services.WebMethod]
        public static int getDemurrageTimeInMins()
        {
            int demurrageTimeInMins = Int32.Parse(ConfigurationManager.AppSettings["demurrageMins"]);

            return demurrageTimeInMins;
        }

        [System.Web.Services.WebMethod]
        public static List<KeyValuePair<string, string>> getDemurrageTimeOptions()
        {
            var timeOptionsValues = new List<KeyValuePair<string, string>>();
            timeOptionsValues.Add(new KeyValuePair<string, string>("-", "Before Demurrage count down has ended"));
            timeOptionsValues.Add(new KeyValuePair<string, string>("+", "After Demurrage count down has ended"));

            return timeOptionsValues;
        }
    }
}