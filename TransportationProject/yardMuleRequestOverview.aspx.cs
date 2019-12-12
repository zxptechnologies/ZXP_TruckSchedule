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
    public partial class yardMuleRequestOverview : System.Web.UI.Page
    {
      
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

                    if (!(zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isYardMule)) //make sure this matches whats in Site.Master and Default
                    {
                        Response.BufferOutput = true;
                        Response.Redirect("/ErrorPage.aspx?ErrorCode=5", false);
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("/Account/Login.aspx?ReturnURL=/yardMuleRequestOverview.aspx", false);
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in yardMuleRequestOverview Page_Load(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in yardMuleRequestOverview Page_Load(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

        }

        [System.Web.Services.WebMethod]
        public static Object getYardMuleRequestGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int AssigneeID;

            try
            {
                
                    string sqlCmdText;
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                if (zxpUD._isAdmin)
                    {
                        AssigneeID = 0;
                    }
                    else
                    {
                        AssigneeID = zxpUD._uid;
                    }


                    sqlCmdText = string.Concat( "SELECT MSID, PONumber, RequestID, Task, Assignee, Requester, Comment , NewSpotID ",
                        ", AssignedDockSpot, NewSpot, OldSpot, AssigneeFirstName, AssigneeLastName ",
                        ", RequesterFirstName, RequesterLastName, TimeRequestSent, TimeRequestStart, TimeRequestEnd ",
                        ", RequestDueDateTime, isRejected, TrailerNumber, Location, Status, isOpenInCMS ",
                        ", currentDockSpotID, CurrentSpot, ProdCount, topProdID, ProductName_CMS, SpotReserveTime ",
                        "FROM dbo.vw_YardmuleRequestsGridData");
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", AssigneeID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getYardMuleRequestGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetPODetailsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

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
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;

        }

        [System.Web.Services.WebMethod]
        public static void updateRequest(int requestID, string comments)
        {
            DateTime Now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //1. select MSID based on requestID
                    sqlCmdText = "SELECT MSID FROM dbo.Requests WHERE RequestID = @RID";
                    int MSID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID)));

                    //2.log into mainschedule events
                    //yard mule  - EventTypeID = 2026 --> "Yard Mule Request Updated"
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 2026, @TIME, @YM, 'false'); " +
                                    "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", Now),
                                                                                                                     new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@YM", zxpUD._uid)));
                    //3. log event into Main Schedule Request Events
                    ChangeLog Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", Now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", Now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                            "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@EID", eventID));
                    //4. update comment in request
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Request", "Comment", Now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, comments.ToString(), eventID, "RequestID", requestID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Requests SET Comment = @COMMENT " +
                                    "WHERE (RequestID = @RID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@COMMENT", TransportHelperFunctions.convertStringEmptyToDBNULL(comments)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

        }

        [System.Web.Services.WebMethod]
        public static DateTime startRequest(int requestID, int MSID)
        {
            DateTime timeStamp = DateTime.Now;

            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //1. log into Main Schedule Events
                    //yard mule  - EventTypeID = 21 --> "Yard Mule Request started"
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 21, @TIME, @YM, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@YM", zxpUD._uid)));
                    //2. log into Main Schedule Request Events
                    ChangeLog Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                        "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@EID", eventID));
                    //3. update assignee in request
                    Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Request", "Assignee", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, zxpUD._uid.ToString(), eventID, "RequestID", requestID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Requests SET Assignee = @YM WHERE RequestID = @RID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@YM", zxpUD._uid),
                                                                                         new SqlParameter("@RID", requestID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview startRequest(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return timeStamp;
        }

        [System.Web.Services.WebMethod]
        public static DateTime completeRequest(int requestID, int MSID)
        {
            List<object[]> spotData = new List<object[]>();
            DataSet dataSet = new DataSet();
            DateTime timeStamp = DateTime.Now;
            ChangeLog Cl;
            int eventID;
            string spotID = null;
            int spotIDInt = 0;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramRID = new SqlParameter("@RID", SqlDbType.Int);
                    paramRID.Value = requestID;
                    int yardmule = zxpUD._uid;

                    //1)get spot and spot type
                    sqlCmdText = "SELECT NewSpotID, TDS.SpotType FROM dbo.Requests R INNER JOIN dbo.TruckDockSpots TDS ON TDS.SpotID = R.NewSpotID WHERE RequestID = @RID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID));

                    // 2) log into mainschedule events

                    if (dataSet.Tables[0].Rows.Count != 0)
                    {
                        spotID = Convert.ToString(dataSet.Tables[0].Rows[0]["NewSpotID"]);
                        spotIDInt = Convert.ToInt32(dataSet.Tables[0].Rows[0]["NewSpotID"]);
                    }

                    if (spotData.Count > 0)
                    {
                        if (!string.IsNullOrEmpty(spotData[0][0].ToString()) && MSID > 0)  //if request was a truck move, update location and last updated
                        {
                            if (spotData[0][1].ToString().ToUpper().Equals("BULK"))
                            {
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                "VALUES (@MSID, 6, @TIME, @YM, 'false'); " +
                                                "SELECT SCOPE_IDENTITY()";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timeStamp),
                                                                                                                             new SqlParameter("@YM", yardmule)));

                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "DOCKBULK", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TransportHelperFunctions.convertStringEmptyToDBNULL(spotID).ToString(), eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();


                                sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, LocationShort = 'DOCKBULK', currentDockSpotID = @SPOT, StatusID = 5  WHERE MSID = @MSID;";
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp),
                                                                                                     new SqlParameter("@SPOT", spotIDInt),
                                                                                                     new SqlParameter("@MSID", eventID));
                            }
                            else if (Convert.ToString(dataSet.Tables[0].Rows[0]["SpotType"]).ToUpper().Equals("VAN"))
                            {
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                "VALUES (@MSID, 5, @TIME, @YM, 'false'); " +
                                                "SELECT SCOPE_IDENTITY()";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timeStamp),
                                                                                                                             new SqlParameter("@YM", yardmule)));

                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "DOCKVAN", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TransportHelperFunctions.convertStringEmptyToDBNULL(spotID).ToString(), eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();

                                sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, LocationShort = 'DOCKVAN', currentDockSpotID = @SPOT, StatusID = 5  WHERE MSID = @MSID;";
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp),
                                                                                                     new SqlParameter("@SPOT", spotIDInt),
                                                                                                     new SqlParameter("@MSID", eventID));

                            }
                            else if (Convert.ToString(dataSet.Tables[0].Rows[0]["SpotType"]).ToUpper().Equals("WAIT"))
                            {
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                "VALUES (@MSID, 4, @TIME, @YM, 'false'); " +
                                                "SELECT SCOPE_IDENTITY()";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timeStamp),
                                                                                                                             new SqlParameter("@YM", yardmule)));

                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "WAIT", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();

                                sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, LocationShort = 'WAIT', StatusID = 5, currentDockSpotID = NULL  WHERE MSID = @MSID;"; //, DockSpotID = @SPOT - removed, not needed 
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp),
                                                                                                     new SqlParameter("@MSID", eventID));

                            }
                            else if (Convert.ToString(dataSet.Tables[0].Rows[0]["SpotType"]).ToUpper().Equals("YARD"))
                            {
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                "VALUES (@MSID, 3065, @TIME, @YM, 'false'); " +
                                                "SELECT SCOPE_IDENTITY()";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timeStamp),
                                                                                                                             new SqlParameter("@YM", yardmule)));

                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "YARD", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();
                                Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                                Cl.CreateChangeLogEntryIfChanged();

                                sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, LocationShort = 'YARD', StatusID = 5, currentDockSpotID = NULL WHERE MSID = @MSID;";//, DockSpotID = @SPOT - removed, not needed 
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp),
                                                                                                     new SqlParameter("@MSID", MSID));

                            }
                        }
                    }
                    //yard mule  - EventTypeID = 18 --> "Yard Mule Request completed"
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                            "VALUES (@MSID, 18, @TIME, @YM, 'false'); " +
                            "SELECT SCOPE_IDENTITY()";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                 new SqlParameter("@TIME", timeStamp),
                                                                                                                 new SqlParameter("@YM", yardmule)));

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
                string strErr = " Exception Error in YardMuleRequestOverview completeRequest(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return timeStamp;
        }

        [System.Web.Services.WebMethod]
        public static Object getCompletedRequestData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT * FROM ( " +
                                    "SELECT R.MSID, MS.PONumber, R.RequestID,  R.Task, " +
                                    "(SELECT URS.FirstName FROM dbo.Users as URS WHERE R.Requester = URS.UserID) RequesterFirstName, " +
                                    "(SELECT URS.LastName FROM dbo.Users as URS WHERE R.Requester = URS.UserID) RequesterLastName, " +
                                    "(SELECT URS.FirstName FROM dbo.Users as URS WHERE R.Assignee = URS.UserID) AssigneeFirstName, " +
                                    "(SELECT URS.LastName FROM dbo.Users as URS WHERE R.Assignee = URS.UserID) AssigneeLastName, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN (17) ORDER BY TimeStamp DESC) TimeRequestSent, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN (21)  ORDER BY TimeStamp DESC) TimeRequestStart, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN  (18) ORDER BY TimeStamp DESC) TimeRequestEnd, " +
                                    "R.Comment, TDS.SpotDescription, R.TrailerNumber, RequestDueDateTime, MS.TruckType, MS.isRejected, MS.isOpenInCMS " +
                                    "FROM Requests R " +
                                    "INNER JOIN MainScheduleRequestEvents MSRE ON R.RequestID = MSRE.RequestID " +
                                    "INNER JOIN MainScheduleEvents MSE1 ON MSRE.EventID = MSE1.EventID " +
                                    "LEFT JOIN MainSchedule MS ON MS.MSID = MSE1.MSID " +
                                    "LEFT JOIN TruckDockSpots TDS ON TDS.SpotID = MS.DockSpotID " +
                                    "WHERE  (MS.isHidden = 0 OR MS.isHidden IS NULL) AND isVisible = 1 AND EventTypeID IN (18) AND MSE1.isHidden = 0 " +
                                    ") ALLDATA WHERE (DATEADD(dd, 0, DATEDIFF(dd, 0, TimeRequestEnd)) = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) " +
                                    "ORDER BY PONumber";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getCompletedRequestData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void undoCompleteRequest(int MSID, int reqID)
        {
            DateTime timeStamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //generic type - no need to change status or location
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3042, 'false'); " +
                                        "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = (SELECT TOP (1) MSE.EventID FROM dbo.MainScheduleEvents AS MSE " +
                                        "INNER JOIN dbo.MainScheduleRequestEvents AS MSRE ON MSRE.EventID = MSE.EventID " +
                                        "WHERE MSE.MSID = @MSID AND MSE.isHidden = 'false' AND MSRE.RequestID = @RID AND MSE.EventTypeID = 18)";

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramUserID = new SqlParameter("@UserId", SqlDbType.Int);
                    SqlParameter paramTimeStamp = new SqlParameter("@TimeStamp", SqlDbType.DateTime);
                    SqlParameter paramRequestID = new SqlParameter("@RID", SqlDbType.Int);

                    paramMSID.Value = MSID;
                    paramUserID.Value = zxpUD._uid;
                    paramTimeStamp.Value = timeStamp;
                    paramRequestID.Value = reqID;
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@UserId", zxpUD._uid),
                                                                                         new SqlParameter("@TimeStamp", timeStamp),
                                                                                         new SqlParameter("@RID", reqID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview undoCompleteRequest(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoStartRequest(int MSID, int reqID)
        {
            DateTime timeStamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 21); " +
                                            "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3043, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", timeStamp)));

                    ChangeLog Cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Request", "Assignee", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, null, eventID, "RequestID", reqID.ToString());
                    Cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Requests SET Assignee = NULL WHERE RequestID = @RID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview undoStartRequest(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetLogDataByMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            try
            {
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                TruckLogHelperFunctions.logByMSIDConnection(sql_connStr, MSID, data);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in YardMuleRequestOverview GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview GetLogDataByMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
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
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                TruckLogHelperFunctions.logListConnection(sql_connStr, data);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in YardMuleRequestOverview GetLogList(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview GetLogList(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //1. find filetypeID
                    sqlCmdText = "SELECT FileTypeID FROM dbo.FileTypes WHERE FileType = @FTYPE";
                    int filetypeID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FTYPE", fileType)));

                    //2. create event Main Schedule Events
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
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0", eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static string[] ProcessFileAndData(string filename, string strUploadType)
        {
            try
            {
                string[] newFileAndPath = TransportHelperFunctions.ProcessFileAndData(filename, strUploadType);
                return newFileAndPath;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in yardMuleRequestOverview ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static Object getAvailableDockSpots(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            string truckType;

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.TruckType FROM dbo.MainSchedule AS MS WHERE MS.MSID = @MSID";
                    truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (truckType == "Van")
                    {
                        sqlCmdText = "SELECT SpotID, SpotDescription FROM TruckDockSpots Where SpotType = 'Van' AND isDisabled = 0 ORDER BY SpotDescription";
                    }
                    else
                    {
                        sqlCmdText = "SELECT SpotID, SpotDescription FROM TruckDockSpots Where SpotType = 'Bulk' AND isDisabled = 0 ORDER BY SpotDescription";
                    }
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetLocationOptions(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //get current location
                    sqlCmdText = "SELECT TOP (1) MS.LocationShort, L.LocationLong, " +
                                     "(SELECT S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS currentStatus " +
                                     "FROM dbo.MainSchedule as MS " +
                                     "INNER JOIN dbo.Locations L ON MS.LocationShort = L.LocationShort WHERE MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    data.Add(dataSet.Tables[0].Rows[0].ItemArray);

                    //get truck type
                    sqlCmdText = "SELECT MS.TruckType FROM dbo.MainSchedule AS MS WHERE MSID = @MSID";
                    string truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (truckType.ToLower() == "van")
                    {
                        //get location based on van type
                        sqlCmdText = "SELECT L.LocationShort, LocationLong " +
                                                "FROM dbo.LocationStatusRelation LSR " +
                                                "INNER JOIN dbo.Locations L ON LSR.LocationShort = L.LocationShort " +
                                                "INNER JOIN dbo.Status S ON S.StatusID = LSR.StatusID " +
                                                "WHERE S.StatusID = 7 AND L.LocationShort != 'DOCKBULK'" + // status 7 = sampling
                                                "ORDER BY LocationShort, SortOrder ";
                    }
                    else
                    {
                        //get location based on bulk type
                        sqlCmdText = "SELECT L.LocationShort, LocationLong " +
                                                "FROM dbo.LocationStatusRelation LSR " +
                                                "INNER JOIN dbo.Locations L ON LSR.LocationShort = L.LocationShort " +
                                                "INNER JOIN dbo.Status S ON S.StatusID = LSR.StatusID " +
                                                "WHERE S.StatusID = 7 AND L.LocationShort != 'DOCKVAN'" + // status 7 = sampling
                                                "ORDER BY LocationShort, SortOrder ";
                    }
                    dataSet = new DataSet();
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview GetLocationOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void updateLocationAndUndoRequestComplete(int MSID, string newLoc, int dockSpot, int ReqID)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3042, 'false'); " +
                        "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = (SELECT TOP (1) MSE.EventID FROM dbo.MainScheduleEvents AS MSE " +
                        "INNER JOIN dbo.MainScheduleRequestEvents AS MSRE ON MSRE.EventID = MSE.EventID " +
                        "WHERE MSE.MSID = @MSID AND MSE.isHidden = 'false' AND MSRE.RequestID = @RequestID AND MSE.EventTypeID = 18)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@UserId", zxpUD._uid),
                                                                                         new SqlParameter("@TimeStamp", now),
                                                                                         new SqlParameter("@RequestID", ReqID));
                    switch (newLoc)
                    {
                        case "WAIT":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@MSID, 4, @TimeStamp, @userID, 'false')" +
                                                "SELECT SCOPE_IDENTITY()";
                            break;
                        case "DOCKBULK":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@MSID, 6, @TimeStamp, @userID, 'false')" +
                                                "SELECT SCOPE_IDENTITY()";
                            break;
                        case "YARD":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@MSID, 3065, @TimeStamp, @userID, 'false')" +
                                                "SELECT SCOPE_IDENTITY()";
                            break;
                        case "DOCKVAN":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@MSID, 5, @TimeStamp, @userID, 'false')" +
                                                "SELECT SCOPE_IDENTITY()";
                            break;
                    }

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TimeStamp", now),
                                                                                                                     new SqlParameter("@userID", zxpUD._uid)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, newLoc.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();


                    if (newLoc == "DOCKBULK" || newLoc == "DOCKVAN")
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, dockSpot.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = 5, LastUpdated = @TimeStamp, currentDockSpotID = @dockSpotID WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc),
                                                                                             new SqlParameter("@TimeStamp", now),
                                                                                             new SqlParameter("@dockSpotID", TransportHelperFunctions.convertStringEmptyToDBNULL(dockSpot)),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = 5, LastUpdated = @TimeStamp WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc),
                                                                                             new SqlParameter("@TimeStamp", now),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview updateLocationAndUndoRequestComplete(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static bool checkRequestTypeBeforeUndoComplete(int reqID)
        {
            bool requiresNewLocation = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //check request type 
                    sqlCmdText = "SELECT RequestTypeID FROM dbo.Requests WHERE RequestID = @RID";
                    int RequestTypeID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID)));

                    if (RequestTypeID != 3) //'other' (request) type does not have a location change thus location doesnt not need to be selected after mover undone
                    {
                        requiresNewLocation = true;
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview checkRequestTypeBeforeUndoComplete(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return requiresNewLocation;
        }

        [System.Web.Services.WebMethod]
        public static int verifySpotIsCurrentlyAvailable(int MSID, int spotID)
        {
            string DayofWeekID;
            int rowCount = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    DayofWeekID = TransportationProject.trailerOverview.GetDayOfWeekID(DateTime.Today);
                    //check request type 
                    sqlCmdText = "SELECT count(*) from dbo.MainSchedule as MS " +
                                          "WHERE MS.currentDockSpotID = @SpotID AND MSID != @MSID";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotID", spotID),
                                                                                                                  new SqlParameter("@MSID", MSID)));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview verifySpotIsCurrentlyAvailable(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static Object verifySpotIsAvailableInSchedule(int MSID, int spotID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            string DayofWeekID;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    DayofWeekID = TransportationProject.trailerOverview.GetDayOfWeekID(DateTime.Today);

                    //check request type 
                    sqlCmdText = "DECLARE @undoTime DATETIME, @timeBlockDuration DECIMAL, @endTimeProcessed DATETIME, @MinMSID INT, @MaxID INT " +
                                            "SELECT @MinMSID = MIN(MSID), @MaxID = MAX(MSID) FROM dbo.MainSchedule " +
                                            "SET @undoTime = GETDATE() " +
                                            "SET @timeBlockDuration = (SELECT TDS.HoursInTimeBlock FROM dbo.TruckDockSpots as TDS INNER JOIN dbo.TruckDockSpotTimeslots AS TDST ON TDST.SpotID = TDS.SpotID " +
                                            "WHERE TDS.SpotID = @SpotID AND TDST.DayOfWeekID = @DayofWeekID AND TDST.isOpen = 'true') " +
                                            "WHILE (@MinMSID IS NOT NULL AND @MinMSID <= @MaxID) " +
                                            "BEGIN " +
                                            "IF(@SpotID != (SELECT DockSpotID FROM MainSchedule WHERE MSID = @MinMSID)) " +
                                            "BEGIN " +
                                            "SET @MinMSID = @MinMSID + 1 " +
                                            "END " +
                                            "ELSE " +
                                            "BEGIN " +
                                            "IF ((SELECT COUNT (*) FROM MainSchedule WHERE MSID = @MinMSID) = 0) " +
                                            "SET @MinMSID = @MinMSID + 1 " +
                                            "ELSE " +
                                            "BEGIN " +
                                            "SET @endTimeProcessed = (SELECT ETA FROM MainSchedule WHERE MSID = @MinMSID) " +
                                            "SET @endTimeProcessed = DATEADD(second, ((@timeBlockDuration) * 60 * 60), @endTimeProcessed)  " +
                                            "IF( @undoTime <= @endTimeProcessed AND @undoTime >= (SELECT ETA FROM MainSchedule WHERE MSID = @MinMSID)) " +
                                            "BEGIN " +
                                            "SELECT MS.PONumber, MS.TrailerNumber, MS.ETA, @endTimeProcessed, " +
                                            "(SELECT LocationLong FROM dbo.Locations WHERE LocationShort = MS.LocationShort), (SELECT StatusText FROM dbo.Status WHERE StatusID = MS.StatusID) " +
                                            "FROM dbo.MainSchedule AS MS WHERE MSID = @MinMSID " +
                                            "SET @MinMSID = @MinMSID + 1 " +
                                            "END " +
                                            "ELSE " +
                                            "SET @MinMSID = @MinMSID + 1 " +
                                            "END " +
                                            "END " +
                                            "END ";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotID", spotID),
                                                                                                  new SqlParameter("@DayofWeekID", DayofWeekID));

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
                string strErr = " Exception Error in YardMuleRequestOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static bool checkIfUserIsAssignee(int requestID)
        {
            bool isSignedInUserAssignee = false;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT Assignee FROM dbo.Requests WHERE RequestID = @RID";

                    int yardmule = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID)));
                    if (yardmule == zxpUD._uid)
                    {
                        isSignedInUserAssignee = true;
                    }
                    else
                    {
                        isSignedInUserAssignee = false;
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview checkIfUserIsAssignee(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return isSignedInUserAssignee;
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP(1) MSRE.RequestID, MSE.EventTypeID, MSE.TimeStamp, Users.UserID, UserName from dbo.MainScheduleRequestEvents as MSRE " +
                                    "INNER JOIN dbo.MainScheduleEvents as MSE ON MSRE.EventID = MSE.EventID " +
                                    "INNER JOIN dbo.Requests R ON R.RequestID = MSRE.RequestID " +
                                    "LEFT JOIN dbo.Users ON R.Assignee = Users.UserID " +
                                    "WHERE MSRE.RequestID = @RequestID AND MSE.isHidden = 'false' AND " +
                                    "(EventTypeID = 17 OR EventTypeID = 18 OR EventTypeID = 21) " +
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
                        eventType = Convert.ToInt32(dataSet.Tables[0].Rows[0]["EventTypeID"]);

                        if (eventType == 17) //created
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


                    returnData.Add(Convert.ToInt32(doesRequestExist));
                    returnData.Add(Convert.ToInt32(isAvailableForUserToEdit));
                    returnData.Add(eventType);

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT FileID, MSID, MSF.FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld FROM dbo.MainScheduleFiles MSF " +
                                    "INNER JOIN dbo.FileTypes FT ON FT.FileTypeID = MSF.FileTypeID " +
                                    "WHERE isHidden = 0 AND MSID = @MSID AND (MSF.FileTypeID = 3 OR MSF.FileTypeID = 4)";

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
                string strErr = " Exception Error in YardMuleRequestOverview GetFileUploadsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.MainScheduleFiles SET FileDescription=@DESC WHERE FileID = @FID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@DESC", TransportHelperFunctions.convertStringEmptyToDBNULL(description)),
                                                                                         new SqlParameter("@FID", TransportHelperFunctions.convertStringEmptyToDBNULL(fileID)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleFiles", "FileDescription", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, description, null, "FileID", fileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview UpdateFileUploadData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
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
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    switch (fileType)
                    {
                        case "BOL":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                                    "VALUES (@PMSID, 4102, @NOW, @UserID, 0); " +
                                                    "SELECT SCOPE_IDENTITY()";
                            break;
                        case "COFA":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                                    "VALUES (@PMSID, 4098, @NOW, @UserID, 0); " +
                                                    "SELECT SCOPE_IDENTITY()";
                            break;
                        default: // generic files
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                                    "VALUES (@PMSID, 4100, @NOW, @UserID, 0); " +
                                                    "SELECT SCOPE_IDENTITY()";
                            break;
                    }
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                     new SqlParameter("@NOW", timestamp),
                                                                                                                     new SqlParameter("@UserID", zxpUD._uid)));
                    sqlCmdText = "UPDATE dbo.MainScheduleFiles SET isHidden = 1 WHERE fileID = @PFID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PFID", fileID));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "FileID", fileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardMuleRequestOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }
    }
}