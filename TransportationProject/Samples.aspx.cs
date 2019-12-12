using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using System.Transactions;
using System.Web;


namespace TransportationProject
{
    public partial class Samples : System.Web.UI.Page
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

                    if (!(zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin)) //make sure this matches whats in Site.Master and Default
                    {
                        Response.BufferOutput = true;
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/Samples.aspx", false);//zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Samples Page_Load(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples Page_Load(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

        }

        [System.Web.Services.WebMethod]
        public static ZXPUserData getUserData()
        {
            ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
            //create a zxpuserdata with only the necessary data  
            return zxpUD.GetScrubbedUserData(); 
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
                    

                sqlCmdText = "SELECT SpotID, SpotDescription FROM TruckDockSpots Where SpotType = @SpotType AND isDisabled = 0 ORDER BY SpotDescription";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotType", truckType));

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int getCurrentDockSpot(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int currentOrAssignedSpot = 0;

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT ISNULL(MS.currentDockSpotID, 0) FROM dbo.MainSchedule AS MS WHERE MS.MSID = @MSID";
                currentOrAssignedSpot = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                if (currentOrAssignedSpot == 0)
                {
                    sqlCmdText = "SELECT MS.DockSpotID FROM dbo.MainSchedule AS MS WHERE MS.MSID = @MSID";
                    currentOrAssignedSpot = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getCurrentDockSpot(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return currentOrAssignedSpot;
        }


        [System.Web.Services.WebMethod]
        public static void deleteSample(int sampleID, int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 6098, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", now)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "isHidden", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET isHidden = 1 WHERE SampleID =@SID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples deleteSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }
        

        [System.Web.Services.WebMethod]
        public static void approveSample(int MSID, int sampleID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int rowCount;
            DateTime now = DateTime.Now;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3052= Sample Approved
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 3052, @TSTAMP, @USER, 'false');" +
                                    "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid),
                                                                                                                     new SqlParameter("@TSTAMP", now)));


                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "TestApproved", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "16", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET TestApproved = 1, StatusID = 16 WHERE SampleID = @SID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));


                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Samples as S " +
                                            "INNER JOIN dbo.PODetails POD ON POD.PODetailsID = S.PODetailsID " +
                                            "WHERE POD.MSID = @MSID AND S.TestApproved IS NULL AND S.isHidden = 'false' and S.SampleTakenEventID IS NOT NULL";

                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));



                    //if last sample that is approved/reject change truck status to waiting (from sampling)
                    if (rowCount == 0)
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, now.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 5, LastUpdated = @TSTAMP WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", now),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    else
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, now.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TSTAMP WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", now),
                                                                                             new SqlParameter("@MSID", MSID));
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples approveSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoApproveSample(int MSID, int sampleID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3054= Undo Sample Approved
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 3054, @TSTAMP, @USER, 'false');" +
                                    "SELECT SCOPE_IDENTITY()";

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "TestApproved", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "15", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET TestApproved = NULL, StatusID = 15 WHERE SampleID = @SID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "6", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //update status to waiting for sample results
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 6 WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples undoApproveSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void rejectSample(int MSID, int sampleID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int rowCount;
            DateTime now = DateTime.Now;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3053= Sample Rejected
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 3053, @TSTAMP, @USER, 'false');" +
                                    "SELECT SCOPE_IDENTITY()";

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "TestApproved", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "StatusID", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET TestApproved = 0, StatusID = 16 WHERE SampleID = @SID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Samples as S " +
                                    "INNER JOIN dbo.PODetails POD ON POD.PODetailsID = S.PODetailsID " +
                                    "WHERE POD.MSID = @MSID AND S.TestApproved IS NULL AND S.isHidden = 'false' and S.SampleTakenEventID IS NOT NULL";

                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    //if last sample that is approved/reject change truck status to waiting (from sampling)
                    if (rowCount == 0)
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, now.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 5, LastUpdated = @TSTAMP WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", now),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    else
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, now.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TSTAMP WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", now),
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples rejectSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void undoRejectSample(int MSID, int sampleID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
            ChangeLog cLog;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3055= Sample Rejected
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 3053); " +
                                        "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 3055, @TSTAMP, @USER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "TestApproved", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "15", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET TestApproved = NULL, StatusID = 15 WHERE SampleID = @SID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    //update status to waiting for sample results
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "6", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 6 WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples undoRejectSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetLoadOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT LoadTypeShort, LoadTypeLong FROM dbo.LoadTypes WHERE (isUsedOnlyForInspections = 'false' OR isUsedOnlyForInspections is null) ORDER BY LoadTypeLong";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
                  
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples GetLoadOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getCurrentTrailers()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT MSID, TrailerNumber FROM dbo.MainSchedule WHERE(LocationShort NOT IN ('NOS', 'GS')) AND isHidden = 0 AND TrailerNumber IS NOT NULL ORDER BY TrailerNumber";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
                  
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getCurrentTrailers(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getAvailablePOForSamplesGridOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT MSID, PONumber FROM dbo.MainSchedule WHERE (LocationShort != 'NOS' AND LocationShort != 'GS') AND isHidden = 0 ORDER BY PONumber";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getAvailablePOForSamplesGridOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getPODetailProductsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT PODetailsID, PD.ProductID_CMS FROM dbo.PODetails PD INNER JOIN dbo.MainSchedule MS ON MS.MSID = PD.MSID WHERE PD.MSID = @MSID AND MS.isHidden = 0";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getPODetailProductsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetLocationOptions(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            string truckType;
            
            try
            {
               
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                //get current location
                sqlCmdText = "SELECT TOP (1) MS.LocationShort, L.LocationLong, " +
                                        "(SELECT S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS currentStatus, " +
                                        "(SELECT TDS.SpotDescription FROM dbo.TruckDockSpots TDS WHERE MS.currentDockSpotID = TDS.SpotID AND (MS.LocationShort = 'DOCKBULK' OR MS.LocationShort = 'DOCKVAN')) AS currentSpot " +
                                        "FROM dbo.MainSchedule as MS " +
                                        "INNER JOIN dbo.Locations L ON MS.LocationShort = L.LocationShort WHERE MSID = @MSID";

                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                data.Add(dataSet.Tables[0].Rows[0].ItemArray);

            //get truck type
                sqlCmdText = "SELECT MS.TruckType FROM dbo.MainSchedule AS MS WHERE MSID = @MSID";
                truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

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
                string strErr = " Exception Error in Samples GetLocationOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static DateTime takeProductSample(int MSID, int sampleID)
        {
            DateTime timeStamp = DateTime.Now;
            ChangeLog cLog;
            DataSet dataSet = new DataSet();
            try
            {

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 2025= Sample Taken
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 2025, @TSTAMP, @USER, 'false');" +
                                    "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", timeStamp),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //TODO ADD eventid to appropriate column in samples tables
                    //gets current location and status
                    sqlCmdText = "SELECT LocationShort, StatusID FROM dbo.MainSchedule WHERE MSID = @MSID;";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    int statusID = Convert.ToInt32(dataSet.Tables[0].Rows[0]["StatusID"]);
                    string loc = Convert.ToString(dataSet.Tables[0].Rows[0]["LocationShort"]); 

                    
                    //if statusID is not Sampling, change to sampling this is for when there is more than one sample taken
                    if (statusID != 7)
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        
                        //first set to waiting incase sample taken is undone
                        sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 5, LastUpdated = @TSTAMP WHERE MSID = @MSID; ";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", timeStamp), new SqlParameter("@MSID", MSID));
                        
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "7", eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        //set status to sampling
                        sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 7, LastUpdated = @TSTAMP WHERE MSID = @MSID; ";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", timeStamp), new SqlParameter("@MSID", MSID));
                    }

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SampleTakenEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "19", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET SampleTakenEventID = @EID, LocationShort = @loc, StatusID = 19 WHERE SampleID = @SID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID),
                                                                                         new SqlParameter("@loc", loc),
                                                                                         new SqlParameter("@SID", sampleID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples takeProductSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return timeStamp;
        }


        [System.Web.Services.WebMethod]
        public static void undoTakeProductSample(int MSID, int sampleID)
        {
            ChangeLog cLog;
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3050= Undo Sample Taken
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 2025) " +
                                            "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 3050, @TSTAMP, @USER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //TODO ADD eventid to appropriate column in samples tables
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SampleTakenEventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "LocationShort", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET SampleTakenEventID = NULL, StatusID = NULL, LocationShort = NULL WHERE SampleID = @SID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //set status to waiting (sampling is when sample is taken
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 5 WHERE MSID = @MSID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples undoTakeProductSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateCommentLotusIDAndGravity(int sampleID, string comments, string lotusID, float? gravity, string bypassComment)
        {
            ChangeLog cLog;
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "Comments", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, comments, null, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "LotusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, lotusID.ToString(), null, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SpecificGravity", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, gravity.ToString(), null, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "bypassCOFAComment", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, bypassComment, null, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET Comments = @Comments, LotusID = @LotusID, SpecificGravity = @Gravity, bypassCOFAComment = @BypassCOFAComment WHERE (SampleID = @SampleID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Comments", TransportHelperFunctions.convertStringEmptyToDBNULL(comments)),
                                                                                         new SqlParameter("@LotusID", TransportHelperFunctions.convertStringEmptyToDBNULL(lotusID)),
                                                                                         new SqlParameter("@Gravity", TransportHelperFunctions.convertStringEmptyToDBNULL(gravity)),
                                                                                         new SqlParameter("@BypassCOFAComment", TransportHelperFunctions.convertStringEmptyToDBNULL(bypassComment)),
                                                                                         new SqlParameter("@SampleID", sampleID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples updateCommentLotusIDAndGravity(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static DateTime sentProductSample(int MSID, int sampleID)
        {
            DateTime timeStamp = DateTime.Now;
            ChangeLog cLog;
           
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 8= Sample sent to lab
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 8, @TSTAMP, @USER, 'false');" +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", timeStamp),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //TODO ADD eventid to appropriate column in samples tables
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SampleSentEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "20", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET SampleSentEventID = @EID, StatusID = 20 WHERE SampleID = @SID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID), new SqlParameter("@SID", sampleID));
                    
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TSTAMP WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", timeStamp), new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return timeStamp;
        }

        //TODO: ADD USER DATA 
        [System.Web.Services.WebMethod]
        public static void undoSentProductSample(int MSID, int sampleID)
        {
            DateTime now = DateTime.Now;
            ChangeLog cLog;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3038= Undo Sample sent to lab
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 8); " +
                                            "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 3038, @TSTAMP, @USER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //TODO ADD eventid to appropriate column in samples tables
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SampleSentEventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "19", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET SampleSentEventID = NULL, StatusID = 19 WHERE SampleID = @SID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "7", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //update status to sampling
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 7 WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static DateTime receiveProductSample(int MSID, int sampleID)
        {
            DateTime timeStamp = DateTime.Now;
            ChangeLog cLog;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 9= Sample received by lab personnel
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 9, @TSTAMP, @USER, 'false');" +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", timeStamp),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //TODO ADD eventid to appropriate column in samples tables
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SampleLabReceivedEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "15", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET SampleLabReceivedEventID = @EID, StatusID = 15, LocationShort = 'LAB' WHERE SampleID = @SID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID), new SqlParameter("@SID", sampleID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "6", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 6, LastUpdated = @TSTAMP WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", timeStamp), new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples receiveProductSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return timeStamp;
        }

        [System.Web.Services.WebMethod]
        public static void undoReceiveProductSample(int MSID, int sampleID)
        {
            ChangeLog cLog;
            DateTime now = DateTime.Now;
           
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //EventTypeID = 3039= Undo Sample received by lab personnel
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 9); " +
                                            "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 3039, @TSTAMP, @USER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //TODO ADD eventid to appropriate column in samples tables
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "SampleLabReceivedEventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "20", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET SampleLabReceivedEventID = NULL, STATUSID = 20 WHERE SampleID = @SID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SID", sampleID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "7", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //changed status back to sampling
                    sqlCmdText = "UPDATE dbo.MainSchedule SET StatusID = 7 WHERE MSID = @MSID;";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples undoReceiveProductSample(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void createSample(int MSID, int PODetailsID, string Comments)
        {
            ChangeLog cLog;
            DateTime now = DateTime.Now;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (0 == PODetailsID)
                    {
                        throw new Exception("No matching PODetailsID = " + PODetailsID.ToString() + " found for the MSID = " + MSID.ToString());
                    }
                    //EventTypeID = 2036= Sample Created
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 2036, @TIME, @USER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //Log into event log first to get eventid
                    sqlCmdText = "INSERT INTO dbo.Samples(PODetailsID, isHidden, SampleCreatedEventID, Comments) VALUES (@PODID, 0, @EID, @COMMENTS); " +
                                         "SELECT SCOPE_IDENTITY()";
                    int sampleID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PODID", PODetailsID),
                                                                                                                      new SqlParameter("@EID", eventID),
                                                                                                                      new SqlParameter("@COMMENTS", TransportHelperFunctions.convertStringEmptyToDBNULL(Comments))));
                    
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "PODetailsID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, PODetailsID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "isHidden", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "false", eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "SampleCreatedEventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "Comments", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, Comments, eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();                    
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, now.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", now), new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples createSample(). Details: " + ex.ToString();
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
                string strErr = " Exception Error in Samples ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static void AddFileDBEntry(int MSID, string fileType, string filenameOld, string filenameNew, string filepath, string fileDescription, int SampleID)
        {//is currently not being used 
            ChangeLog cLog;
            DateTime now = DateTime.Now;
           
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //First find filetypeID
                    sqlCmdText = "SELECT FileTypeID FROM dbo.FileTypes WHERE FileType = @FTYPE";
                    int filetypeID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FTYPE", fileType)));

                    sqlCmdText = "INSERT INTO dbo.MainScheduleFiles (MSID, FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld, isHidden) " +
                                        "VALUES (@PMSID, @PFTID, @PDESC, @PFPATH, @PFNEW, @PFOLD, 0);" +
                                        "SELECT SCOPE_IDENTITY()";
                    int newFileID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                     new SqlParameter("@PFTID", filetypeID),
                                                                                                                     new SqlParameter("@PDESC", fileDescription),
                                                                                                                     new SqlParameter("@PFPATH", filepath),
                                                                                                                     new SqlParameter("@PFNEW", filenameNew),
                                                                                                                     new SqlParameter("@PFOLD", filenameOld)));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Samples", "FileID_COFA", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, newFileID.ToString(), null, "SampleID", SampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET FileID_COFA = @FID WHERE SampleID = @SampleID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FID", newFileID), new SqlParameter("@SampleID", SampleID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples AddFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getSampleGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
           
            try
            {
               
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = string.Concat( "SELECT  MSID ,PODetailsID ,PONumber ,ProductID_CMS ,FileID ,Filepath ,FilenameOld ,SampleID, LotusID ,TimeSampleTaken ,TimeSampleSent ",
                        ",TimeSampleReceived ,didLabNotReceived ,Comments ,FilenameNew ,TestApproved ,TrailerNumber ,FirstName ,LastName ,bypassCOFAComment ,SpecificGravity ",
                        ",isOpenInCMS ,isRejected ,ProductName_CMS ",
                            "FROM dbo.vw_SampleGridData ",
                            "ORDER BY TestApproved, didLabNotReceived, TimeSampleReceived") ;

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getSampleGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
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
                string strErr = " SQLException Error in Samples GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in Samples GetLogList(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples GetLogList(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
            }
            return data;
        }

        //password hasher
        private static string MD5Hash(string INPUT)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.UTF8.GetBytes(INPUT));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            return sBuilder.ToString();
        }

        [System.Web.Services.WebMethod]
        public static int checkLabAdminCredentials(string userName, string password)
        {
            int canBypasserID = 0;
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT TOP (1) UserID FROM dbo.Users WHERE UserName = @Username AND Password = @Password AND isLabAdmin = 'true' AND isDisabled = 'false'";
                    string hashedPassword = DataTransformer.PasswordHash(password);
                    canBypasserID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Username", userName),
                                                                                                                       new SqlParameter("@Password", hashedPassword)));
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples checkLabAdminCredentials(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return canBypasserID;
        }

        [System.Web.Services.WebMethod]
        public static void bypassCOFA(int sampleID, int bypasserUserID, string bypassComment, int MSID)
        {
            DateTime now = DateTime.Now;
            int eventID = 0;
            ChangeLog cLog;
            int bypassID;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (bypasserUserID == 0) //when user is already a lab admin, 0 is passed. 
                    {
                        bypassID = zxpUD._uid;
                    }
                    else //Other wise lab admin user id is passed here
                    {
                        bypassID = bypasserUserID;
                    }
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@MSID, 4096, @TimeStamp, @bypasserUserID, 'false'); " +
                                                "SELECT CAST(scope_identity() AS int)";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                 new SqlParameter("@TimeStamp", now),
                                                                                                                 new SqlParameter("@bypasserUserID", bypassID)));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, now.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TimeStamp WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", now), new SqlParameter("@MSID", MSID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "bypassCOFAComment", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, bypassComment.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "bypassApproverUserID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, bypasserUserID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "COFAEventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "SampleID", sampleID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET bypassCOFAComment = @bypassComment, bypassApproverUserID = @bypasserUserID, COFAEventID = @eventID WHERE (SampleID = @SampleID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@bypassComment", bypassComment),
                                                                                         new SqlParameter("@bypasserUserID", bypassID),
                                                                                         new SqlParameter("@eventID", eventID),
                                                                                         new SqlParameter("@SampleID", sampleID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples bypassCOFA(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getListofTrucksCurrentlyInZXP()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber,  MS.LocationShort " +
                                        "FROM dbo.MainSchedule as MS " +
                                        "WHERE MS.LocationShort != 'NOS' AND MS.isHidden = 0";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object updateLocation(int MSID, string newLoc, int dockSpot)
        {
            DateTime now = DateTime.Now;
            List<object> returnData = new List<object>();
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText = null;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

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
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, dockSpot.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    if (newLoc == "DOCKBULK" || newLoc == "DOCKVAN")
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = 5, LastUpdated = @TimeStamp, currentDockSpotID = @dockSpotID WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc), 
                                                                                             new SqlParameter("@TimeStamp", now), 
                                                                                             new SqlParameter("@dockSpotID", TransportHelperFunctions.convertStringEmptyToDBNULL(dockSpot)), 
                                                                                             new SqlParameter("@MSID", MSID));
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = 5, LastUpdated = @TimeStamp, currentDockSpotID = null WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc), new SqlParameter("@TimeStamp", now), new SqlParameter("@MSID", MSID));
                    }
                    sqlCmdText = "SELECT StatusText FROM dbo.Status WHERE StatusID = 5";
                    string statusText = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText));

                    returnData.Add(statusText);
                    returnData.Add(5);

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples updateLocation(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static Object getSampleGridDataByMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, PD.PODetailsID, MS.PONumber, PD.ProductID_CMS, " +
                        "MSF.FileID, MSF.Filepath, MSF.FilenameOld, S.SampleID, S.LotusID, " +
                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleTakenEventID = MSE1.EventID " +
                                        "WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleTaken, " +
                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleSentEventID = MSE1.EventID " +
                                        "WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleSent, " +
                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleLabReceivedEventID = MSE1.EventID " +
                                        "WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleReceived, " +
                        "S.Comments, MSF.FilenameNew, TestApproved, TrailerNumber, " +
                        "(SELECT FirstName FROM dbo.Users WHERE S.bypassApproverUserID = UserID), " +
                        "(SELECT LastName FROM dbo.Users WHERE S.bypassApproverUserID = UserID), " +
                        "S.bypassCOFAComment, S.SpecificGravity, MS.isOpenInCMS, MS.isRejected, PCMS.ProductName_CMS   " +
                        "FROM dbo.MainSchedule MS " +
                        "INNER JOIN dbo.PODetails PD ON MS.MSID = PD.MSID " +
                        "INNER JOIN dbo.Samples S ON S.PODetailsID = PD.PODetailsID " +
                        "LEFT JOIN dbo.MainScheduleFiles MSF ON MSF.MSID = MS.MSID AND S.FileID_COFA = MSF.FileID " +
                        "LEFT JOIN dbo.ProductsCMS AS PCMS ON PD.ProductID_CMS = PCMS.ProductID_CMS " +
                        "LEFT JOIN dbo.MainScheduleEvents AS MSE ON MSE.EventID = S.COFAEventID " +
                        "WHERE (MSF.FileTypeID = 2 OR MSF.FileTypeID iS NULL) AND (MSF.isHidden = 0 OR MSF.isHidden IS NULL) AND S.isHidden = 0 AND MS.isHidden = 0 AND MS.MSID = @MSID " +
                        "AND (MSE.EventTypeID != 4096 OR S.COFAEventID IS NULL) " +
                        "ORDER BY CASE WHEN (SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleLabReceivedEventID = MSE1.EventID " + 
                            "WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) IS NULL THEN 1 ELSE 0 END, TimeSampleReceived";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                 
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getSampleGridDataByMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getCurrentLocationAndStatus(int MSID)
        {
            List<object> data = new List<object>();
            DataSet dataSet = new DataSet();
            string locShort;
            int statShort;
            string locLong;
            string statLong;
            bool canSample = false;
            bool canUpdateLocation = false;

            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP (1) MS.LocationShort, MS.StatusID, L.LocationLong, S.StatusText " +
                                      "FROM dbo.MainSchedule AS MS " +
                                      "INNER JOIN dbo.Locations AS L ON MS.LocationShort = L.LocationShort " +
                                      "INNER JOIN dbo.Status AS S ON S.StatusID = MS.StatusID " +
                                      "WHERE MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    locShort = Convert.ToString(dataSet.Tables[0].Rows[0]["LocationShort"]);
                    statShort = Convert.ToInt32(dataSet.Tables[0].Rows[0]["StatusID"]);

                    locLong = Convert.ToString(dataSet.Tables[0].Rows[0]["LocationLong"]);
                    statLong = Convert.ToString(dataSet.Tables[0].Rows[0]["StatusText"]);


                    if (locShort == "GS" || locShort == "NOS")
                    {
                        canSample = false;
                        if (statShort == 3 || statShort == 2) //2 = arrived, 3 = weighting
                        {
                            canUpdateLocation = true;
                        }
                    }
                    else if (statShort != 5 && statShort != 9 && statShort != 12 && statShort != 14 && statShort != 7)// 5= waiting, 9 == inspection ended, 12 = loadingEnded, 14 = unloadEnded, 7 = sampling
                    {
                        canSample = true;
                        if (statShort != 7) //7 = sampling (cant move while sampling)
                        {
                            canUpdateLocation = true;
                        }
                    }
                    else
                    {
                        canSample = true;
                        if (statShort == 3 || statShort == 2) //2 = arrived, 3 = weighting
                        {
                            canUpdateLocation = true;
                        }
                    }

                    data.Add(canSample);
                    data.Add(locLong);
                    data.Add(statLong);
                    data.Add(canUpdateLocation);
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getCurrentLocationAndStatus(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static List<string> CreateRequestForReSample(int rMSID, string trailnum, string productString, int OrginalSampleID, int PODetailsID)
        {
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
            List<string> returnData = new List<string>();
            string comments = null;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //------INSERT NEW REQUEST 
                    sqlCmdText = "INSERT INTO dbo.Requests (MSID, TrailerNumber, Task, Requester, RequestPersonTypeID, RequestTypeID, isVisible) " +
                                    "VALUES (@MSID, @TRAILER, @TASK, @REQUESTER, 1, 3, 1); " +
                                    "SELECT SCOPE_IDENTITY()";

                    int requestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", rMSID),
                                                                                                                        new SqlParameter("@TRAILER", TransportHelperFunctions.convertStringEmptyToDBNULL(trailnum)),
                                                                                                                        new SqlParameter("@TASK", productString),
                                                                                                                        new SqlParameter("@REQUESTER", zxpUD._uid)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "MSID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, rMSID.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "TrailerNumber", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, trailnum.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Task", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, productString.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Requester", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "isVisible", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //------log request created into mainscheduleevents table
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 2027, @TIME, @REQUESTER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", rMSID),
                                                                                                                        new SqlParameter("@TIME", now),
                                                                                                                        new SqlParameter("@REQUESTER", zxpUD._uid)));
                    //log into mainschedulerequestevents table
                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                 "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@EID", eventID));

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //get timestamps
                    sqlCmdText = "SELECT " +
                                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleTakenEventID = MSE1.EventID WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleTaken, " +
                                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleSentEventID = MSE1.EventID WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleSent, " +
                                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleLabReceivedEventID = MSE1.EventID WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleReceived " +
                                        "FROM dbo.MainSchedule MS " +
                                        "INNER JOIN dbo.PODetails PD ON MS.MSID = PD.MSID " +
                                        "INNER JOIN dbo.Samples S ON S.PODetailsID = PD.PODetailsID " +
                                        "WHERE S.SampleID = @SampleID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SampleID", OrginalSampleID));

                    string TimeSampleTaken;
                    string TimeSampleSent;
                    string TimeSampleReceived;

                    if (dataSet.Tables[0].Rows[0]["TimeSampleTaken"].Equals(DBNull.Value))
                    {
                        TimeSampleTaken = "N/A";
                    }
                    else
                    {
                        TimeSampleTaken = Convert.ToString(dataSet.Tables[0].Rows[0]["TimeSampleTaken"]);
                    }

                    if (dataSet.Tables[0].Rows[0]["TimeSampleSent"].Equals(DBNull.Value))
                    {
                        TimeSampleSent = "N/A";
                    }
                    else
                    {
                        TimeSampleSent = Convert.ToString(dataSet.Tables[0].Rows[0]["TimeSampleSent"]);
                    }

                    if (dataSet.Tables[0].Rows[0]["TimeSampleReceived"].Equals(DBNull.Value))
                    {
                        TimeSampleReceived = "N/A";
                    }
                    else
                    {
                        TimeSampleReceived = Convert.ToString(dataSet.Tables[0].Rows[0]["TimeSampleReceived"]);
                    }
                    comments = "Resample - Orginal Sample Data: Sample Taken at " + TimeSampleTaken + ", Sample Sent to Lab at " + TimeSampleSent + ", Sample Received by Lab at " + TimeSampleReceived + ", Resample Request Sent by Lab at " + now;

                    scope.Complete();
                }

                createSample(rMSID, PODetailsID, comments);
                returnData.Add("true");

                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                MainScheduleEvent msEvent = new MainScheduleEvent(rMSID, 8098, null, now, zxpUD._uid, false);
                int newEventID = msEventLog.createNewEventLog(msEvent);
                string customAlertMsg = "Resample. " + createDetailsMessageForEventBasedAlerts(rMSID, 8098, OrginalSampleID);
                msEventLog.TriggerExistingAlertForEvent(newEventID, customAlertMsg);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static Object getApprovedAndRejectedSampleGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, PD.PODetailsID, MS.PONumber, PD.ProductID_CMS, " +
                        "MSF.FileID, MSF.Filepath, MSF.FilenameOld, S.SampleID, S.LotusID, " +
                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleTakenEventID = MSE1.EventID WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleTaken, " +
                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleSentEventID = MSE1.EventID WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleSent, " +
                        "(SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleLabReceivedEventID = MSE1.EventID WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) AS TimeSampleReceived, " +
                        "S.Comments, MSF.FilenameNew, TestApproved, TrailerNumber, " +
                        "(SELECT FirstName FROM dbo.Users WHERE S.bypassApproverUserID = UserID), " +
                        "(SELECT LastName FROM dbo.Users WHERE S.bypassApproverUserID = UserID), " +
                        "S.bypassCOFAComment, S.SpecificGravity, MS.isOpenInCMS, MS.isRejected, PCMS.ProductName_CMS, MS.isRejected  " +
                        "FROM dbo.MainSchedule MS " +
                        "INNER JOIN dbo.PODetails PD ON MS.MSID = PD.MSID " +
                        "INNER JOIN dbo.Samples S ON S.PODetailsID = PD.PODetailsID " +
                        "LEFT JOIN dbo.MainScheduleFiles MSF ON MSF.MSID = MS.MSID AND S.FileID_COFA = MSF.FileID " +
                        "LEFT JOIN dbo.ProductsCMS AS PCMS ON PD.ProductID_CMS = PCMS.ProductID_CMS " +
                        "LEFT JOIN dbo.MainScheduleEvents AS MSE ON MSE.EventID = S.COFAEventID " +
                        "WHERE S.isHidden = 0 AND MS.isHidden = 0 AND MS.isOpenInCMS = 'true' AND S.TestApproved IS NOT NULL " +
                        "ORDER BY TestApproved, CASE WHEN (SELECT TOP (1) Timestamp FROM dbo.MainScheduleEvents MSE1 INNER JOIN dbo.Samples AS S1 ON S1.SampleLabReceivedEventID = MSE1.EventID " +
                                "WHERE S1.SampleID = S.SampleID AND MSE1.MSID = MS.MSID ORDER BY TimeStamp DESC ) IS NULL THEN 1 ELSE 0 END, TimeSampleReceived";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Samples getApprovedAndRejectedSampleGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static DataSet getTruckAndSampleInfoForEventBasedCustomMessage(int MSID, int EventTypeID, int SampleID)
        {
            DataSet TruckData = new DataSet();
            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT POD.ProductID_CMS, pCMS.ProductName_CMS, S.Comments, MS.PONumber, MS.PONumber_ZXPOutbound, MS.CustomerID, MS.TrailerNumber, U.FirstName, U.LastName " +
                                        "FROM dbo.Samples S  " +
                                        "INNER JOIN dbo.PODetails POD ON POD.PODetailsID = POD.PODetailsID " +
                                        "INNER JOIN dbo.ProductsCMS pCMS ON pCMS.ProductID_CMS = POD.ProductID_CMS " +
                                        "INNER JOIN dbo.MainSchedule MS ON MS.MSID = POD.MSID " +
                                        "INNER JOIN dbo.MainScheduleEvents MSE ON MS.MSID = MSE.MSID  " +
                                        "INNER JOIN dbo.Users U ON U.UserID = MSE.UserId " +
                                        "WHERE S.SampleID = @SampleID AND MS.MSID = @MSID AND MSE.EventTypeID = @EventTypeID";

                    TruckData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SampleID", SampleID),
                                                                                                    new SqlParameter("@MSID", MSID),
                                                                                                    new SqlParameter("@EventTypeID", EventTypeID));
                 
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in yardAndWaiting getTruckInfoForEventBasedCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return TruckData;
        }



        [System.Web.Services.WebMethod]
        public static string createDetailsMessageForEventBasedAlerts(int MSID, int EventTypeID, int SampleID)
        {
            string customAlertMsg = string.Empty;
            string prodName = null;
            string prodDesc = null;
            string labComment = null;
            string PONum = null;
            string customerOrderNum = null;
            string customerID = null;
            string trailerNum = null;
            string firstName = null;
            string lastName = null;


            try
            {
                DataSet truckAndSampleDetailsDS = getTruckAndSampleInfoForEventBasedCustomMessage(MSID, EventTypeID, SampleID);

                if (truckAndSampleDetailsDS != null && truckAndSampleDetailsDS.Tables.Count != 0)
                {
                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["ProductID_CMS"].Equals(DBNull.Value))
                    {
                        prodDesc = "N/A";
                    }
                    else
                    {
                        prodDesc = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["ProductID_CMS"]);
                    }

                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["ProductName_CMS"].Equals(DBNull.Value))
                    {
                        prodName = "N/A";
                    }
                    else
                    {
                        prodName = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["ProductName_CMS"]);
                    }

                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["Comments"].Equals(DBNull.Value))
                    {
                        labComment = "";
                    }
                    else
                    {
                        labComment = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["Comments"]);
                    }


                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["PONumber"].Equals(DBNull.Value))
                    {
                        PONum = "N/A";
                    }
                    else
                    {
                        PONum = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["PONumber"]);
                    }


                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["PONumber_ZXPOutbound"].Equals(DBNull.Value))
                    {
                        customerOrderNum = "N/A";
                    }
                    else
                    {
                        customerOrderNum = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["PONumber_ZXPOutbound"]);
                    }


                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["CustomerID"].Equals(DBNull.Value))
                    {
                        customerID = "N/A";
                    }
                    else
                    {
                        customerID = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["CustomerID"]);
                    }

                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["TrailerNumber"].Equals(DBNull.Value))
                    {
                        trailerNum = "N/A";
                    }
                    else
                    {
                        trailerNum = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["TrailerNumber"]);
                    }


                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["FirstName"].Equals(DBNull.Value))
                    {
                        firstName = " ";
                    }
                    else
                    {
                        firstName = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["FirstName"]);
                    }

                    if (truckAndSampleDetailsDS.Tables[0].Rows[0]["LastName"].Equals(DBNull.Value))
                    {
                        lastName = " ";
                    }
                    else
                    {
                        lastName = Convert.ToString(truckAndSampleDetailsDS.Tables[0].Rows[0]["LastName"]);
                    }

                    if (EventTypeID == 3053)//sample rej
                    {
                        customAlertMsg = "Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Product Name: " + prodName + " Part #:" + prodDesc + System.Environment.NewLine +
                            "Sample Rejected by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Lab Comment: " + labComment + System.Environment.NewLine;
                    }
                    else if (EventTypeID == 3052)//sample aprv
                    {
                        customAlertMsg = "Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Product Name: " + prodName + " Part #:" + prodDesc + System.Environment.NewLine +
                            "Sample Approved by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Lab Comment: " + labComment + System.Environment.NewLine;
                    }

                    else if (EventTypeID == 8098)//resample
                    {
                        customAlertMsg = "Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Product Name: " + prodName + " Part #:" + prodDesc + System.Environment.NewLine +
                            "Resample Requested by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Lab Comment: " + labComment + System.Environment.NewLine;
                    }
                }
                else
                {
                    Exception ex = new Exception("No truck info was found. Please check if this is the correct inspection");
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in samples createDetailsMessageForEventBasedAlerts(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return customAlertMsg;
        }



    }
}