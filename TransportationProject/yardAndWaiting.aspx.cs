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
    public partial class yardAndWaiting : System.Web.UI.Page
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
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);

                    if (!(zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin || zxpUD._isGuard || zxpUD._isYardMule)) //make sure this matches whats in Site.Master and Default
                    {
                        Response.BufferOutput = true;
                        Response.Redirect("/ErrorPage.aspx?ErrorCode=5", false);
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("/Account/Login.aspx?ReturnURL=/yardAndWaiting.aspx", false);
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in YardAndWait Page_Load(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting Page_Load(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getYardGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int highlightDiff = getHighLightValue();

            try
            {
                
               //string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                //sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber,  " +
                //        "(SELECT TOP 1 S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status, MS.isDropTrailer, " +
                //        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3070 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS DroppedTime, MS.isEmpty, MS.YardComment,  " +
                //        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3074 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS EmptyTime, MS.isOpenInCMS, " +
                //        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3065 AND MS.MSID = MSE.MSID AND isHidden = 'false' order by TimeStamp DESC) AS ArrivedAtYardTime, " +
                //        "(SELECT TOP 1 DATEADD(mi, @HLMINS, (SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 7099 AND MS.MSID = MSE.MSID AND isHidden = 'false') ) ) AS HighlightTimeMax, " +
                //        "(CASE WHEN ((GETDATE() > (SELECT TOP 1 DATEADD(mi, @HLMINS, (SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 7099 AND MS.MSID = MSE.MSID AND isHidden = 'false') ) )) " +
                //        "OR (SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 7099 AND MS.MSID = MSE.MSID AND isHidden = 'false') IS NULL) " +
                //        "THEN  0 " +
                //        "ELSE 1 " +
                //        "END) as HL, " +
                //        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS " +
                //        "FROM dbo.MainSchedule AS MS " +
                //        "LEFT JOIN dbo.TrailersInYard as TiY ON Tiy.MSID = MS.MSID " +
                //        "LEFT JOIN (SELECT MSID, COUNT(PODetailsID) AS PDCount, " +
                //        "(SELECT TOP 1 PD_A.ProductID_CMS " +
                //        "FROM dbo.PODetails PD_A " +
                //        "INNER JOIN dbo.ProductsCMS PCMS_A ON PD_A.ProductID_CMS = PCMS_A.ProductID_CMS " +
                //        "WHERE PD_A.MSID =  PD.MSID " +
                //        ") AS topProdID  " +
                //        "FROM dbo.PODetails PD  " +
                //        "GROUP BY MSID " +
                //        ") ProdDet ON ProdDet.MSID = MS.MSID " +
                //        "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = ProdDet.topProdID " +
                //        "WHERE (MS.LocationShort = 'YARD' OR (MS.LocationShort = 'NOS' AND TiY.MSID is not NULL)) AND MS.isRejected = 'false' AND MS.isHidden = 'false'" +
                //        "UNION " +
                //        "SELECT -1 AS MSID, -1 AS PONumber, TiY.TrailerNumber, " +
                //        "'Waiting' AS Status, 'false' AS isDropTrailer, " +
                //        "NULL AS DroppedTime, 'true' AS isEmpty, NULL AS YardComment,  " +
                //        "NULL AS EmptyTime, -1 AS isOpenInCMS, " +
                //        "NULL AS ArrivedAtYardTime, NULL AS HighlightTimeMax, 0 AS HL, " +
                //        "0 AS ProdCount, NULL AS topProdID, NULL AS ProductName_CMS " +
                //        "FROM dbo.TrailersInYard as TiY " +
                //        "WHERE tiy.MSID is Null";
                
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getYardGridData", new SqlParameter("@OffsetForHighlightingInMinutes", highlightDiff));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getYardGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getWaitGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            int highlightDiff = getHighLightValue();

            try
            {
                
               // string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


               /* sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber, MS.isDropTrailer," +
                        "(SELECT TOP 1 S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status,  MS.isEmpty, MS.WaitingAreaComment, " +
                        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3074 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS EmptyTime, MS.isOpenInCMS, " +
                        "(SELECT TOP (1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 4 AND MS.MSID = MSE.MSID AND isHidden = 'false' order by TimeStamp DESC) AS ArrivedAtWaitTime, " +
                        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 4094 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS FromGSTime, " +
                        "(SELECT TOP 1 DATEADD(mi, @HLMINS, (SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 4094 AND MS.MSID = MSE.MSID AND isHidden = 'false') ) ) AS HighlightTimeMax, " +
                        "(CASE WHEN ((GETDATE() > (SELECT TOP 1 DATEADD(mi, @HLMINS, (SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 4094 AND MS.MSID = MSE.MSID AND isHidden = 'false') ) )) " +
                        "OR (SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 4094 AND MS.MSID = MSE.MSID AND isHidden = 'false') IS NULL) " +
                        "THEN  0 " +
                        "ELSE 1 " +
                        "END) as HL, " +
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
                        "WHERE MS.LocationShort = 'WAIT' AND MS.isRejected = 'false' AND MS.isHidden = 'false'"; */
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getWaitGridData", new SqlParameter("@OffsetForHighlightingInMinutes", highlightDiff));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getWaitGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getPOOptionsInZXP()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber  " +
                        "FROM dbo.MainSchedule AS MS " +
                        "WHERE (MS.LocationShort != 'NOS') AND (MS.isRejected = 'false' AND MS.isHidden = 'false')";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getPOOptionsInZXP(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetLocationOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT L.LocationShort, L.LocationLong FROM dbo.Locations AS L WHERE L.LocationShort = 'WAIT' OR L.LocationShort = 'YARD'";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void updateLocation(int MSID, string newLoc)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
           
            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (newLoc == "YARD")
                    {
                        //3065 placed truck in yard
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                               "VALUES (@MSID, 3065, @TimeStamp, @USER, 'false'); " +
                           "SELECT SCOPE_IDENTITY()";
                    }
                    else //loc = "WAIT"
                    {
                        //4 placed truck in wait
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                  "VALUES (@MSID, 4, @TimeStamp, @USER, 'false'); " +
                              "SELECT SCOPE_IDENTITY()";
                    }

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                        new SqlParameter("@TimeStamp", now),
                                                                                                                        new SqlParameter("@USER", zxpUD._uid)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "5", eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LocationShort", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, newLoc.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //query 1: update location
                    sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, LastUpdated = @TimeStamp, StatusID = 5  WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc),
                                                                                         new SqlParameter("@TimeStamp", now),
                                                                                         new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting updateLocation(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        
        [System.Web.Services.WebMethod]
        public static void updateTrailerNumber(string trailerNumber, int MSID)
        {
            DateTime timestamp =  DateTime.Now; 
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.MainSchedule SET TrailerNumber = @TRAIL WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TRAIL", trailerNumber),
                                                                                         new SqlParameter("@MSID", MSID));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TrailerNumber", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, trailerNumber, null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting updateTrailerNumber(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static List<object> dropTheTrailer(int MSID)
        {
            DateTime now = DateTime.Now;
            string trailer;
            ChangeLog cLog;
            bool didSucceed = false;
            string msg = string.Empty;
            List<object> returnObject = new List<object>();
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //query 1: get trailer
                    sqlCmdText = "SELECT MS.TrailerNumber FROM dbo.MainSchedule AS MS WHERE (MSID = @MSID)";
                    trailer = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (string.IsNullOrWhiteSpace(trailer))
                    {
                        msg = "Trailer number can not be empty when dropped.";
                        returnObject.Add(didSucceed);
                        returnObject.Add(msg);
                        return returnObject;
                    }
                    //query 2 set event
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TrailersInYard", "TrailerNumber", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, trailer.ToString(), null, "TrailerNumber", trailer.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TrailersInYard", "MSID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, MSID.ToString(), null, "TrailerNumber", trailer.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //query 3: drop in trailer 
                    sqlCmdText = "INSERT INTO dbo.TrailersInYard (MSID, TrailerNumber) VALUES (@MSID, @Trailer)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@Trailer", trailer));
                    //query 3: set drop in trailer event
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //query 4 update last updated column
                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TimeStamp WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", now),
                                                                                         new SqlParameter("@MSID", MSID));

                    didSucceed = true;
                    scope.Complete();
                }

                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 3070, null, now, zxpUD._uid, false);
                int newEventID = msEventLog.createNewEventLog(msEvent);
                string customAlertMsg = "Trailer Dropped. " + createDetailsMessageForEventBasedAlerts(MSID, 3070);
                msEventLog.TriggerExistingAlertForEvent(newEventID, customAlertMsg);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            returnObject.Add(didSucceed);
            returnObject.Add(msg);
            return returnObject;
        }

        
        [System.Web.Services.WebMethod]
        public static ICollection<Tuple<string, string>> getProductInfoTrailerDroppedCustomMessage(int MSID)
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
                string strErr = " Exception Error in YardAndWaiting getProductInfoTrailerDroppedCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return listOfProductDetails;
        }




        [System.Web.Services.WebMethod]
        public static string createDetailsMessageForEventBasedAlerts(int MSID, int EventTypeID)
        {
            string customAlertMsg = string.Empty;
            string PONum = null;
            string customerOrderNum = null;
            string customerID = null;
            string trailerNum = null;
            int prodCount = 0;
            string prodName = null;
            string prodDesc = null;
            string firstName = null;
            string lastName = null;


            try
            {
                DataSet truckDetailsDS = getTruckInfoForEventBasedCustomMessage(MSID, EventTypeID);

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


                    if (truckDetailsDS.Tables[0].Rows[0]["FirstName"].Equals(DBNull.Value))
                    {
                        firstName = " ";
                    }
                    else
                    {
                        firstName = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["FirstName"]);
                    }

                    if (truckDetailsDS.Tables[0].Rows[0]["LastName"].Equals(DBNull.Value))
                    {
                        lastName = " ";
                    }
                    else
                    {
                        lastName = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["LastName"]);
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
                        customAlertMsg = "Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Dropped by: " + firstName + " " + lastName + System.Environment.NewLine +
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
                        customAlertMsg = "Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Dropped by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Product: " + prodName + " Part # " + prodDesc + System.Environment.NewLine;
                    }


                    else if (prodCount > 1)
                    {
                        string productString = "Products: " + System.Environment.NewLine;
                        ICollection<Tuple<string, string>> listOfProductDetails = new List<Tuple<string, string>>();
                        listOfProductDetails = getProductInfoTrailerDroppedCustomMessage(MSID);

                        foreach (var item in listOfProductDetails)
                        {
                            productString = productString + "Product Name: " + Convert.ToString(item.Item1) + "Part# :" + Convert.ToString(item.Item2) + System.Environment.NewLine;
                        }

                        customAlertMsg = "Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Dropped by: " + firstName + " " + lastName + System.Environment.NewLine +
                            productString + System.Environment.NewLine;
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
                string strErr = " Exception Error in YardAndWaiting createDetailsMessageForEventBasedAlerts(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return customAlertMsg;
        }

        [System.Web.Services.WebMethod]
        public static DataSet getTruckInfoForEventBasedCustomMessage(int MSID, int EventTypeID)
        {
            DataSet TruckData = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT TOP 1 MS.PONumber, MS.PONumber_ZXPOutbound, MS.CustomerID, MS.TrailerNumber, U.FirstName, U.LastName, " +
                                        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "INNER JOIN dbo.MainScheduleEvents MSE ON MS.MSID = MSE.MSID " +
                                        "INNER JOIN dbo.Users U ON U.UserID = MSE.UserId " +
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
                                        "WHERE MS.MSID = @MSID AND MSE.EventTypeID = @EventTypeID AND MSE.isHidden=0 " + 
                                        "ORDER BY MSE.TimeStamp DESC";
                    TruckData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                    new SqlParameter("@EventTypeID", EventTypeID));
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getTruckInfoForEventBasedCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return TruckData;
        }


        [System.Web.Services.WebMethod]
        public static string emptyTheTrailer(int MSID)
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

                    //query 1 set event;
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, now.ToString(), null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isEmpty", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "true", null, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //query 2 update last updated column
                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TimeStamp, isEmpty = 'true' WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", now),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 3074, null, now, zxpUD._uid, false);
                int newEventID = msEventLog.createNewEventLog(msEvent);
                string customAlertMsg = "Trailer Emptied. " + createDetailsMessageForEventBasedAlerts(MSID, 3074);
                msEventLog.TriggerExistingAlertForEvent(newEventID, customAlertMsg);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting emptyTheTrailer(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return now.ToString();
        }

        [System.Web.Services.WebMethod]
        public static Object getCurrentLocationAndStatus(int MSID)
        {
            List<string> data = new List<string>();
            DataSet dataSet = new DataSet();
            string loc;
            string stat;

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
                    stat = Convert.ToString(dataSet.Tables[0].Rows[0]["Status"]);

                    data.Add(loc);
                    data.Add(stat);

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting getCurrentLocationAndStatus(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static List<string> verifyMove(int MSID, string newLocation)
        {
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
            string currentLocation;
            string currentStatus;
            List<string> returnData = new List<string>();
            
            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT TOP (1) " +
                                        "(SELECT L.LocationLong FROM dbo.Locations AS L WHERE L.LocationShort = MS.LocationShort) AS Location, " +
                                        "(SELECT S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status " +
                                        "FROM dbo.MainSchedule AS MS WHERE MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    currentLocation = Convert.ToString(dataSet.Tables[0].Rows[0]["Location"]);
                    currentStatus = Convert.ToString(dataSet.Tables[0].Rows[0]["Status"]);


                    if (newLocation == "YARD")
                    {
                        switch (currentLocation)
                        {
                            case "Docking Area-Bulk":
                                if (currentStatus == "Waiting" || currentStatus == "Loading Ended" || currentStatus == "Unloading Ended")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                            break;
                            case "Docking Area-Van":
                                if (currentStatus == "Waiting" ||currentStatus == "Loading Ended" || currentStatus == "Unloading Ended")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                            break;

                            case "Guard Station":
                                if (currentStatus == "Weighing" || currentStatus == "Arrived" || currentStatus == "Waiting")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                            break;
                            case "Waiting Area":
                                if (currentStatus == "Waiting")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                            break;
                            default:
                                returnData.Add("false");
                                returnData.Add(currentLocation);
                                returnData.Add(currentStatus);
                            break;

                        }
                    }
                    else if (newLocation == "WAIT")
                    {
                        switch (currentLocation)
                        {
                            case "Docking Area-Bulk":
                                if (currentStatus == "Waiting" || currentStatus == "Loading Ended" || currentStatus == "Unloading Ended")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                                break;

                            case "Docking Area-Van":
                                if (currentStatus == "Waiting" || currentStatus == "Loading Ended" || currentStatus == "Unloading Ended")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                                break;

                            case "Guard Station":
                                if (currentStatus == "Weighing" || currentStatus == "Arrived" || currentStatus == "Waiting")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                                break;

                            case "Trailer Yard":
                                if (currentStatus == "Waiting")
                                {
                                    returnData.Add("true");
                                }
                                else
                                {
                                    returnData.Add("false");
                                    returnData.Add(currentLocation);
                                    returnData.Add(currentStatus);
                                }
                                break;

                            default:
                                returnData.Add("false");
                                returnData.Add(currentLocation);
                                returnData.Add(currentStatus);
                               
                                break;

                        }
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting verifyMove(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnData;
        }


        [System.Web.Services.WebMethod]
        public static void undoEmptyTheTrailer(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            ChangeLog cLog;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //Query 1 - create new event
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3076, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", timestamp)));
                    //Query 2 hide old MT trailer event
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 3074);";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    //Query 3 set event
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, timestamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //Query 4 update last updated 
                    sqlCmdText = "UPDATE dbo.MainSchedule " +
                                        "SET LastUpdated = @TimeStamp WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", timestamp), new SqlParameter("@MSID", MSID));
                    scope.Complete();

                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting undoEmptyTheTrailer(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static void undoDropTheTrailer(int MSID)
        {
            DateTime timestamp = DateTime.Now;
            ChangeLog cLog;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //Query 1 - create new event
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents(MSID, UserId, TimeStamp, EventTypeID, isHidden) VALUES (@MSID, @UserId, @TimeStamp, 3073, 'false'); " +
                                 "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@UserId", zxpUD._uid),
                                                                                                                     new SqlParameter("@TimeStamp", timestamp)));
                    //Query 2 hide old MT trailer event
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' WHERE isHidden = 'false' AND MSID = @MSID AND (EventTypeID = 3070);";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, timestamp.ToString(), eventID, "MSID", MSID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    //Query 3 update last updated 
                    sqlCmdText = "UPDATE dbo.MainSchedule " +
                                        "SET LastUpdated = @TimeStamp WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TimeStamp", timestamp));

                    //Query 4 get trailer num
                    sqlCmdText = "SELECT TrailerNumber FROM dbo.TrailersInYard WHERE MSID = @MSID";
                    string trailer = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                    
                    if (trailer != null)
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.DELETE, "TrailersInYard", "MSID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, MSID.ToString(), eventID, "TrailerNumber", trailer.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        //Query 5 remove from trailers in yard 
                        sqlCmdText = "DELETE FROM dbo.TrailersInYard WHERE MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting undoDropTheTrailer(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in YardAndWaiting GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting GetLogDataByMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
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
                string strErr = " SQLException Error in YardAndWaiting GetLogList(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting GetLogList(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static void setComment(int MSID, string Comment, string CommentType)
        {
            DateTime timestamp = DateTime.Now;
            ChangeLog cLog;
            
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 2035, @TIME, @USER, 'false'); " +
                                    "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                        new SqlParameter("@TIME", timestamp),
                                                                                                                        new SqlParameter("@USER", zxpUD._uid)));

                    if (CommentType == "YARD")
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET YardComment = @COMMENT " +
                                        "WHERE (MSID = @MSID)";

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "YardComment", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, Comment, eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET WaitingAreaComment = @COMMENT " +
                                        "WHERE (MSID = @MSID)";

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "WaitingAreaComment", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, Comment, eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@COMMENT", TransportHelperFunctions.convertStringEmptyToDBNULL(Comment)),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting setComment(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }



        [System.Web.Services.WebMethod]
        public static string verifyIfInspectionIsDoneBeforeUnload(int MSID)
        {
            int numberOfOpenInspections = 0;
            int numberOfInspections = 0;
            string returnString = null;

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT ISNULL(COUNT(*),0) FROM dbo.MainScheduleInspections where MSID = @MSID AND isHidden = 'false' AND InspectionEndEventID IS NULL";
                    numberOfOpenInspections = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (numberOfOpenInspections == 0)
                    {
                        sqlCmdText = "SELECT ISNULL(COUNT(*), 0) FROM dbo.MainScheduleInspections where MSID = @MSID AND isHidden = 'false'";
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
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting verifyIfInspectionIsDoneBeforeUnload(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnString;
        }


        public static int getHighLightValue()
        {
            int minsForHighLight = Int32.Parse(ConfigurationManager.AppSettings["waitAndYardHighlightMins"]);

            return minsForHighLight;
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
                string strErr = " Exception Error in YardAndWaiting GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
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
                                    "WHERE MS.TrailerNumber = @TrailerNum AND MS.LocationShort != 'NOS' AND MS.MSID != @MSID";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TrailerNum", TrailerNum), new SqlParameter("@MSID", MSID)));

                    if (rowCount == 0)
                        canUpdate = true;
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in YardAndWaiting checkIfCanUpdateTrailerNumber(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return canUpdate;
        }


    }
}