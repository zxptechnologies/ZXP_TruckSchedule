using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;
using TransportationProjectDataLayer;
using System.Linq;


namespace TransportationProject.Scripts
{
    public partial class guardStation : System.Web.UI.Page
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

                    if (!(zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isGuard || zxpUD._isAccountManager)) //make sure this matches whats in Site.Master and Default
                    {
                       
                        Response.BufferOutput = true;
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); 
                    }
                    

                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/guardStation.aspx", false);
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in guardStation Page_Load(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in guardStation Page_Load(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

        }

        [System.Web.Services.WebMethod]
        //public static Object GetLocationOptions()
        public static List<TransportationProjectDataLayer.ViewModels.vm_Locations> GetLocationOptions()
        {
            
            List<TransportationProjectDataLayer.ViewModels.vm_Locations> vmLocations = new List<TransportationProjectDataLayer.ViewModels.vm_Locations>();
            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.Locations> locations = dProvider.GetLocations();

                vmLocations = locations.Select<TransportationProjectDataLayer.DomainModels.Locations, TransportationProjectDataLayer.ViewModels.vm_Locations>(x => x).ToList();

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation GetLocationOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vmLocations;
        }

        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_dd_Status> GetStatusOptions()
        {
            
            List<TransportationProjectDataLayer.ViewModels.vm_dd_Status> vmddStatuses = new List<TransportationProjectDataLayer.ViewModels.vm_dd_Status>();
            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.Status> statuses = new List<TransportationProjectDataLayer.DomainModels.Status>();
                statuses = dProvider.GetStatuses();
                vmddStatuses = statuses.Select<TransportationProjectDataLayer.DomainModels.Status, TransportationProjectDataLayer.ViewModels.vm_dd_Status>(x => x).ToList();

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation GetStatusOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vmddStatuses;
        }

        [System.Web.Services.WebMethod]
        public static Object getGuardStationGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            //gets DB info
            //todo add isPostBack check, cant currently 
            try
            {
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlCmdText;

                sqlCmdText = string.Concat(" SELECT  PONumber, MSID, GuardStationComment,ETA,DocumentVerificationTS,TimeArrived ",
                        ",TimeDeparted, TrailerNumber, Cab1Number,  Cab2Number, isRejected,BlanketPOReleaseNumber ",
                        ",DriverName, DriverPhoneNumber, StatusID ",
                        ", LocationShort, TruckType, LoadType, DockSpot, isDropTrailer, CarrierInfo, isOpenInCMS ",
                        ", LoadTypeLong, TruckTypeLong, ProdCount, topProdID, ProductName_CMS, PONumber_ZXPOutbound ",
                        "FROM dbo.vw_GuardStationGridData ",
                        "ORDER BY ETA, PoNumber");
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation getGuardStationGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }




        [System.Web.Services.WebMethod]
        public static bool checksIfIsDropTrailerBeforeLaunchingApp(int MSID)
        {
            bool isDropTrailer = false;

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                //gets data specific data from table and save into readable format
                sqlCmdText = "SELECT isDropTrailer FROM MainSchedule WHERE MSID = @MSID";
                isDropTrailer = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checksIfIsDropTrailerBeforeLaunchingApp(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return isDropTrailer;
        }

        
        [System.Web.Services.WebMethod]
        public static string getParameterForScanner(int MSID)
        {
            ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
            //build param string
            string parameter = MSID.ToString() + zxpUD._uid.ToString();
                return parameter;
         
        }

        [System.Web.Services.WebMethod]
        public static string launchAppAndUpdateWeight(int MSID, string weightType)
        {
            bool isDropTrailer = checksIfIsDropTrailerBeforeLaunchingApp(MSID);
           // System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
            try
            {
                //build param skin
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string parameter = MSID.ToString() + " " + weightType.ToString() + " " + zxpUD._uid.ToString() + " " + isDropTrailer.ToString();
                return parameter;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in guardStation launchAppAndUpdateWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return string.Empty;
        }

        [System.Web.Services.WebMethod]
        public static void checkIn(int MSID)
        {
            DataSet dataSet = new DataSet();
            DateTime currentTimestamp = DateTime.Now;
            DateTime scheduledTime;
            DateTime newScheduleTime;
            string truckType;
            bool isDroptTrailer;
            ChangeLog cLog;
            bool isUrgent = false;
            int PONumber;
            MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //get ETA 
                    sqlCmdText = "SELECT MS.ETA, MS.TimeArrived, isDropTrailer, ISNULL(MS.isUrgent, 'false') AS isUrgent, PONumber FROM dbo.MainSchedule AS MS WHERE MS.MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    scheduledTime = Convert.ToDateTime(dataSet.Tables[0].Rows[0]["ETA"]);
                    isUrgent = Convert.ToBoolean(dataSet.Tables[0].Rows[0]["isUrgent"]);
                    PONumber = Convert.ToInt32(dataSet.Tables[0].Rows[0]["PONumber"]);

                    newScheduleTime = scheduledTime.AddMinutes(15);
                    TimeSpan timeDiff = currentTimestamp.Subtract(scheduledTime);
                    isDroptTrailer = Convert.ToBoolean(dataSet.Tables[0].Rows[0]["isDropTrailer"]);

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramUserID = new SqlParameter("@UserId", SqlDbType.Int);
                    SqlParameter paramTimeStamp = new SqlParameter("@TimeStamp", SqlDbType.DateTime);

                    paramMSID.Value = MSID;
                    paramUserID.Value = zxpUD._uid;
                    paramTimeStamp.Value = currentTimestamp;

                    //Disabled based on request from Matt Mitcham to disable auto creation of yard mule requests- 9/21/2018 
                    ////if isDroptTrailer
                    //if (isDroptTrailer == true)
                    //{
                    //    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, Timestamp, UserId, isHidden) " +
                    //                            "VALUES (@MSID, 17, @TimeStamp, @UserId, 'false'); " +
                    //                            "SELECT SCOPE_IDENTITY()";
                    //    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                    //                                                                                                     new SqlParameter("@TimeStamp", currentTimestamp),
                    //                                                                                                     new SqlParameter("@UserId", zxpUD._uid)));
                    //    sqlCmdText = "INSERT INTO dbo.Requests (MSID, Requester, RequestPersonTypeID, RequestTypeID, isVisible) " +
                    //                    "VALUES (@MSID, @UserId, 2, 5, 1); " +
                    //                    "SELECT SCOPE_IDENTITY()";
                    //    int requestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                    //                                                                                                       new SqlParameter("@UserId", zxpUD._uid)));


                    //    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "MSID", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, MSID.ToString(), eventID, "RequestID", requestID.ToString());
                    //    cLog.CreateChangeLogEntryIfChanged();
                    //    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Requester", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), eventID, "RequestID", requestID.ToString());
                    //    cLog.CreateChangeLogEntryIfChanged();
                    //    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "RequestPersonTypeID", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "2", eventID, "RequestID", requestID.ToString());
                    //    cLog.CreateChangeLogEntryIfChanged();
                    //    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "RequestTypeID", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "RequestID", requestID.ToString());
                    //    cLog.CreateChangeLogEntryIfChanged();
                    //    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "isVisible", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "RequestID", requestID.ToString());
                    //    cLog.CreateChangeLogEntryIfChanged();

                    //    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                    //                    "VALUES(@RID, @EID)";
                    //    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                    //                                                                         new SqlParameter("@EID", eventID));
                    //}

                    //check if PO has already been checked in
                    if (dataSet.Tables[0].Rows[0]["TimeArrived"].Equals(DBNull.Value) || dataSet.Tables[0].Rows[0]["TimeArrived"].ToString() == "")
                    {
                        //if timeArrived > ETA by at least 15 mins use arrived time as demurrage start time
                        if (timeDiff.Days > 0 || timeDiff.Hours > 0 || timeDiff.Minutes > 15)
                        {
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 1025, 'false')";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                 new SqlParameter("@UserId", zxpUD._uid),
                                                                                                 new SqlParameter("@TimeStamp", currentTimestamp));
                        }
                        else//if timeArrived is within 15 mins of ETA demurrage start time is ETA
                        {
                            //update timestamp value 
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 1025, 'false')";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                 new SqlParameter("@UserId", zxpUD._uid),
                                                                                                 new SqlParameter("@TimeStamp", scheduledTime));
                        }

                        //gets data specific data from table and save into readable format
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 2, 'false'); " +
                                     "SELECT SCOPE_IDENTITY()";
                        int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                         new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                         new SqlParameter("@TimeStamp", currentTimestamp)));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "2", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "GS", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 2, LocationShort = 'GS', LastUpdated = @TimeStamp WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", currentTimestamp),
                                                                                             new SqlParameter("@MSID", MSID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TimeArrived", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, currentTimestamp.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        //set checkin ts in main schedule
                        sqlCmdText = "UPDATE dbo.MainSchedule SET TimeArrived = @TimeStamp WHERE @MSID = MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", currentTimestamp),
                                                                                             new SqlParameter("@MSID", MSID));

                        //get truck type
                        sqlCmdText = "SELECT TruckType FROM dbo.MainSchedule WHERE MSID = @MSID";
                        truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                        if (truckType == "Bulk")
                        {
                            DataSet dataSet2 = new DataSet();
                            //if truck type is Bulk, create samples for product
                            sqlCmdText = "SELECT PODetailsID FROM dbo.PODetails as POD WHERE MSID = @MSID";
                            dataSet2 = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                            int sampleID = 0;

                            if (dataSet2.Tables[0].Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow row2 in dataSet2.Tables[0].Rows)
                                {
                                    sampleID = 0;
                                    //EventTypeID = 2036= Sample Created
                                    //create a event for each product
                                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 2036, @TimeStamp, @UserId, 'false'); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                    int sampleCreatedEventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                                  new SqlParameter("@TimeStamp", currentTimestamp),
                                                                                                                                                  new SqlParameter("@UserId", zxpUD._uid)));
                                    //create sample for each product
                                    sqlCmdText = "INSERT INTO dbo.Samples(PODetailsID, isHidden, SampleCreatedEventID) VALUES (@PODID, 0, @EID); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                    sampleID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PODID", row2.ItemArray[0].ToString().Trim()),
                                                                                                                                  new SqlParameter("@EID", sampleCreatedEventID)));
                                    //PODetailsID
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "PODetailsID", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, row2.ItemArray[0].ToString().Trim(), eventID, "SampleID", sampleID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    //isHidden
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "isHidden", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "0", eventID, "SampleID", sampleID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    //SampleCreatedEventID
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "SampleCreatedEventID", currentTimestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, sampleCreatedEventID.ToString(), eventID, "SampleID", sampleID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                            }
                        }
                        if (isUrgent == true)
                        {
                            MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 8099, null, currentTimestamp, zxpUD._uid, false);
                            string customMessage = createCustomUrgentTruckMessage(MSID);
                            int UrgentEventID = msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, customMessage);
                        }

                    }
                    else
                    { throw new Exception("Truck is already been checked in. Please refresh the page for the lastest data."); }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkIn(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static bool doesTruckHaveIncompleteOrFailedInspections(int MSID)
        {
            string TruckType;
            bool hasIncompleteTests = false;
            try
            {
               
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT TruckType FROM dbo.MainSchedule WHERE MSID = @MSID";
                TruckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                
                sqlCmdText = string.Concat("SELECT ISNULL(COUNT(MSInspectionID), 0) FROM dbo.vw_InspectionsResultsForAllTrucks ",
                    "WHERE (InspectionEndEventID IS NULL OR isFailed = 1 OR Result = -999) AND MSID = @MSID");


                int numOpenInspection = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                if (numOpenInspection > 0 && TruckType.ToLower() != "van")
                {
                    hasIncompleteTests = true;
                }

                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation doesTruckHaveIncompleteOrFailedInspections(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return hasIncompleteTests;
        }

        [System.Web.Services.WebMethod]
        public static bool doesTruckHaveExistingInspections(int MSID)
        {
            bool hasExistingInspections = false;
            string TruckType;
            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                sqlCmdText = "SELECT TruckType FROM dbo.MainSchedule WHERE MSID = @MSID";
                TruckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                sqlCmdText = "SELECT ISNULL(COUNT(MSInspectionID), 0) FROM dbo.vw_InspectionsResultsForAllTrucks WHERE MS.MSID = @MSID";
                int numInspection = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                if (numInspection > 0 && TruckType.ToLower() != "van")
                {
                    hasExistingInspections = true;
                }
                else if (TruckType.ToLower() == "van")
                {
                    hasExistingInspections = true;

                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation doesTruckHaveExistingInspections(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return hasExistingInspections;
        }

        [System.Web.Services.WebMethod]
        public static bool doesTruckHaveOpenRequests(int MSID)
        {
            bool hasIncompleteRequests = false;
            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT " +
                                "(	SELECT COUNT(R.RequestID) FROM dbo.Requests R " +
                                            "WHERE R.MSID = @MSID AND R.isVisible = 1 " +
                                        ") - " +
                                        "(	SELECT COUNT(R.RequestID) FROM dbo.MainScheduleRequestEvents MSRE " +
                                            "INNER JOIN dbo.MainScheduleEvents MSE ON MSRE.EventID = MSE.EventID " +
                                            "INNER JOIN dbo.Requests R ON MSRE.RequestID = R.RequestID " +
                                            "WHERE R.isVisible = 1 AND MSE.isHidden = 0 AND MSE.EventTypeID IN (18, 2031, 14, 16) " +
                                            "AND R.MSID = @MSID " +
                                        ") AS OpenRequestCount";
                int numOpenRequest = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                if (numOpenRequest > 0)
                {
                    hasIncompleteRequests = true;
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation doesTruckHaveOpenRequests(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return hasIncompleteRequests;
        }


        [System.Web.Services.WebMethod]
        public static bool doesTruckHaveSamplesPending(int MSID)
        {
            bool hasOpenSamples = false;

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT ISNULL(COUNT(S.SampleID),0) AS OpenSamplesCount FROM dbo.Samples S " +
                                    "INNER JOIN dbo.PODetails PD ON S.PODetailsID = PD.PODetailsID " +
                                    "INNER JOIN dbo.MainSchedule MS ON MS.MSID = PD.MSID  " +
                                    "WHERE MS.isHidden = 0 AND S.isHidden = 0 " +
                                    "AND ((S.TestApproved IS NULL  AND bypassApproverUserID IS NULL)  " +
                                            "OR  SampleTakenEventID IS NULL OR SampleSentEventID IS NULL  " +
                                            "OR SampleLabReceivedEventID IS NULL OR SampleCreatedEventID IS NULL OR (SpecificGravity IS NULL OR SpecificGravity <= 0) ) " +
                                    "AND MS.MSID = @MSID";
                int numOpenSamples = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                if (numOpenSamples > 0)
                {
                    hasOpenSamples = true;
                }

                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation doesTruckHaveSamplesPending(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return hasOpenSamples;
        }

        [System.Web.Services.WebMethod]
        public static bool doesTruckHaveExistingSamples(int MSID)
        {
            bool samplesExist = false;

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT ISNULL(COUNT(S.SampleID),0) AS SamplesCount FROM dbo.Samples S " +
                                    "INNER JOIN dbo.PODetails PD ON S.PODetailsID = PD.PODetailsID " +
                                    "INNER JOIN dbo.MainSchedule MS ON MS.MSID = PD.MSID  " +
                                    "WHERE MS.isHidden = 0 AND S.isHidden = 0 " +
                                    "AND MS.MSID = @MSID";
                int numSamples = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                if (numSamples > 0)
                {
                    samplesExist = true;
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation doesTruckHaveExistingSamples(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return samplesExist;
        }
        [System.Web.Services.WebMethod]
        public static bool checkIfBulk(int MSID)
        {
            string truckType = string.Empty;
            bool isBulk = false;
            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT TruckType FROM dbo.MainSchedule WHERE MSID = @MSID";
                truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                isBulk = truckType.Contains("BULK");
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkIfBulk(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return isBulk;
        }

        [System.Web.Services.WebMethod]
        public static bool isTruckRejected(int MSID)
        {
            bool isRejected = false;
           
            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT isRejected FROM dbo.MainSchedule WHERE MSID = @MSID";
                isRejected = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation isTruckRejected(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return isRejected;
        }

        [System.Web.Services.WebMethod]
        public static bool isWeightInfoComplete(int MSID)
        {
            bool isComplete = false;
            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT ISNULL(NetProductWeight, -999) FROM dbo.MainSchedule WHERE MSID = @MSID";
                isComplete = !(-999 == Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID))));
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation isWeightInfoComplete(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return isComplete;
        }

        [System.Web.Services.WebMethod]
        public static List<object> isTruckAllowedToCheckOut(int MSID)
        {
            bool isAllowed = false;
            string outputMsg = string.Empty;
            bool doInspectionsExist = doesTruckHaveExistingInspections(MSID);
            bool hasIncompleteInspections = doesTruckHaveIncompleteOrFailedInspections(MSID);
            bool hasIncompleteRequests = doesTruckHaveOpenRequests(MSID);
            bool isBulk = checkIfBulk(MSID);
            bool hasSamplesPending = doesTruckHaveSamplesPending(MSID);
            bool doSamplesExist = doesTruckHaveExistingSamples(MSID);
            bool isWeighingDone = isWeightInfoComplete(MSID);
            bool isRejected = isTruckRejected(MSID);


            outputMsg = (hasIncompleteInspections) ? outputMsg + "Truck has inspections that have not been completed or have failed. " + Environment.NewLine : outputMsg;
            outputMsg = (!doInspectionsExist) ? outputMsg + "Truck does not have any inspections done. " + Environment.NewLine : outputMsg;
            outputMsg = (hasIncompleteRequests) ? outputMsg + "Truck has requests or tasks that have not been completed. " + Environment.NewLine : outputMsg;
            if (isBulk)
            {
                outputMsg = (hasSamplesPending) ? outputMsg + "Truck has samples that are pending, rejected or not completed. " + Environment.NewLine : outputMsg;
                outputMsg = (!doSamplesExist) ? outputMsg + "Truck does not have any samples. " + Environment.NewLine : outputMsg;
                outputMsg = (!isWeighingDone) ? outputMsg + "Truck weights information missing. " + Environment.NewLine : outputMsg;
            }
                        //if bulk, check for samples also
            isAllowed = (isBulk) ? (!hasIncompleteInspections && doInspectionsExist && !hasIncompleteRequests && !hasSamplesPending && doSamplesExist && isWeighingDone) : (!hasIncompleteInspections && doInspectionsExist && !hasIncompleteRequests);

            if (isRejected)
            {
                isAllowed = true; //rejected trucks can always be checked out
                outputMsg = string.Empty;
            }

            List<object> rObj = new List<object>();
            rObj.Add(isAllowed);
            rObj.Add(outputMsg);

            return rObj;

        }

        [System.Web.Services.WebMethod]
        public static void checkOut(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "DELETE FROM dbo.TrailersInYard WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramUserID = new SqlParameter("@UserId", SqlDbType.Int);
                    SqlParameter paramTimeStamp = new SqlParameter("@TimeStamp", SqlDbType.DateTime);

                    paramMSID.Value = MSID;
                    paramUserID.Value = zxpUD._uid;
                    paramTimeStamp.Value = timestamp;

                    //gets data specific data from table and save into readable format
                    //1. set move event for GS departure
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 19, 'false');" +
                                 "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", timestamp)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "10", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "GS", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TimeDeparted", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //2. set location to GS
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 10, LocationShort = 'GS', TimeDeparted = @TimeStamp, currentDockSpotID = NULL WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", timestamp), new SqlParameter("@MSID", MSID));

                    //3. set release event
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, Timestamp, UserID, isHidden) VALUES (@MSID, 3069, @TimeStamp, @UserId, 'false');" +
                                 "SELECT SCOPE_IDENTITY()";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                 new SqlParameter("@TimeStamp", timestamp),
                                                                                                                 new SqlParameter("@UserId", zxpUD._uid)));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "10", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NOS", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TimeDeparted", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //4. set location to NOS
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 10, LocationShort = 'NOS', TimeDeparted = @TimeStamp1, LastUpdated = @TimeStamp2 WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp1", timestamp),
                                                                                         new SqlParameter("@TimeStamp2", timestamp),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkOut(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void setVerify(int MSID)
        {
            DateTime now = DateTime.Now;
            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    //gets data specific data from table and save into readable format
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 23, 'false')";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@UserId", zxpUD._uid),
                                                                                         new SqlParameter("@TimeStamp", now));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation setVerify(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static string updateRowData(int MSID, string TrailerNum, string IncomingCab, string OutGoingCab, string BlanketReleaseNum)
        {
            DateTime nowTS = DateTime.Now;
            string returnString = null;            
            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    //EventTypeID = 2035= Truck Schedule Edited
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                "VALUES (@MSID, 2035, @TIME, @USER, 'false'); " +
                                "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", nowTS),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerNumber", nowTS, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TrailerNum, eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "UPDATE dbo.MainSchedule SET TrailerNumber = @TrailerNumber, Cab1Number = @CabNumberIn, Cab2Number = @CabNumberOut WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TrailerNumber", TransportHelperFunctions.convertStringEmptyToDBNULL(TrailerNum)),
                                                                                         new SqlParameter("@CabNumberIn", TransportHelperFunctions.convertStringEmptyToDBNULL(IncomingCab)),
                                                                                         new SqlParameter("@CabNumberOut", TransportHelperFunctions.convertStringEmptyToDBNULL(OutGoingCab)),
                                                                                         new SqlParameter("@MSID", MSID));

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.TrailersInYard WHERE MSID = @MSID";
                    int trailersInYardForPO = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (trailersInYardForPO > 0 && (!string.IsNullOrWhiteSpace(TrailerNum)))
                    {
                        //cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TrailersInYard", "TrailerNumber", nowTS, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TrailerNum, eventID, "TrailerNumber", TrailerNum.ToString());
                        //cLog.CreateChangeLogEntryIfChanged(sqlConn);
                        //update trailer number in trailer in yard
                        sqlCmdText = "UPDATE dbo.TrailersInYard SET TrailerNumber = @TrailerNumber WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TrailerNumber", TransportHelperFunctions.convertStringEmptyToDBNULL(TrailerNum)),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    else if (trailersInYardForPO > 0 && (string.IsNullOrWhiteSpace(TrailerNum)))
                    {
                        returnString = "Trailer number can not be removed due to the trailer being in the Yard.";
                        return returnString;
                    }
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Requests WHERE MSID = @MSID";
                    int trailersInRequestTbl = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (trailersInRequestTbl > 0)
                    {
                        sqlCmdText = "UPDATE dbo.Requests SET TrailerNumber = @TrailerNumber WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TrailerNumber", TransportHelperFunctions.convertStringEmptyToDBNULL(TrailerNum)),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    returnString = "success";
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation updateRowData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnString;
        }

        [System.Web.Services.WebMethod]
        public static List<string> undoCheckIn(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            string truckType = "";
            List<string> returnMessageList = new List<string>();
            DataSet dataSet = new DataSet();
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT (DATEDIFF(MINUTE, MS.TimeArrived, GETDATE()) ) " +
                                            "FROM dbo.MainSchedule as MS " +
                                            "WHERE MSID = @MSID";
                    int timePassedFromCheckOutInMin = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));


                    if (timePassedFromCheckOutInMin <= 59)
                    {
                        ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                        //Query 1 - disable demurrage start
                        sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE (MSID = @MSID AND EventTypeID = 1052);" + 
                                        "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE (MSID = @MSID AND EventTypeID = 8099);";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                        //Query 2 - gets data specific data from table and save into readable format
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3058, 'false')" +
                                    "SELECT SCOPE_IDENTITY()";
                        int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                         new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                         new SqlParameter("@TimeStamp", timestamp)));

 
                        //Query 3 roll status back
                        sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 2);" +
                            "UPDATE dbo.MainSchedule SET StatusID = 1, LocationShort = 'NOS', LastUpdated = @TimeStamp WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                             new SqlParameter("@TimeStamp", timestamp));


                        //continue to use undo checkin event id, for the rest of the mainschedule data is being rolled back
                        ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TimeArrived", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Number", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Number", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "GrossWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "DriverName", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "DriverPhoneNumber", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NULL", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.MainSchedule " +
                                            "SET TimeArrived = NULL, Cab1Weight = NULL, Cab1Number = NULL, Cab2Weight = NULL, Cab2Number = NULL, GrossWeight = NULL, DriverName = NULL, DriverPhoneNumber = NULL, LastUpdated = @TimeStamp  WHERE MSID = @MSID; " +
                                            "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE MSID = @MSID AND EventTypeID = 23";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                             new SqlParameter("@TimeStamp", timestamp));


                        //get truck type
                        sqlCmdText = "SELECT TruckType FROM dbo.MainSchedule WHERE MSID = @MSID";
                        truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                        if (truckType == "Bulk")
                        {
                            //EventTypeID = 2036= Sample Created
                            sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE MSID = @MSID and EventTypeID = 2036";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                            //if truck type is Bulk, create samples for product
                            sqlCmdText = "SELECT PODetailsID FROM dbo.PODetails as POD WHERE MSID = @MSID";
                            dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                            if (dataSet.Tables[0].Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                                {
                                    //create sample for each product
                                    sqlCmdText = "UPDATE dbo.Samples SET isHidden = 'true' WHERE PODetailsID = @PODID";
                                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PODID", row.ItemArray[0].ToString().Trim()));

                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "true", eventID, "PODetailsID", row.ItemArray[0].ToString().Trim());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                            }
                        }
                        returnMessageList.Add("true");
                    }
                    else
                    { 
                        returnMessageList.Add("false");
                        returnMessageList.Add("Undo check in has failed becuase it has been " + timePassedFromCheckOutInMin + " minutes since check in. Undo check in must be performed within and hour of check in.");
                        return returnMessageList;
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoCheckIn(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnMessageList;
        }


        [System.Web.Services.WebMethod]
        public static List<string> undoCheckOut(int MSID)
        {
            DateTime now = DateTime.Now;
            ChangeLog cLog;
            int eventID = 0;
            List<string> returnMessageList = new List<string>();


            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT (DATEDIFF(MINUTE, MS.TimeDeparted, GETDATE()) ) " +
                                            "FROM dbo.MainSchedule as MS " +
                                            "WHERE MSID = @MSID";

                    int timePassedFromCheckOutInMin = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (timePassedFromCheckOutInMin <= 59)
                    {
                        //gets data specific data from table and save into readable format
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3059, 'false')" +
                                "SELECT SCOPE_IDENTITY()";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", now)));


                        sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true', LastUpdated = @TimeStamp WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 19)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                             new SqlParameter("@TimeStamp", now));
                        //undo checkout ts in main schedule
                        sqlCmdText = "UPDATE dbo.MainSchedule SET TimeDeparted = NULL WHERE @MSID = MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TimeDeparted", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "true", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        returnMessageList.Add("true");
                    }
                    else
                    {
                        returnMessageList.Add("false");
                        returnMessageList.Add("Undo check out has failed becuase it has been " + timePassedFromCheckOutInMin + " minutes since check out. Undo check out must be performed within and hour of check out.");
                        return returnMessageList;
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoCheckOut(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnMessageList;
        }

        [System.Web.Services.WebMethod]
        public static void undoVerify(int MSID)
        {
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3062, 'false') " +
                        "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE MSID = @MSID AND EventTypeID = 23 ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@UserId", zxpUD._uid),
                                                                                         new SqlParameter("@TimeStamp", now));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoVerify(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static int checkIfWeightTaken(int MSID, bool isWeighIn)
        {
            var rowCount = 0;
            
            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                if (isWeighIn == true)
                {
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.MainSchedule WHERE (MSID = @MSID AND WeightIn IS NOT NULL)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID))); 

                }
                else
                {
                    sqlCmdText = "SELECT COUNT (*) FROM dbo.MainSchedule WHERE (MSID = @MSID AND WeightOut IS NOT NULL)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID))); 
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkIfWeightTaken(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static List<decimal> getCurrentWeights(int MSID)
        {
            List<decimal> listOfWeights = new List<decimal>();
            DataSet dataSet = new DataSet();

            decimal gross;
            decimal grossObtainMethod = 0;
            decimal cab1Solo;
            decimal cab1ObtainMethod = 0;
            decimal cab2Solo;
            decimal cab2ObtainMethod = 0;
            decimal cab2WithTrailer;
            decimal cab2WithTrailerObtainMethod = 0;
            decimal cab1WithTrailer;
            decimal cab1WithTrailerObtainMethod = 0;
            decimal trailer;
            decimal trailerObtainMethod = 0;
            decimal netWeight;

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT TOP (1) MS.GrossWeight, MS.Cab1Weight, MS.Cab2Weight, MS.Cab2WithTrailerWeight, MS.TrailerWeight, MS.NetProductWeight, MS.GrossWeightObtainedMethodID, MS.Cab1WeightObtainedMethodID, " +
                                "MS.Cab2WeightObtainedMethodID, MS.Cab2WithTrailerWeightObtainedMethodID, MS.TrailerWeightObtainedMethodID, MS.Cab1WithTrailerWeight, MS.Cab1WithTrailerWeightObtainedMethodID " +
                                "FROM dbo.MainSchedule as MS WHERE (MS.MSID = @MSID) ";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                //set gross val
                if (dataSet.Tables[0].Rows[0]["GrossWeight"].Equals(DBNull.Value))
                {
                    gross = 0;
                }
                else
                {
                    gross = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["GrossWeight"]);
                    grossObtainMethod = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["GrossWeightObtainedMethodID"]);
                }
                //set cab1Solo val
                if (dataSet.Tables[0].Rows[0]["Cab1Weight"].Equals(DBNull.Value))
                {
                    cab1Solo = 0;
                }
                else
                {
                    cab1Solo = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab1Weight"]);
                    cab1ObtainMethod = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab1WeightObtainedMethodID"]);
                }
                //set cab2Solo val
                if (dataSet.Tables[0].Rows[0]["Cab2Weight"].Equals(DBNull.Value))
                {
                    cab2Solo = 0;
                }
                else
                {
                    cab2Solo = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab2Weight"]);
                    cab2ObtainMethod = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab2WeightObtainedMethodID"]);
                }
                //set cab2WithTrailer val
                if (dataSet.Tables[0].Rows[0]["Cab2WithTrailerWeight"].Equals(DBNull.Value))
                {
                    cab2WithTrailer = 0;
                }
                else
                {
                    cab2WithTrailer = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab2WithTrailerWeight"]);
                    cab2WithTrailerObtainMethod = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab2WithTrailerWeightObtainedMethodID"]);
                }

                //set cab1WithTrailer val
                if (dataSet.Tables[0].Rows[0]["Cab1WithTrailerWeight"].Equals(DBNull.Value))
                {
                    cab1WithTrailer = 0;
                }
                else
                {
                    cab1WithTrailer = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab1WithTrailerWeight"]);
                    cab1WithTrailerObtainMethod = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Cab1WithTrailerWeightObtainedMethodID"]);
                }

                //set trailer val
                if (dataSet.Tables[0].Rows[0]["TrailerWeight"].Equals(DBNull.Value))
                {
                    trailer = 0;
                }
                else
                {
                    trailer = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["TrailerWeight"]);
                    trailerObtainMethod = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["TrailerWeightObtainedMethodID"]);
                }
                //set netWeight val
                if (dataSet.Tables[0].Rows[0]["NetProductWeight"].Equals(DBNull.Value))
                {
                    netWeight = 0;
                }
                else
                {
                    netWeight = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["NetProductWeight"]);
                }


                listOfWeights.Add(gross);
                listOfWeights.Add(cab1Solo);
                listOfWeights.Add(cab2Solo);
                listOfWeights.Add(cab2WithTrailer);
                listOfWeights.Add(trailer);
                listOfWeights.Add(netWeight);

                listOfWeights.Add(grossObtainMethod);
                listOfWeights.Add(cab1ObtainMethod);
                listOfWeights.Add(cab2ObtainMethod);
                listOfWeights.Add(cab2WithTrailerObtainMethod);
                listOfWeights.Add(trailerObtainMethod);


                listOfWeights.Add(cab1WithTrailer);
                listOfWeights.Add(cab1WithTrailerObtainMethod);
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation getCurrentWeights(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return listOfWeights;
        }

        [System.Web.Services.WebMethod]
        public static decimal getNetWeightAndSpecificGravity(int MSID)
        {
            decimal specificGrav = 0;
            
            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = 
                    "SELECT TOP (1) ISNULL(S.SpecificGravity, 0.0) " +
                    "FROM dbo.MainSchedule AS MS " +
                    "INNER JOIN dbo.PODetails AS POD ON MS.MSID = POD.MSID " +
                    "INNER JOIN dbo.Samples AS S ON S.PODetailsID = POD.PODetailsID " +
                    "INNER JOIN dbo.MainScheduleEvents AS MSE ON MSE.MSID = MS.MSID " +
                    "WHERE MS.MSID = @MSID AND MSE.EventTypeID = 3052 and S.SpecificGravity IS NOT NULL ORDER BY MSE.TimeStamp DESC ";

                specificGrav = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation getNetWeightAndSpecificGravity(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return specificGrav;
        }

        private static decimal calcProductWeightFromGrossMTCab1AndMTTrailer(decimal gross, decimal cab1, decimal MTTrailer)
        {
            return gross - cab1 - MTTrailer;
        }

        private static decimal calcProductWeightFromGrossAndCabWTrailer(decimal gross, decimal cabWTrailer)
        {
            return gross - cabWTrailer;
        }

        private static decimal calcTrailerWeight(decimal cab2MT, decimal cab2WTrailer) //trailer
        {
            return cab2WTrailer - cab2MT;
        }

        private static decimal calcCab1FromCab1WTrailerAndTrailer(decimal trailer, decimal cab1WTrailer)// cab 1
        {
            return cab1WTrailer - trailer;
        }

        private static decimal calcCab2FromCab2WTrailerAndTrailer(decimal trailer, decimal cab2WTrailer)// cab 2
        {
            return cab2WTrailer - trailer;
        }

        private static decimal calcCabWithTrailerFromCabAndTrailer(decimal trailer, decimal cab)
        {
            return cab + trailer;
        }

        private static decimal calcCabFromNetAndTrailer(decimal net, decimal trailer)
        {
            return net - trailer;
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
                string strErr = " SQLException Error in GuardStation GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in GuardStation GetLogList(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation GetLogList(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static string CheckCurrentStatus(int MSID)
        {
            string currentStatus = null;

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT LocationShort FROM dbo.MainSchedule WHERE MSID = @MSID ";
                currentStatus = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation CheckCurrentStatus(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return currentStatus;
        }

        [System.Web.Services.WebMethod]
        public static bool checkIfManualEntryIsEnabled()
        {
            DateTime timestamp = DateTime.Now;
            bool isManualEntryEnabled = false;

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                //check if manual weighing is enabled
                sqlCmdText = "SELECT TOP 1 isEnabled FROM dbo.ManualWeights ";
                isManualEntryEnabled = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText));
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkIfManualEntryIsEnabled(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return isManualEntryEnabled;
        }

        [System.Web.Services.WebMethod]
        public static List<decimal> updateWeightManually(int MSID, int weightSelectionType, decimal weight)
        {
            DateTime timestamp = DateTime.Now;
            List<decimal> listOfWeights = new List<decimal>();
            string returnMessage = string.Empty;
            int eventID;
            bool isDropTrailer;
            ChangeLog cLog;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //check if manual weighing is enabled
                    sqlCmdText = "SELECT TOP 1 isEnabled FROM dbo.ManualWeights ";
                    bool isManualEntryEnabled = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText));

                    if (!isManualEntryEnabled)
                    {
                        throw new Exception("Cannot update manually. Manual Entry has been disabled. Please contact your administrator or the IT department.");
                    }
                    else
                    {
                        SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                        SqlParameter paramTimestamp = new SqlParameter("@TIME", SqlDbType.DateTime);
                        SqlParameter paramWeight = new SqlParameter("@TruckWeight", SqlDbType.Decimal);
                        SqlParameter paramUserID = new SqlParameter("@USER", SqlDbType.Int);

                        paramMSID.Value = MSID;
                        paramTimestamp.Value = timestamp;
                        paramWeight.Value = weight;
                        paramUserID.Value = zxpUD._uid;

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, paramTimestamp.Value.ToString(), null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "WeighUnits", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "Lbs", null, "MSID", MSID.ToString()); //TODO : need to confirm if test writer writes this
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "GS", null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "3", null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "SELECT MS.isDropTrailer FROM dbo.MainSchedule as MS WHERE (MS.MSID = @MSID)";

                        isDropTrailer = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                        switch (weightSelectionType)
                        {
                            case 1: //gross
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                    "VALUES (@MSID, 4073, @TIME, @USER, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "GrossWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, paramWeight.Value.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "GrossWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "2", null, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                sqlCmdText = "UPDATE dbo.MainSchedule SET GrossWeight = @TruckWeight , WeighUnits = 'Lbs', LastUpdated = @TIME, GrossWeightObtainedMethodID = 2, LocationShort = 'GS', StatusID = 3 WHERE MSID = @MSID";
                                break;
                            case 2: //cab in(1)
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                    "VALUES (@MSID, 4074, @TIME, @USER, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, paramWeight.Value.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "2", null, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1Weight = @TruckWeight, Cab1WeightObtainedMethodID = 2, WeighUnits = 'Lbs', LastUpdated  = @TIME, LocationShort = 'GS', StatusID = 3 WHERE MSID = @MSID";
                                break;
                            case 3: //cab out(2)
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                    "VALUES (@MSID, 4075, @TIME, @USER, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, paramWeight.Value.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "2", null, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2Weight = @TruckWeight, Cab2WeightObtainedMethodID = 2, WeighUnits = 'Lbs', LastUpdated = @TIME, LocationShort = 'GS', StatusID = 3  WHERE MSID = @MSID";
                                break;
                            case 4: //cab out(2) with trailer
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                    "VALUES (@MSID, 4076, @TIME, @USER, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, paramWeight.Value.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "2", null, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2WithTrailerWeight = @TruckWeight, Cab2WithTrailerWeightObtainedMethodID = 2, WeighUnits = 'Lbs', LastUpdated = @TIME, LocationShort = 'GS', StatusID = 3  WHERE MSID = @MSID";
                                break;

                            case 5://trailer
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                    "VALUES (@MSID, 4077, @TIME, @USER, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, paramWeight.Value.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "2", null, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                sqlCmdText = "UPDATE dbo.MainSchedule SET TrailerWeight = @TruckWeight, TrailerWeightObtainedMethodID = 2, WeighUnits = 'Lbs', LastUpdated = @TIME, LocationShort = 'GS', StatusID = 3  WHERE MSID = @MSID";
                                break;

                            case 6: //cab in(1) with trailer
                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                    "VALUES (@MSID, 7100, @TIME, @USER, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, paramWeight.Value.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "2", null, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                                sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1WithTrailerWeight = @TruckWeight, Cab1WithTrailerWeightObtainedMethodID = 2, WeighUnits = 'Lbs', LastUpdated = @TIME, LocationShort = 'GS', StatusID = 3  WHERE MSID = @MSID";
                                break;
                            default:
                                sqlCmdText = string.Empty;
                                break;
                        }
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TruckWeight", weight),
                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation updateWeightManually(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            listOfWeights = getCurrentWeights(MSID);

            return listOfWeights;
        }

        [System.Web.Services.WebMethod]
        public static void updateDriverInfo(int MSID, string driverName, string driverPhoneNumber, string trailernumber, string cab1number)
        {
            DateTime timestamp = DateTime.Now;
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "DriverName", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, driverName, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "DriverPhoneNumber", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, driverPhoneNumber, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerNumber", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, trailernumber, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Number", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, cab1number, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = string.Concat( "UPDATE dbo.MainSchedule SET DriverName = @DriverName, DriverPhoneNumber = @DriverPhoneNumber, ",
                                                "TrailerNumber = @TrailerNumber, Cab1Number = @Cab1Number ", 
                                                "WHERE (MSID = @MSID)");
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@DriverName", driverName),
                                                                                         new SqlParameter("@DriverPhoneNumber", driverPhoneNumber),
                                                                                         new SqlParameter("@Cab1Number", cab1number),
                                                                                         new SqlParameter("@TrailerNumber", trailernumber),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation updateDriverInfo(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateGSCommentAndCabNumbers(int MSID, string GSComment, string cab1, string cab2)
        {
            DateTime timestamp = DateTime.Now;
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "GuardStationComment", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, GSComment, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Number", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, cab1, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Number", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, cab2, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET GuardStationComment = @GSComment, Cab1Number = @CabNumberIn, Cab2Number = @CabNumberOut WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@GSComment", TransportHelperFunctions.convertStringEmptyToDBNULL(GSComment)),
                                                                                         new SqlParameter("@CabNumberIn", TransportHelperFunctions.convertStringEmptyToDBNULL(cab1)),
                                                                                         new SqlParameter("@CabNumberOut", TransportHelperFunctions.convertStringEmptyToDBNULL(cab2)),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation updateGSCommentAndCabNumbers(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }
        [System.Web.Services.WebMethod]
        public static void undoGrossWeight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            int? eventID;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "GrossWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "NetProductWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "GrossWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "UPDATE dbo.MainSchedule SET GrossWeight = NULL, GrossWeightObtainedMethodID = NULL, NetProductWeight = NULL WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    //find orginal weight event
                    sqlCmdText = "SELECT ISNULL(MSE.EventID, 0) FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.EventTypeID = 4073 OR MSE.EventTypeID = 4084 OR MSE.EventTypeID = 4089) AND ((MSE.MSID = @MSID) AND MSE.isHidden = 'false')";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (eventID.HasValue)
                    {
                        //clear it
                        sqlCmdText = "Update dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = @EventID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventID", eventID));
                    }
                    else
                    {
                        throw new Exception("Orginal weight event could not be found.");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoGrossWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoCab1Weight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            int? eventID;
            bool isDropTrailer;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramUserID = new SqlParameter("@USER", SqlDbType.Int);
                    SqlParameter paramTime = new SqlParameter("@TIME", SqlDbType.DateTime);

                    paramMSID.Value = MSID;
                    paramUserID.Value = zxpUD._uid;
                    paramTime.Value = timestamp;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "SELECT ISNULL(isDropTrailer, 'false') FROM dbo.MainSchedule WHERE MSID = @MSID";
                    isDropTrailer = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (isDropTrailer == false)
                    {
                        //gets data specific data from table and save into readable format
                        //clear on main schedule table
                        sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1Weight = NULL, Cab1WeightObtainedMethodID = NULL, Cab2Weight = NULL, Cab2WeightObtainedMethodID = NULL WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1Weight = NULL, Cab1WeightObtainedMethodID = NULL WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    }
                    //set undo event
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 4085, @TIME, @USER, 'false');";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID), new SqlParameter("@TIME", timestamp), new SqlParameter("@USER", zxpUD._uid));

                    //find orginal weight event
                    sqlCmdText = "SELECT ISNULL(MSE.EventID, 0) FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.EventTypeID = 4074 OR MSE.EventTypeID = 4085 OR MSE.EventTypeID = 4090) AND ((MSE.MSID = @MSID) AND MSE.isHidden = 'false')";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (eventID.HasValue)
                    {
                        //clear it
                        sqlCmdText = "Update dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = @EventID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventID", eventID));
                    }
                    else
                    {
                        throw new Exception("Orginal weight event could not be found.");
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoCab1Weight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoCab2Weight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            int? eventID;
            bool isDropTrailer;
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "SELECT ISNULL(isDropTrailer, 'false') FROM dbo.MainSchedule WHERE MSID = @MSID";
                    isDropTrailer = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (isDropTrailer == false)
                    {
                        //clear on main schedule table
                        sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1Weight = NULL, Cab1WeightObtainedMethodID = NULL, Cab2Weight = NULL, Cab2WeightObtainedMethodID = NULL WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2Weight = NULL, Cab2WeightObtainedMethodID = NULL WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    }

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 4086, @TIME, @USER, 'false');";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TIME", timestamp),
                                                                                         new SqlParameter("@USER", zxpUD._uid));

                    //find orginal weight event
                    sqlCmdText = "SELECT ISNULL(MSE.EventID, 0) FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.EventTypeID = 4075 OR MSE.EventTypeID = 4086 OR MSE.EventTypeID = 4091) AND ((MSE.MSID = @MSID) AND MSE.isHidden = 'false')";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (eventID.HasValue)
                    {
                        //clear it
                        sqlCmdText = "Update dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = @EventID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventID", eventID));
                    }
                    else
                    {
                        throw new Exception("Orginal weight event could not be found.");
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoCab2Weight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoCab2wTrailerWeight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            int? eventID;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramUserID = new SqlParameter("@USER", SqlDbType.Int);
                    SqlParameter paramTime = new SqlParameter("@TIME", SqlDbType.DateTime);

                    paramMSID.Value = MSID;
                    paramUserID.Value = zxpUD._uid;
                    paramTime.Value = timestamp;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2WithTrailerWeight = NULL, Cab2WithTrailerWeightObtainedMethodID = NULL WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 4087, @TIME, @USER, 'false');";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TIME", timestamp),
                                                                                         new SqlParameter("@USER", zxpUD._uid));

                    //find orginal weight event
                    sqlCmdText = "SELECT ISNULL(MSE.EventID, 0) FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.EventTypeID = 4076 OR MSE.EventTypeID = 4082 OR MSE.EventTypeID = 4092) AND ((MSE.MSID = @MSID) AND MSE.isHidden = 'false')";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (eventID.HasValue)
                    {
                        //clear it
                        sqlCmdText = "Update dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = @EventID";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventID", eventID)));
                    }
                    else
                    {
                        throw new Exception("Orginal weight event could not be found.");
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoCab2wTrailerWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }



        [System.Web.Services.WebMethod]
        public static void undoCab1wTrailerWeight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            int? eventID;

            try
            {
                using (var scope = new TransactionScope())
                {

                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1WithTrailerWeight = NULL, Cab1WithTrailerWeightObtainedMethodID = NULL WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 7101, @TIME, @USER, 'false');";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TIME", timestamp),
                                                                                         new SqlParameter("@USER", zxpUD._uid));

                    //find orginal weight event
                    sqlCmdText = "SELECT ISNULL(MSE.EventID, 0) FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.EventTypeID = 7100 OR MSE.EventTypeID = 7102 OR MSE.EventTypeID = 7103) AND ((MSE.MSID = @MSID) AND MSE.isHidden = 'false')";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (eventID.HasValue)
                    {
                        //clear it
                        sqlCmdText = "Update dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = @EventID";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventID", eventID)));
                    }
                    else
                    {
                        throw new Exception("Orginal weight event could not be found.");
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoCab1wTrailerWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }




        [System.Web.Services.WebMethod]
        public static void undoTrailerWeight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            int? eventID;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "UPDATE dbo.MainSchedule SET TrailerWeight = NULL, TrailerWeightObtainedMethodID = NULL WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 4087, @TIME, @USER, 'false');";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TIME", timestamp),
                                                                                         new SqlParameter("@USER", zxpUD._uid));
                    //find orginal weight event
                    sqlCmdText = "SELECT ISNULL(MSE.EventID, 0) FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.EventTypeID = 4077 OR MSE.EventTypeID = 4083 OR MSE.EventTypeID = 4093) AND ((MSE.MSID = @MSID) AND MSE.isHidden = 'false')";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (eventID.HasValue)
                    {
                        //clear it
                        sqlCmdText = "Update dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventID = @EventID";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EventID", eventID)));
                    }
                    else
                    {
                        throw new Exception("Orginal weight event could not be found.");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoTrailerWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoNetWeight(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "UPDATE dbo.MainSchedule SET NetProductWeight = NULL WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "NetProductWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, null, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation undoNetWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getCurrentLocationAndStatusB4Undo(int MSID)
        {
            DataSet dataSet = new DataSet();
            List<string> data = new List<string>();
            string loc;
            int stat;
            string canUndoCheckOut;

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT TOP (1) " +
                                    "(SELECT L.LocationLong FROM dbo.Locations AS L WHERE L.LocationShort = MS.LocationShort) AS Location, " +
                                    "(SELECT S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status " +
                                    "FROM dbo.MainSchedule AS MS WHERE MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    loc = Convert.ToString(dataSet.Tables[0].Rows[0]["Location"]);
                    stat = Convert.ToInt32(dataSet.Tables[0].Rows[0]["Status"]);

                    if (loc == "NOS" && stat == 10)
                    {
                        canUndoCheckOut = "true";
                    }
                    else
                    {
                        canUndoCheckOut = "false";

                    }

                    data.Add(loc);
                    data.Add(stat.ToString());
                    data.Add(canUndoCheckOut);
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation getCurrentLocationAndStatusB4Undo(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void DeleteFileDBEntry(int fileID, string fileType, int MSID)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //1. insert event to Main Schedule Events
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

                    //2. update Main Schedule Files
                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "FileID", fileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainScheduleFiles SET isHidden = 1 WHERE fileID = @PFID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PFID", fileID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation DeleteFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void AddFileDBEntry(int MSID, string fileType, string filenameOld, string filenameNew, string filepath, string fileDescription)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
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
                    //3. update main Schedule Files
                    sqlCmdText = "INSERT INTO dbo.MainScheduleFiles (MSID, FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld, isHidden) " +
                                        "VALUES (@PMSID, @PFTID, @PDESC, @PFPATH, @PFNEW, @PFOLD, 0);" +
                                        "SELECT SCOPE_IDENTITY()";
                    int newFileID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                     new SqlParameter("@PFTID", filetypeID),
                                                                                                                     new SqlParameter("@PDESC", fileDescription),
                                                                                                                     new SqlParameter("@PFPATH", filepath),
                                                                                                                     new SqlParameter("@PFNEW", filenameNew),
                                                                                                                     new SqlParameter("@PFOLD", filenameOld)));

                    //4. If COFA was uploaded, need to fine associated sample and add file upload details
                    if ("COFA" == fileType)
                    {
                        //GET SampleID
                        sqlCmdText = string.Concat("SELECT TOP 1 S.SampleID ",
                                                "FROM dbo.Samples S ",
                                                "INNER JOIN dbo.PODetails PD ON S.PODetailsID = PD.PODetailsID ",
                                                "WHERE PD.MSID = @PMSID");

                        int sampleID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID)));

                        //UPDATE FileID_COFA and COFAEventID
                        sqlCmdText = "UPDATE dbo.Samples SET FileID_COFA=@FILEID, COFAEventID = @EVENTID WHERE SampleID = @SAMPLEID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FILEID", newFileID),
                                                                new SqlParameter("@EVENTID", eventID),
                                                                new SqlParameter("@SAMPLEID", sampleID));

                    }


                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "MSID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, MSID.ToString(), null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FileTypeID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, filetypeID.ToString(), null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FileDescription", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, fileDescription.ToString(), null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "Filepath", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filepath.ToString(), null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FilenameNew", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filenameNew.ToString(), null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FilenameOld", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filenameOld.ToString(), null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "False", null, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation AddFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetFileUploadsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT FileID, MSID, MSF.FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld FROM dbo.MainScheduleFiles MSF " +
                                    "INNER JOIN dbo.FileTypes FT ON FT.FileTypeID = MSF.FileTypeID " +
                                    "WHERE isHidden = 0 AND MSID = @PMSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation GetFileUploadsFromMSID(). Details: " + ex.ToString();
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
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

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
                string strErr = " Exception Error in GuardStation UpdateFileUploadData(). Details: " + ex.ToString();
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
                string strErr = " Exception Error in GuardStation ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return null;
        }

        [System.Web.Services.WebMethod]
        public static List<object> calculateWeight(int MSID, int weightType)
        {
            List<decimal> listOfWeights = new List<decimal>();
            List<object> returnData = new List<object>();
            bool isDropTrailer = false;
            DateTime timestamp = DateTime.Now;
            string errorMsg = string.Empty;
            ChangeLog cLog;
            listOfWeights = getCurrentWeights(MSID);
            int eventID = 0;
            decimal gross = 0;
            decimal cab1Solo = 0;
            decimal cab2Solo = 0;
            decimal cab2WithTrailer = 0;
            decimal cab1WithTrailer = 0;
            decimal trailer = 0;
            decimal net = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    gross = listOfWeights[0];
                    cab1Solo = listOfWeights[1];
                    cab2Solo = listOfWeights[2];
                    cab2WithTrailer = listOfWeights[3];
                    trailer = listOfWeights[4];
                    net = listOfWeights[5];
                    cab1WithTrailer = listOfWeights[11];

                    sqlCmdText = "SELECT MS.isDropTrailer FROM dbo.MainSchedule as MS WHERE (MS.MSID = @MSID)";
                    isDropTrailer = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));


                    switch(weightType)
                    {
                        case 2: //cab in(1)

                            if (trailer > 0 && cab1WithTrailer > 0)//if ((isDropTrailer == false || isDropTrailer == null) && (trailer > 0 && cab2WithTrailer > 0))
                            {
                                cab1Solo = calcCab1FromCab1WTrailerAndTrailer(trailer, cab1WithTrailer);
                                if (cab1Solo > 0)
                                {
                                    sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1Weight = @Cab1Weight, Cab1WeightObtainedMethodID = 3 " +//update cab1 val in db
                                                            "WHERE (MSID = @MSID)";
                                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Cab1Weight", cab1Solo), new SqlParameter("@MSID", MSID));
                                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                        "VALUES (@MSID, 4080, @TIME, @USER, 'false'); " +
                                                        "SELECT SCOPE_IDENTITY()";
                                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                 new SqlParameter("@TIME", timestamp),
                                                                                                                                 new SqlParameter("@USER", zxpUD._uid)));

                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, cab1Solo.ToString(), eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                                else
                                {
                                    errorMsg = "Error when calculating cab 1. Please review weights and try again.";
                                }
                            }
                            else
                            {
                                errorMsg = "Error when calculating cab 1. Please review weights and try again.";
                            }
                       

                            break;
                        case 3: //cab out(2) 
                            if (cab2Solo == 0 && cab2WithTrailer > 0 && trailer > 0)
                            {
                                cab2Solo = calcCab2FromCab2WTrailerAndTrailer(trailer, cab2WithTrailer);//calc cab2 from trailer & cab2WithTrailer
                                if (cab2Solo > 0)
                                {
                                    sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2Weight = @Cab2Weight, Cab2WeightObtainedMethodID = 3 " +//update cab2 val in db
                                                         "WHERE (MSID = @MSID)";
                                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Cab2Weight", cab2Solo), new SqlParameter("@MSID", MSID));
                                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                         "VALUES (@MSID, 4081, @TIME, @USER, 'false'); " +
                                                         "SELECT SCOPE_IDENTITY()";
                                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                 new SqlParameter("@TIME", timestamp),
                                                                                                                                 new SqlParameter("@USER", zxpUD._uid)));

                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2Weight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, cab2Solo.ToString(), eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                                else
                                {
                                    errorMsg = "Error when calculating cab 2. Please review weights and try again.";
                                }
                            }
                            else
                            {
                                errorMsg = "Error when calculating cab 2. Please review weights and try again.";
                            }


                            break;
                        case 4: //cab out(2) with trailer
                            //if (isDropTrailer == false || isDropTrailer == null)
                            //{
                                if (cab2WithTrailer == 0 && (cab2Solo > 0 && trailer > 0))
                                {
                                    cab2WithTrailer = calcCabWithTrailerFromCabAndTrailer(trailer, cab2Solo);//calc cab2WithTrailer from trailer & cab1
                                    if (cab2WithTrailer > 0)
                                    {
                                        sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2WithTrailerWeight = @Cab2WithTrailerWeight, Cab2WithTrailerWeightObtainedMethodID = 3 " +//update cab2WithTrailer val in db
                                                            "WHERE (MSID = @MSID)";
                                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Cab2WithTrailerWeight", cab2WithTrailer), new SqlParameter("@MSID", MSID));
                                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 4082, @TIME, @USER, 'false'); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                     new SqlParameter("@TIME", timestamp),
                                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, cab2WithTrailer.ToString(), eventID, "MSID", MSID.ToString());
                                        cLog.CreateChangeLogEntryIfChanged();
                                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                        cLog.CreateChangeLogEntryIfChanged();
                                    }
                                    else
                                    {
                                        errorMsg = "Error when calculating cab 2 with trailer. Please review weights and try again.";
                                    }
                                }
                            //}
                                else if (cab2WithTrailer == 0 && net > 0 && trailer > 0)
                                {
                                    cab2WithTrailer = calcCabFromNetAndTrailer(net, trailer);
                                    if (cab2WithTrailer > 0)
                                    {
                                        sqlCmdText = "UPDATE dbo.MainSchedule SET Cab2WithTrailerWeight = @Cab2WithTrailerWeight, Cab2WithTrailerWeightObtainedMethodID = 3 " +//update cab2WithTrailer val in db
                                                            "WHERE (MSID = @MSID)";
                                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Cab2WithTrailerWeight", cab2WithTrailer), new SqlParameter("@MSID", MSID));
                                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 4082, @TIME, @USER, 'false'); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                     new SqlParameter("@TIME", timestamp),
                                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, cab2WithTrailer.ToString(), eventID, "MSID", MSID.ToString());
                                        cLog.CreateChangeLogEntryIfChanged();
                                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab2WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                        cLog.CreateChangeLogEntryIfChanged();
                                    }
                                    else
                                    {
                                        errorMsg = "Error when calculating cab 2 with trailer. Please review weights and try again.";
                                    }
                                }
                                else
                                {
                                    errorMsg = "Error when calculating cab 2 with trailer. Please review weights and try again.";
                                }

                            break;

                        case 5://trailer
                            if (trailer == 0 && (cab2Solo > 0 && cab2WithTrailer > 0) || (cab1Solo > 0 && cab1WithTrailer > 0))
                            {
                                if (cab2Solo > 0 && cab2WithTrailer > 0)
                                {
                                    trailer = calcTrailerWeight(cab2Solo, cab2WithTrailer);
                                }
                                else
                                {
                                    trailer = calcTrailerWeight(cab1Solo, cab1WithTrailer);
                                }

                                if (trailer > 0)
                                {
                                    sqlCmdText = "UPDATE dbo.MainSchedule SET TrailerWeight = @TrailerWeight, TrailerWeightObtainedMethodID = 3 " +//update trailer val in db
                                                            "WHERE (MSID = @MSID)";
                                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TrailerWeight", cab2WithTrailer), new SqlParameter("@MSID", MSID));
                                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 4083, @TIME, @USER, 'false'); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                 new SqlParameter("@TIME", timestamp),
                                                                                                                                 new SqlParameter("@USER", zxpUD._uid)));

                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, trailer.ToString(), eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                                else
                                {
                                    errorMsg = "Error when calculating trailer. Please review weights and try again.";
                                }
                            }
                            else
                            {
                                errorMsg = "Error when calculating trailer. Please review weights and try again.";
                            }
                            break;
                        case 6://net
                            if (net > 0)
                            {
                                break;
                            }
                            else if ((net == 0 && gross > 0 && cab2WithTrailer > 0))
                            {
                                net = calcProductWeightFromGrossAndCabWTrailer(gross, cab2WithTrailer);//calc netWeight from gross, cab2WTrailer
                            }
                            else if ((net == 0 && gross > 0 && cab1WithTrailer > 0))
                            {
                                net = calcProductWeightFromGrossAndCabWTrailer(gross, cab1WithTrailer);//calc netWeight from gross, cab2WTrailer
                            }
                            else if (net == 0 && gross > 0 && cab1Solo > 0 && trailer > 0)
                            {
                                net = calcProductWeightFromGrossMTCab1AndMTTrailer(gross, cab1Solo, trailer);//calc netWeight from gross, cab1, & trailer
                            }
                            else if (net == 0 && gross > 0 && cab2Solo > 0 && trailer > 0)
                            {
                                net = calcProductWeightFromGrossMTCab1AndMTTrailer(gross, cab2Solo, trailer);//calc netWeight from gross, cab1, & trailer
                            }
                            else {
                                errorMsg = "Error when calculating net. Lack of values";
                                //throw new Exception("Error when calculating net. Lack of values");
                            }
                            if (net > 0)
                            {
                                sqlCmdText = "UPDATE dbo.MainSchedule SET NetProductWeight = @NetProductWeight " +//update netWeight val in db
                                                            "WHERE (MSID = @MSID); ";
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@NetProductWeight", net), new SqlParameter("@MSID", MSID));

                                sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 4079, @TIME, @USER, 'false');" +
                                                            "SELECT SCOPE_IDENTITY()";
                                eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                             new SqlParameter("@TIME", timestamp),
                                                                                                                             new SqlParameter("@USER", zxpUD._uid)));

                                cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "NetProductWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, net.ToString(), eventID, "MSID", MSID.ToString());
                                cLog.CreateChangeLogEntryIfChanged();
                            }
                            else
                            {
                                errorMsg = "Error when calculating net. Cannot have negative net weight. Please review weights and try again.";
                            }
                            break;
                        case 7:
                            if (cab1WithTrailer == 0 && (cab1Solo > 0 && trailer > 0))
                            {
                                cab1WithTrailer = calcCabWithTrailerFromCabAndTrailer(trailer, cab1Solo);//calc cab1WithTrailer from trailer & cab1
                                if (cab1WithTrailer > 0)
                                {
                                    sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1WithTrailerWeight = @Cab1WithTrailerWeight, Cab1WithTrailerWeightObtainedMethodID = 3 " +//update cab1WithTrailer val in db
                                                            "WHERE (MSID = @MSID)";
                                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Cab1WithTrailerWeight", cab1WithTrailer), new SqlParameter("@MSID", MSID));
                                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 7102, @TIME, @USER, 'false'); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                 new SqlParameter("@TIME", timestamp),
                                                                                                                                 new SqlParameter("@USER", zxpUD._uid)));

                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, cab1WithTrailer.ToString(), eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                                else
                                {
                                    errorMsg = "Error when calculating cab 1 with trailer. Please review weights and try again.";
                                }
                            }
                            else if (cab1WithTrailer == 0 && net > 0 && trailer > 0)
                            {
                                cab1WithTrailer = calcCabFromNetAndTrailer(net, trailer);
                                if (cab1WithTrailer > 0)
                                {
                                    sqlCmdText = "UPDATE dbo.MainSchedule SET Cab1WithTrailerWeight = @Cab1WithTrailerWeight, Cab1WithTrailerWeightObtainedMethodID = 3 " +//update cab1WithTrailer val in db
                                                            "WHERE (MSID = @MSID)";
                                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Cab1WithTrailerWeight", cab1WithTrailer), new SqlParameter("@MSID", MSID));
                                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                            "VALUES (@MSID, 7102, @TIME, @USER, 'false'); " +
                                                            "SELECT SCOPE_IDENTITY()";
                                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                                 new SqlParameter("@TIME", timestamp),
                                                                                                                                 new SqlParameter("@USER", zxpUD._uid)));

                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeight", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, cab1WithTrailer.ToString(), eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Cab1WithTrailerWeightObtainedMethodID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "3", eventID, "MSID", MSID.ToString());
                                    cLog.CreateChangeLogEntryIfChanged();
                                }
                                else
                                {
                                    errorMsg = "Error when calculating cab 1 with trailer. Please review weights and try again.";
                                }

                            }
                            else
                            {
                                errorMsg = "Error when calculating cab 1 with trailer. Please review weights and try again.";
                            }

                            break;


                        default:
                            sqlCmdText = string.Empty;
                            break;
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation calculateWeight(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            listOfWeights = getCurrentWeights(MSID);
            returnData.Add(errorMsg);
            returnData.Add(listOfWeights);
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static string verifyAndMove(int MSID, string newLocation)
        {
            DateTime now = DateTime.Now;
            string currentLocation;
            string currentStatus;
            string returnText = "";
            DataSet dataSet = new DataSet();
            int eventID = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP (1) " +
                                    "(SELECT L.LocationLong FROM dbo.Locations AS L WHERE L.LocationShort = MS.LocationShort) AS Location, " +
                                    "(SELECT S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status " +
                                    "FROM dbo.MainSchedule AS MS WHERE MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    currentLocation = Convert.ToString(dataSet.Tables[0].Rows[0]["Location"]);
                    currentStatus = Convert.ToString(dataSet.Tables[0].Rows[0]["Status"]);

                    if (currentLocation == "Guard Station")
                    {
                        if (newLocation == "wait")
                        {
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                        "VALUES (@MSID, 4094, @TimeStamp, @USER, 'false'); " +
                                                        "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                        "VALUES (@MSID, 4, @TimeStamp, @USER, 'false'); " +
                                                        "SELECT SCOPE_IDENTITY()";
                            eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                         new SqlParameter("@TimeStamp", now),
                                                                                                                         new SqlParameter("@USER", zxpUD._uid)));

                            ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), eventID, "MSID", MSID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "WAIT", eventID, "MSID", MSID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();

                            sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = 'WAIT', LastUpdated = @TimeStamp, StatusID = 5,  currentDockSpotID = NULL  WHERE (MSID = @MSID)";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                 new SqlParameter("@TimeStamp", now));
                            returnText = "success";
                        }
                        else if (newLocation == "yard")
                        {
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                        "VALUES (@MSID, 7099, @TimeStamp, @USER, 'false'); " +
                                                        "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                        "VALUES (@MSID, 3065, @TimeStamp, @USER, 'false'); " +
                                                        "SELECT SCOPE_IDENTITY()";
                            eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                         new SqlParameter("@TimeStamp", now),
                                                                                                                         new SqlParameter("@USER", zxpUD._uid)));

                            ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), eventID, "MSID", MSID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "YARD", eventID, "MSID", MSID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();

                            sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = 'YARD', LastUpdated = @TimeStamp, StatusID = 5,  currentDockSpotID = NULL  WHERE (MSID = @MSID)";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                 new SqlParameter("@TimeStamp", now));
                            returnText = "success";
                        }
                    }
                    else
                    {
                        returnText = "Records indicate that this PO is current at " + currentLocation + ". From this screen, you can only move POs whos current location is Guard Station.";

                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation verifyAndMove(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnText;
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
                string strErr = " Exception Error in GuardStation getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }



        [System.Web.Services.WebMethod]
        public static Object getUndoLocationOptions(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

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
                    sqlCmdText  = "SELECT L.LocationShort, LocationLong " +
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
                string strErr = " Exception Error in GuardStation getUndoLocationOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void updateLocationAndUndoCheckOut(int MSID, string newLoc, int dockSpot)
        {
            DateTime now = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3059, 'false'); " +
                        "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventTypeID = 19 AND MSID = @MSID AND isHidden = 'false'" +
                        "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE EventTypeID = 3069 AND MSID = @MSID AND isHidden = 'false'";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@userID", zxpUD._uid),
                                                                                         new SqlParameter("@TimeStamp", now));
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
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = 5, LastUpdated = @TimeStamp, currentDockSpotID = @dockSpotID, TimeDeparted = NULL WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc),
                                                                                             new SqlParameter("@TimeStamp", now),
                                                                                             new SqlParameter("@dockSpotID", TransportHelperFunctions.convertStringEmptyToDBNULL(dockSpot)),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = 5, LastUpdated = @TimeStamp,  currentDockSpotID = NULL, TimeDeparted = NULL WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc),
                                                                                             new SqlParameter("@TimeStamp", now),
                                                                                             new SqlParameter("@MSID", MSID));
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation updateLocationAndUndoCheckOut(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static int verifySpotIsCurrentlyAvailable(int MSID, int spotID)
        {
            int rowCount = 0;
            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                //check request type 
                sqlCmdText = "SELECT count(*) from dbo.MainSchedule as MS " +
                                        "WHERE MS.currentDockSpotID = @SpotID AND MSID != @MSID";
                rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotID", spotID),
                                                                                                                  new SqlParameter("@MSID", MSID)));
                    
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation verifySpotIsCurrentlyAvailable(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static Object verifySpotIsAvailableInSchedule(int MSID, int spotID)
        {
            string DayofWeekID;
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
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
                                                        "   SET @MinMSID = @MinMSID + 1 " +
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
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation verifySpotIsAvailableInSchedule(). Details: " + ex.ToString();
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
                string strErr = " Exception Error in GuardStation GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static bool checkIfTrailerDropped(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            bool returnValue = false;

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT count(*) FROM dbo.MainScheduleEvents " +
                                "WHERE MSID = @MSID AND EVENTTYPEID = 3070 and isHidden = 'false'";
                int rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                if (rowCount != 0)
                {
                    returnValue = true;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkIfTrailerDropped(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnValue;
        }

        [System.Web.Services.WebMethod]
        public static bool checkIfCanUpdateTrailerNumber(int MSID, string TrailerNum)
        {
            int rowCount = 0;
            bool canUpdate = false;

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT COUNT(MS.TrailerNumber) " +
                                    "FROM dbo.MainSchedule MS " +
                                    "WHERE MS.TrailerNumber = @TrailerNum AND MS.LocationShort != 'NOS' AND MS.MSID != @MSID AND MS.ISHIDDEN != 'true'";
                rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TrailerNum", TrailerNum), new SqlParameter("@MSID", MSID)));

                if (rowCount == 0)
                {
                    canUpdate = true;
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation checkIfCanUpdateTrailerNumber(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return canUpdate;
        }

        [System.Web.Services.WebMethod]
        public static string createCustomUrgentTruckMessage(int MSID)
        {
            string customAlertMsg = string.Empty;
            string PONum = null;
            string customerOrderNum = null;
            string customerID = null;
            string trailerNum = null;
            int prodCount = 0;
            string prodName = null;
            string prodDesc = null;


            try
            {
                DataSet truckDetailsDS = getTruckInfoForUrgentCustomMessage(MSID);

                if (truckDetailsDS != null && truckDetailsDS.Tables.Count != 0)
                {

                    if (truckDetailsDS.Tables[0].Rows[0]["PONumber"].Equals(DBNull.Value))
                    {
                        PONum = "N/A";
                    }
                    else
                    {
                        PONum = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["PONumber"]);
                    }


                    if (truckDetailsDS.Tables[0].Rows[0]["PONumber_ZXPOutbound"].Equals(DBNull.Value))
                    {
                        customerOrderNum = "N/A";
                    }
                    else
                    {
                        customerOrderNum = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["PONumber_ZXPOutbound"]);
                    }


                    if (truckDetailsDS.Tables[0].Rows[0]["CustomerID"].Equals(DBNull.Value))
                    {
                        customerID = "N/A";
                    }
                    else
                    {
                        customerID = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["CustomerID"]);
                    }

                    if (truckDetailsDS.Tables[0].Rows[0]["TrailerNumber"].Equals(DBNull.Value))
                    {
                        trailerNum = "N/A";
                    }
                    else
                    {
                        trailerNum = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["TrailerNumber"]);
                    }

                    if (truckDetailsDS.Tables[0].Rows[0]["ProdCount"].Equals(DBNull.Value))
                    {
                        prodCount = 0;
                    }
                    else
                    {
                        prodCount = Convert.ToInt32(truckDetailsDS.Tables[0].Rows[0]["ProdCount"]);
                    }


                    if (prodCount == 0)
                    {
                        customAlertMsg = "Truck marked as urgent has been checked in. Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Product: Not defined" + System.Environment.NewLine;
                    }
                    if (prodCount == 1)
                    {
                        if (truckDetailsDS.Tables[0].Rows[0]["topProdID"].Equals(DBNull.Value))
                        {
                            prodName = "N/A";
                        }
                        else
                        {
                            prodName = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["topProdID"]);
                        }

                        if (truckDetailsDS.Tables[0].Rows[0]["ProductName_CMS"].Equals(DBNull.Value))
                        {
                            prodDesc = "N/A";
                        }
                        else
                        {
                            prodDesc = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["ProductName_CMS"]);
                        }

                        customAlertMsg = "Truck marked as urgent has been checked in. Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Product: " + prodName + " Part # " + prodDesc + System.Environment.NewLine;
                    }


                    else if (prodCount > 1)
                    {
                        string productString = "Products: " + System.Environment.NewLine;
                        ICollection<Tuple<string, string>> listOfProductDetails = new List<Tuple<string, string>>();
                        listOfProductDetails = getProductInfoUrgentCustomMessage(MSID);

                        foreach (var item in listOfProductDetails)
                        {
                            productString = productString + "Product Name: " + Convert.ToString(item.Item1) + "Part# :" + Convert.ToString(item.Item2) + System.Environment.NewLine;
                        }

                        customAlertMsg = "Truck marked as urgent has been checked in. Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            productString + System.Environment.NewLine;
                    }

                }
                else
                {
                    Exception ex = new Exception("No truck info was found.");
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation createCustomUrgentTruckMessage(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return customAlertMsg;
        }

        [System.Web.Services.WebMethod]
        public static DataSet getTruckInfoForUrgentCustomMessage(int MSID)
        {
            DataSet TruckData = new DataSet();
            try
            {
               
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                sqlCmdText = "SELECT MS.PONumber, MS.PONumber_ZXPOutbound, MS.CustomerID, MS.TrailerNumber, " +
                                        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "LEFT JOIN (SELECT MSID, COUNT(PODetailsID) AS PDCount, " +
                                        "(SELECT TOP 1 PD_A.ProductID_CMS " +
                                        "FROM dbo.PODetails PD_A " +
                                        "INNER JOIN dbo.ProductsCMS PCMS_A ON PD_A.ProductID_CMS = PCMS_A.ProductID_CMS " +
                                        "WHERE PD_A.MSID =  PD.MSID " +
                                        ") AS topProdID  " +
                                        "FROM dbo.PODetails PD  " +
                                        "GROUP BY MSID " +
                                        ") ProdDet ON ProdDet.MSID = MS.MSID " +
                                        "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = ProdDet.topProdID " +
                                        "WHERE MS.MSID = @MSID";

                    TruckData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation getTruckInfoForUrgentCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return TruckData;
        }


        [System.Web.Services.WebMethod]
        public static ICollection<Tuple<string, string>> getProductInfoUrgentCustomMessage(int MSID)
        {
            DataSet productInfo = new DataSet();
            string productName;
            string partNum;
            ICollection<Tuple<string, string>> listOfProductDetails = new List<Tuple<string, string>>();
            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                sqlCmdText = "SELECT PODetailsID, ProductID_CMS " +
                                        "FROM dbo.PODetails POD " +
                                        "WHERE MSID = @MSID";

                productInfo = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                foreach (System.Data.DataRow row in productInfo.Tables[0].Rows)
                {
                    if (productInfo.Tables[0].Rows[0]["ProductID_CMS"].Equals(DBNull.Value))
                    {
                        productName = "";
                    }
                    else
                    {
                        productName = Convert.ToString(productInfo.Tables[0].Rows[0]["ProductID_CMS"]);
                    }

                    if (productInfo.Tables[0].Rows[0]["PODetailsID"].Equals(DBNull.Value))
                    {
                        partNum = "";
                    }
                    else
                    {
                        partNum = Convert.ToString(productInfo.Tables[0].Rows[0]["PODetailsID"]);
                    }

                    listOfProductDetails.Add(Tuple.Create(partNum, productName));
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in GuardStation getProductInfoUrgentCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return listOfProductDetails;
        }
    }
}