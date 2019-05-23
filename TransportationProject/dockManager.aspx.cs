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
    public partial class dockManager : System.Web.UI.Page
    {
        protected static String sql_connStr;
        //public static ZXPUserData zxpUD = new ZXPUserData();
        public static int trailerNumberOfDaysCheck = 5; //TODO : Expose in webconfig as a setting


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

                    if (zxpUD._isAdmin || zxpUD._isDockManager) //make sure this matches whats in Site.Master and Default
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
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/dockManager.aspx", false);//zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dockManager Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }
        public static string GetDayOfWeekID(DateTime selectedDate)
        {

            TimeslotDayOfWeek tsDay = TimeslotDayOfWeek.GetDayOfWeekID(selectedDate);
            return tsDay.DayofWeekShortName;
        }

        [System.Web.Services.WebMethod]
        public static Object GetTimeslotsData(DateTime selectedDate, string spotType, int? spotID, int MSID)
        {
            //currently not being used but left here incase they want us to add it back in
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            List<object[]> headerData = new List<object[]>();
            string selectedDateDOW = GetDayOfWeekID(selectedDate);
            int columncount = 0;
            try
            {
                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                }

                sqlCmd.Connection = sqlConn;


                SqlParameter paramSpotType = new SqlParameter("@SPOTTYPE", SqlDbType.NVarChar);
                SqlParameter paramSpotID = new SqlParameter("@SPOTID", SqlDbType.Int);
                paramSpotType.Value = spotType;
                paramSpotID.Value = spotID;
                sqlCmd.Parameters.Add(paramSpotType);


                sqlCmd.CommandText = "SELECT Count(SpotID) FROM (SELECT -999 AS SpotID UNION " +
                "SELECT SpotID FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort WHERE ST.SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard') AND isDisabled = 0) AS A";

                if (spotID != -999)
                {
                    sqlCmd.Parameters.Add(paramSpotID);
                    sqlCmd.CommandText = sqlCmd.CommandText + " WHERE SpotID = @SPOTID";
                }

                columncount = Convert.ToInt32(sqlCmd.ExecuteScalar());

                sqlCmd.CommandText = "SELECT * FROM (SELECT -999 AS SpotID, 'Task Time / No Spot' AS SpotDescription UNION " +  //modified label; different from trailerOverview
                "SELECT SpotID, SpotDescription FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort WHERE ST.SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard') AND isDisabled = 0) AS A";

                if (spotID != -999)
                {
                    sqlCmd.CommandText = sqlCmd.CommandText + " WHERE SpotID = @SPOTID";

                }
                DataSet dsLoadSpotData = new DataSet();
                DataTable tblSpotData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlSpotReader = sqlCmd.ExecuteReader();
                dsLoadSpotData.Tables.Add(tblSpotData);
                dsLoadSpotData.Load(sqlSpotReader, LoadOption.OverwriteChanges, tblSpotData);

                foreach (System.Data.DataRow row in dsLoadSpotData.Tables[0].Rows)
                {
                    headerData.Add(row.ItemArray);
                }

                SqlParameter paramDAY = new SqlParameter("@DAY", SqlDbType.DateTime);
                SqlParameter paramDOW = new SqlParameter("@DOW", SqlDbType.NVarChar);
                SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);

                paramDAY.Value = selectedDate;
                paramDOW.Value = selectedDateDOW;
                paramMSID.Value = MSID;

                sqlCmd.Parameters.Clear();
                sqlCmd.Parameters.Add(paramSpotType);
                sqlCmd.Parameters.Add(paramDAY);
                sqlCmd.Parameters.Add(paramDOW);
                sqlCmd.Parameters.Add(paramMSID);

                sqlCmd.CommandText = "SELECT * FROM (SELECT TDST.SpotID, TDST.FromTime, TDST.ToTime, TDST.isOpen, ST.SpotTypeShort, TDS.isDisabled, TDST.DayOfWeekID, 0 AS isAppointment, TDS.HoursInTimeBlock, NULL AS PONumber " +
                                        "FROM dbo.TruckDockSpotTimeslots TDST " +
                                        "INNER JOIN dbo.TruckDockSpots TDS ON TDST.SpotID = TDS.SpotID " +
                                        "INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +
                                        "UNION " +
                                        "SELECT -999 AS SpotID, '00:00' AS FromTime, '23:59' AS ToTime, 1 AS isOpen, NULL AS SpotTypeShort, 0 AS isDisabled, '@DOW' AS DayOfWeekID, 0 AS isAppointment, 0 AS HoursInTimeBlock, NULL  AS PONumber " +
                                        "UNION " +
                                        "SELECT NewSpotID AS SpotID, SpotReserveTime AS FromTime, DATEADD(minute,60*(TDS_1.HoursInTimeBlock-floor(TDS_1.HoursInTimeBlock)), DATEADD(hour, floor(TDS_1.HoursInTimeBlock), SpotReserveTime)) AS ToTime, " +
                                            "1 AS isOpen, ST.SpotTypeShort, 0 AS isDisabled , " +
                                            "CASE " +
                                                "WHEN DayNum = 1 THEN 'SU' " +
                                                "WHEN DayNum = 2 THEN 'M' " +
                                                "WHEN DayNum = 3 THEN 'T' " +
                                                "WHEN DayNum = 4 THEN 'W' " +
                                                "WHEN DayNum = 5 THEN 'TH' " +
                                                "WHEN DayNum = 6 THEN 'F' " +
                                                "WHEN DayNum = 7 THEN 'SA' " +
                                            "END AS DayOfWeekID, 1 AS isAppointment,TDS_1.HoursInTimeBlock, MS_1.PONumber  AS PONumber " + 
                                        "FROM dbo.Requests R " + 
                                        "INNER JOIN dbo.MainSchedule MS_1 ON R.MSID = MS_1.MSID " + 
                                        "LEFT JOIN dbo.TruckDockSpots TDS_1 ON R.NewSpotID = TDS_1.SpotID " + 
                                        "INNER JOIN dbo.SpotType ST ON ST.SpotTypeShort = TDS_1.SpotType " +
                                        "INNER JOIN (SELECT MSID, datepart(dw,SpotReserveTime) as DayNum FROM dbo.Requests ) AS A_1 ON A_1.MSID = MS_1.MSID  " +
                                        "WHERE SpotReserveTime >= @DAY AND SpotReserveTime < DateADD(day, 1, @DAY) AND MS_1.isHidden = 0 AND R.isVisible = 1" +
                                        "AND NewSpotID IS NOT NULL AND SpotReserveTime > @DAY " +
                                        ") AS ALLDATA ";

                if (spotID != -999)
                {
                    sqlCmd.Parameters.Add(paramSpotID);
                    sqlCmd.CommandText = sqlCmd.CommandText + " WHERE SpotID = @SPOTID " + 
                                        "AND isDisabled = 0 " +
                                        "AND DayOfWeekID = @DOW";
                }
                else {
                    sqlCmd.CommandText = sqlCmd.CommandText + "WHERE (SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard') OR SpotTypeShort IS NULL) " +
                                            "AND isDisabled = 0 " +
                                            "AND DayOfWeekID = @DOW";
                }

                DataSet dsLoadData = new DataSet();
                DataTable tblLoadData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsLoadData.Tables.Add(tblLoadData);
                dsLoadData.Load(sqlReader, LoadOption.OverwriteChanges, tblLoadData);

                //populate return object
                foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }



            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dockManager GetTimeslotsData(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetTimeslotsData(). Details: " + ex.ToString();
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

            List<object> newList = new List<object>();
            newList.Add(columncount);
            newList.Add(headerData);
            newList.Add(data);

            return newList;
        }

        [System.Web.Services.WebMethod]
        public static Object getLoaders()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT UserID, UserName, FirstName, LastName FROM dbo.Users WHERE (isLoader = 1 AND isDisabled = 0) ORDER BY FirstName, LastName";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getLoaders(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getYardMules()
        {
            List<object[]> data = new List<object[]>();            
            DataSet dataSet = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT UserID, UserName, FirstName, LastName FROM dbo.Users WHERE (isYardMule = 1 AND isDisabled = 0) ORDER BY FirstName, LastName";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getYardMules(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getRequestTypes(int? requestPersonTypeID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (requestPersonTypeID == null)
                    {
                        sqlCmdText = "SELECT RT.RequestTypeID, RT.RequestType FROM dbo.RequestTypes RT WHERE RT.RequestTypeID <> 4";

                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    }
                    else
                    {
                        sqlCmdText = "SELECT RT.RequestTypeID, RT.RequestType FROM dbo.RequestTypes RT INNER JOIN dbo.RequestTypeToPersonRelation RTPR ON RT.RequestTypeID = RTPR.RequestTypeID WHERE RTPR.RequestPersonTypeID = @PTYPEID AND  RT.RequestTypeID <> 4";

                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PTYPEID", requestPersonTypeID));
                    }

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getRequestTypes(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getRequestPersonTypes()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT RPT.RequestPersonTypeID, RPT.RequestPersonType FROM dbo.RequestPersonTypes RPT";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getRequestPersonTypes(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }



        [System.Web.Services.WebMethod]
        public static Object GetSpots()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT -999 AS SpotID, '(NONE)' AS SpotDescription, NULL AS SpotType, 0 AS HoursInTimeBlock UNION " +
                    "(SELECT SpotID, SpotDescription, SpotType, HoursInTimeBlock FROM dbo.TruckDockSpots  WHERE isDisabled = 0) ORDER BY SpotDescription ";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetSpots(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetSpotsByType(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (MSID > 0)
                    {
                        sqlCmdText = "SELECT -999 AS SpotID, '(NONE)' AS SpotDescription, NULL AS SpotType, 0 AS HoursInTimeBlock UNION " +
                         "SELECT SpotID, SpotDescription, SpotType, HoursInTimeBlock FROM dbo.TruckDockSpots WHERE SpotType = (SELECT MS.TruckType FROM MainSchedule AS MS WHERE MS.MSID = @MSID) AND isDisabled = 0 " +
                         "UNION SELECT SpotID, SpotDescription, SpotType, HoursInTimeBlock FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON ST.SpotTypeShort = TDS.SpotType WHERE SpotTypeShort IN ('Yard', 'Wait') " +
                        "ORDER BY SpotDescription";

                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    }
                    else //MSID = -1, PO = N/A selected
                    {
                        sqlCmdText = "SELECT -999 AS SpotID, '(NONE)' AS SpotDescription, NULL AS SpotType, 0 AS HoursInTimeBlock " +
                            "UNION SELECT SpotID, SpotDescription, SpotType, HoursInTimeBlock FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON ST.SpotTypeShort = TDS.SpotType WHERE SpotTypeShort IN ('Yard', 'Wait') " +
                            "ORDER BY SpotDescription";

                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    }

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetSpotsByType(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getCurrentAvailableTrailers()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT -1 AS MSID, '(N/A)' AS TrailerNumber " +
                                        "UNION " +
                                        "SELECT ISNULL(MSID, 0) AS MSID, TrailerNumber FROM  dbo.TrailersInYard " +
                                        "UNION " +
                                        "SELECT MSID, TrailerNumber FROM dbo.MainSchedule " +
                                        "WHERE LTRIM(RTRIM(TrailerNumber)) IS NOT NULL AND isHidden = 0 " +
                                        "AND (StatusID NOT IN (1, 10) AND LocationShort <> 'NOS') "; //TODO decide to only show all po's or only po's in plant + departed (filter 1 status id)&  disable start requests in ym and loader, modify also GetAvailablePONumbers...()


                    //TODO: revisit; possible add when CMS PO status is implemented
                    //"SELECT MSID, TrailerNumber FROM dbo.MainSchedule WHERE TimeArrived > DATEADD(dd, @NUMDAYS, DATEDIFF(dd, 0, GETDATE())) AND LTRIM(RTRIM(TrailerNumber)) IS NOT NULL " +  
                    //"AND (StatusID NOT IN (1, 10) AND LocationShort <> 'NOS')"; 


                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getCurrentAvailableTrailers(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static Object GetAvailablePONumberForLoaderRequests()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT -1 AS MSID, '(N/A)' AS PONum, 'NONE' AS TruckType UNION " +
                                        "SELECT MSID, CONCAT(CAST(PONumber AS varchar(10)), '-', TrailerNumber), TruckType FROM dbo.MainSchedule " +
                                        "WHERE isHidden = 0 AND LocationShort != 'NOS' " +
                                        "OR ((SELECT DATEADD(dd, DATEDIFF(dd, 0, ETA), 0)) = (SELECT CAST (GETDATE() as DATE)) " +
                                        "OR (SELECT DATEADD(dd, DATEDIFF(dd, 0, ETA), 0)) = (SELECT DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1))) " +
                        // "AND (LocationShort <> 'NOS' AND StatusID IN (1)) " +  //TODO decide to only show all po's or only po's in plant (filter 1 and 10 status id)&  disable start requests in ym and loader
                                        "ORDER BY PONum";


                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetAvailablePONumberForLoaderRequests(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetAvailablePONumberForYardmuleRequests()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //TODO: revisit query to see if limit based on ETA is necessary 
                    sqlCmdText = "SELECT -1 AS MSID, '(N/A)' AS PONum, 'NONE' AS TruckType UNION " +
                                        "SELECT MSID, CONCAT(CAST(PONumber AS varchar(10)), '-', TrailerNumber), TruckType FROM dbo.MainSchedule " +
                                        "WHERE isHidden = 0 " +
                        //"AND (ETA >= DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) " +
                        //"OR (ETA < DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1))) " +
                                        "AND( (LocationShort <> 'NOS' AND StatusID NOT IN (1, 10) )  OR (LocationShort<> 'NOS' AND StatusID = 10 AND isDropTrailer = 1))" +  //TODO decide to only show all po's or only po's in plant (filter 1 and 10 status id)&  disable start requests in ym and loader, modify also getcurrentavailabletrailers()
                                        "ORDER BY PONum";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getYardMules(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]//zxczxczxc
        public static Object getDataForAddNewRow(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
            int assignedDockSpotID = 0;
            int currentDockSpotID = 0;
            string truckType = null;
            DateTime dueDateTime;

            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT MS.TrailerNumber, (SELECT SpotDescription FROM dbo.TruckDockSpots WHERE MS.DockSpotID = SpotID) AS AssignedDockSpot, " +
                                            "MS.DockSpotID,  MS.MSID,  MS.isDropTrailer,  MS.LoadType, " +
                                            "(SELECT HoursInTimeBlock FROM dbo.TruckDockSpots WHERE SpotID = DockSpotID) AS TimeBlock, " +
                                            "MS.currentDockSpotID, MS.TruckType, (SELECT SpotDescription FROM dbo.TruckDockSpots WHERE MS.currentDockSpotID = SpotID) AS CurrentSpot " +
                                            "From dbo.MainSchedule AS MS LEFT JOIN dbo.TruckDockSpots AS TDS ON MS.DockSpotID = TDS.SpotID WHERE MSID = @MSID";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID), new SqlParameter("@Now", now));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                    if (MSID == -1)
                    {
                        assignedDockSpotID = 0;
                        currentDockSpotID = 0;
                    }
                    else
                    {
                        truckType = Convert.ToString(dataSet.Tables[0].Rows[0]["TruckType"]);

                        if (dataSet.Tables[0].Rows[0]["DockSpotID"].Equals(DBNull.Value) || dataSet.Tables[0].Rows[0]["DockSpotID"].ToString() == "")
                        {
                            assignedDockSpotID = 0;
                        }
                        else
                        {
                            assignedDockSpotID = Convert.ToInt32(dataSet.Tables[0].Rows[0]["DockSpotID"]);
                        }


                        if (dataSet.Tables[0].Rows[0]["currentDockSpotID"].Equals(DBNull.Value) || dataSet.Tables[0].Rows[0]["currentDockSpotID"].ToString() == "")
                        {
                            currentDockSpotID = 0;
                        }
                        else
                        {
                            currentDockSpotID = Convert.ToInt32(dataSet.Tables[0].Rows[0]["currentDockSpotID"]);
                        }
                    }

                    if ((assignedDockSpotID == currentDockSpotID && assignedDockSpotID != 0) && truckType.ToLower() == "bulk" && truckType != null)
                    {
                        sqlCmdText = "DECLARE @f float " +
                                                "SET @f = (SELECT TDS.HoursInTimeBlock " +
                                                "FROM dbo.TruckDockSpots AS TDS " +
                                                "INNER JOIN dbo.MainSchedule AS MS ON MS.currentDockSpotID = TDS.SpotID) " +
                                                "SELECT " +
                                                "DATEADD(mi, (@f - FLOOR(@f)) * 60, DATEADD(hh, FLOOR(@f), MSE.TimeStamp)) " +
                                                "FROM dbo.MainScheduleEvents AS MSE " +
                                                "WHERE MSE.EventTypeID = 6 AND MSE.MSID = @MSID " +
                                                "ORDER BY MSE.TimeStamp DESC";
                        dueDateTime = Convert.ToDateTime(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));


                        object[] rowArray = new object[1];
                        rowArray[0] = Convert.ToString(dueDateTime);
                        data.Add(rowArray);

                    }
                    else if ((assignedDockSpotID == currentDockSpotID && assignedDockSpotID != 0) && truckType.ToLower() == "van" && truckType != null)
                    {
                        sqlCmdText = "DECLARE @f float " +
                                                "SET @f = (SELECT TDS.HoursInTimeBlock " +
                                                "FROM dbo.TruckDockSpots AS TDS " +
                                                "INNER JOIN dbo.MainSchedule AS MS ON MS.currentDockSpotID = TDS.SpotID WHERE MS.MSID = @MSID) " +
                                                "SELECT " +
                                                "DATEADD(mi, (@f - FLOOR(@f)) * 60, DATEADD(hh, FLOOR(@f), MSE.TimeStamp)) " +
                                                "FROM dbo.MainScheduleEvents AS MSE " +
                                                "WHERE MSE.EventTypeID = 5 AND MSE.MSID = @MSID " +
                                                "ORDER BY MSE.TimeStamp DESC";
                        dueDateTime = Convert.ToDateTime(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                        object[] rowArray = new object[1];
                        rowArray[0] = Convert.ToString(dueDateTime);
                        data.Add(rowArray);
                    }
                    else if ((currentDockSpotID == 3015 || currentDockSpotID == 3017) || ((assignedDockSpotID == 3015 || assignedDockSpotID == 3017) && currentDockSpotID == 0) || (currentDockSpotID == 0 && assignedDockSpotID == 0) || (currentDockSpotID == 0 && assignedDockSpotID == -999))
                    {
                        //data.Add("No dock spot assigned");
                    }
                    else
                    {
                        //sqlCmd.Parameters.Add(paramNow);
                        sqlCmdText = "DECLARE @f float " +
                                                "SET @f = (SELECT TDS.HoursInTimeBlock " +
                                                "FROM dbo.TruckDockSpots AS TDS " +
                                                "INNER JOIN dbo.MainSchedule AS MS ON MS.DockSpotID = TDS.SpotID " +
                                                "WHERE MSID = @MSID) " +
                                                "SELECT " +
                                                "DATEADD(mi, (@f - FLOOR(@f)) * 60, DATEADD(hh, FLOOR(@f), @Now)) ";
                        dueDateTime = Convert.ToDateTime(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID), new SqlParameter("@Now", now)));

                        object[] rowArray = new object[1];
                        rowArray[0] = Convert.ToString(dueDateTime);
                        data.Add(rowArray);
                    }

                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkIfSpotChangeRequestExist(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getDataForAddNewRowUsingTrailerNum(string trailnum)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    //TODO: Modify query to show only active requests + recently finished requests (maybe recently finished today) 
                    sqlCmdText = "SELECT TrailerNumber, SpotDescription, DockSpotID, MSID From dbo.MainSchedule LEFT JOIN dbo.TruckDockSpots ON DockSpotID = SpotID WHERE UPPER(TrailerNumber) = @TRAIL";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getDataForAddNewRowUsingTrailerNum(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static List<VW_DockManagerYardMuleRequestGridEntry> getYardMuleRequestsGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            List<VW_DockManagerYardMuleRequestGridEntry> vw_YardGridData = new List<VW_DockManagerYardMuleRequestGridEntry>();
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                //TODO: Modify query to show only active requests + recently finished requests (maybe recently finished today) 
                    sqlCmdText = "SELECT * FROM ( " +
                        "SELECT R.MSID, MS.PONumber, R.RequestID,  R.Task, R.Assignee, R.Requester, R.Comment, R.NewSpotID, MS.DockSpotID AS AssignedDockSpot," +
                        "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID = 17 ORDER BY TimeStamp DESC) TimeRequestSent," +
                        "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID = 21 ORDER BY TimeStamp DESC) TimeRequestStart," +
                        "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID = 18 ORDER BY TimeStamp DESC) TimeRequestEnd, " +
                        "ISNULL(R.TrailerNumber, MS.TrailerNumber) AS TrailerNumber, RequestTypeID, RequestDueDateTime, MS.TruckType, MS.isRejected, MS.isOpenInCMS, " +
                        "MS.currentDockSpotID, (SELECT TDS3.SpotDescription FROM dbo.TruckDockSpots AS TDS3 WHERE MS.currentDockSpotID = TDS3.SpotID) AS CurrentSpot, " +
                        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ISNULL(ProdDet.topProdID, 0) topProdID, PCMS.ProductName_CMS, SpotReserveTime " +
                        "FROM Requests R " +
                        "LEFT JOIN MainSchedule MS ON MS.MSID = R.MSID " +
                        "LEFT JOIN (SELECT MSID, COUNT(PODetailsID) AS PDCount, " + 
                    "(SELECT TOP 1 PD_A.ProductID_CMS " + 
                    "FROM dbo.PODetails PD_A " +
                    "INNER JOIN dbo.ProductsCMS PCMS_A ON PD_A.ProductID_CMS = PCMS_A.ProductID_CMS " +
                    "WHERE PD_A.MSID =  PD.MSID " +
                    ") AS topProdID  " + 
                    "FROM dbo.PODetails PD  " + 
                    "GROUP BY MSID " +
                    ") ProdDet ON ProdDet.MSID = MS.MSID "+
                    "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = ProdDet.topProdID " +
                        "WHERE  (MS.isHidden = 0 OR MS.isHidden IS NULL) AND RequestPersonTypeID = 2 AND isVisible = 1 AND NOT (MS.StatusID = 10 AND MS.isDropTrailer = 0)" +
                        ") AllData " +
                        "WHERE ((TimeRequestEnd > DATEADD(HOUR, -1, CURRENT_TIMESTAMP) AND TimeRequestEnd <  CURRENT_TIMESTAMP) OR TimeRequestEnd IS NULL) " +
                        "ORDER BY TimeRequestSent";//"ORDER BY RequestDueDateTime, TimeRequestSent";

                VW_DockManagerYardMuleRequestGridEntry vw_YardGridRow;

            

                SqlDataReader reader = SqlHelper.ExecuteReader(sql_connStr, CommandType.Text, sqlCmdText);
                while (reader.Read())
                {
                    vw_YardGridRow = new VW_DockManagerYardMuleRequestGridEntry();
                    vw_YardGridRow.MSID = reader.GetValueOrDefault<int>("MSID");
                    vw_YardGridRow.PONumber = reader.GetValueOrDefault<int>("PONumber");
                    vw_YardGridRow.RequestID = reader.GetValueOrDefault<int>("RequestID");
                    vw_YardGridRow.Task = reader.GetValueOrDefault<string>("Task");
                    vw_YardGridRow.Assignee = reader.GetValueOrDefault<int>("Assignee");
                    vw_YardGridRow.Requester = reader.GetValueOrDefault<int>("Requester");
                    vw_YardGridRow.Comment = reader.GetValueOrDefault<string>("Comment");

                    int? nSpotID = reader.GetValueOrDefault<int>("NewSpotID");
                    vw_YardGridRow.NewSpotID = (0 == nSpotID ? null : nSpotID);


                    int? adSpot = reader.GetValueOrDefault<int>("AssignedDockSpot");
                    vw_YardGridRow.AssignedDockSpot = (0 == adSpot ? null : adSpot);

                    vw_YardGridRow.TimeRequestSent = reader.GetValueOrDefault<DateTime>("TimeRequestSent");

                    DateTime? dStart = reader.GetValueOrDefault<DateTime>("TimeRequestStart");
                    vw_YardGridRow.TimeRequestStart = (default(DateTime) == dStart ? null : dStart);

                
                    DateTime? dEnd = reader.GetValueOrDefault<DateTime>("TimeRequestEnd");
                    vw_YardGridRow.TimeRequestEnd = (default(DateTime) == dEnd ? null : dEnd);

                    vw_YardGridRow.TrailerNumber = reader.GetValueOrDefault<string>("TrailerNumber");
                    vw_YardGridRow.RequestTypeID = reader.GetValueOrDefault<int>("RequestTypeID");
                    vw_YardGridRow.RequestDueDateTime = reader.GetValueOrDefault<DateTime>("RequestDueDateTime");
                    vw_YardGridRow.TruckType = reader.GetValueOrDefault<string>("TruckType");
                    vw_YardGridRow.isRejected = reader.GetValueOrDefault<bool>("isRejected");
                    vw_YardGridRow.isOpenInCMS = reader.GetValueOrDefault<bool>("isOpenInCMS");

                    int? cSpotID = reader.GetValueOrDefault<int>("currentDockSpotID");
                    vw_YardGridRow.currentDockSpotID = (0 == cSpotID ?  null : cSpotID);

                    vw_YardGridRow.CurrentSpot = reader.GetValueOrDefault<string>("CurrentSpot");
                    vw_YardGridRow.ProdCount = reader.GetValueOrDefault<int>("ProdCount");
                    vw_YardGridRow.topProdID = reader.GetValueOrDefault<string>("topProdID");
                    vw_YardGridRow.ProductName_CMS = reader.GetValueOrDefault<string>("ProductName_CMS");
                    vw_YardGridRow.SpotReserveTime = reader.GetValueOrDefault<DateTime>("SpotReserveTime");
                    vw_YardGridData.Add(vw_YardGridRow);

                    
                }



                //dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                //    //populate return object
                //    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                //    {
                //        data.Add(row.ItemArray);
                //    }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getYardMuleRequestsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return vw_YardGridData;
        }

        [System.Web.Services.WebMethod]
        public static Object getLoaderRequestsGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                    string sqlCmdText;
                    //TODO: Modify query to show only active requests + recently finished requests (maybe recently finished today) 
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT * FROM ( " +
                         "SELECT R.MSID, MS.PONumber, R.RequestID,  R.Task, R.Assignee, R.Requester, R.Comment,  R.NewSpotID, MS.DockSpotID AS OriginallyAssignedSpot," +
                        "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSRE.EventID = MSE1.EventID WHERE (isHidden = 0) AND MSE1.MSID = R.MSID AND MSRE.RequestID = R.RequestID AND EventTypeID = 2027 ORDER BY TimeStamp DESC) TimeRequestSent," +
                        "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSRE.EventID = MSE1.EventID WHERE (isHidden = 0) AND MSE1.MSID = R.MSID AND MSRE.RequestID = R.RequestID AND (EventTypeID = 2030  OR EventTypeID =  13  OR EventTypeID =  15) ORDER BY TimeStamp DESC) TimeRequestStart," +
                        "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSRE.EventID = MSE1.EventID WHERE (isHidden = 0) AND MSE1.MSID = R.MSID AND MSRE.RequestID = R.RequestID AND (EventTypeID = 2031  OR EventTypeID =  14  OR EventTypeID =  16) ORDER BY TimeStamp DESC) TimeRequestEnd, " +
                        "ISNULL(R.TrailerNumber, MS.TrailerNumber) AS TrailerNumber, RequestTypeID, RequestDueDateTime, MS.isRejected, MS.isOpenInCMS, MS.currentDockSpotID, " +
                        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS, MS.ETA " +
                        "FROM Requests R " +
                        "LEFT JOIN MainSchedule MS ON MS.MSID = R.MSID " +

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

                        "WHERE (MS.isHidden = 0 OR MS.isHidden IS NULL) AND RequestPersonTypeID = 1  AND isVisible = 1" +
                        ") AllData " +
                        "WHERE (TimeRequestEnd > DATEADD(HOUR, -1, CURRENT_TIMESTAMP) OR TimeRequestEnd IS NULL) OR " +
                        "((SELECT DATEADD(dd, DATEDIFF(dd, 0, ETA), 0)) = (SELECT CAST (GETDATE() as DATE)) OR " +
                        "(SELECT DATEADD(dd, DATEDIFF(dd, 0, ETA), 0)) = (SELECT DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1))) " +
                        "ORDER BY TimeRequestSent";//"ORDER BY RequestDueDateTime, TimeRequestSent";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager getLoaderRequestsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
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
               
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT * FROM ( " +
                                    "SELECT R.MSID, MS.PONumber, R.RequestID,  R.Task, " + 
                                    "(SELECT URS.FirstName FROM dbo.Users as URS WHERE R.Requester = URS.UserID) RequesterFirstName, " + 
                                    "(SELECT URS.LastName FROM dbo.Users as URS WHERE R.Requester = URS.UserID) RequesterLastName, " + 
                                    "(SELECT URS.FirstName FROM dbo.Users as URS WHERE R.Assignee = URS.UserID) AssigneeFirstName, " +
                                    "(SELECT URS.LastName FROM dbo.Users as URS WHERE R.Assignee = URS.UserID) AssigneeLastName, "+
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN (17, 2027) ORDER BY TimeStamp DESC) TimeRequestSent, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN (2030, 13, 15, 21)  ORDER BY TimeStamp DESC) TimeRequestStart, " +
                                    "(SELECT TOP (1) Timestamp FROM MainScheduleEvents MSE1 INNER JOIN MainScheduleRequestEvents MSRE ON MSE1.MSID = R.MSID AND MSRE.EventID = MSE1.EventID WHERE (isHidden = 0 or isHidden IS NULL) AND MSRE.RequestID = R.RequestID AND EventTypeID IN  (2031, 14, 16, 18) ORDER BY TimeStamp DESC) TimeRequestEnd, " +
                                    "R.Comment,  R.NewSpotID, ISNULL(R.TrailerNumber, MS.TrailerNumber) AS TrailerNumber, RequestDueDateTime, MS.TruckType, MS.isRejected, MS.isOpenInCMS " +
                                    "FROM MainScheduleEvents MSE1 " +
                                    "INNER JOIN MainSchedule MS ON MS.MSID = MSE1.MSID " +
                                    "INNER JOIN MainScheduleRequestEvents  MSRE ON MSE1.EventID = MSRE.EventID " +
                                    "INNER JOIN Requests R ON MS.MSID = R.MSID AND MSRE.RequestID = R.RequestID " +
                                    "WHERE  (MS.isHidden = 0 OR MS.isHidden IS NULL) AND isVisible = 1 AND EventTypeID IN (2031, 14, 16, 18) AND MSE1.isHidden = 0 " +
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
                string strErr = " Exception Error in dockManager getYardMules(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int CheckIfSpotIsAvailable(int spotID, int MSID)
        {
            //currently not being used but left here incase they want us to add it back in
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            int rc = 0;

            try
            {

                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                }

                sqlCmd.Connection = sqlConn;
                

                SqlParameter paramSpot = new SqlParameter("@SPOT", SqlDbType.Int);
                sqlCmd.Parameters.Add(paramSpot);
                paramSpot.Value = spotID;



                sqlCmd.CommandText = "SELECT HoursInTimeBlock FROM dbo.TruckDockSpots WHERE SpotID = @SPOT";
                double hrsblock = Convert.ToDouble(sqlCmd.ExecuteScalar());

                SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                paramMSID.Value = MSID;
                sqlCmd.Parameters.Add(paramMSID);

                //Check database for a scheduled truck or truck currently in spot that will overlap that is not the selected truck; //does not take into account that goes over their expected time 
                sqlCmd.CommandText = "SELECT COUNT(*) FROM dbo.MainSchedule WHERE (LocationShort NOT IN ('NOS')) AND DockSpotID = @SPOT AND isHidden = 0 AND isRejected = 0 AND MSID <> @MSID AND ETA  >= @DUEDATEMIN AND ETA <= @DUEDATEMAX";
                rc = Convert.ToInt32(sqlCmd.ExecuteScalar());


                //Check database for a truck request for spot that will overlap that is not the selected truck
                sqlCmd.CommandText = "SELECT COUNT(*) FROM dbo.Requests R INNER JOIN dbo.MainSchedule MS ON MS.MSID = R.MSID WHERE R.RequestTypeID IN (3, 4, 5) AND R.isVisible = 1 AND R.NewSpotID = @SPOT AND R.RequestDueDateTime >= @DUEDATEMIN AND R.RequestDueDateTime <= @DUEDATEMAX " +
                    "AND MS.MSID <> @MSID AND MS.isHidden = 0 AND isRejected = 0 AND (LocationShort NOT IN ('NOS'))";
                rc = rc + Convert.ToInt32(sqlCmd.ExecuteScalar());
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dockManager checkIfSpotIsAvaialble(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkIfSpotIsAvaialble(). Details: " + ex.ToString();
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
            return rc;
        }

        //TODO: Add userID of person logged in editing inspection result
        [System.Web.Services.WebMethod]
        public static void CreateRequest(int rMSID, string trailnum, int? assignee, int? newSpotID, int RequestPersonType, int RequestTypeID, DateTime? SpotReserveTime)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();

                using (var scope = new TransactionScope())
                {
                    string sqlCmdText = string.Empty;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    int requestID = 0;

                    if (1 == RequestPersonType)
                    {//loader
                        sqlCmdText = "INSERT INTO dbo.Requests (MSID, TrailerNumber, Assignee, Requester, NewSpotID, RequestPersonTypeID, RequestTypeID, isVisible, SpotReserveTime) " +
                                "VALUES (@MSID, @TRAILER, @ASSIGN, @REQUESTER, @NEWSPOT, @RPERSON, @RTYPE, 1, @SPOTRESERVETIME); " +
                                "SELECT SCOPE_IDENTITY()";
                    requestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText,  new SqlParameter("@MSID", rMSID),
                                                                                                                        new SqlParameter("@TRAILER", TransportHelperFunctions.convertStringEmptyToDBNULL(trailnum)),
                                                                                                                        new SqlParameter("@ASSIGN", TransportHelperFunctions.convertStringEmptyToDBNULL(assignee)),
                                                                                                                        new SqlParameter("@REQUESTER", zxpUD._uid),
                                                                                                                        new SqlParameter("@NEWSPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString())),
                                                                                                                        new SqlParameter("@RPERSON", RequestPersonType),
                                                                                                                        new SqlParameter("@RTYPE", RequestTypeID),
                                                                                                                        new SqlParameter("@SPOTRESERVETIME", SpotReserveTime)
                                                                                                                        ));


                    } 
                    else if (2 == RequestPersonType)
                    { //ym
                        sqlCmdText = "INSERT INTO dbo.Requests (MSID, TrailerNumber, Requester, NewSpotID, RequestPersonTypeID, RequestTypeID, isVisible, SpotReserveTime) " +
                                "VALUES (@MSID, @TRAILER, @REQUESTER, @NEWSPOT, @RPERSON, @RTYPE, 1, @SPOTRESERVETIME); " +
                                "SELECT SCOPE_IDENTITY()";
                    requestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", rMSID),
                                                                                                                    new SqlParameter("@TRAILER", TransportHelperFunctions.convertStringEmptyToDBNULL(trailnum)),
                                                                                                                    new SqlParameter("@REQUESTER", zxpUD._uid),
                                                                                                                    new SqlParameter("@NEWSPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString())),
                                                                                                                    new SqlParameter("@RPERSON", RequestPersonType),
                                                                                                                    new SqlParameter("@RTYPE", RequestTypeID),
                                                                                                                    new SqlParameter("@SPOTRESERVETIME", SpotReserveTime)
                                                                                                                    ));

                    };



                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "MSID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, rMSID.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "TrailerNumber", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(trailnum).ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Assignee", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, assignee.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Requester", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "NewSpotID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString()).ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "RequestPersonTypeID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, RequestPersonType.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "RequestTypeID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, RequestTypeID.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "isVisible", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "SpotReserveTime", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, SpotReserveTime.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    if (1 == RequestPersonType)
                    { //loader - EventTypeID = 2027 --> "Loader Assignment Created"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 2027, @TIME, @REQUESTER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    }
                    else if (2 == RequestPersonType)
                    { //yard mule  - EventTypeID = 17 --> "Yard Mule Request Created"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 17, @TIME, @REQUESTER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    }
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", rMSID),
                                                                                                                     new SqlParameter("@TIME", now),
                                                                                                                     new SqlParameter("@REQUESTER", zxpUD._uid)));

                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                    "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID.ToString()),
                                                                                         new SqlParameter("@EID", eventID.ToString()));

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager CreateRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static int checkIfSpotChangeRequestExist(int MSID)
        {
            int rowCount = 0;

            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT COUNT(*) FROM dbo.Requests as REQ " +
                                     "INNER JOIN dbo.MainSchedule MS ON REQ.MSID = MS.MSID " +
                                     "INNER JOIN dbo.RequestTypes RT ON RT.RequestTypeID = REQ.RequestTypeID " +
                                        "WHERE REQ.MSID = @MSID AND REQ.isVisible != 'false' AND REQ.NewSpotID IS NOT NULL AND MS.isHidden = 0 AND RequestType LIKE '%move%'";

                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkIfSpotChangeRequestExist(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static int checkIfSpotChangeRequestExist_OnRowEdit(int MSID, int ReqID)
        {
            int rowCount = 0;

            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT COUNT(*) FROM dbo.Requests as REQ " +
                                        "INNER JOIN dbo.MainSchedule MS ON REQ.MSID = MS.MSID " +
                                        "INNER JOIN dbo.RequestTypes RT ON RT.RequestTypeID = REQ.RequestTypeID " +
                                        "WHERE REQ.MSID = @MSID AND REQ.isVisible != 'false' AND REQ.NewSpotID IS NOT NULL AND RequestID != @RequestID AND MS.isHidden = 0 AND MS.isRejected = 0 AND RequestType LIKE '%move%'";

                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID), new SqlParameter("@RequestID", ReqID)));
             
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkIfSpotChangeRequestExist_OnRowEdit(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }

        //Function checks if RequestType being inserted already exists for a given MSID where RequestType != Other
        [System.Web.Services.WebMethod]
        public static Object checkIfRequestTypeExists(int MSID, int reqTypeID)
        {
            int count = 0;

            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT COUNT(*) FROM dbo.Requests REQ " +
                                     "INNER JOIN dbo.MainSchedule MS ON REQ.MSID = MS.MSID " + 
                                     "INNER JOIN dbo.RequestTypes RT ON RT.RequestTypeID = REQ.RequestTypeID " +
                                     "WHERE MS.MSID = @MSID AND REQ.RequestTypeID = @RTYPEID and isVisible = 1 AND MS.isHidden = 0 AND MS.isRejected = 0 AND RequestType NOT LIKE 'Other'";
                    count = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                               new SqlParameter("@RTYPEID", reqTypeID)));
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkIfRequestTypeExists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return count;
        }

        //Function checks if Request has been started 
        [System.Web.Services.WebMethod]
        public static bool checkIfRequestStarted(int reqID)
        {
            bool wasStarted = false;

            try
            {
               
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    //Load started = 13, Unload started 15, Yardmule Request= 21, Loader Assignment started = 2030
                    sqlCmdText = "SELECT COUNT(E.EventTypeID) FROM dbo.MainScheduleRequestEvents MSRE " +
                                    "INNER JOIN dbo.Requests R ON R.RequestID = MSRE.RequestID " +
                                    "INNER JOIN dbo.MainScheduleEvents MSE ON R.MSID = MSE.MSID AND MSRE.EventID = MSE.EventID " +
                                    "INNER JOIN dbo.EventTypes E ON MSE.EventTypeID = E.EventTypeID " +
                                    "WHERE R.RequestID = @RID AND (E.EventTypeID = 13 OR E.EventTypeID = 15 OR E.EventTypeID = 2030 OR E.EventTypeID =  21) AND R.isVisible = 1 AND (MSE.isHidden = 'false')";
                    int count = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID)));
                    if (0 < count)
                    {
                        wasStarted = true;
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkIfRequestStarted(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return wasStarted;
        }

        [System.Web.Services.WebMethod]
        public static void deleteRequest(int reqID, int MSID)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {

                    //------log request created into mainscheduleevents table

                    //2034 = Request Deleted Event
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                            "VALUES (@MSID, 2034, @TIME, @REQUESTER, 'false'); " +
                        "SELECT SCOPE_IDENTITY()";

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", now),
                                                                                                                     new SqlParameter("@REQUESTER", zxpUD._uid)));

                    //Was decided to hide requests from interface and not delete them for reporting and audit reasons
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "isVisible", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0", eventID, "RequestID", reqID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    sqlCmdText = "UPDATE dbo.Requests SET isVisible = 0 WHERE RequestID = @RID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID));


                    //log into mainschedulerequestevents table
                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents (RequestID, EventID) " +
                                "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID), new SqlParameter("@EID", eventID));

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, reqID.ToString(), eventID, "RequestID", reqID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", reqID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager deleteRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

       // TODO : either on client side or serverside - ask when if edits can be done on a task that has been started/ended
        [System.Web.Services.WebMethod]
        public static void updateRequest(int reqID, int? assignee, int? newSpotID, int RequestTypeID, DateTime SpotReserveTime)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "UPDATE dbo.Requests SET  Assignee = @ASSIGN, Requester = @REQUESTER, NewSpotID = @NEWSPOT, RequestTypeID = @RTYPE, SpotReserveTime = @SPOTRESERVETIME " + // RequestDueDateTime = @DUE " +
                                    "WHERE (RequestID = @RID)";

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ASSIGN", TransportHelperFunctions.convertStringEmptyToDBNULL(assignee))
                                                                                       , new SqlParameter("@REQUESTER", zxpUD._uid)
                                                                                       , new SqlParameter("@NEWSPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString()))
                                                                                       , new SqlParameter("@RTYPE", RequestTypeID)
                                                                                       , new SqlParameter("@RID", reqID)
                                                                                       , new SqlParameter("@SPOTRESERVETIME", SpotReserveTime));



                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "Assignee", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, assignee.ToString(), null, "RequestID", reqID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "Requester", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), null, "RequestID", reqID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "NewSpotID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString()).ToString(), null, "RequestID", reqID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "RequestTypeID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, RequestTypeID.ToString(), null, "RequestID", reqID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Requests", "SpotReserveTime", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, SpotReserveTime.ToString(), null, "RequestID", reqID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //------LOG REQUEST CREATION INTO EVENTS TABLE 
                    // 1) Find request type
                    sqlCmdText = "SELECT RequestPersonTypeID FROM dbo.Requests WHERE RequestID = @RID";
                    int RequestPersonType = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID)));

                    // 2) Find MSID 
                    sqlCmdText = "SELECT MSID FROM dbo.Requests WHERE RequestID = @RID";
                    int MSID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID)));

                    // 3) log into mainschedule events
                    if (1 == RequestPersonType)
                    { //loader - EventTypeID = 2028 --> "Loader Assignment Updated"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                     "VALUES (@MSID, 2028, @TIME, @REQUESTER, 'false'); " +
                                     "SELECT SCOPE_IDENTITY()";

                    }
                    else if (2 == RequestPersonType)
                    { //yard mule  - EventTypeID = 2026 --> "Yard Mule Request Updated"
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                     "VALUES (@MSID, 2026, @TIME, @REQUESTER, 'false'); " +
                                     "SELECT SCOPE_IDENTITY()";
                    }

                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID), 
                                                                                                                     new SqlParameter("@TIME", now), 
                                                                                                                     new SqlParameter("@REQUESTER", zxpUD._uid)));

                    // 4) log into mainschedule requestevents
                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                 "VALUES(@RID, @EID)";

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", reqID),
                                                                                         new SqlParameter("@EID", eventID));
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, reqID.ToString(), eventID, "RequestID", reqID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", reqID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager updateRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object checkStatusOfYMRequest(int reqID)
        {
            List<object[]> data = new List<object[]>();            
            DataSet dataSet = new DataSet();
            try
            {
              
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT TOP(1) MSRE.RequestID, MSE.EventTypeID, MSE.TimeStamp, UserName from dbo.MainScheduleRequestEvents as MSRE " +
                                        "INNER JOIN dbo.MainScheduleEvents as MSE ON MSRE.EventID = MSE.EventID " +
                                        "INNER JOIN dbo.Requests R ON R.RequestID = MSRE.RequestID " +
                                        "LEFT JOIN dbo.Users ON R.Assignee = Users.UserID " +
                                        "WHERE MSRE.RequestID = @RequestID AND MSE.isHidden = 'false' AND " +
                                        "(EventTypeID = 17 OR EventTypeID = 18 OR EventTypeID = 21) " +
                                        "ORDER BY TimeStamp DESC";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RequestID", reqID));
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkStatusOfYMRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object checkStatusOfLoaderRequest(int reqID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
              
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT TOP(1) MSRE.RequestID, MSE.EventTypeID, MSE.TimeStamp, UserName from dbo.MainScheduleRequestEvents as MSRE " +
                                        "INNER JOIN dbo.MainScheduleEvents as MSE ON MSRE.EventID = MSE.EventID " +
                                        "INNER JOIN dbo.Requests R ON R.RequestID = MSRE.RequestID " +
                                        "LEFT JOIN dbo.Users ON R.Assignee = Users.UserID " +
                                        "WHERE MSRE.RequestID = @RequestID AND MSE.isHidden = 'false' AND " +
                                        "(EventTypeID = 2027 OR EventTypeID = 2030 OR EventTypeID =  13  OR EventTypeID =  15 OR EventTypeID = 2031  OR EventTypeID =  14  OR EventTypeID =  16) " +
                                        "ORDER BY TimeStamp DESC";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RequestID", reqID));
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                 
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkStatusOfLoaderRequest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static string checkLoadType(int MSID)
        {
            string loadType = null;
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT LoadType FROM dbo.MainSchedule WHERE MSID = @MSID";

                    loadType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager checkLoadType(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return loadType;
        }

        [System.Web.Services.WebMethod]
        public static Object getRequestTypesBasedOnMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            string loadType = null;
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT LoadType FROM dbo.MainSchedule WHERE MSID = @MSID";

                    loadType = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (loadType == "LOADOUT")
                    {
                        sqlCmdText = "SELECT RT.RequestTypeID, RT.RequestType FROM dbo.RequestTypes RT INNER JOIN dbo.RequestTypeToPersonRelation RTPR ON RT.RequestTypeID = RTPR.RequestTypeID WHERE RTPR.RequestPersonTypeID = 1 AND RequestType NOT IN ('Unload')";
                    }
                    else if (loadType == "LOADIN")
                    {
                        sqlCmdText = "SELECT RT.RequestTypeID, RT.RequestType FROM dbo.RequestTypes RT INNER JOIN dbo.RequestTypeToPersonRelation RTPR ON RT.RequestTypeID = RTPR.RequestTypeID WHERE RTPR.RequestPersonTypeID = 1 AND RequestType NOT IN ('Load')";
                    }
                    else if (loadType == null || loadType == "")
                    {
                        sqlCmdText = "SELECT RT.RequestTypeID, RT.RequestType FROM dbo.RequestTypes RT INNER JOIN dbo.RequestTypeToPersonRelation RTPR ON RT.RequestTypeID = RTPR.RequestTypeID WHERE RTPR.RequestPersonTypeID = 1 AND RequestType ! = 'Load' AND RequestType ! = 'Unload'";
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
                string strErr = " Exception Error in dockManager getRequestTypesBasedOnMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
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
                string strErr = " SQLException Error in dockManager GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in dockManager GetLogList(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetLogList(). Details: " + ex.ToString();
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
        public static Object GetPODetailsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();            
            DataSet dataSet = new DataSet();
            try
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
                    
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dockManager GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

    }
}