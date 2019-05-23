using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;

namespace TransportationProject
{
    public partial class loaderTimeTracking : System.Web.UI.Page
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
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isLoader) //make sure this matches whats in Site.Master and Default
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
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false);//zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/loaderTimeTracking.aspx", false);
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderTimeTracking Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderTimeTracking Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

        }

        [System.Web.Services.WebMethod]
        public static Object getloaderTimeTrackingGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int assigneeID;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (zxpUD._isAdmin)
                    {
                        assigneeID = 0;
                    }
                    else
                    {
                        assigneeID = zxpUD._uid;
                    }

                    //gets data specific data from table and save into readable format
                    //sqlCmdText = "SELECT * FROM ( " +
                    //                "SELECT R.MSID, MS.PONumber, R.RequestID, R.Task, R.Assignee, R.Requester, R.Comment, R.RequestPersonTypeID, R.RequestTypeID, MS.DockSpotID, TD.SpotDescription, U.FirstName AS LoaderFirstName, U.LastName AS LoaderLastName, " +
                    //                "U2.FirstName AS RequesterFirstName, U2.LastName AS RequesterLastName,  " +
                    //                "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSRE.EventID = MSE1.EventID WHERE (isHidden = 'false') AND (MSE1.MSID = R.MSID) AND (MSRE.RequestID = R.RequestID) AND (EventTypeID = 2027 ) ORDER BY TimeStamp DESC ) TimeRequestSent, " +
                    //                "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSRE.EventID = MSE1.EventID WHERE (isHidden = 'false') AND (MSE1.MSID = R.MSID) AND (MSRE.RequestID = R.RequestID) AND (EventTypeID = 2030 OR EventTypeID = 13 OR EventTypeID = 15) ORDER BY TimeStamp DESC ) TimeRequestStart, " +
                    //                "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSRE.EventID = MSE1.EventID WHERE (isHidden = 'false') AND (MSE1.MSID = R.MSID) AND (MSRE.RequestID = R.RequestID) AND (EventTypeID = 2031 OR EventTypeID = 14 OR EventTypeID = 16) ORDER BY TimeStamp DESC ) TimeRequestEnd, " +
                    //                "RT.RequestType, RequestDueDateTime, MS.isRejected, MS.TrailerNumber, MS.isOpenInCMS, " +
                    //                "MS.currentDockSpotID, (SELECT TDS3.SpotDescription FROM dbo.TruckDockSpots AS TDS3 WHERE MS.currentDockSpotID = TDS3.SpotID) AS CurrentSpot, " +
                    //                "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS, MS.ETA " +
                    //                "FROM Requests R " +
                    //                "LEFT JOIN MainSchedule MS ON MS.MSID = R.MSID " +
                    //                "LEFT JOIN Users U ON U.UserID = R.Assignee " +
                    //                "INNER JOIN Users U2 ON U2.UserID = R.Requester " +
                    //                "INNER JOIN RequestTypes RT on RT.RequestTypeID = R.RequestTypeID " +
                    //                "LEFT JOIN TruckDockSpots TD ON TD.SpotID = MS.DockSpotID " +
                    //                "LEFT JOIN (SELECT MSID, COUNT(PODetailsID) AS PDCount, " +
                    //                "(SELECT TOP 1 PD_A.ProductID_CMS " +
                    //                "FROM dbo.PODetails PD_A " +
                    //                "INNER JOIN dbo.ProductsCMS PCMS_A ON PD_A.ProductID_CMS = PCMS_A.ProductID_CMS " +
                    //                "WHERE PD_A.MSID =  PD.MSID " +
                    //                ") AS topProdID  " +
                    //                "FROM dbo.PODetails PD  " +
                    //                "GROUP BY MSID " +
                    //                ") ProdDet ON ProdDet.MSID = MS.MSID " +
                    //                "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = ProdDet.topProdID " +
                    //                "WHERE RequestPersonTypeID = 1 AND isVisible = 1 AND (MS.isHidden = 0 OR MS.isHidden IS NULL) " +  //RequestPersonTypeID = 1 to get loader related requests
                    //    //"AND (R.Assignee = @ASSIGNUID OR @ASSIGNUID = 0) " +
                    //                ") AllData " +
                    //                "WHERE (TimeRequestEnd > DATEADD(HOUR, -1, CURRENT_TIMESTAMP) OR TimeRequestEnd IS NULL) OR " +
                    //                "((SELECT DATEADD(dd, DATEDIFF(dd, 0, ETA), 0)) = (SELECT CAST (GETDATE() as DATE)) OR " +
                    //                "(SELECT DATEADD(dd, DATEDIFF(dd, 0, ETA), 0)) = (SELECT DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1))) " +
                    //                "ORDER BY RequestDueDateTime, TimeRequestSent";
                    sqlCmdText = string.Concat("SELECT MSID, PONumber, RequestID, Task, Assignee, Requester, Comment, RequestPersonTypeID, RequestTypeID, ",
                        "DockSpotID, SpotDescription, LoaderFirstName, LoaderLastName, RequesterFirstName, RequesterLastName, ",
                        "TimeRequestSent, TimeRequestStart, TimeRequestEnd, RequestType, RequestDueDateTime, isRejected, TrailerNumber ",
                        ", isOpenInCMS, currentDockSpotID, CurrentSpot, ProdCount, topProdID, ProductName_CMS, ETA ",
                        "FROM dbo.vw_LoaderTimeTrackingRequestGridData ",
                        "ORDER BY RequestDueDateTime, TimeRequestSent");
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
                string strErr = " Exception Error in LoaderTimeTracking getloaderTimeTrackingGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void setTankStrapping(int MSID, Boolean isStart, TankStrapping tStrap)
        {
            try
            {

                DateTime timeStamp = DateTime.Now;

                using (var scope = new TransactionScope())
                {

                    string sqlCmdText = "SELECT COUNT(*) FROM dbo.TankStrappings WHERE MSID = @MSID AND isStartStrap = @START";
                    int count = Convert.ToInt16(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@START", isStart)));
                    if (count > 0)
                    {// update
                        sqlCmdText = string.Concat("Update dbo.TankStrappings ",
                         "SET Temp = @Temp, Feet = @Feet , Inches = @Inches , FractionNumerator = @fNum, FractionDenominator = @fDenom, ",
                         "GallonFtInConverted = @FtInGal, GallonFractionConverted = @GalFrac , GallonTotal = @GalTotal, TankNum = @TankNum , Flush = @Flush ",
                          "WHERE MSID = @MSID AND isStartStrap = @isStart ");
                        //TODO ADD CHANGELOG

                    }
                    else
                    {//insert
                        sqlCmdText = string.Concat("INSERT INTO dbo.TankStrappings ",
                          "(MSID, isStartStrap, Temp, Feet, Inches, FractionNumerator, FractionDenominator, ",
                          "GallonFtInConverted, GallonFractionConverted, GallonTotal, TankNum, Flush) ",
                           "VALUES(@MSID, @isStart, @Temp, @Feet, @Inches, @fNum, @fDenom, @FtInGal, @GalFrac, @GalTotal, @TankNum, @Flush )");


                        //TODO ADD CHANGELOG
                    }

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@isStart", tStrap.isStrapStart),
                                                                                         new SqlParameter("@Temp", tStrap.Temp),
                                                                                         new SqlParameter("@Feet", tStrap.Feet),
                                                                                         new SqlParameter("@Inches", tStrap.Inches),
                                                                                         new SqlParameter("@fNum", tStrap.Numerator),
                                                                                         new SqlParameter("@fDenom", tStrap.Denominator),
                                                                                         new SqlParameter("@FtInGal", tStrap.GallonsConvertedFromFtAndIn),
                                                                                         new SqlParameter("@GalFrac", tStrap.GallonsConvertedFromFraction),
                                                                                         new SqlParameter("@GalTotal", tStrap.GallonsTotal),
                                                                                         new SqlParameter("@TankNum", tStrap.TankNum),
                                                                                         new SqlParameter("@Flush", tStrap.Flush)
                                                                                         );


                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking setTankStrapping(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }

            
        }


        [System.Web.Services.WebMethod]
        public static TankStrapping getTankStrapping(int MSID, Boolean isStart)
        {
            TankStrapping tStrap = new TankStrapping();
            DataSet dataSet = new DataSet();

            try
            {

                string sqlCmdText;
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = string.Concat("SELECT MSID, isStartStrap, TankNum, isNull(Temp, 0) Temp, isNull(Feet,0) Feet , isNull(Inches,0) Inches ",
                            ",isNull(FractionNumerator,0) FractionNumerator, isNull(FractionDenominator,0) FractionDenominator ",
                            ",isNull(GallonFtInConverted,0) GallonFtInConverted,isNull(GallonFractionConverted,0) GallonFractionConverted,isNull(GallonTotal,0) GallonTotal, isNull(Flush,0) Flush ",
                            "FROM dbo.TankStrappings ",
                            "WHERE MSID = @MSID AND isStartStrap = @START");

                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                            new SqlParameter("@START", isStart));


                //populate return object
                if(dataSet.Tables[0].Rows.Count > 0)
                {
                    System.Data.DataRow row = dataSet.Tables[0].Rows[0];

                    tStrap.MSID = Convert.ToInt16(row["MSID"]);
                    tStrap.isStrapStart = Convert.ToBoolean(row["isStartStrap"]);
                    tStrap.Temp = Convert.ToSingle(row["Temp"]);
                    tStrap.Feet = Convert.ToInt16(row["Feet"]);
                    tStrap.Inches = Convert.ToInt16(row["Inches"]);
                    tStrap.Numerator = Convert.ToInt16(row["FractionNumerator"]);
                    tStrap.Denominator = Convert.ToInt16(row["FractionDenominator"]);
                    tStrap.GallonsConvertedFromFtAndIn = Convert.ToSingle(row["GallonFtInConverted"]);
                    tStrap.GallonsConvertedFromFraction = Convert.ToSingle(row["GallonFractionConverted"]);
                    tStrap.GallonsTotal = Convert.ToSingle(row["GallonTotal"]);
                    tStrap.TankNum = Convert.ToInt16(row["TankNum"]);
                    tStrap.Flush = Convert.ToSingle(row["Flush"]);
                }


            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking getTankStrapping(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return tStrap;
        }



        [System.Web.Services.WebMethod]
        public static Object GetSpots()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT -999 AS SpotID, '(None)' AS SpotDescription, NULL AS SpotType UNION " +
                                    "(SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots WHERE isDisabled = 0) ORDER BY SpotDescription";

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
                string strErr = " Exception Error in LoaderTimeTracking GetSpots(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
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
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking startRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return timeStamp;
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
                string strErr = " Exception Error in LoaderTimeTracking getRequestInformationForAlert(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in loaderTimeTracking createCustomMessageForCompletedTask(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderTimeTracking createCustomMessageForCompletedTask(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in loaderTimeTracking completeRequest(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderTimeTracking completeRequest(). Details: " + ex.ToString();
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
        public static void updateRequest(int requestID, string comments)
        {
            DateTime timeStamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    // 1) Find request type
                    sqlCmdText = "SELECT ISNULL(Assignee, 0) FROM dbo.Requests WHERE RequestID = @RID";
                    int loader = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID)));

                    if (loader == 0)
                    {
                        sqlCmdText = "UPDATE dbo.Requests SET Assignee = @LOADER WHERE RequestID = @RID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                             new SqlParameter("@LOADER", zxpUD._uid));
                    }

                    // 2) Find MSID 
                    sqlCmdText = "SELECT MSID FROM dbo.Requests WHERE RequestID = @RID";
                    int MSID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID)));

                    // 3) log into mainschedule events
                    //loader  - EventTypeID = 2028 --> "Loader Assignment Updated"
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, Timestamp, UserId, isHidden) " +
                            "VALUES (@MSID, 2028, @TIME, @LOADER, 'false'); " +
                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@LOADER", zxpUD._uid)));

                    ChangeLog Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "Comment", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, comments.ToString(), eventID, "RequestID", requestID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    //4) set comment in request table
                    sqlCmdText = "UPDATE dbo.Requests SET Comment = @COMMENT " +
                                    "WHERE (RequestID = @RID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@COMMENT", TransportHelperFunctions.convertStringEmptyToDBNULL(comments)),
                                                                                         new SqlParameter("@RID", requestID));

                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    //4) add event to MainScheduleRequestEvents
                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@EID", eventID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking updateRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
          
        [System.Web.Services.WebMethod]
        public static void undoCompleteRequest(int MSID, int requestType)
        {
            DateTime now = DateTime.Now;
            int EventTypeID = 0;
            int EventTypeIDForHidden = 0;
            int eventID = 0;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    switch (requestType)
                    {
                        case 1:
                            EventTypeID = 3047; //Undo Loading Finished
                            EventTypeIDForHidden = 16; //Loading Finished
                            break;
                        case 2:
                            EventTypeID = 3045; //Undo Unloading Finished
                            EventTypeIDForHidden = 14; //Unloading Finished
                            break;
                        case 3:
                            EventTypeID = 3049; //Undo Loader Assignment Completed
                            EventTypeIDForHidden = 2031; //Loader Assignment Completed
                            break;
                    }
                    if (EventTypeID != 0 && EventTypeIDForHidden != 0)
                    {
                        //gets data specific data from table and save into readable format
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, @EventTypeID, 'false');" +
                                                 "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE (isHidden = 'false') AND (MSID = @MSID) AND (EventTypeID = @EventTypeIDHidden)";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", now),
                                                                                                                     new SqlParameter("@EventTypeID", EventTypeID),
                                                                                                                     new SqlParameter("@EventTypeIDHidden", EventTypeIDForHidden)));
                    }
                    else
                    {
                        throw new Exception("EventTypeID and EventTypeIDForHidden can not be 0.");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking undoCompleteRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoStartRequest(int MSID, int requestType, int reqID)
        {
            DateTime now = DateTime.Now;
            int EventTypeID = 0;
            int EventTypeIDForHidden = 0;
            int eventID = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    switch (requestType)
                    {
                        case 1:
                            EventTypeID = 3046; //Undo Loading Started
                            EventTypeIDForHidden = 15; //Loading Started
                            break;
                        case 2:
                            EventTypeID = 3044; //Undo Unloading Started
                            EventTypeIDForHidden = 13; //Unloading Started
                            break;
                        case 3:
                            EventTypeID = 3048; //Undo Loader Assignment Started
                            EventTypeIDForHidden = 2030; //Loader Assignment Started
                            break;
                    }

                    if (EventTypeID != 0 && EventTypeIDForHidden != 0)
                    {
                        //gets data specific data from table and save into readable format
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, @EventTypeID, 0); " +
                                            "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = @EventTypeIDHidden); " +
                                            "SELECT SCOPE_IDENTITY()";

                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", now),
                                                                                                                     new SqlParameter("@EventTypeID", EventTypeID),
                                                                                                                     new SqlParameter("@EventTypeIDHidden", EventTypeIDForHidden)));
                    }
                    else
                    {
                        throw new Exception("EventTypeID and EventTypeIDForHidden can not be 0.");
                    }

                    sqlCmdText = "UPDATE dbo.Requests SET Assignee = NULL WHERE RequestID = @RID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking undoStartRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
        [System.Web.Services.WebMethod]
        public static Object GetLogDataByMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            try
            {
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                TruckLogHelperFunctions.logByMSIDConnection(sql_connStr, MSID, data);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderTimeTracking GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderTimeTracking GetLogDataByMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetLogList()
        {
            List<object[]> data = new List<object[]>();
            try
            {
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                TruckLogHelperFunctions.logListConnection(sql_connStr, data);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderTimeTracking GetLogList(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderTimeTracking GetLogList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {

            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getCompletedRequestData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //TODO: Modify query to show only active requests + recently finished requests (maybe recently finished today) 
                    sqlCmdText = "SELECT * FROM ( " +
                                    "SELECT R.MSID, MS.PONumber, R.RequestID,  R.Task, " +
                                    "(SELECT URS.FirstName FROM dbo.Users as URS WHERE R.Requester = URS.UserID) RequesterFirstName, " +
                                    "(SELECT URS.LastName FROM dbo.Users as URS WHERE R.Requester = URS.UserID) RequesterLastName, " +
                                    "(SELECT URS.FirstName FROM dbo.Users as URS WHERE R.Assignee = URS.UserID) AssigneeFirstName, " +
                                    "(SELECT URS.LastName FROM dbo.Users as URS WHERE R.Assignee = URS.UserID) AssigneeLastName, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN (2027) ORDER BY TimeStamp DESC) TimeRequestSent, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN (2030, 13, 15)  ORDER BY TimeStamp DESC) TimeRequestStart, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN  (2031, 14, 16) ORDER BY TimeStamp DESC) TimeRequestEnd, " +
                                    "R.Comment, TDS.SpotDescription, R.TrailerNumber, RequestDueDateTime, MS.TruckType, MS.isRejected, MS.isOpenInCMS " +
                                    "FROM Requests R " +
                                    "INNER JOIN MainScheduleRequestEvents MSRE ON R.RequestID = MSRE.RequestID " +
                                    "INNER JOIN MainScheduleEvents MSE1 ON MSRE.EventID = MSE1.EventID " +
                                    "LEFT JOIN MainSchedule MS ON MS.MSID = MSE1.MSID " +
                                    "LEFT JOIN TruckDockSpots TDS ON TDS.SpotID = MS.DockSpotID " +
                                    "WHERE  (MS.isHidden = 0 OR MS.isHidden IS NULL) AND isVisible = 1 AND EventTypeID IN (2031, 14, 16) AND MSE1.isHidden = 0 " +
                                    ") ALLDATA WHERE (DATEADD(dd, 0, DATEDIFF(dd, 0, TimeRequestEnd)) = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) " +
                                    "ORDER BY PONumber";

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
                string strErr = " Exception Error in LoaderTimeTracking getCompletedRequestData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void AddFileDBEntry(int MSID, string fileType, string filenameOld, string filenameNew, string filepath, string fileDescription)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //First find filetypeID
                    sqlCmdText = "SELECT FileTypeID FROM dbo.FileTypes WHERE FileType = @FTYPE";
                    int filetypeID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FTYPE", fileType)));

                    switch (fileType)
                    {
                        case "BOL":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                            "VALUES (@PMSID, 4101, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                        case "COFA":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                            "VALUES (@PMSID, 4097, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                        default: // generic files
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                            "VALUES (@PMSID, 4099, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                    }
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                        new SqlParameter("@NOW", timestamp),
                                                                                                                        new SqlParameter("@UserID", zxpUD._uid)));

                    sqlCmdText = "INSERT INTO dbo.MainScheduleFiles (MSID, FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld, isHidden) " +
                                        "VALUES (@PMSID, @PFTID, @PDESC, @PFPATH, @PFNEW, @PFOLD, 0);" +
                                        "SELECT SCOPE_IDENTITY()";

                    int newFileID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                        new SqlParameter("@PFTID", filetypeID),
                                                                                                                        new SqlParameter("@PDESC", fileDescription),
                                                                                                                        new SqlParameter("@PFPATH", filepath),
                                                                                                                        new SqlParameter("@PFNEW", filenameNew),
                                                                                                                        new SqlParameter("@PFOLD", filenameOld)));


                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "MSID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, MSID.ToString(), eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FileTypeID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, filetypeID.ToString(), eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FileDescription", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, fileDescription.ToString(), eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "Filepath", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filepath.ToString(), eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FilenameNew", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filenameNew.ToString(), eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FilenameOld", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filenameOld.ToString(), eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "False", eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking AddFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static string[] ProcessFileAndData(string filename, string strUploadType)
        //public static string[] ProcessFileAndData(int MSID, string filename, string strUploadType)
        {

            try
            {
                string[] newFileAndPath = TransportHelperFunctions.ProcessFileAndData(filename, strUploadType);
                return newFileAndPath;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

            return null;
        }


        [System.Web.Services.WebMethod]
        public static string verifyIfInspectionIsDoneBeforeUnload(int MSID)
        {
            int numberOfOpenInspections = 0;
            int numberOfInspections = 0;
            string returnString = null;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT ISNULL(COUNT(*),0) FROM dbo.MainScheduleInspections WHERE MSID = @MSID AND isHidden = 'false' AND InspectionEndEventID IS NULL";
                    numberOfOpenInspections = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (numberOfOpenInspections == 0)
                    {
                        sqlCmdText = "SELECT ISNULL(COUNT(*), 0) FROM dbo.MainScheduleInspections WHERE MSID = @MSID AND isHidden = 'false'";
                        numberOfInspections = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                        if (numberOfInspections == 0)
                        {
                            returnString = "hasNotStartedInspections";
                        }
                    }
                    else
                    {
                        returnString = "hasOpenInspections";
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking verifyIfInspectionIsDoneBeforeUnload(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnString;
        }


        [System.Web.Services.WebMethod]
        public static Object GetPODetailsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT PD.PODetailsID, PD.ProductID_CMS, PD.QTY, PD.LotNumber, PD.UnitOfMeasure, PCMS.ProductName_CMS " +
                                    "FROM dbo.PODetails PD " +
                                    "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = PD.ProductID_CMS " +
                                    "WHERE PD.MSID = @MSID ORDER BY PD.ProductID_CMS ";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

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
                string strErr = " Exception Error in LoaderTimeTracking GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object checkStatusOfRequest(int reqID)
        {
            List<int> returnData = new List<int>();
            DataSet dataSet = new DataSet();
            bool doesRequestExist = false;
            bool isAvailableForUserToEdit = false;
            int eventType = 0;
            int assigneeUserID = 0;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP(1) MSRE.RequestID, MSE.EventTypeID, MSE.TimeStamp, Users.UserID, UserName from dbo.MainScheduleRequestEvents as MSRE " +
                                        "INNER JOIN dbo.MainScheduleEvents as MSE ON MSRE.EventID = MSE.EventID " +
                                        "INNER JOIN dbo.Requests R ON R.RequestID = MSRE.RequestID " +
                                        "LEFT JOIN dbo.Users ON R.Assignee = Users.UserID " +
                                        "WHERE MSRE.RequestID = @RequestID AND MSE.isHidden = 'false' AND " +
                                        "(EventTypeID = 13 OR EventTypeID = 14 OR EventTypeID = 15 OR EventTypeID = 16 OR EventTypeID = 2027 OR EventTypeID = 2030 OR EventTypeID = 2031) " +
                                        "ORDER BY TimeStamp DESC";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RequestID", reqID));

                    if (dataSet.Tables[0].Rows.Count > 0)
                    {
                        if (dataSet.Tables[0].Rows[0]["UserID"].Equals(DBNull.Value))
                        {
                            assigneeUserID = 0;
                        }
                        else
                        {
                            assigneeUserID = Convert.ToInt16(dataSet.Tables[0].Rows[0]["UserID"]);
                        }
                        eventType = Convert.ToInt16(dataSet.Tables[0].Rows[0]["EventTypeID"]);

                        if (eventType == 2027) //created
                        {
                            doesRequestExist = true;
                            isAvailableForUserToEdit = true;
                        }
                        else
                        {
                            if (assigneeUserID == zxpUD._uid)
                            {
                                isAvailableForUserToEdit = true;
                            }
                            else
                            {
                                isAvailableForUserToEdit = false;
                            }
                        }
                    }
                    else
                    {
                        doesRequestExist = false;
                        isAvailableForUserToEdit = false;
                    }
                    returnData.Add(Convert.ToInt16(doesRequestExist));
                    returnData.Add(Convert.ToInt16(isAvailableForUserToEdit));
                    returnData.Add(eventType);
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking checkStatusOfRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static Object GetFileUploadsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT FileID, MSID, MSF.FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld FROM dbo.MainScheduleFiles MSF " +
                                    "INNER JOIN dbo.FileTypes FT ON FT.FileTypeID = MSF.FileTypeID " +
                                    "WHERE isHidden = 0 AND MSID = @PMSID AND (MSF.FileTypeID = 3 OR MSF.FileTypeID = 4)";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID));

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
                string strErr = " Exception Error in LoaderTimeTracking GetFileUploadsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static void UpdateFileUploadData(int fileID, string description)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleFiles", "FileDescription", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, description, null, "FileID", fileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainScheduleFiles SET FileDescription=@DESC WHERE FileID = @FID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@DESC", TransportHelperFunctions.convertStringEmptyToDBNULL(description)),
                                                                                         new SqlParameter("@FID", TransportHelperFunctions.convertStringEmptyToDBNULL(fileID)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking UpdateFileUploadData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void DeleteFileDBEntry(int fileID, string fileType, int MSID)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    switch (fileType)
                    {
                        case "BOL":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                            "VALUES (@PMSID, 4102, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                        case "COFA":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                            "VALUES (@PMSID, 4098, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                        default: // generic files
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                            "VALUES (@PMSID, 4100, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                    }
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                     new SqlParameter("@NOW", timestamp),
                                                                                                                     new SqlParameter("@UserID", zxpUD._uid)));

                    sqlCmdText = "UPDATE dbo.MainScheduleFiles SET isHidden = 1 WHERE fileID = @PFID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PFID", fileID));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "True", eventID, "FileID", fileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking DeleteFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static bool checkIfTruckIsOnSite(int MSID)
        {
            string location;
            bool isOnSite = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT LocationShort FROM dbo.MainSchedule WHERE MSID = @MSID";
                    location = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (location != "NOS")
                    {
                        isOnSite = true;
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in LoaderTimeTracking checkIfTruckIsOnSite(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isOnSite;
        }

    }
}