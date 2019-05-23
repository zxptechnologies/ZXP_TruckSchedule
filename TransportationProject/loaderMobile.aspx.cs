using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.Transactions;
using Microsoft.ApplicationBlocks.Data;
using System.Data;

namespace TransportationProject
{
    public partial class loaderMobile : System.Web.UI.Page
    {
        protected static String sql_connStr;
        //public static ZXPUserData zxpUD = new ZXPUserData();
        void Page_PreInit(Object sender, EventArgs e)
        {
            if (Request.Browser.IsMobileDevice)
            {
                this.MasterPageFile = "~/Site.Mobile.master";
            }
            else
            {
                this.MasterPageFile = "~/Site.master";
            }


        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);

                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isLoader || zxpUD._isYardMule) //make sure this matches whats in Site.Master and Default
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
                        //Response.Redirect("/ErrorPage.aspx?ErrorCode=5", false); mi4 url
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }

                }
                else
                {
                    Response.BufferOutput = true;
                    //Response.Redirect("/Account/Login.aspx?ReturnURL=/dockManager.aspx", false); mi4 url
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/loaderMobile.aspx", false);//zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderMobile Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }//page_load()

        [System.Web.Services.WebMethod]
        public static Sample getSampleInformationForMSID(int MSID)
        {
            // DataSet dataSet = new DataSet();
            Sample sampleInfo = new Sample();

            try
            {

                string sqlCmdText;

                sqlCmdText = string.Concat("SELECT  MSID ,PODetailsID ,PONumber ,ProductID_CMS ,FileID ,Filepath ,FilenameOld ,SampleID, LotusID ,TimeSampleTaken ,TimeSampleSent ",
                        ",TimeSampleReceived ,didLabNotReceived ,Comments ,FilenameNew ,TestApproved ,TrailerNumber ,FirstName ,LastName ,bypassCOFAComment ,SpecificGravity ",
                        ",isOpenInCMS ,isRejected ,ProductName_CMS ",
                         "FROM dbo.vw_SampleGridData ",
                         "WHERE MSID = @pMSID ",
                         "ORDER BY TestApproved, didLabNotReceived, TimeSampleReceived");
                SqlDataReader reader = SqlHelper.ExecuteReader(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@pMSID", MSID));
                while (reader.Read())
                {

                    sampleInfo.MSID = reader.GetValueOrDefault<int>("MSID");
                    sampleInfo.PODetailsID = reader.GetValueOrDefault<int>("PODetailsID");
                    sampleInfo.PONumber = reader.GetValueOrDefault<int>("PONumber");
                    sampleInfo.ProductID_CMS = reader.GetValueOrDefault<string>("ProductID_CMS");
                    sampleInfo.FileID = reader.GetValueOrDefault<int>("FileID");
                    sampleInfo.Filepath = reader.GetValueOrDefault<string>("Filepath");
                    sampleInfo.FilenameOld = reader.GetValueOrDefault<string>("FilenameOld");
                    sampleInfo.SampleID = reader.GetValueOrDefault<int>("SampleID");
                    sampleInfo.LotusID = reader.GetValueOrDefault<string>("LotusID");
                    DateTime? tempTime = reader.GetValueOrDefault<DateTime>("TimeSampleTaken");
                    sampleInfo.TimeSampleTaken = tempTime == default(DateTime)? null: tempTime;
                    DateTime? tempTime2 = reader.GetValueOrDefault<DateTime>("TimeSampleReceived");
                    sampleInfo.TimeSampleReceived = tempTime == default(DateTime) ? null : tempTime2;
                    sampleInfo.didLabNotReceived = reader.GetValueOrDefault<int>("didLabNotReceived");
                    sampleInfo.Comments = reader.GetValueOrDefault<string>("Comments");
                    sampleInfo.FilenameNew = reader.GetValueOrDefault<string>("FilenameNew");
                    sampleInfo.TestApproved = reader.GetValueOrDefault<bool>("TestApproved");
                    sampleInfo.TrailerNumber = reader.GetValueOrDefault<string>("TrailerNumber");
                    sampleInfo.FirstName = reader.GetValueOrDefault<string>("FirstName");
                    sampleInfo.LastName = reader.GetValueOrDefault<string>("LastName");
                    sampleInfo.bypassCOFAComment = reader.GetValueOrDefault<string>("bypassCOFAComment");
                    sampleInfo.SpecificGravity = reader.GetValueOrDefault<int>("SpecificGravity");
                    sampleInfo.isOpenInCMS = reader.GetValueOrDefault<bool>("isOpenInCMS");
                    sampleInfo.isRejected = reader.GetValueOrDefault<bool>("isRejected");
                    sampleInfo.ProductName_CMS = reader.GetValueOrDefault<string>("ProductName_CMS");


                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile getSampleGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return sampleInfo;
        }


        [System.Web.Services.WebMethod]
        public static List<vw_LoaderMobileMainGridData> getLoaderMobileGrid()
        {
            List<vw_LoaderMobileMainGridData> gridData = new List<vw_LoaderMobileMainGridData>();

            try
            {

                string sqlCmdText = string.Concat( "SELECT MSID, StatusID, StatusText, TrailerNumber, SpotID, SpotDescription, " ,
                    "ProdID, ProdName, PODetailsID, PONumber, PONumber_ZXPOutbound, ETA FROM dbo.vw_LoaderMobileGridData");
                SqlDataReader reader = SqlHelper.ExecuteReader(sql_connStr, CommandType.Text, sqlCmdText);
                while (reader.Read())
                {

                    vw_LoaderMobileMainGridData rowEntry = new vw_LoaderMobileMainGridData();
                    rowEntry.MSID = reader.GetValueOrDefault<int>("MSID");
                    rowEntry.StatusID = reader.GetValueOrDefault<int>("StatusID");
                    rowEntry.StatusName = reader.GetValueOrDefault<string>("StatusText");
                    rowEntry.TrailerNumber = reader.GetValueOrDefault<string>("TrailerNumber"); ;
                    rowEntry.SpotID = reader.GetValueOrDefault<int>("SpotID"); ;
                    rowEntry.SpotName = reader.GetValueOrDefault<string>("SpotDescription");
                    rowEntry.ProductID_CMS = reader.GetValueOrDefault<string>("ProdID");
                    rowEntry.ProductName_CMS = reader.GetValueOrDefault<string>("ProdName");
                    rowEntry.PODetailsID = reader.GetValueOrDefault<int>("PODetailsID");
                    rowEntry.PONumber = reader.GetValueOrDefault<int>("PONumber").ToString();
                    rowEntry.PONumber_ZXPOutbound = reader.GetValueOrDefault<string>("PONumber_ZXPOutbound");
                    rowEntry.ETA = reader.GetValueOrDefault<DateTime>("ETA");

                    gridData.Add(rowEntry);
                }

            }

            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderMobile getLoaderMobileGrid(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile getLoaderMobileGrid(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return gridData;

        }

        [System.Web.Services.WebMethod]
        public static List<vw_LoadAndUnloadRequests> getLoadAndUnloadRequests(int MSID)
        {
            List<vw_LoadAndUnloadRequests> requestsData = new List<vw_LoadAndUnloadRequests>();
            try
            { 

                string sqlCmdText = "SELECT RequestID, RequestTypeID, TimeRequestStart, TimeRequestEnd FROM dbo.vw_LoadAndUnloadRequests WHERE MSID = @msid";
                SqlDataReader reader = SqlHelper.ExecuteReader(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                while (reader.Read())
                {

                    int RequestID = reader.GetValueOrDefault<int>("RequestID");
                    int RequestTypeID = reader.GetValueOrDefault<int>("RequestTypeID");
                    DateTime? TimeRequestStart = reader.GetValueOrDefault<DateTime>("TimeRequestStart"); 
                    DateTime?  TimeRequestEnd = reader.GetValueOrDefault<DateTime>("TimeRequestEnd");

                    TimeRequestStart = TimeRequestStart == default(DateTime) ? null : TimeRequestStart;
                    TimeRequestEnd = TimeRequestEnd == default(DateTime) ? null : TimeRequestEnd;

                    vw_LoadAndUnloadRequests request = new vw_LoadAndUnloadRequests(RequestID, MSID, RequestTypeID, TimeRequestStart, TimeRequestEnd);
                    requestsData.Add(request);
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderMobile getLoadAndUnloadRequests(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile getLoadAndUnloadRequests(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return requestsData;
        }

        [System.Web.Services.WebMethod]
        public static DateTime startRequest(int requestID, int requestTypeID, int MSID)
        {
            DateTime timeStamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText = string.Empty;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (requestTypeID == 1) //Load
                    {
                        //loader - EventTypeID = 15 --> "Loading Started"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 15, @TIME, @LOADER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    }
                    else if (requestTypeID == 2) //Unload
                    {
                        //loader  - EventTypeID = 13 --> "Unloading Started"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 13, @TIME, @LOADER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    }
                    else if (requestTypeID == 3) //Other
                    {
                        //loader  - EventTypeID = 2030 --> "Loader Assignment Started"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 2030, @TIME, @LOADER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    }
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@LOADER", zxpUD._uid)));

                    ChangeLog Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "Assignee", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), eventID, "RequestID", requestID.ToString(), "RequestID", requestID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Requests SET Assignee = @LOADER WHERE RequestID = @RID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOADER", zxpUD._uid),
                                                                                         new SqlParameter("@RID", requestID));

                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                    "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@EID", eventID));
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderMobile startRequest(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile startRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return timeStamp;
        }

        [System.Web.Services.WebMethod]
        public static DateTime completeRequest(int requestID, int requestTypeID, int MSID)
        {
            SqlConnection sqlConn = new SqlConnection();
            DateTime timeStamp = DateTime.Now;

            try
            {

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                sqlConn = new SqlConnection();
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = string.Empty;
                int eventID = 0;
                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                if (requestTypeID == 1) //Load
                {
                    MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 16, null, timeStamp, zxpUD._uid, false);
                    string newAlertMsg = createCustomMessageForCompletedTask(requestID);
                    eventID = msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, "Loading Finished. " + newAlertMsg);
                }
                else if (requestTypeID == 2) //Unload
                {
                    MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 14, null, timeStamp, zxpUD._uid, false);
                    string newAlertMsg = createCustomMessageForCompletedTask(requestID);
                    eventID = msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, "Unloading Finished. " + newAlertMsg);
                }
                else if (requestTypeID == 3) //Other
                {
                    MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 2031, null, timeStamp, zxpUD._uid, false);
                    string newAlertMsg = createCustomMessageForCompletedTask(requestID);
                    eventID = msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, newAlertMsg);
                }

                if (eventID == 0)
                {
                    throw new Exception("Invalid eventID. Error creating new event log.");
                }

                using (var scope = new TransactionScope())
                {
                    sqlQuery = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@RID", requestID), new SqlParameter("@EID", eventID));

                    sqlQuery = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSID", MSID), new SqlParameter("@TIME", timeStamp));



                    sqlConn = new SqlConnection(new TruckScheduleConfigurationKeysHelper().sql_connStr);
                    ChangeLog Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderMobile completeRequest(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile completeRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {

                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return timeStamp;
        }

        [System.Web.Services.WebMethod]
        public static bool CheckInspectionValidationSetting()
        {
            bool ValidationSetting = false;
            try
            {
                ValidationSetting = InspectionsHelperFunctions.CheckInspectionValidationSetting(sql_connStr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile CheckInspectionValidationSetting(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return ValidationSetting;
            
        }

        [System.Web.Services.WebMethod]
        public static List<object> canInspectionBeEdited(int prodDetailID, int MSInspectionListID, int MSInspectionID)
        {

            List<object> returnObj = new List<object>();
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                returnObj = InspectionsHelperFunctions.canInspectionBeEdited(prodDetailID, MSInspectionListID, MSInspectionID, sql_connStr, zxpUD);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile canInspectionBeStarted(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return returnObj;
        }

        [System.Web.Services.WebMethod]
        public static List<object> setInspectionResult(int MSInspectionID, int testID, int result, int prodDetailID)
        {
            //DateTime timestamp = DateTime.Now; //Initialize the timestamp here
            //String returnMsg = String.Empty;
            //bool isDealBreaker = false;
            //bool isLastQuestion = false;  
            //int verInspID = 0;
            //bool hasEnded = false;
            List<object> returnData = new List<object>();
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                returnData = InspectionsHelperFunctions.setInspectionResult(MSInspectionID, testID, result, prodDetailID, sql_connStr, zxpUD);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile setInspectionResult(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            
            //returnData.Add(timestamp);
            //returnData.Add(returnMsg);
            //returnData.Add(hasEnded);
            //returnData.Add(isLastQuestion);
            return returnData;
        }


        [System.Web.Services.WebMethod]
        public static List<object[]> getRequestInformationForAlert(int RequestID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP 1 ISNULL(Task, ''), ISNULL(Comment, ''), RT.RequestType , U.FirstName, U.LastName, ISNULL(MS.TrailerNumber, '') " +
                                          "FROM dbo.Requests R " +
                                          "INNER JOIN dbo.RequestTypes RT ON R.RequestTypeID = RT.RequestTypeID " +
                                          "INNER JOIN dbo.MainSchedule MS ON R.MSID = MS.MSID " +
                                          "INNER JOIN dbo.Users U ON U.UserID = R.Assignee " +
                                          "WHERE MS.isHidden = 0 AND R.isVisible = 1 AND R.RequestID = @REQUESTID";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@REQUESTID", RequestID));

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
                string strErr = " Exception Error in loaderMobile getRequestInformationForAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static string createCustomMessageForCompletedTask(int RequestID)
        {
            string customMessage = string.Empty;
            try
            {
                List<object[]> taskInfo = getRequestInformationForAlert(RequestID);
                if (taskInfo.Count > 0)
                {
                    string Task = string.Empty, Comment = string.Empty, RequestType = string.Empty,
                           FirstName = string.Empty, LastName = string.Empty, TrailerNumber = string.Empty;

                    Task = taskInfo[0][0].ToString();
                    Comment = taskInfo[0][1].ToString();
                    RequestType = taskInfo[0][2].ToString();
                    FirstName = taskInfo[0][3].ToString();
                    LastName = taskInfo[0][4].ToString();
                    TrailerNumber = taskInfo[0][5].ToString();

                    customMessage = "The " + RequestType + " task has been completed. Details: " + System.Environment.NewLine +
                            "Task: " + Task + System.Environment.NewLine +
                            "Completed by : " + FirstName + " " + LastName + System.Environment.NewLine +
                            "For Trailer : " + TrailerNumber + System.Environment.NewLine +
                            "Addition Comments on task: " + Comment + System.Environment.NewLine;

                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderMobile createCustomMessageForCompletedTask(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile createCustomMessageForCompletedTask(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
            }
            return customMessage;
        }



        [System.Web.Services.WebMethod]
        public static DataSet GetPOdetailsData(int prodDetailID)
        {
            DataSet dsPODetails = new DataSet();

            try
            {
                dsPODetails = InspectionsHelperFunctions.GetPOdetailsData(prodDetailID, sql_connStr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile GetPOdetailsData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }



            return dsPODetails;
        }

  



        [System.Web.Services.WebMethod]
        public static List<object[]> getInspectionList(int MSID, string ProductID_CMS)
        {
            List<object[]> data = new List<object[]>();
            try
            {
                int prodDetailID = InspectionsHelperFunctions.getPOdetailsIDForMSIDandProduct(MSID, ProductID_CMS, sql_connStr);
                if (0 != prodDetailID)
                {
                    data = InspectionsHelperFunctions.getInspectionList(prodDetailID, sql_connStr);
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile getInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
          
            return data;

        }


        [System.Web.Services.WebMethod]
        public static InspectionList getMSInspectionListAndData(int MSID, string ProductID_CMS, int InspectionListID)
        {
            InspectionList inspList = new InspectionList();
            try
            {
                int prodDetailID = InspectionsHelperFunctions.getPOdetailsIDForMSIDandProduct(MSID, ProductID_CMS, sql_connStr);
                if (0 != prodDetailID)
                {
                    inspList = InspectionsHelperFunctions.getMSInspectionListAndData(prodDetailID, InspectionListID, sql_connStr);
                }


            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderMobile getMSInspectionListAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return inspList;

        }




    }
}