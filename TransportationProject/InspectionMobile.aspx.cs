using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;


namespace TransportationProject
{
    public partial class InspectionMobile : System.Web.UI.Page
    {
        protected static string sql_connStr;
        //protected static ZXPUserData zxpUD = new ZXPUserData();

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

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLoader) //make sure this matches whats in Site.Master and Default
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
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); // zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/inspectionMobile.aspx", false); //zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in InspectionMobile Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
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
                string strErr = " Exception Error in InspectionMobile ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return null;
        }


        [System.Web.Services.WebMethod]
        public static int getDefaultDockSpot(int prodDetailsID)
        {
            List<object[]> data = new List<object[]>();
            int currentOrAssignedSpot = 0;
            try
            {
                
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT ISNULL(MS.currentDockSpotID, 0) " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "INNER JOIN dbo.PODetails AS POD ON POD.MSID = MS.MSID " +
                                        "WHERE POD.PODetailsID = @prodDetailsID";
                    currentOrAssignedSpot = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@prodDetailsID", prodDetailsID)));

                    if (currentOrAssignedSpot == 0)
                    {
                        sqlQuery = "SELECT MS.DockSpotID " +
                                            "FROM dbo.MainSchedule AS MS " +
                                            "INNER JOIN dbo.PODetails AS POD ON POD.MSID = MS.MSID " +
                                            "WHERE POD.PODetailsID = @prodDetailsID";
                        currentOrAssignedSpot = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@prodDetailsID", prodDetailsID)));
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getDefaultDockSpot(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return currentOrAssignedSpot;
        }

        [System.Web.Services.WebMethod]
        public static Object getTruckAndProductList()
        {
            DataSet dsInspectableTrucks = new DataSet();
            List<inspectableTrucks> truckData = new List<inspectableTrucks>();
            try
            {
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT MSID, TrailerNumber, PODetailsID, ProductID_CMS, TruckType, TruckProdLabel FROM  dbo.GetAvailableTruckswDataForInspection ORDER BY TruckProdLabel";
                    dsInspectableTrucks = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery);
                    foreach (System.Data.DataRow row in dsInspectableTrucks.Tables[0].Rows)
                    {
                        inspectableTrucks insTrucks = new inspectableTrucks(Convert.ToInt32(row["MSID"]),
                                                                                row["TrailerNumber"].ToString(),
                                                                                Convert.ToInt32(row["PODetailsID"]),
                                                                                row["ProductID_CMS"].ToString(),
                                                                                row["TruckType"].ToString(),
                                                                                row["TruckProdLabel"].ToString());
                        truckData.Add(insTrucks);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getTruckAndProductList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return truckData;
        }

        [System.Web.Services.WebMethod]
        public static object getTruckAndDataAvailableForInspections(int prodDetailID)
        {
            object data = null;
            try
            {
                
                    DataSet dsPODetailData = GetPOdetailsData(prodDetailID);

                    //ErrorLogging.WriteEvent("1-" + dsGridData.Tables.Count.ToString(), EventLogEntryType.Information);
                    if (0 == dsPODetailData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }

                    int MSID = Convert.ToInt32(dsPODetailData.Tables[0].Rows[0]["MSID"]);

                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery =
                        //"SELECT TOP 1 MSID, ETA, CustomerID, TruckType, PONumber, LoadType, TrailerNumber, isDropTrailer, Cab1Number, Cab2Number, Carrier, Shipper, " +
                        //"LoadTypeLong, isRejected, RejectionComment, LocationLong, MS.LocationShort, " +
                        //"(SELECT TOP 1 TimeStamp FROM dbo.MainScheduleEvents MSE WHERE MSE.MSID = MS.MSID AND (EventTypeID = 2037) ORDER BY Timestamp DESC) AS TimeRejected, " +
                        //"(SELECT TOP 1 TimeStamp FROM dbo.MainScheduleEvents MSE WHERE MSE.MSID = MS.MSID AND (EventTypeID = 3037) ORDER BY Timestamp DESC) AS TimeUndoRejected, " +
                        //"MS.StatusID, S.StatusText, " +
                        //"(SELECT TDS.SpotDescription FROM dbo.TruckDockSpots TDS WHERE MS.currentDockSpotID = TDS.SpotID AND (MS.LocationShort = 'DOCKBULK' OR MS.LocationShort = 'DOCKVAN')) AS currentSpot, " +
                        //"isOpenInCMS " +
                        "SELECT TOP 1 MSID, ETA, CustomerID, TruckType, PONumber, LoadType, TrailerNumber, isDropTrailer, Cab1Number, Cab2Number, Carrier, Shipper, " +
                        "LoadTypeLong, isRejected, RejectionComment, LocationLong, MS.LocationShort, " +
                        "MS.StatusID, S.StatusText, " +
                        "(SELECT TOP 1 TimeStamp FROM dbo.MainScheduleEvents MSE WHERE MSE.MSID = MS.MSID AND (EventTypeID = 2037) ORDER BY Timestamp DESC) AS TimeRejected, " +
                        "(SELECT TDS.SpotDescription FROM dbo.TruckDockSpots TDS WHERE MS.currentDockSpotID = TDS.SpotID AND (MS.LocationShort = 'DOCKBULK' OR MS.LocationShort = 'DOCKVAN')) AS currentSpot, " +
                        "MS.currentDockSpotID, isOpenInCMS " +
                        "FROM dbo.MainSchedule MS " +
                        "INNER JOIN dbo.Locations LS ON LS.LocationShort = MS.LocationShort " +
                        "INNER JOIN dbo.LoadTypes LT ON LT.LoadTypeShort = MS.LoadType " +
                        "INNER JOIN dbo.Status S ON S.StatusID = MS.StatusID " +
                        "WHERE MSID = @MSID";

                    DataSet dsGridData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSID", MSID));
                    data = dsGridData.Tables[0].Rows[0].ItemArray;
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getTruckAndDataAvailableForInspections(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        //public static Object getInspectionListsForSelectedTruckAndProduct(int MSID, string productCMS)
        //{

        //    try
        //    {
        //       //TODO
        //        //1) GET DATA FROM Database

        //        //2) Make Objects
        //        // getInspectionList
        //        List<InspectionList> InspLists = new List<InspectionList>();
        //       // InspLists.Add(new InspectionList(MSInspectionListID, MSID, InspectionListID, InspectionListName, ProductID_CMS, RunNumber, isHidden)


        //    }
        //    catch (SqlException excep)
        //    {
        //        string strErr = " SQLException Error in InspectionMobile getInspectionListsForSelectedTruckAndProduct(). Details: " + excep.ToString();
        //        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
        //        throw excep;
        //    }
        //    catch (Exception ex)
        //    {
        //        string strErr = " Exception Error in InspectionMobile getInspectionListsForSelectedTruckAndProduct(). Details: " + ex.ToString();
        //        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
        //        System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
        //        ErrorLogging.sendtoErrorPage(1);
        //    }


        //    return 0;
        //}




        [System.Web.Services.WebMethod]
        public static List<object[]> getInspectionList(int prodDetailID)
        {
            List<object[]> data = new List<object[]>();
            try
            {
                data = InspectionsHelperFunctions.getInspectionList( prodDetailID,  sql_connStr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            //try
            //{

            //        DataSet dsGridData = GetPOdetailsData(prodDetailID);
            //        if (0 == dsGridData.Tables[0].Rows.Count)
            //        {
            //            throw new Exception("GetPOdetailsData() Failed");
            //        }
            //        string CMSProdID = dsGridData.Tables[0].Rows[0]["ProductID_CMS"].ToString();
            //        int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);
            //        data = getInspectionListUsingProductIDAndMSID(CMSProdID, MSID);

            //}
            //catch (Exception ex)
            //{
            //    string strErr = " Exception Error in InspectionMobile getInspectionList(). Details: " + ex.ToString();
            //    ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            //    System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
            //    ErrorLogging.sendtoErrorPage(1);
            //    throw ex;
            //}
            return data;
        }


        [System.Web.Services.WebMethod]
        public static DataSet GetPOdetailsData(int prodDetailID)
        {
            DataSet dsPODetails = new DataSet();

            try {
                dsPODetails = InspectionsHelperFunctions.GetPOdetailsData( prodDetailID, sql_connStr);
            }
            catch (Exception ex) {
                string strErr = " Exception Error in InspectionMobile GetPOdetailsData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }


            //try
            //{

            //        //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
            //        string sqlQuery = "SELECT TOP 1 ProductID_CMS, MSID, QTY, LotNumber, UnitOfMeasure, FileID_COFA FROM dbo.PODetails WHERE PODetailsID = @PDetailID";
            //        dsPODetails = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@PDetailID", prodDetailID));

            //}
            //catch (Exception ex)
            //{
            //    string strErr = " Exception Error in InspectionMobile GetPOdetailsData(). Details: " + ex.ToString();
            //    ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
            //    System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
            //    ErrorLogging.sendtoErrorPage(1);
            //    throw ex;
            //}
            return dsPODetails;
        }


        [System.Web.Services.WebMethod]
        public static Object getAvailableLocations(int prodDetailsID)
        {
            List<object[]> data = new List<object[]>();
            try
            {
                
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    string sqlQuery = "SELECT MS.TruckType " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "INNER JOIN dbo.PODetails AS POD ON POD.MSID = MS.MSID " +
                                        "WHERE POD.PODetailsID = @prodDetailsID";

                    string truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@prodDetailsID", prodDetailsID)));

                    if (truckType.ToLower() == "van")
                    {
                        //get location based on van type
                        sqlQuery = "SELECT LocationShort, LocationLong FROM dbo.Locations WHERE (LocationShort ! = 'NOS' AND LocationShort != 'GS' AND LocationShort != 'LAB' AND LocationShort != 'DOCKBULK') ORDER BY LocationShort DESC";
                    }
                    else
                    {
                        //get location based on bulk type
                        sqlQuery = "SELECT LocationShort, LocationLong FROM dbo.Locations WHERE (LocationShort ! = 'NOS' AND LocationShort != 'GS' AND LocationShort != 'LAB' AND LocationShort != 'DOCKVAN') ORDER BY LocationShort DESC";
                    }
                    DataSet dsAvailLocations = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery);
                    foreach (System.Data.DataRow row in dsAvailLocations.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getAvailableLocations(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getAvailableDockSpots(int prodDetailID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            string truckType;
            try
            {
                DataSet dsGridData = GetPOdetailsData(prodDetailID);
                if (0 == dsGridData.Tables[0].Rows.Count)
                {
                    throw new Exception("GetPOdetailsData() Failed");
                }
                int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.TruckType FROM dbo.MainSchedule AS MS WHERE MS.MSID = @MSID";
                    truckType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID))).Trim().ToUpper();

                    if (truckType == "VAN")
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
                string strErr = " Exception Error in InspectionMobile getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;

        }

        [System.Web.Services.WebMethod]
        public static List<object> updateLocation(int prodDetailID, string newLoc, int? dockSpot)
        {
            DateTime now = DateTime.Now;
            List<object> returnData = new List<object>();

            try
            {

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                DataSet dsGridData = GetPOdetailsData(prodDetailID);
                if (0 == dsGridData.Tables[0].Rows.Count)
                {
                    throw new Exception("GetPOdetailsData() Failed");
                }
                string CMSProdID = dsGridData.Tables[0].Rows[0]["ProductID_CMS"].ToString();
                int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                using (var scope = new TransactionScope())
                {
                    string sqlCmdText = null;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

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
                        default:
                            throw new Exception("Location was not provided in updateLocation()");
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
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = @STAT, LastUpdated = @TimeStamp, currentDockSpotID = @dockSpotID WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "currentDockSpotID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, dockSpot.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc)
                                                                                           , new SqlParameter("@STAT", 5)
                                                                                           , new SqlParameter("@TimeStamp", now)
                                                                                           , new SqlParameter("@dockSpotID", TransportHelperFunctions.convertStringEmptyToDBNULL(dockSpot))
                                                                                           , new SqlParameter("@MSID", MSID));
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainSchedule SET LocationShort = @LOC, StatusID = @STAT, LastUpdated = @TimeStamp, currentDockSpotID = null WHERE (MSID = @MSID)"; //StatusID 5 = waiting
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@LOC", newLoc)
                                                                                           , new SqlParameter("@STAT", 5)
                                                                                           , new SqlParameter("@TimeStamp", now)
                                                                                           , new SqlParameter("@MSID", MSID));
                    }

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TimeStamp WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TimeStamp", now), new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile updateLocation(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnData;
        }

        
        
        

        [System.Web.Services.WebMethod]
        public static InspectionList getMSInspectionListAndData(int prodDetailID, int InspectionListID)
        {
            InspectionList inspList = new InspectionList();
            try
            {
                inspList = InspectionsHelperFunctions.getMSInspectionListAndData(prodDetailID, InspectionListID, sql_connStr);

                //using (var scope = new TransactionScope())
                //{
                //    DataSet dsGridData = GetPOdetailsData(prodDetailID);

                //    //ErrorLogging.WriteEvent("1-" + dsGridData.Tables.Count.ToString(), EventLogEntryType.Information);
                //    if (0 == dsGridData.Tables[0].Rows.Count)
                //    {
                //        throw new Exception("GetPOdetailsData() Failed");
                //    }

                //    string CMSproductID = dsGridData.Tables[0].Rows[0]["ProductID_CMS"].ToString();
                //    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                //    int MSInspectionListID = getMainscheduleInspectionListID(CMSproductID, MSID, InspectionListID);
                //    //get data  for ui

                //    //ErrorLogging.WriteEvent("2-" + MSInspectionListID.ToString(), EventLogEntryType.Information);
                //    if (0 == MSInspectionListID)
                //    {
                //        throw new Exception("getMainscheduleInspectioinListID() Failed");
                //    }

                //    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                //    string sqlQuery = "SELECT InspectionListName, RunNumber, isHidden " +
                //                          "FROM dbo.MainScheduleInspectionLists " +
                //                          "WHERE MSInspectionListID = @MSLID";
                //    DataSet resultData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSLID", MSInspectionListID));

                //    string InspectionListName = resultData.Tables[0].Rows[0]["InspectionListName"].ToString();
                //    int runNumber = Convert.ToInt32(resultData.Tables[0].Rows[0]["RunNumber"]);
                //    bool isHidden = Convert.ToBoolean(resultData.Tables[0].Rows[0]["isHidden"]);

                //    //ErrorLogging.WriteEvent("3-" + resultData.Tables.Count.ToString(), EventLogEntryType.Information);
                //    inspList = new InspectionList(MSInspectionListID, MSID, InspectionListID, InspectionListName, CMSproductID, runNumber, isHidden);


                //    sqlQuery = "SELECT MSInspectionListDetailID, MSInspectionListID, InspectionListID, InspectionHeaderID, SortOrder, InspectionHeaderName " +
                //                                "FROM dbo.MainScheduleInspectionListsDetails " +
                //                                "WHERE MSInspectionListID = @MSLID " +
                //                                "ORDER BY SortOrder";
                //    DataSet MSInspectionListDetailsData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSLID", MSInspectionListID));

                //    //ErrorLogging.WriteEvent("4", EventLogEntryType.Information);
                //    for (int i = 0; i < MSInspectionListDetailsData.Tables[0].Rows.Count; i++)
                //    {

                //        int MSInspectionListDetailID = Convert.ToInt32(MSInspectionListDetailsData.Tables[0].Rows[i]["MSInspectionListDetailID"]);
                //        int InspectionHeaderID = Convert.ToInt32(MSInspectionListDetailsData.Tables[0].Rows[i]["InspectionHeaderID"]);
                //        int SortOrder = Convert.ToInt32(MSInspectionListDetailsData.Tables[0].Rows[i]["SortOrder"]);
                //        string InspectionHeaderName = MSInspectionListDetailsData.Tables[0].Rows[i]["InspectionHeaderName"].ToString();
                //        Inspection nInspection = getInspection(MSInspectionListDetailID);

                //        // ErrorLogging.WriteEvent("5", EventLogEntryType.Information);
                //        if (0 == nInspection.MSInspectionID)
                //        {
                //            throw new Exception("getInspection() Failed");
                //        }

                //        InspectionListDetails inspListDetails = new InspectionListDetails(MSInspectionListDetailID, MSInspectionListID, InspectionHeaderID, InspectionHeaderName, SortOrder, nInspection);
                //        inspList.addInspectionListDetail(inspListDetails);
                //    }
                //    scope.Complete();
                //}
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getMSInspectionListAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return inspList;
        }

        [System.Web.Services.WebMethod]
        public static string updateInspectionComment(int prodDetailID, int MSInspectionID, string comment)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                DataSet dsGridData = GetPOdetailsData(prodDetailID);

                //ErrorLogging.WriteEvent("1-" + dsGridData.Tables.Count.ToString(), EventLogEntryType.Information);
                if (0 == dsGridData.Tables[0].Rows.Count)
                {
                    throw new Exception("GetPOdetailsData() Failed");
                }

                int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionComment", Convert.ToDateTime(now), zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(comment).ToString(), null, "MSInspectionID", MSInspectionID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainScheduleInspections SET InspectionComment = @Comment " +
                                    "WHERE (MSInspectionID = @INSPID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Comment", TransportHelperFunctions.convertStringEmptyToDBNULL(comment)),
                                                                                         new SqlParameter("@INSPID", MSInspectionID));

                    //Create an entry in Event Log
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " + //Inspection comment updated eventtype id = 3068
                                "VALUES (@MSID, 3068, @TIME, @USER, 'false');";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TIME", now),
                                                                                         new SqlParameter("@USER", zxpUD._uid));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile updateInspectionComment(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return now.ToString();
        }


        


        [System.Web.Services.WebMethod]
        public static Object getFileUploadsFromProdDetailID(int prodDetailID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    DataSet dsGridData = GetPOdetailsData(prodDetailID);

                    if (0 == dsGridData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }

                    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                    sqlCmdText = "SELECT FileID, MSID, MSF.FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld FROM dbo.MainScheduleFiles MSF " +
                                        "INNER JOIN dbo.FileTypes FT ON FT.FileTypeID = MSF.FileTypeID " +
                                        "WHERE isHidden = 0 AND MSID = @PMSID AND (MSF.FileTypeID = 3 OR MSF.FileTypeID = 4)";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getFileUploadsFromProdDetailID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        

        [System.Web.Services.WebMethod]
        public static List<object> checkIfControlsCanBeUpdated(int prodDetailID)
        {
            List<object> returnData = new List<object>();
            bool canUpdateLoc = true;
            bool canEditTest = false;

            try
            {
                
                    DataSet dsPOdata = GetPOdetailsData(prodDetailID);
                    if (0 == dsPOdata.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }
                    int MSID = Convert.ToInt32(dsPOdata.Tables[0].Rows[0]["MSID"]);
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    string sqlQuery = "SELECT TOP (1) MS.LocationShort, MS.StatusID, L.LocationLong, S.StatusText, MS.isRejected, MS.currentDockSpotID,  " +
                                          "(SELECT TDS.SpotDescription FROM dbo.TruckDockSpots TDS WHERE MS.currentDockSpotID = TDS.SpotID AND (MS.LocationShort = 'DOCKBULK' OR MS.LocationShort = 'DOCKVAN')) AS currentSpot, " +
                                          "MS.isOpenInCMS, MS.isDropTrailer " +
                                          "FROM dbo.MainSchedule AS MS " +
                                          "INNER JOIN dbo.Locations AS L ON MS.LocationShort = L.LocationShort " +
                                          "INNER JOIN dbo.Status AS S ON S.StatusID = MS.StatusID " +
                                          "WHERE MSID = @MSID";
                    DataSet dsLocationData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSID", MSID));

                    string locShort = Convert.ToString(dsLocationData.Tables[0].Rows[0]["LocationShort"]);
                    int statShort = Convert.ToInt32(dsLocationData.Tables[0].Rows[0]["StatusID"]);
                    bool isOpenInCMS = Convert.ToBoolean(dsLocationData.Tables[0].Rows[0]["isOpenInCMS"]);
                    bool isDropTrailer = Convert.ToBoolean(dsLocationData.Tables[0].Rows[0]["isDropTrailer"]);

                    //NOTE:  statShort == 2 -- was removed because ZXP can not change status to weighing (#3) and wouldnt be able to change location
                    if (statShort == 1 || statShort == 6 || statShort == 7 || statShort == 8 || statShort == 10 || statShort == 11 || statShort == 13 || statShort == 19 || statShort == 20)
                    {
                        canUpdateLoc = false;
                    }
                    if (statShort == 5 || statShort == 8 || statShort == 9 || statShort == 16 || statShort == 21)
                    {
                        canEditTest = true;
                    }

                    //if drop trailer , PO open in cms and truck has departed
                    if (locShort == "NOS" && statShort == 10 && isDropTrailer && isOpenInCMS)
                    {
                        canEditTest = true;
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile checkIfControlsCanBeUpdated(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            returnData.Add(canUpdateLoc);
            returnData.Add(canEditTest);
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static List<object> setInspectionResult(int MSInspectionID, int testID, int result, int prodDetailID)
        {
            DateTime timestamp = DateTime.Now; //Initialize the timestamp here
            String returnMsg = String.Empty;
            bool isDealBreaker = false;
            bool isLastQuestion = false;
            int verInspID = 0;
            bool hasEnded = false;
            int numOfUnansweredQuestions = 0;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    DataSet dsGridData = GetPOdetailsData(prodDetailID);
                    if (0 == dsGridData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }
                    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspectionResults", "Result", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, result.ToString(), null, "MSInspectionID", MSInspectionID.ToString(), "testID", testID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspectionResults", "SubmittedTimeStamp", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), null, "MSInspectionID", MSInspectionID.ToString(), "testID", testID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "UPDATE dbo.MainScheduleInspectionResults SET Result = @Result, SubmittedTimeStamp = @TIME, UserID = @USER " +
                                    "WHERE (TestID = @TID AND MSInspectionID = @INSPID)";

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@Result", result)
                                                                                                , new SqlParameter("@TIME", timestamp)
                                                                                                , new SqlParameter("@USER", zxpUD._uid)
                                                                                                , new SqlParameter("@TID", testID)
                                                                                                , new SqlParameter("@INSPID", MSInspectionID));

                    //check if inspection needs to end based on different conditions
                    verInspID = getSecondaryDoubleVerificationInspectionIfExists(MSInspectionID); // find second verification Inspection
                    isDealBreaker = isQuestionADealBreaker(MSInspectionID, testID);// check if is dealbreaker
                    isLastQuestion = isLastAnsweredQuestion(testID, MSInspectionID);

                    if (0 == result) //if question is failed
                    {
                        //If a deal breaker question is failed, inspection fails
                        //All questions in a second verification inspection are deal breakers
                        if (isDealBreaker || (verInspID == MSInspectionID)) //if this is a dealbreaker question or if this is the second verification inspection, set isFailed flag
                        {
                            if (verInspID == MSInspectionID)
                            {
                                returnMsg = "This inspection is for the secondary validation. All questions are critical questions. ";
                            }
                            returnMsg = returnMsg + "The inspection has failed and will end due to failing a critical inspection question. ";
                            setIsFailedStatus(MSInspectionID, true, timestamp);

                            endInspection(MSID, MSInspectionID, timestamp, false);
                            hasEnded = true;
                            //Log event failed

                            MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                            MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                            string newAlertMsg = createCustomInspectionFailedMessage(MSID, MSInspectionID);
                            msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, returnMsg + newAlertMsg);
                        }
                        //Automatically fail a second verification inspection because the user does not need to complete it
                        //if it double verification exists and it is not the same as the current inspection set isFail flag
                        if (isDealBreaker && verInspID > 0 && verInspID != MSInspectionID)
                        {
                            setIsFailedStatus(verInspID, true, timestamp);
                            endInspection(MSID, verInspID, timestamp, true);
                            MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                            MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                            string newAlertMsg = createCustomInspectionFailedMessage(MSID, verInspID);
                            msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, "Secondary Inspection Autofailed." + newAlertMsg);

                            returnMsg = returnMsg + "Because a verification inspection exists, that secondary inspection was also set to \"Failed\" and does not need to be completed.";
                        }

                        if (!hasEnded)
                        {
                            //check if all questions are failed and set isFailed
                            int numOfNonFailedQuestions = checkifAnyQuestionsAreNotFailed(MSInspectionID);
                            numOfUnansweredQuestions = checkForNumberOfUnansweredQuestions(MSInspectionID);

                            if (0 == numOfNonFailedQuestions && numOfUnansweredQuestions == 0)
                            {
                                //All questions failed. update inspection status to fail;
                                setIsFailedStatus(MSInspectionID, true, timestamp);
                                endInspection(MSID, MSInspectionID, timestamp, false);
                                returnMsg = returnMsg + "The inspection has failed and will end due to failing all questions. ";

                                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                                MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                                string newAlertMsg = createCustomInspectionFailedMessage(MSID, MSInspectionID);
                                msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, returnMsg + newAlertMsg);
                                hasEnded = true;

                                if (verInspID > 0 && verInspID != MSInspectionID)
                                {
                                    setIsFailedStatus(verInspID, true, timestamp);
                                    endInspection(MSID, verInspID, timestamp, true);
                                    msEventLog = new MainScheduleEventLogger();
                                    msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                                    newAlertMsg = createCustomInspectionFailedMessage(MSID, verInspID);
                                    msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, "Secondary Inspection Autofailed." + newAlertMsg);

                                    returnMsg = returnMsg + "Because a verification inspection exists, that secondary inspection was also set to \"Failed\" and does not need to be completed.";
                                }
                            }
                        }
                    }
                    //automatically end inspection if last question
                    int numOfNonPassedQuestions = checkifAnyQuestionsAreNotPassed(MSInspectionID);
                    numOfUnansweredQuestions = checkForNumberOfUnansweredQuestions(MSInspectionID);

                    if (!hasEnded && 0 == numOfNonPassedQuestions && numOfUnansweredQuestions == 0)
                    {
                        //All questions passed. update inspection status to pass;

                        setIsFailedStatus(MSInspectionID, false, timestamp);
                        if (verInspID > 0 && verInspID != MSInspectionID)
                        {
                            int numOfFailedVerificationQuestions = checkifAnyQuestionsAreNotPassed(verInspID);
                            bool verificationFailed = true;
                            if (0 == numOfFailedVerificationQuestions)
                            {
                                verificationFailed = false;
                            }
                            setAutoClosedStatus(verInspID, false, timestamp);
                            setIsFailedStatus(verInspID, verificationFailed, timestamp);
                        }
                    }
                    if (!hasEnded && isLastQuestion) //close the inspection if all question have been answered; this will trigger even if only updating comments 
                    {

                        endInspection(MSID, MSInspectionID, timestamp, false);
                        returnMsg = returnMsg + Environment.NewLine + "All questions answered. Inspection has ended.";
                        hasEnded = true;
                    }
                    if (!hasEnded && !isLastQuestion)
                    {
                        setCompleteStatus(MSID, MSInspectionID, timestamp, false);
                    }
                    if (hasEnded && isLastQuestion)
                    {
                        setCompleteStatus(MSID, MSInspectionID, timestamp, true);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile setInspectionResult(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            List<object> returnData = new List<object>();
            returnData.Add(timestamp);
            returnData.Add(returnMsg);
            returnData.Add(hasEnded);
            returnData.Add(isLastQuestion);
            return returnData;

        }

        [System.Web.Services.WebMethod]
        public static int checkifAnyQuestionsAreNotFailed(int MSInspectionID)
        {
            int numOfNonFailedQuestions = -1;
            try
            {
               
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                          "FROM dbo.MainScheduleInspectionResults MSIR " +
                          "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                          "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (1, -1) ";

                    numOfNonFailedQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));
                    if (-1 == numOfNonFailedQuestions)
                    {
                        throw new Exception("checkifAnyQuestionsAreNotFailed Query Failed");
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile checkifAllQuestionsAreFailed(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return numOfNonFailedQuestions;
        }


        [System.Web.Services.WebMethod]
        public static int checkifAnyQuestionsAreNotPassed(int MSInspectionID)
        {
            int numOfFailedQuestions = -1;
            try
            {
               
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                          "FROM dbo.MainScheduleInspectionResults MSIR " +
                          "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                          "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (0) "; //0 = failed


                    numOfFailedQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));

                    if (-1 == numOfFailedQuestions)
                    {
                        throw new Exception("checkifAnyQuestionsAreNotPassed Query Failed");
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile checkifAnyQuestionsAreNotPassed(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return numOfFailedQuestions;
        }

        [System.Web.Services.WebMethod]
        public static int checkForNumberOfUnansweredQuestions(int MSInspectionID)
        {
            int numOfUnansweredQuestions = -1;
            try
            {
               
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                          "FROM dbo.MainScheduleInspectionResults MSIR " +
                          "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                          "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (-999) "; //-999 = unanswered


                    numOfUnansweredQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));

                    if (-1 == numOfUnansweredQuestions)
                    {
                        throw new Exception("checkForNumberOfUnansweredQuestions Query Failed");
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile checkForNumberOfUnansweredQuestions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return numOfUnansweredQuestions;
        }

        [System.Web.Services.WebMethod]
        public static List<object> canInspectionBeEdited(int prodDetailID, int MSInspectionListID, int MSInspectionID)
        {
            string outputMsg = string.Empty;
            bool canEdit = false;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                DataSet dsGridData = GetPOdetailsData(prodDetailID);
                    if (0 == dsGridData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }
                    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);


                    //1) CHECK if the logged in inspector can start this inspectionID
                    bool didUserStartDoVerifyInspectionBefore = didUserStartAnotherVerificationInspectionOfSameType(MSInspectionListID, MSInspectionID, zxpUD._uid, MSID);

                    if (didUserStartDoVerifyInspectionBefore)
                    {
                        outputMsg = outputMsg + "You are not permitted to start this inspection as you have already started or done an inspection of this kind for this truck. Please ask another user to perform the inspection. ";
                    }
                    //2) Check if previous necessary inspections have been completed 
                    bool arePrevInspectionsDone = haveAllPreviousInspectionsBeenDoneInOrder(MSInspectionListID, MSInspectionID);

                    if (!arePrevInspectionsDone)
                    {
                        outputMsg = outputMsg + "There are inspections that need to be done prior to starting the selected inspection. Please make sure those are completed before continuing. ";
                    }
                    canEdit = !didUserStartDoVerifyInspectionBefore && arePrevInspectionsDone;
                  
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile canInspectionBeStarted(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);

            }
            List<object> returnObj = new List<object>();
            returnObj.Add(canEdit);
            returnObj.Add(outputMsg);
            return returnObj;
        }

        [System.Web.Services.WebMethod]
        public static void AddFileDBEntry(int prodDetailID, string fileType, string filenameOld, string filenameNew, string filepath, string fileDescription)
        {
            DateTime timestamp = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    DataSet dsGridData = GetPOdetailsData(prodDetailID);
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (0 == dsGridData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }
                    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

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
                string strErr = " Exception Error in InspectionMobile AddFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static bool haveAllPreviousInspectionsBeenDoneInOrder(int MSInspectListID, int MSInspectID)
        {
            bool isDone = false;
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //find if there exists an inspection under the list with a sort order lower than the selected inspection that has not been completed
                    sqlCmdText = "SELECT ISNULL(COUNT(MSI.MSInspectionID), 0) " +
                                            "FROM dbo.MainScheduleInspections MSI " +
                                            "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD ON MSI.MSInspectionListDetailID = MSILD.MSInspectionListDetailID " +
                                            "WHERE MSILD.MSInspectionListID = @MSIListID " +
                                            "AND MSI.isHidden = 0 " +
                                            "AND MSI.InspectionEndEventID IS NULL " + //check if not completed
                        //"AND MSI.wasAutoClosed = 0 " +          //TODO: CL: ask zxp if they should be able to continue other inspections if previous inspections have not been started but was autoclosed
                                            "AND MSILD.SortOrder <= ( SELECT  MSILD_1.SortOrder " +
                                                                    "FROM dbo.MainScheduleInspections MSI_1 " +
                                                                    "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD_1 ON MSI_1.MSInspectionListDetailID = MSILD_1.MSInspectionListDetailID " +
                                                                    "WHERE MSI_1.MSInspectionID = @MSInspID ) " +
                                            "AND MSI.MSInspectionID <> @MSInspID";
                    int countOfInspectionsNotCompleted = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSIListID", MSInspectListID),
                                                                                                                                            new SqlParameter("@MSInspID", MSInspectID)));
                    if (0 == countOfInspectionsNotCompleted)
                    {
                        isDone = true;
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile haveAllPreviousInspectionsBeenDoneInOrder(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isDone;
        }

        [System.Web.Services.WebMethod]
        public static int getInspectionCreatorUserID(int MSInspectID)
        {
            int userID = 0;
            try
            {
               
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    //Check if there exists a verification inspection of the same type under the selected list that was started by user excluding the selected inspection
                    sqlCmdText = "SELECT ISNULL(UserID, 0) FROM dbo.MainScheduleInspections WHERE MSInspectionID = @MSInspID";
                    userID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSInspID", MSInspectID)));
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getInspectionCreatorUserID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return userID;
        }

        //Checks if the current user performing/view/editing/creating the inspection is associated to a verification inspectiion 
        [System.Web.Services.WebMethod]
        public static bool didUserStartAnotherVerificationInspectionOfSameType(int MSInspectListID, int MSInspectID, int userID, int MSID)
        {
            bool didStart = false;
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    //1) Check if there are same existing inspections of the selected started by users that are verifications test

                    //Check if there exists a verification inspection of the same type under the selected list that was started by user excluding the selected inspection
                    sqlCmdText = "SELECT ISNULL(COUNT(MSI.MSInspectionID), 0) " +
                                            "FROM dbo.MainScheduleInspectionListsDetails  MSILD " +
                                            "INNER JOIN dbo.MainScheduleInspections MSI ON MSILD.MSInspectionListDetailID = MSI.MSInspectionListDetailID " +
                                            "WHERE MSILD.MSInspectionListID = @MSIListID  " +
                                            "AND MSI.InspectionHeaderID =  " +                      //check for same type of inspection as selected
                                                    "(	SELECT InspectionHeaderID " +
                                                        "FROM dbo.MainScheduleInspections MSI_1  " +
                                                        "WHERE MSI_1.MSInspectionID = @MSInspID " +
                                                    ") " +
                                            "AND MSI.needsVerificationTest = 1 " +                 //filter to make sure inspection is a verification test 
                                            "AND MSI.isHidden = 0 " +
                                            "AND USERID = @UID " +
                                            "AND MSI.MSID = @MSID " +  //only count inspections under the truck/MSID
                                            "AND MSI.wasAutoClosed = 0 " +
                                            "AND MSI.MSInspectionID <> @MSInspID";
                    int inspectionCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSIListID", MSInspectListID),
                                                                                                                             new SqlParameter("@MSInspID", MSInspectID),
                                                                                                                             new SqlParameter("@UID", userID),
                                                                                                                             new SqlParameter("@MSID", MSID)));
                    if (inspectionCount > 0)
                    {  //if count > 0 then there exists an inspection by user of same type. User cannot perform inspection.
                        didStart = true;
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile didUserStartAnotherVerificationInspectionOfSameType(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return didStart;
        }

        [System.Web.Services.WebMethod]
        public static void startInspection(int prodDetailID, int MSinspectionID)
        {
            List<object[]> data = new List<object[]>();
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                DataSet dsGridData = GetPOdetailsData(prodDetailID);
                if (0 == dsGridData.Tables[0].Rows.Count)
                {
                    throw new Exception("GetPOdetailsData() Failed");
                }
                int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);


                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //loader  - EventTypeID = 7 --> "Inspection Started "
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                    "VALUES (@MSID, 7, @TIME, @INSPECTOR, 'false'); SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", now),
                                                                                                                     new SqlParameter("@INSPECTOR", zxpUD._uid)));
                    SqlParameter paramMSInspectionID = new SqlParameter("@MSINSPID", SqlDbType.Int);
                    SqlParameter paramEventIDStart = new SqlParameter("@EID", SqlDbType.Int);
                    paramMSInspectionID.Value = MSinspectionID;
                    paramEventIDStart.Value = eventID;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionStartEventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "MSInspectionID", MSinspectionID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "USERID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), eventID, "MSInspectionID", MSinspectionID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainScheduleInspections SET InspectionStartEventID = @EID, USERID = @INSPECTOR WHERE MSInspectionID = @MSINSPID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID),
                                                                                         new SqlParameter("@INSPECTOR", zxpUD._uid),
                                                                                         new SqlParameter("@MSINSPID", MSinspectionID));
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), null, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "8", null, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, StatusID = 8 WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", now),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile startInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void endInspection(int MSID, int MSInspectionID, DateTime timeStamp, Boolean isAutoClosed)
        {
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                InspectionsHelperFunctions.endInspection(MSID, MSInspectionID, timeStamp, isAutoClosed, sql_connStr, zxpUD);
               
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile endInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void setCompleteStatus(int MSID, int MSInspectionID, DateTime timeStamp, Boolean isComplete)
        {
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (!(MSID > 0 && MSInspectionID > 0))
                {
                    throw new Exception("Invalid MSID:" + MSID.ToString() + " or MSInspectionID: " + MSInspectionID.ToString() + " given in endInspection.");
                }
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    ChangeLog cLog;

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramTimeStamp = new SqlParameter("@TIME", SqlDbType.NVarChar);
                    SqlParameter paramInspector = new SqlParameter("@INSPECTOR", SqlDbType.Int);
                    SqlParameter paramMSInspectionID = new SqlParameter("@INSPID", SqlDbType.Int);
                    paramTimeStamp.Value = timeStamp;
                    paramMSID.Value = MSID;
                    paramInspector.Value = zxpUD._uid;
                    paramMSInspectionID.Value = MSInspectionID;

                    if (isComplete)
                    {
                        int eventID;
                        // EventTypeID =22 --> "Inspection Completed "
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                "VALUES (@MSID, 22, @TIME, @INSPECTOR, 'false'); SELECT SCOPE_IDENTITY()";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@INSPECTOR", zxpUD._uid)));
                        sqlCmdText = "UPDATE dbo.MainScheduleInspections SET InspectionEndEventID = @EID WHERE MSInspectionID = @INSPID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID),
                                                                                             new SqlParameter("@INSPID", MSInspectionID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionEndEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "9", null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainScheduleInspections SET InspectionEndEventID = NULL WHERE MSInspectionID = @INSPID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@INSPID", MSInspectionID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionEndEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "NULL", null, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, timeStamp.ToString(), null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "9", null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, StatusID = 9 WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp), new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile setCompleteStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static List<object[]> getInspectionInformationforAlert(int MSID, int MSInspectionID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP 1 MSI.MSID, MS.PONumber, MS.TrailerNumber, MSIL.ProductID_CMS, PCMS.ProductName_CMS, MSE.TimeStamp AS InspectionEndTime, MSI.InspectionHeaderName " +
                                            ",MSI.RunNumber, MSI.isFailed, MSE.UserId, U.FirstName, U.LastName " +
                                            "FROM dbo.MainScheduleInspections MSI " +
                                            "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD ON MSILD.MSInspectionListDetailID = MSI.MSInspectionListDetailID " +
                                            "INNER JOIN dbo.MainScheduleInspectionLists MSIL ON MSIL.MSInspectionListID = MSILD.MSInspectionListID " +
                                            "INNER JOIN dbo.MainSchedule MS ON MS.MSID = MSI.MSID " +
                                            "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = MSIL.ProductID_CMS " +
                                            "LEFT JOIN dbo.MainScheduleEvents MSE ON MSE.EventID = MSI.InspectionEndEventID " +
                                            "LEFT JOIN dbo.Users U ON MSE.UserId = U.UserID " +
                                            "WHERE MSI.MSID = @MSID AND MSI.MSInspectionID = @MSInspectionID AND MSI.isHidden = 0 AND MSIL.isHidden = 0";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                  new SqlParameter("@MSInspectionID", MSInspectionID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getInspectionInformationforAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static string createCustomInspectionFailedMessage(int MSID, int MSInspectionID)
        {
            string customAlertMsg = string.Empty;
            try
            {
                
                    List<object[]> inspectionInfo = getInspectionInformationforAlert(MSID, MSInspectionID);
                    if (inspectionInfo != null && inspectionInfo.Count != 0)
                    {
                        string sMSID = inspectionInfo[0][0].ToString();
                        string sPONumber = inspectionInfo[0][1].ToString();
                        string sTrailer = inspectionInfo[0][2].ToString();
                        string sCMSProdID = inspectionInfo[0][3].ToString();
                        string sCMSProdName = inspectionInfo[0][4].ToString();
                        string sInspectionEndTime = inspectionInfo[0][5].ToString();
                        string sInspectionName = inspectionInfo[0][6].ToString();
                        string sRunNumber = inspectionInfo[0][7].ToString();
                        string sIsFailed = inspectionInfo[0][8].ToString();
                        string sUserID = inspectionInfo[0][9].ToString();
                        string sFirstName = inspectionInfo[0][10].ToString();
                        string sLastName = inspectionInfo[0][11].ToString();

                        customAlertMsg = "Inspection failed. Details: " + System.Environment.NewLine +
                            "Inspection name: " + sInspectionName + " Run #" + sRunNumber + System.Environment.NewLine +
                            "For PO-Trailer: " + sPONumber + "-" + sTrailer + System.Environment.NewLine +
                            "For product: " + sCMSProdID + "(" + sCMSProdName + ")" + System.Environment.NewLine +
                            "Inspection done by: " + sFirstName + " " + sLastName + System.Environment.NewLine +
                            "On: " + sInspectionEndTime + System.Environment.NewLine;
                    }
                    else
                    {
                        Exception ex = new Exception("No inspection Information was found. Please check if this is the correct inspection.");
                        throw ex;
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile createCustomInspectionFailedMessage(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return customAlertMsg;
        }

        [System.Web.Services.WebMethod]
        public static bool isLastAnsweredQuestion(int testID, int MSInspectionID)
        {
            bool isLast = false;
            try
            {
              isLast = InspectionsHelperFunctions.isLastAnsweredQuestion(testID, MSInspectionID, sql_connStr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile isLastAnsweredQuestion(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isLast;
        }

        [System.Web.Services.WebMethod]
        public static bool isQuestionADealBreaker(int MSInspectionID, int testID)
        {
            bool isDealBreaker = false;
            try
            {
                isDealBreaker = InspectionsHelperFunctions.isQuestionADealBreaker(MSInspectionID, testID, sql_connStr);
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile isQuestionADealBreaker(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isDealBreaker;
        }


        [System.Web.Services.WebMethod]
        public static int getSecondaryDoubleVerificationInspectionIfExists(int MSinspectionID)
        {
            int verificationMSinspectionID = 0;

            try
            {

                 verificationMSinspectionID = InspectionsHelperFunctions.getSecondaryDoubleVerificationInspectionIfExists(MSinspectionID, sql_connStr);

                //string sqlCmdText;
                ////sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                ////get MSInspectionID of second verification test 
                //sqlCmdText = "SELECT TOP 1 ISNULL(MSI.MSInspectionID,0)" +
                //                        "FROM dbo.MainScheduleInspectionListsDetails  MSILD " +
                //                        "INNER JOIN dbo.MainScheduleInspections MSI ON MSILD.MSInspectionListDetailID = MSI.MSInspectionListDetailID " +
                //                        "INNER JOIN (SELECT MSI_1.InspectionHeaderID, MSI_1.MSID, MSI_1.MSInspectionListDetailID, MSILD_1.SortOrder, MSILD_1.MSInspectionListID " +
                //                                    "FROM dbo.MainScheduleInspections MSI_1 " +
                //                                    "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD_1 ON MSILD_1.MSInspectionListDetailID = MSI_1.MSInspectionListDetailID " +
                //                                    "WHERE MSI_1.MSInspectionID = @MSInspID " +
                //                                    ") OrigInspection ON OrigInspection.MSID = MSI.MSID AND OrigInspection.InspectionHeaderID = MSILD.InspectionHeaderID " +
                //                        "WHERE MSI.needsVerificationTest = 1 " +
                //                        "AND MSI.isHidden = 0 " +
                //                        "AND MSILD.MSinspectionListID = OrigInspection.MSInspectionListID " +
                //                        "ORDER BY MSILD.SortOrder DESC, RunNumber DESC";

                //verificationMSinspectionID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSInspID", MSinspectionID)));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getSecondaryDoubleVerificationInspectionIfExists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return verificationMSinspectionID;
        }


        [System.Web.Services.WebMethod]
        public static void setIsFailedStatus(int MSInspectionID, bool isFailed)
        {
            DateTime timestamp = DateTime.Now;
            List<object> returnObj = new List<object>();
            try
            {
                setIsFailedStatus(MSInspectionID, isFailed, timestamp);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in InspectionMobile setIsFailedStatus(int MSInspectionID, bool isFailed). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile setIsFailedStatus(int MSInspectionID, bool isFailed). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }

        }


        [System.Web.Services.WebMethod]
        public static void setIsFailedStatus(int MSInspectionID, bool isFailed, DateTime timestamp)
        {
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                InspectionsHelperFunctions.setIsFailedStatus(MSInspectionID, isFailed, timestamp, sql_connStr, zxpUD);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile setIsFailedStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void setAutoClosedStatus(int MSInspectionID, bool isAutoClosed, DateTime timestamp)
        {
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "wasAutoClosed", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, isAutoClosed.ToString(), null, "MSInspectionID", MSInspectionID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    //set isFailed flag for the inspection
                    sqlCmdText = "UPDATE dbo.MainScheduleInspections SET wasAutoClosed = @ISAUTOCLOSED WHERE  MSInspectionID = @INSPID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ISAUTOCLOSED", isAutoClosed),
                                                                                         new SqlParameter("@INSPID", MSInspectionID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile setAutoClosedStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getListofTrucksCurrentlyInZXPWithIncompleteTest()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
               
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //Result == -999 indicates question has not been answered
                    sqlCmdText = "SELECT DISTINCT MS.MSID, ETA, PONumber, TrailerNumber, A.NewName, MS.LocationShort, LS.LocationLong, A.InspectionEndEventID, isRejected, MS.StatusID, S.StatusText, " +
                                        "A.isFailed, MSIL.ProductID_CMS, ISNULL(PCMS.ProductName_CMS, MSIL.ProductID_CMS)  " +
                                    "FROM dbo.MainSchedule MS " +
                                    "INNER JOIN dbo.Locations LS ON LS.LocationShort = MS.LocationShort " +
                                    "INNER JOIN dbo.LoadTypes LT ON LT.LoadTypeShort = MS.LoadType " +
                                    "INNER JOIN dbo.Status S ON S.StatusID = MS.StatusID " +
                                    "INNER JOIN dbo.MainScheduleInspectionLists AS MSIL ON MSIL.MSID = MS.MSID " +
                                    "INNER JOIN (SELECT DISTINCT MSI.MSID, MSI.MSInspectionID, MSI.InspectionHeaderID, CONCAT(MSI.InspectionHeaderName,'- RUN: ' , RunNumber) AS NewName, MSI.InspectionEndEventID, " +
                                                "MSI.isFailed FROM dbo.MainScheduleInspections MSI  " +
                                                "INNER JOIN dbo.MainScheduleInspectionResults MSIR ON MSIR.MSInspectionID = MSI.MSInspectionID  " +
                                                "INNER JOIN dbo.InspectionResultType IRT ON IRT.ResultValue = MSIR.Result " +
                                                "WHERE(MSI.InspectionEndEventID IS NULL) AND MSI.isHidden = 0" +                                                //USE If NOT including unanswered questions
                                                ") AS A ON A.MSID = MS.MSID " +
                                    "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = MSIL.ProductID_CMS " +
                                    "WHERE (MS.LocationShort <> 'NOS') AND MS.isHidden = 0 AND MSIL.isHidden = 0 " +
                                    "ORDER BY PONumber, TrailerNumber, NewName";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionMobile getListofTrucksCurrentlyInZXPWithIncompleteTest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }
    }






    public class inspectableTrucks
    {
        public int MSID { get; private set; }
        public string TrailerNumber { get; private set; }
        public int PODetailsID { get; private set; }
        public string ProductID_CMS { get; private set; }
        public string TruckType { get; private set; }
        public string TruckProdLabel { get; private set; }

        public inspectableTrucks(int MSID, string TrailerNumber, int PODetailsID, string ProductID_CMS, string TruckType, string TruckProdLabel)
        {
            this.MSID = MSID;
            this.TrailerNumber = TrailerNumber;
            this.PODetailsID = PODetailsID;
            this.ProductID_CMS = ProductID_CMS;
            this.TruckType = TruckType;
            this.TruckProdLabel = TruckProdLabel;

        }
        
    }
}