using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;

namespace TransportationProject.AdminSubPages
{
    public partial class Admin_Alerts : System.Web.UI.Page
    {
     

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
               // HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();

                if (zxpUD._uid != new ZXPUserData()._uid)
                {
                    
                    if (!zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
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
                string strErr = " SQLException Error in Admin_Alerts Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getProductOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP (50) ProductID_CMS, ProductName_CMS FROM dbo.ProductsCMS ORDER BY ProductName_CMS";
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
                string strErr = " Exception Error in Admin_Alerts getProductOptions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getTankOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TankID, TankName FROM dbo.Tanks ORDER BY TankName";

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
                string strErr = " Exception Error in Admin_Alerts getTankOptions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInspectionHeaderOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT IH.InspectionHeaderID, IH.InspectionHeaderName FROM dbo.InspectionHeader AS IH WHERE IH.isDisabled = 'false'";
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
                string strErr = " Exception Error in Admin_Alerts getInspectionHeaderOptions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getProductListBasedOnInput(string INPUT)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            string ProductIDOrName = "%" + INPUT + "%";

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT DISTINCT pCMS.ProductID_CMS, pCMS.ProductName_CMS " +
                                        "FROM ProductsCMS as pCMS " +
                                        "WHERE (UPPER(pCMS.ProductID_CMS) LIKE UPPER(@ProductID_CMS)) OR (UPPER (pCMS.ProductName_CMS) LIKE UPPER(@ProductName_CMS))";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ProductID_CMS", ProductIDOrName),
                                                                                                  new SqlParameter("@ProductName_CMS", ProductIDOrName));
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
                string strErr = " Exception Error in Admin_Alerts getProductListBasedOnInput(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }



        [System.Web.Services.WebMethod]
        public static Object getEventOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //will be updated to all events during maintenance
                    sqlCmdText = "SELECT EventTypeID, EventTypeDescription FROM dbo.EventTypes WHERE EventTypeID = 14 OR EventTypeID = 16 OR EventTypeID = 3052 OR " +
                                            "EventTypeID = 3053 OR EventTypeID = 2037 OR EventTypeID = 7098 OR EventTypeID = 3074 OR EventTypeID = 3051 OR EventTypeID = 3070 OR " +
                                            "EventTypeID = 8098 OR EventTypeID = 8099";
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
                string strErr = " Exception Error in Admin_Alerts getEventOptions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDemurrageGridData()
        {
            DataSet dataSet = new DataSet();
            List<object[]> demurrageData = new List<object[]>();
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageSubject, A.SMSMessageBody  " +
                                           "FROM dbo.Alerts AS A  " +
                                           "WHERE A.isDisabled = 'false' AND A.AlertTypeID = 1";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        demurrageData.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts getDemurrageGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return demurrageData;
        }

        [System.Web.Services.WebMethod]
        public static Object getCapacityGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TankID, A.Percentage, A.isEmailAlert, A.isSMSAlert, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageSubject, A.SMSMessageBody " +
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
                string strErr = " Exception Error in Admin_Alerts getCapacityGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInactiveGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageSubject, A.SMSMessageBody " +
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
                string strErr = " Exception Error in Admin_Alerts getInactiveGridData(). Details: " + ex.ToString();
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.InspectionHeaderID, A.isEmailAlert, A.isSMSAlert, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageSubject, A.SMSMessageBody  " +
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
                string strErr = " Exception Error in Admin_Alerts getInspectionDealBreakerGridData(). Details: " + ex.ToString();
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.ProductID_CMS, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert, PROD.ProductName_CMS, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageSubject, A.SMSMessageBody  " +
                                            "FROM dbo.Alerts AS A " +
                                            "INNER JOIN dbo.ProductsCMS AS PROD ON A.ProductID_CMS = PROD.ProductID_CMS " +
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
                string strErr = " Exception Error in Admin_Alerts getDropTrailerGridData(). Details: " + ex.ToString();
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.TriggerAfterXMinutes, A.isEmailAlert, A.isSMSAlert, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageSubject, A.SMSMessageBody " +
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
                string strErr = " Exception Error in Admin_Alerts getCOFAUploadGridData(). Details: " + ex.ToString();
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.AlertID, A.Name, A.ProductID_CMS, A.isEmailAlert, A.isSMSAlert, EA.EventTypeID, PROD.ProductName_CMS, A.EmailMessageSubject, A.EmailMessageBody, A.SMSMessageBody, A.SMSMessageSubject " +
                                            "FROM dbo.Alerts AS A " +
                                            "INNER JOIN dbo.EventAlerts AS EA ON A.AlertID = EA.AlertID " +
                                            "LEFT JOIN dbo.ProductsCMS AS PROD ON A.ProductID_CMS = PROD.ProductID_CMS " +
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
                string strErr = " Exception Error in Admin_Alerts getEventGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int setNewDemurrageAlert(string NAME, bool isEmailAlert, bool isSMSAlert, int ALERTTIME, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)// , string PRODUCTID_CMS)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 1)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "INSERT INTO dbo.Alerts (AlertTypeID, Name, TriggerAfterXMinutes, isEmailAlert, isSMSAlert, isDisabled, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (1, @Name, @AlertTime, @isEmailAlert, @isSMSAlert, 'false', 'true', 'false', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@AlertTime", ALERTTIME),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewDemurrageAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }

        [System.Web.Services.WebMethod]
        public static int setNewCapacityAlert(string NAME, decimal PERCENTAGE, bool isEmailAlert, bool isSMSAlert, int TankID, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (PERCENTAGE > 1 || PERCENTAGE <= 0)
                    { throw new Exception("Invalid capacity entered"); }


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 2)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "INSERT INTO dbo.Alerts (Name, Percentage, isEmailAlert, isSMSAlert, TankID, isDisabled, AlertTypeID, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (@Name, @Percentage, @isEmailAlert, @isSMSAlert, @TankID, 'false', 2, 'true', 'false', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@Percentage", PERCENTAGE),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@TankID", TankID),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewCapacityAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }

        [System.Web.Services.WebMethod]
        public static int setNewInactiveAlert(string NAME, int ALERTTIME, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;



                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 3)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {


                        sqlCmdText = "INSERT INTO dbo.Alerts (Name, TriggerAfterXMinutes, isEmailAlert, isSMSAlert, isDisabled, AlertTypeID, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (@Name, @AlertTime, @isEmailAlert, @isSMSAlert, 'false', 3, 'true', 'false', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@AlertTime", ALERTTIME),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewInactiveAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }

        [System.Web.Services.WebMethod]
        public static int setNewDealBreakerAlert(string NAME, int INSPECTIONID, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 4)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "INSERT INTO dbo.Alerts (Name, InspectionHeaderID, isEmailAlert, isSMSAlert, isDisabled, AlertTypeID, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (@Name, @InspectionHeaderID, @isEmailAlert, @isSMSAlert, 'false', 4, 'false', 'true', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";

                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@InspectionHeaderID", INSPECTIONID),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                    }
                    else
                    {
                        throw new Exception("There is another deal breaker alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewDealBreakerAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }

        [System.Web.Services.WebMethod]
        public static int setNewDropTrailerAlert(string NAME, string ProductID_CMS, int DaysAfterArrivalAlertInMins, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 5)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "INSERT INTO dbo.Alerts (Name, ProductID_CMS, TriggerAfterXMinutes, isEmailAlert, isSMSAlert, isDisabled, AlertTypeID, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (@Name, @ProductID_CMS, @DaysAfterArrivalAlert, @isEmailAlert, @isSMSAlert, 'false', 5, 'true', 'false', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@ProductID_CMS", ProductID_CMS),
                                                                                                                     new SqlParameter("@DaysAfterArrivalAlert", DaysAfterArrivalAlertInMins),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                    }
                    else
                    {
                        throw new Exception("There is another drop trailer storage alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewDropTrailerAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }

        [System.Web.Services.WebMethod]
        public static int setNewCOFAUploadAlert(string NAME, int ALERTTIME, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 6)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "INSERT INTO dbo.Alerts (Name, TriggerAfterXMinutes, isEmailAlert, isSMSAlert, isDisabled, AlertTypeID, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (@Name, @AlertTime, @isEmailAlert, @isSMSAlert, 'false', 6, 'true', 'false', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@AlertTime", ALERTTIME),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                    }
                    else
                    {
                        throw new Exception("There is another deal breaker alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewCOFAUploadAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }


        [System.Web.Services.WebMethod]
        public static int setNewEventAlert(string NAME, string ProductID_CMS, int EVENTTYPEID, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            Int32 AlertID = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND isDisabled = 'false' AND AlertTypeID = 1007)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME)));

                    if (rowCount == 0)
                    {

                        sqlCmdText = "INSERT INTO dbo.Alerts (Name, ProductID_CMS, isEmailAlert, isSMSAlert, isDisabled, AlertTypeID, isScheduledAlert, isEventDrivenAlert, EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody) " +
                                                "VALUES (@Name, @ProductID_CMS, @isEmailAlert, @isSMSAlert, 'false', 1007, 'false', 'true', @EmailMessageSubject, @EmailMessageBody, @SMSMessageSubject, @SMSMessageBody); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        AlertID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                                                     new SqlParameter("@ProductID_CMS", TransportHelperFunctions.convertStringEmptyToDBNULL(ProductID_CMS)),
                                                                                                                     new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                                                     new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                                                     new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                                                     new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                                                     new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                                                     new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody))));
                        sqlCmdText = "INSERT INTO dbo.EventAlerts (AlertID, EventTypeID) " +
                                                "VALUES (@AlertID, @EventTypeID)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@AlertID", AlertID),
                                                                                             new SqlParameter("@EventTypeID", EVENTTYPEID));
                    }
                    else
                    {
                        throw new Exception("There is another event driven alert by the name " + NAME);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts setNewEventAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return AlertID;
        }

        [System.Web.Services.WebMethod]
        public static void updateDemurrageAlert(int ALERTID, string NAME, bool isEmailAlert, bool isSMSAlert, int ALERTTIME, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)//, string PRODUCTID_CMS)
        {
            int rowCount;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 1)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, TriggerAfterXMinutes = @AlertTime, isScheduledAlert = 'true', isEventDrivenAlert = 'false', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID AND AlertTypeID = 1";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@AlertTime", ALERTTIME),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));
                    }
                    else
                    {
                        throw new Exception("There is another demurrage alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateDemurrageAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateCapacityAlert(int ALERTID, string NAME, decimal PERCENTAGE, bool isEmailAlert, bool isSMSAlert, int TankID, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (PERCENTAGE > 1 || PERCENTAGE <= 0)
                    { throw new Exception("Invalid capacity entered"); }


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 2)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    //if the name is changed or still the same, update
                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, Percentage = @Percentage, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, TankID = @TankID, isScheduledAlert = 'true', isEventDrivenAlert = 'false', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@Percentage", PERCENTAGE),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@TankID", TankID),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));
                    }
                    else
                    {
                        throw new Exception("There is another capacity alert by that name.");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateCapacityAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateInactiveAlert(int ALERTID, string NAME, int ALERTTIME, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 3)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, TriggerAfterXMinutes = @AlertTime, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, isScheduledAlert = 'true', isEventDrivenAlert = 'false', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID AND AlertTypeID = 3";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@AlertTime", ALERTTIME),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));
                    }
                    else
                    {
                        throw new Exception("There is another inactive alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateInactiveAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateDealBreakersAlert(int ALERTID, string NAME, int INSPECTIONHEADERID, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 4)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    //if the name is changed or still the same, update
                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, InspectionHeaderID = @InspectionHeaderID, isScheduledAlert = 'false', isEventDrivenAlert = 'true', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID AND AlertTypeID = 4";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));
                    }
                    else
                    {
                        throw new Exception("There is another capacity alert by that name.");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateDealBreakersAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateDropTrailerAlert(int ALERTID, string NAME, string ProductID_CMS, int DAYSINMINS, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount = 0;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 5)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, ProductID_CMS = @ProductID_CMS, TriggerAfterXMinutes = @DaysAfterArrivalAlert, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, isScheduledAlert = 'true', isEventDrivenAlert = 'false', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID AND AlertTypeID = 5";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@ProductID_CMS", ProductID_CMS),
                                                                                             new SqlParameter("@DaysAfterArrivalAlert", DAYSINMINS),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));
                    }
                    else
                    {
                        throw new Exception("There is another drop trailer storage alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateDropTrailerAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateCOFAUploadAlert(int ALERTID, string NAME, int ALERTTIME, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 6)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, TriggerAfterXMinutes = @AlertTime, isScheduledAlert = 'true', isEventDrivenAlert = 'false', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID AND AlertTypeID = 6";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@AlertTime", ALERTTIME),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));
                    }
                    else
                    {
                        throw new Exception("There is another demurrage alert by that name");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateCOFAUploadAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }




        [System.Web.Services.WebMethod]
        public static void updateEventAlert(int ALERTID, string NAME, string ProductID_CMS, int EVENTTYPEID, bool isEmailAlert, bool isSMSAlert, string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            int rowCount;
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    CheckAlertMessageLengths(EmailMessageSubject, EmailMessageBody, SMSMessageSubject, SMSMessageBody);
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Alerts WHERE (Name = @Name AND AlertID != @AlertID AND isDisabled = 'false' AND AlertTypeID = 1007)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME), new SqlParameter("@AlertID", ALERTID)));

                    if (rowCount == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Alerts SET Name = @Name, isEmailAlert = @isEmailAlert, isSMSAlert = @isSMSAlert, ProductID_CMS = @ProductID_CMS, isScheduledAlert = 'false', isEventDrivenAlert = 'true', " +
                                                "EmailMessageSubject = @EmailMessageSubject, EmailMessageBody = @EmailMessageBody, SMSMessageSubject = @SMSMessageSubject, SMSMessageBody = @SMSMessageBody WHERE AlertID = @AlertID AND AlertTypeID = 1007";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Name", NAME),
                                                                                             new SqlParameter("@isEmailAlert", isEmailAlert),
                                                                                             new SqlParameter("@isSMSAlert", isSMSAlert),
                                                                                             new SqlParameter("@ProductID_CMS", TransportHelperFunctions.convertStringEmptyToDBNULL(ProductID_CMS)),
                                                                                             new SqlParameter("@EmailMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageSubject)),
                                                                                             new SqlParameter("@EmailMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(EmailMessageBody)),
                                                                                             new SqlParameter("@SMSMessageSubject", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageSubject)),
                                                                                             new SqlParameter("@SMSMessageBody", TransportHelperFunctions.convertStringEmptyToDBNULL(SMSMessageBody)),
                                                                                             new SqlParameter("@AlertID", ALERTID));

                        sqlCmdText = "UPDATE dbo.EventAlerts SET EventTypeID = @EventTypeID WHERE AlertID = @AlertID";
                        rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventTypeID", EVENTTYPEID), new SqlParameter("@AlertID", ALERTID)));
                    }
                    else
                    {
                        throw new Exception("There is another event driven alert by the name " + NAME);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts updateEventAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        private static void CheckAlertMessageLengths(string EmailMessageSubject, string EmailMessageBody, string SMSMessageSubject, string SMSMessageBody)
        {
            if (EmailMessageSubject.Length > 50)
            {
                throw new Exception("Email Subject is too long");
            }
            if (EmailMessageBody.Length > 500)
            {
                throw new Exception("Email Body is too long");
            }
            if (SMSMessageSubject.Length > 50)
            {
                throw new Exception("Text Message Subject is too long");
            }
            if (SMSMessageBody.Length > 160)
            {
                throw new Exception("Text Message Subject is too long");
            }
        }

        [System.Web.Services.WebMethod]
        public static void disableAlert(int ALERTID, int ALERTTYPEID)
        {
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.Alerts SET isDisabled = 'true' WHERE AlertID = @AlertID AND AlertTypeID = @AlertTypeID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@AlertID", ALERTID), new SqlParameter("@AlertTypeID", ALERTTYPEID));

                    sqlCmdText = "UPDATE dbo.UserAlerts SET isDisabled = 'true' WHERE (AlertID = @AlertID AND AlertType = @AlertTypeID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@AlertID", ALERTID), new SqlParameter("@AlertTypeID", ALERTTYPEID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Alerts disableAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }


        [System.Web.Services.WebMethod]
        public static List<KeyValuePair<string, string>> getDemurrageTimeOptions()
        {
            var timeOptionsValues = new List<KeyValuePair<string, string>>();
            timeOptionsValues.Add(new KeyValuePair<string, string>("-", "Before Demurrage count down has ended"));
            timeOptionsValues.Add(new KeyValuePair<string, string>("+", "After Demurrage count down has ended"));

            return timeOptionsValues;
        }

        [System.Web.Services.WebMethod]
        public static int getDemurrageTimeInMins()
        {
            int demurrageTimeInMins = Int32.Parse(ConfigurationManager.AppSettings["demurrageMins"]);

            return demurrageTimeInMins;
        }
    }
}