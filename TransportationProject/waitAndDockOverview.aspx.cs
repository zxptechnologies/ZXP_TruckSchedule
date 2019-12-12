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
    public partial class waitAndDockOverview : System.Web.UI.Page
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

                    if (zxpUD._uid == -1) //make sure this matches whats in Site.Master and Default
                    {
                        Response.BufferOutput = true;
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/waitAndDockOverview.aspx", false);
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in waitAndDockOverview Page_Load(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in waitAndDockOverview Page_Load(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
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

                    sqlCmdText = "SELECT LocationShort, LocationLong FROM dbo.Locations ORDER BY LocationLong";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview GetLocationOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetStatusOptions()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT StatusID, StatusText FROM dbo.Status";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                  
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview GetStatusOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDockSpotsForBulk()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT SpotID, SpotDescription FROM TruckDockSpots Where SpotType = 'Bulk' AND isDisabled = 0 ORDER BY SpotDescription";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getDockSpotsForBulk(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }
		
        [System.Web.Services.WebMethod]
        public static Object getDockSpots()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT SpotID, SpotDescription FROM TruckDockSpots Where isDisabled = 0 ORDER BY SpotDescription";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDockSpotsForVan()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT SpotID, SpotDescription FROM TruckDockSpots Where SpotType = 'Van' AND isDisabled = 0 ORDER BY SpotDescription";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getDockSpotsForVan(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getWaitingAreaData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            
            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber, MS.isDropTrailer," +
                                    "(SELECT TOP 1 S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status,  MS.isEmpty, MS.WaitingAreaComment,  " +
                                    "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3074 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS EmptyTime, MS.isOpenInCMS, MS.isRejected, " +
                                            "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime,  " +
                                    "(SELECT TOP (1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 4 AND MS.MSID = MSE.MSID AND isHidden = 'false' order by TimeStamp DESC) AS ArrivedAtWaitTime " +
                                    "FROM dbo.MainSchedule AS MS " +
                                    "WHERE MS.LocationShort = 'WAIT' AND MS.isHidden = 'false'";
               
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getWaitingAreaData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDockVanData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber, MS.currentDockSpotID, " +
                                        "(SELECT TOP(1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.MSID = MS.MSID AND MSE.isHidden = 'false' AND (MSE.EventTypeID = 5)) TimePlacedInDock, MS.isRejected, MS.isOpenInCMS, " +
                                        "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime " +
                                        "FROM dbo.MainSchedule AS MS WHERE MS.LocationShort = 'DOCKVAN' AND MS.isHidden = 'false'";
                

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getDockVanData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getScheduledTrucks()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, PONumber,  MS.ETA, MS.Comments, TimeArrived, TimeDeparted, " +
                            //"(SELECT TOP (1) TimeStamp FROM dbo.MainScheduleEvents MSE LEFT JOIN dbo.EventSubTypes EST ON MSE.EventSubTypeID = EST.EventSubTypeID  WHERE MSE.MSID = MS.MSID AND (MSE.EventTypeID = 2 OR (MSE.EventTypeID = 3064 AND EventSubType = 'GSO')) AND isHidden = 'false' ORDER BY TimeStamp DESC) AS CheckIn, " +
                            //"(SELECT TOP (1) TimeStamp FROM dbo.MainScheduleEvents MSE LEFT JOIN dbo.EventSubTypes EST ON MSE.EventSubTypeID = EST.EventSubTypeID WHERE MSE.MSID = MS.MSID AND (MSE.EventTypeID = 19 OR (MSE.EventTypeID = 3064 AND EventSubType = 'REL')) AND isHidden = 'false' ORDER BY TimeStamp DESC) AS CheckOut, " +
                                "TrailerNumber, isRejected, MS.LocationShort, MS.StatusID, MS.currentDockSpotID, MS.DockSpotID, MS.isOpenInCMS, " +
                                "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime, " +
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
                                "WHERE MS.isHidden = 0 AND ((MS.ETA <= (CONVERT(date, getdate()+ 1))) AND (MS.ETA >= (CONVERT(date, getdate()))))";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }
        
        [System.Web.Services.WebMethod]
        public static Object getTrailerInYardData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber, " +
                                        "(SELECT TOP 1 S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status, MS.isDropTrailer, " +
                                        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3070 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS DroppedTime, MS.isEmpty, MS.YardComment, "+
                                        "(SELECT TOP 1 MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.EventTypeID = 3074 AND MS.MSID = MSE.MSID AND isHidden = 'false') AS EmptyTime, MS.isOpenInCMS,  " +
                                        "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime, " +
                                        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS "+
                                        "FROM dbo.MainSchedule AS MS " +
                                        "LEFT JOIN (SELECT MSID, COUNT(PODetailsID) AS PDCount, " +
                                        "(SELECT TOP 1 PD_A.ProductID_CMS " +
                                        "FROM dbo.PODetails PD_A " +
                                        "INNER JOIN dbo.ProductsCMS PCMS_A ON PD_A.ProductID_CMS = PCMS_A.ProductID_CMS " +
                                        "WHERE PD_A.MSID =  PD.MSID " +
                                        ") AS topProdID  " +
                                        "FROM dbo.PODetails PD  "+
                                        "GROUP BY MSID " +
                                        ") ProdDet ON ProdDet.MSID = MS.MSID " +
                                        "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = ProdDet.topProdID " +
                                        "LEFT JOIN dbo.TrailersInYard as TiY ON Tiy.MSID = MS.MSID " +
                                        "WHERE (MS.LocationShort = 'YARD' OR (MS.LocationShort = 'NOS' AND TiY.MSID is not NULL)) AND MS.isRejected = 'false' AND MS.isHidden = 'false' " +
                                        "UNION " +
                                        "SELECT -1 AS MSID, -1 AS PONumber, TiY.TrailerNumber, " +
                                        "'Waiting' AS Status, 'false' AS isDropTrailer, " +
                                        "NULL AS DroppedTime, 'true' AS isEmpty, NULL AS YardComment,  " +
                                        "NULL AS EmptyTime, -1 AS isOpenInCMS, NULL AS DemurrageTime, " +
                                        "0 AS ProdCount, NULL AS topProdID, NULL AS ProductName_CMS " +
                                        "FROM dbo.TrailersInYard as TiY " +
                                        "WHERE tiy.MSID is Null";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getTrailerInYardData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getReleasedTrucksData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, PONumber,  MS.ETA, MS.Comments, " +
                            //"(SELECT TOP (1) TimeStamp FROM dbo.MainScheduleEvents MSE LEFT JOIN dbo.EventSubTypes EST ON MSE.EventSubTypeID = EST.EventSubTypeID  WHERE MSE.MSID = MS.MSID AND (MSE.EventTypeID = 2 OR (MSE.EventTypeID = 3064 AND EventSubType = 'GSO')) AND isHidden = 'false' ORDER BY TimeStamp DESC) AS CheckIn, " +
                            //"(SELECT TOP (1) TimeStamp FROM dbo.MainScheduleEvents MSE LEFT JOIN dbo.EventSubTypes EST ON MSE.EventSubTypeID = EST.EventSubTypeID WHERE MSE.MSID = MS.MSID AND (MSE.EventTypeID = 19 OR (MSE.EventTypeID = 3064 AND EventSubType = 'REL')) AND isHidden = 'false' ORDER BY TimeStamp DESC) AS CheckOut, " +
                                    "TimeArrived, TimeDeparted, TrailerNumber, isRejected, MS.isOpenInCMS, " +
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
                                    "WHERE MS.isHidden = 0 AND MS.LocationShort = 'NOS' AND MS.StatusID = 10 AND TimeDeparted >=Convert(date, getdate()) AND TimeDeparted < Convert(date, DATEADD(d,1, getdate()))  ";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getReleasedTrucksData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getPendSamplesTruckData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.LocationShort, S.SampleID, S.TestApproved, TrailerNumber, MS.StatusID, isRejected, MS.isOpenInCMS, " +
                                        "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime, " +
                                        "PCMS.ProductName_CMS, POD.ProductID_CMS " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "INNER JOIN dbo.PODetails AS POD ON MS.MSID = POD.MSID " +
                                        "INNER JOIN dbo.Samples AS S ON S.PODetailsID = POD.PODetailsID " +
                                        "LEFT JOIN dbo.ProductsCMS AS PCMS ON POD.ProductID_CMS = PCMS.ProductID_CMS " +
                                        "WHERE S.isHidden = 0 AND MS.isHidden = 0 AND MS.isOpenInCMS = 'true' AND S.TestApproved IS NULL " +
                                        //"WHERE S.isHidden = 0 AND MS.isHidden = 0 AND TestApproved IS NULL AND (MS.LocationShort NOT IN ('NOS')) " +
                                        "ORDER BY MS.MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getPendSamplesTruckData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }
        
        [System.Web.Services.WebMethod]
        public static Object getTruckWithInspectionsDone()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, PONumber, MS.LocationShort, isRejected, TrailerNumber, MS.StatusID, " +
                                         "(SELECT TOP(1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.MSID = MS.MSID AND MSE.isHidden = 'false' AND (MSE.EventTypeID = 3051 OR MSE.EventTypeID = 7) ORDER BY TimeStamp DESC) AS ReOpenOrStart, " +
                                         "(SELECT TOP(1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.MSID = MS.MSID AND MSE.isHidden = 'false' AND (MSE.EventTypeID = 22) ORDER BY TimeStamp DESC) AS Closed, MS.isOpenInCMS, " +
                                        "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "WHERE MS.StatusID = 8 OR MS.StatusID = 9 AND MS.isHidden = 0 ";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getTruckWithInspectionsDone(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDockBulkData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber, MS.currentDockSpotID, " +
                                            "(SELECT TOP(1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE MSE.MSID = MS.MSID AND MSE.isHidden = 'false' AND (MSE.EventTypeID = 6)) TimePlacedInDock, MS.isRejected, MS.isOpenInCMS, " +
                                                "DATEDIFF(minute, (SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC), GETDATE() ) AS DemurrageTime " +
                                            "FROM dbo.MainSchedule AS MS WHERE MS.LocationShort = 'DOCKBULK' AND MS.isHidden = 'false'";

               
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getDockBulkData(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in waitAndDockOverview GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in waitAndDockOverview GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in waitAndDockOverview GetLogList(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in waitAndDockOverview GetLogList(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static List<int> getColorCellSettings()
        {
            List<int> listOfCellColorSettings = new List<int>();
            int yellowCellSetting;
            int orangeCellSetting;
            int redCellSetting;

            try
            {
                yellowCellSetting = Convert.ToInt32(ConfigurationManager.AppSettings["yellowDemurrage"]);
                orangeCellSetting = Convert.ToInt32(ConfigurationManager.AppSettings["orangeDemurrage"]);
                redCellSetting = Convert.ToInt32(ConfigurationManager.AppSettings["redDemurrage"]);

                listOfCellColorSettings.Add(yellowCellSetting);
                listOfCellColorSettings.Add(orangeCellSetting);
                listOfCellColorSettings.Add(redCellSetting);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in WaitAndDockOverview getColorCellSettings(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getColorCellSettings(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
            }
            return listOfCellColorSettings;
        }

        [System.Web.Services.WebMethod]
        public static Object getTimeDiff()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT * FROM " + 
                                    "(SELECT MS.MSID, "+
                                    "(SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1025 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC) As StartTime, " +
                                    "(SELECT TOP 1 MSE.Timestamp FROM dbo.MainScheduleEvents MSE WHERE EventTypeID = 1026 AND MSE.MSID = MS.MSID and isHidden = 'false' ORDER BY TimeStamp DESC) As EndTime " +
                                    "FROM dbo.MainSchedule AS MS " +
                                    "WHERE MS.isOpenInCMS = 'true' " +
                                    ") AS DemurrageTime " +
                                    "WHERE StartTime IS NOT NULL AND EndTime IS NULL";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in WaitAndDockOverview getTimeDiff(). Details: " + ex.ToString();
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
                string strErr = " Exception Error in WaitAndDockOverview GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }


    }
}