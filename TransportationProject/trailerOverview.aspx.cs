using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;
using TransportationProjectDataLayer;
using System.Linq;


namespace TransportationProject
{
    public partial class trailerOverview : System.Web.UI.Page
    {
       
        protected static String as400_connStr;

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
              
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (zxpUD._uid != new ZXPUserData()._uid)
                {

                    if (!(zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isGuard || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin || zxpUD._isAccountManager)) //make sure this matches whats in Site.Master and Default
                    {
                        Response.BufferOutput = true;
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/trailerOverview.aspx", false); //zxp live url
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TrailerOverview Page_Load(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview Page_Load(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static List<PODetails> GetPODetailsFromMSID(int MSID)
        {
            List<PODetails> poData = new List<PODetails>();
            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                poData = dProvider.GetPODetails(MSID);
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
           
            }
            return poData;
        }

        [System.Web.Services.WebMethod]
        public static List<LoadTypes> GetLoadOptions()
        {
           List<LoadTypes> loadData = new List<LoadTypes>();

            try
            {

                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                loadData = dProvider.GetLoadTypes(false);

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetLoadOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return loadData;
        }

        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_UnitOfMeasure> GetUnits()
        {
            List<TransportationProjectDataLayer.ViewModels.vm_UnitOfMeasure> vmUnits = new List<TransportationProjectDataLayer.ViewModels.vm_UnitOfMeasure>();

            try
            {

                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.UnitOfMeasure> units = dProvider.GetUnitsOfMeasure();
                vmUnits = units.Select<TransportationProjectDataLayer.DomainModels.UnitOfMeasure, TransportationProjectDataLayer.ViewModels.vm_UnitOfMeasure>(x => x).ToList();
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetUnits(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vmUnits;
        }

       

        [System.Web.Services.WebMethod]
        public static void UpdateTruckSchedulePOsFromCMS()
        {
            
            try
            {
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                SqlConnection sqlConn = new SqlConnection(sql_connStr);
                SqlCommand sqlcmd = new SqlCommand("msdb.dbo.sp_start_job", sqlConn);
                sqlcmd.Parameters.AddWithValue("@job_name", "TS_GetCMSAvailablePOs");
                using (sqlConn)
                {
                    sqlConn.Open();
                    using (sqlcmd)
                    {
                        sqlcmd.ExecuteNonQuery();
                        ErrorLogging.WriteEvent("Starting Job TS_GetCMSAvailablePOs to update POs.", EventLogEntryType.Information);
                    }
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview UpdateTruckSchedulePOsFromCMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Information);
                //Log error and continue without redirect;
                
            }
        }
        
        //private static Object GetPOsFromCMSDirectly()
        private static List<CMS_AvailablePO> GetPOsFromCMSDirectly()
        {
            List<object[]> data = new List<object[]>();
            List<CMS_AvailablePO> availPO = new List<CMS_AvailablePO>();
            DataSet dataSet = new DataSet();
            DataSet ODBC_dataSet = new DataSet();
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();

            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;

            try
            {
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                string sqlCmdText;

                //Retrieve and combine PO and Sales order number data where the status is not complete. Ask if should constrain results to a certain date range
                odbcCmd.CommandText =
                    "SELECT KAPO# AS PONUM, " +
                        "(SELECT KBPT# FROM CMSDAT.POI WHERE KBPO# = A.KAPO# AND KBITM# = 1 ) AS Prod1, " +
                        "(SELECT KBPT# FROM CMSDAT.POI WHERE KBPO# = A.KAPO# AND  KBITM# = 2 ) AS Prod2, " +
                        "(SELECT KBPT# FROM CMSDAT.POI WHERE KBPO# = A.KAPO# AND KBITM# = 3 ) AS Prod3, " +
                        "0 AS isOrder, '' AS ZXPPONUM " +
                    "FROM CMSDAT.POH AS A WHERE KAOSTS NOT LIKE '%C%' AND KAPO# NOT LIKE '9%'" +
                    "UNION " +
                    "SELECT DCORD# AS PONUM, " +
                        "(SELECT DDPART FROM CMSDAT.OCRI WHERE DDORD# = B.DCORD# AND DDITM# = 1 ) AS Prod1, " +
                        "(SELECT DDPART FROM CMSDAT.OCRI WHERE DDORD# = B.DCORD# AND  DDITM# = 2 ) AS Prod2, " +
                        "(SELECT DDPART FROM CMSDAT.OCRI WHERE DDORD# = B.DCORD# AND DDITM# = 3 ) AS Prod3, " +
                        "1 AS isOrder, DCPO AS ZXPPONUM " +
                    "FROM CMSDAT.OCRH AS B WHERE DCSTAT NOT LIKE '%C%' AND DCORD# NOT LIKE '9%' " + //AND DCPLNT LIKE '001' " + //steve's request on 5/4/2016 email. only retrieve orders (OCRH) from plant == 001
                                                                                                    // DCPLNT condition removed on 3/23/2018 - request by csims and steve
                    "ORDER BY PONUM DESC ";
                DataSet dsLoadData = new DataSet();
                OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                dsAdapter.Fill(dsLoadData);

                sqlCmdText = "SELECT DISTINCT PONumber FROM dbo.MainSchedule where isHidden = 0 AND NOT (LocationShort = 'NOS' AND isRejected = 1)";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                foreach (System.Data.DataRow CMSRow in dsLoadData.Tables[0].Rows)
                {
                    bool isFound = false;
                    foreach (System.Data.DataRow poRow in dataSet.Tables[0].Rows)
                    {
                        string CMSPO = CMSRow.ItemArray[0].ToString();
                        string SQLPO = poRow.ItemArray[0].ToString();

                        if (CMSPO.CompareTo(SQLPO) == 0)
                        {
                            isFound = true;
                        }
                    }
                    if (!isFound)
                    {
                        CMS_AvailablePO newPO = new CMS_AvailablePO();
                        newPO.PONUM = int.Parse(CMSRow.ItemArray[0].ToString());
                        if (CMSRow.ItemArray[1] != null) { newPO.Prod1 = CMSRow.ItemArray[1].ToString(); }

                        if (CMSRow.ItemArray[2] != null) { newPO.Prod2 = CMSRow.ItemArray[2].ToString(); }
                        if (CMSRow.ItemArray[3] != null) { newPO.Prod3 = CMSRow.ItemArray[3].ToString(); }
                        int ordernum = int.Parse( CMSRow.ItemArray[4].ToString());
                        newPO.isOrder = ordernum == 1 ? true : false;
                        if (CMSRow.ItemArray[5] != null) { newPO.ZXPPONUM = CMSRow.ItemArray[5].ToString(); }

                        availPO.Add(newPO);
                        data.Add(CMSRow.ItemArray);
                    }
                }

            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in trailerOverview GetAvailablePONumber(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in trailerOverview GetAvailablePONumber(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return availPO;

        }



        //Combine two CMS table information 
        //CMSDAT.POH PO Header table, CMSDAT.POI PO Details table
        //CMSDAT.OCRH Sales Order Detail, OMSDAT.OCRI Sales order details 
        [System.Web.Services.WebMethod]
        public static Object GetAvailablePONumber()
        {
            string isDirect = ConfigurationManager.AppSettings["CMSUpdateIsFromDirectlyFromCMS"];
            if (isDirect == String.Empty || isDirect.ToLower().Equals("true"))
            {
                return GetPOsFromCMSDirectly();
            }
            else
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                return dProvider.GetAvailableCMSPOs();
            }

        }

        [System.Web.Services.WebMethod]
        public static int CheckIfPOExistsInMainSchedule(int ponum)
        {
            int rowCount = 0;

            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                rowCount = dProvider.GetRowCountForPO(ponum);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview CheckIfPOExistsInMainSchedule(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return rowCount;
        }

        
        //Combine two table information 
        //CMSDAT.POH PO Header table, CMSDAT.POI PO Details table
        //CMSDAT.OCRH Sales Order Detail, OMSDAT.OCRI Sales order details 
        [System.Web.Services.WebMethod]
        public static Object GetPOData(int PO)
        {
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {

                odbcCmd.CommandText = string.Concat("SELECT cID, cName , OrderDate FROM( ",
                    "SELECT KAOVND AS cID, KAOVNM AS cName , KAODAT AS OrderDate FROM CMSDAT.POH WHERE KAPO# = ? ",
                    "UNION ",
                    "SELECT DCBCUS AS cID, DCBNAM AS cName , DCODAT AS OrderDate FROM CMSDAT.OCRH WHERE DCORD# = ? ",
                    ") AS POInfo ",
                    "order by OrderDate DESC ",
                    "fetch first 1 row only");
                

                    odbcCmd.Parameters.Add("POnum1", OdbcType.Numeric).Value = PO;
                    odbcCmd.Parameters.Add("POnum2", OdbcType.Numeric).Value = PO;

                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                    dsAdapter.Fill(dataSet);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetPOData(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return data;
        }

        
        [System.Web.Services.WebMethod]
        public static Object GetCustomerOptions()
        {
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    odbcCmd.CommandText = "SELECT DISTINCT CUSTID, CUSTNAME FROM (SELECT BVCUST AS CUSTID, TRIM(BVNAME) AS CUSTNAME FROM CMSDAT.CUST UNION " +
                                          "SELECT BTVEND AS CUSTID, TRIM(BTNAME) AS CUSTNAME FROM CMSDAT.VEND) AS A " +
                                          "ORDER BY CUSTNAME";
                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                    dsAdapter.Fill(dataSet);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetCustomerOptions(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_dd_Status> GetStatusOptions(bool isFormatting, string locationshort)
        {
            List<TransportationProjectDataLayer.ViewModels.vm_dd_Status> vmddStatuses = new List<TransportationProjectDataLayer.ViewModels.vm_dd_Status>();
            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.Status> statuses = new List<TransportationProjectDataLayer.DomainModels.Status>();
                if (isFormatting)
                {
                    statuses= dProvider.GetStatuses();
                }
                else
                {
                    statuses = dProvider.GetStatusesFilteredByLocation(locationshort);
                }
                vmddStatuses = statuses.Select<TransportationProjectDataLayer.DomainModels.Status, TransportationProjectDataLayer.ViewModels.vm_dd_Status>(x => x).ToList();

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetStatusOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vmddStatuses;
        }

        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_Locations> GetLocationOptions(bool isFormatting)
        {
            List<TransportationProjectDataLayer.ViewModels.vm_Locations> vmLocations = new List<TransportationProjectDataLayer.ViewModels.vm_Locations>();
            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.Locations> locations = dProvider.GetLocations();

                vmLocations = locations.Select<TransportationProjectDataLayer.DomainModels.Locations, TransportationProjectDataLayer.ViewModels.vm_Locations>(x => x).ToList();

                if (!isFormatting)
                {
                    TransportationProjectDataLayer.ViewModels.vm_Locations vmLocation = vmLocations.Find(x => x.LocationShortname == "NOS");
                    vmLocations.Clear();
                    vmLocations.Add(vmLocation);
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetLocationOptions(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vmLocations;
        }

        

        [System.Web.Services.WebMethod]
        public static Object GetCOFAFileUploadsFromMSID(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                string sqlCmdText;
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT FileID, MSF.MSID, MSF.FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld, PD.ProductID_CMS, PCMS.ProductName_CMS " +
                                    "FROM dbo.MainScheduleFiles MSF " +
                                    "INNER JOIN dbo.FileTypes FT ON FT.FileTypeID = MSF.FileTypeID " +
                                    "INNER JOIN dbo.PODetails PD ON PD.MSID = MSF.MSID " +
                                    "INNER JOIN dbo.Samples S ON S.PODetailsID = PD.PODetailsID AND S.FileID_COFA = MSF.FileID " +
                                    "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = PD.ProductID_CMS " +
                                    "WHERE MSF.isHidden = 0 AND MSF.MSID = @PMSID AND MSF.FileTypeID = 2 AND (S.TestApproved =1 OR S.TestApproved IS NULL) AND S.isHidden = 0";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetCOFAFileUploadsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_MainScheduleFiles> GetFileUploadsFromMSID(int MSID)
        {
            List<TransportationProjectDataLayer.ViewModels.vm_MainScheduleFiles> vmFiles = new List<TransportationProjectDataLayer.ViewModels.vm_MainScheduleFiles>();

            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.MainScheduleFiles> msFiles = dProvider.GetMainScheduleFiles(MSID);
                vmFiles = msFiles.Select<TransportationProjectDataLayer.DomainModels.MainScheduleFiles, TransportationProjectDataLayer.ViewModels.vm_MainScheduleFiles>(x => x).ToList();
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetCOFAFileUploadsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vmFiles;
        }


        [System.Web.Services.WebMethod]
        public static bool IsUserPermittedToEdit()
        {
            ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
            return zxpUD.CanUserCRUDSchedules();
        }

        
        //CL: From email discussion with Steve, keep files and db entry on server can clean up later 
        //Just set isHidden = true
        [System.Web.Services.WebMethod]
        public static void DeleteFileDBEntry(int fileID, string fileType)
        {
            DateTime timestamp = DateTime.Now;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //1. get MSID
                    sqlCmdText = "SELECT MSID FROM dbo.MainScheduleFiles WHERE FileID = @PFID";
                    int MSID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PFID", fileID)));

                    //2. insert event to Main Schedule Events
                    switch (fileType)
                    {
                        case "BOL":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                       "VALUES (@MSID, 4102, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                        case "COFA":
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                       "VALUES (@MSID, 4098, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                        default: // generic files
                            sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) " +
                                       "VALUES (@MSID, 4100, @NOW, @UserID, 0);" +
                                            "SELECT SCOPE_IDENTITY()";
                            break;
                    }

                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@NOW", timestamp),
                                                                                                                     new SqlParameter("@UserID", zxpUD._uid)));
                    //3. hide file
                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "FileID", fileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    sqlCmdText = "UPDATE dbo.MainScheduleFiles SET isHidden = 1 WHERE fileID = @PFID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PFID", fileID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview DeleteFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
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
                                                "VALUES (@PMSID, 4101, @NOW, @UserID, 0);" +
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
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "False", eventID, "FileID", newFileID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview AddFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static List<TransportationProjectDataLayer.ViewModels.vm_TruckTypes> GetTruckTypes()
        {
            List<TransportationProjectDataLayer.ViewModels.vm_TruckTypes> vm_ttypes = new List<TransportationProjectDataLayer.ViewModels.vm_TruckTypes>();
            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                List<TransportationProjectDataLayer.DomainModels.TruckTypes> tTypes = dProvider.GetTruckTypes();
                vm_ttypes = tTypes.Select<TransportationProjectDataLayer.DomainModels.TruckTypes, TransportationProjectDataLayer.ViewModels.vm_TruckTypes>(x => x).ToList();
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetTruckTypes(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return vm_ttypes;
        }



        public static string GetDayOfWeekID(DateTime selectedDate)
        {

            TimeslotDayOfWeek tsDay = TimeslotDayOfWeek.GetDayOfWeekID(selectedDate);
            return tsDay.DayofWeekShortName;
            
        }
        

        [System.Web.Services.WebMethod]
        public static Object GetTimeslotsData(DateTime selectedDate, string spotType, int? spotID, int MSID, int? PONUM)
        {
            DataSet dataSet = new DataSet();
            List<object[]> data = new List<object[]>();
            List<object[]> headerData = new List<object[]>();
            string selectedDateDOW = GetDayOfWeekID(selectedDate);
            int columncount = 0;
            List<object[]> spotData;//= GetSpotsBasedOnProductsUnderPODetails(spotType, MSID, PONUM);
            String filterOnSpots = string.Empty;

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (spotID == null || -999 == spotID)
                    {
                        if (spotType.ToUpper() == "VAN")
                        {
                            spotData = GetSpotsByType("VAN");
                        }
                        else
                        {
                            spotData = GetSpotsByType("BULK");
                            //Uncomment and use if zxp decides (that for bulk) to change to showing only spots associated to products instead of showing all available spots
                            //GetSpotsBasedOnProductsUnderPODetails(spotType, MSID, PONUM);
                        }
                        for (int i = 0; i < spotData.Count; i++)
                        {
                            if (filterOnSpots == string.Empty)
                            {
                                filterOnSpots = spotData[i][0].ToString();
                            }
                            else
                            {
                                filterOnSpots = filterOnSpots + ", " + spotData[i][0].ToString();
                            }
                        }
                    }

                    if (spotID != -999)
                    {
                        //Count the number of columns
                        sqlCmdText = "SELECT Count(SpotID) FROM (SELECT -999 AS SpotID UNION " +
                                        "SELECT SpotID FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +
                                        "WHERE ST.SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard') AND isDisabled = 0) AS A WHERE SpotID = @SPOTID";
                        columncount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOTTYPE", spotType),
                                                                                                                         new SqlParameter("@SPOTID", spotID)));
                        //Get the header data, 
                        sqlCmdText = "SELECT * FROM (SELECT -999 AS SpotID, '(Other Scheduled Trucks)' AS SpotDescription, 'zed' AS SpotType UNION " +
                        "SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +
                        "WHERE ST.SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard')  AND isDisabled = 0) AS A WHERE SpotID = @SPOTID order by SpotType desc";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOTTYPE", spotType),
                                                                                                      new SqlParameter("@SPOTID", spotID));
                    }
                    else
                    {
                        //Count the number of columns
                        sqlCmdText = "SELECT Count(SpotID) FROM (SELECT -999 AS SpotID UNION " +
                                        "SELECT SpotID FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +
                                        "WHERE ST.SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard') AND isDisabled = 0) AS A ";
                        columncount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOTTYPE", spotType)));
                        //Get the header data, 
                        sqlCmdText = "SELECT * FROM (SELECT -999 AS SpotID, '(Other Scheduled Trucks)' AS SpotDescription, 'zed' AS SpotType UNION " +
                        "SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +
                        "WHERE ST.SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard')  AND isDisabled = 0) AS A order by SpotType desc";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOTTYPE", spotType));
                    }
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        headerData.Add(row.ItemArray);
                    }

                    SqlParameter paramDAY = new SqlParameter("@DAY", SqlDbType.DateTime);
                    SqlParameter paramDOW = new SqlParameter("@DOW", SqlDbType.NVarChar);
                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);

                    paramDAY.Value = selectedDate;
                    paramDOW.Value = selectedDateDOW;
                    paramMSID.Value = MSID;

                    sqlCmdText = "SELECT * FROM (SELECT TDST.SpotID, TDST.FromTime, TDST.ToTime, TDST.isOpen, ST.SpotTypeShort, TDS.isDisabled, TDST.DayOfWeekID, 0 AS isAppointment, TDS.HoursInTimeBlock, NULL AS PONumber " +
                                            "FROM dbo.TruckDockSpotTimeslots TDST " +
                                            "INNER JOIN dbo.TruckDockSpots TDS ON TDST.SpotID = TDS.SpotID " +
                                            "INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +
                                            "UNION " +
                                            "SELECT MS.DockSpotID AS SpotID, ETA AS FromTime, " +
                                                "DATEADD(minute,60*(TDS.HoursInTimeBlock-floor(TDS.HoursInTimeBlock)), DATEADD(hour, floor(TDS.HoursInTimeBlock), ETA)) AS ToTime, " +
                                                "0 AS isOpen, CASE WHEN MS.DockSpotID = -999 THEN @SPOTTYPE ELSE TDS.SpotType END AS SpotTypeShort, MS.isHidden AS isDisabled, " +
                                                "CASE " +
                                                    "WHEN DayNum = 1 THEN 'SU' " +
                                                    "WHEN DayNum = 2 THEN 'M' " +
                                                    "WHEN DayNum = 3 THEN 'T' " +
                                                    "WHEN DayNum = 4 THEN 'W' " +
                                                    "WHEN DayNum = 5 THEN 'TH' " +
                                                    "WHEN DayNum = 6 THEN 'F' " +
                                                    "WHEN DayNum = 7 THEN 'SA' " +
                                                "END AS DayOfWeekID, 1 AS isAppointment, TDS.HoursInTimeBlock, MS.PONumber " +
                                            "FROM dbo.MainSchedule MS " +
                                            "LEFT JOIN TruckDockSpots TDS ON MS.DockSpotID = TDS.SpotID " +
                                            "INNER JOIN (SELECT MSID, datepart(dw,ETA) as DayNum FROM dbo.MainSchedule ) AS A ON A.MSID = MS.MSID " +
                                            "WHERE ETA >= @DAY AND ETA < DateADD(day, 1, @DAY) AND MS.isHidden = 0 AND MS.MSID <> @MSID " +
                                            "UNION " +
                                            "SELECT -999 AS SpotID, '00:00' AS FromTime, '23:59' AS ToTime, 1 AS isOpen, NULL AS SpotTypeShort, 0 AS isDisabled, '@DOW' AS DayOfWeekID, 0 AS isAppointment, 0 AS HoursInTimeBlock, NULL  AS PONumber " +
                                             ") AS ALLDATA ";
                    dataSet = new DataSet();
                    if (spotID != -999)
                    {
                        //show only the chosen spot
                        sqlCmdText = sqlCmdText + " WHERE SpotID = @SPOTID " +
                                                    "AND isDisabled = 0 " +
                                                    "AND DayOfWeekID = @DOW";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOTTYPE", spotType),
                                                                                                      new SqlParameter("@DAY", selectedDate),
                                                                                                      new SqlParameter("@DOW", selectedDateDOW),
                                                                                                      new SqlParameter("@MSID", MSID),
                                                                                                      new SqlParameter("@SPOTID", spotID));
                    }
                    else
                    {

                        if (filterOnSpots != string.Empty) //filter down to spots available based on products
                        {
                            sqlCmdText = sqlCmdText +
                                    " WHERE  (SpotID IN (" + filterOnSpots + ") OR SpotTypeShort IS NULL) " + //  OR SpotTypeShort IN ('Wait','Yard') OR SpotTypeShort IS NULL)" +
                                               "AND isDisabled = 0 " +
                                               "AND DayOfWeekID = @DOW";
                        }
                        else
                        {
                            //default show all
                            sqlCmdText = sqlCmdText + " WHERE (SpotTypeShort IN (@SPOTTYPE, 'Wait','Yard') OR SpotTypeShort IS NULL) " +
                                               "AND isDisabled = 0 " +
                                               "AND DayOfWeekID = @DOW";
                        }
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOTTYPE", spotType),
                                                                                                      new SqlParameter("@DAY", selectedDate),
                                                                                                      new SqlParameter("@DOW", selectedDateDOW),
                                                                                                      new SqlParameter("@MSID", MSID));
                    }
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetTimeslotsData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            List<object> newList = new List<object>();
            newList.Add(columncount);
            newList.Add(headerData);
            newList.Add(data);

            return newList;
        }



        [System.Web.Services.WebMethod]
        public static Object GetSpots()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT -999 AS SpotID, '(None)' AS SpotDescription, NULL AS SpotType UNION " +
                    "(SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots WHERE isDisabled = 0) ORDER BY SpotDescription";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                  
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetSpots(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static List<object[]> GetSpotsByType(string spotType)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT -999 AS SpotID, '(None)' AS SpotDescription, NULL AS SpotType UNION " +
                    "(SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots WHERE SpotType = @STYPE AND isDisabled = 0 ) " +
                     "UNION SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON ST.SpotTypeShort = TDS.SpotType WHERE SpotTypeShort IN ('Yard', 'Wait') " +
                     "ORDER BY SpotDescription";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@STYPE", spotType));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetSpotsByType(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int CheckIfSpotIsAvailable(int spotID)
        {
            int rc = 0;
            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (spotID != -999) //if spotid is -999 then allow
                    {
                        sqlCmdText = "SELECT COUNT(*) FROM dbo.MainSchedule WHERE LocationStatus <> 'GSO' AND (@SPOT = DockSpotID) AND isHidden = 0"; //
                        rc = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SPOT", spotID)));

                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview CheckIfSpotIsAvailable(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return rc;
        }


        [System.Web.Services.WebMethod]
        //public static Object GetTrailerGridData()
        public static Object GetTrailerGridData()
        {

            List<TrailerGridData> tgData = new List<TrailerGridData>();

            try
            {
                TransportationProjectDataProvider dProvider = new TransportationProjectDataProvider();
                tgData = dProvider.GetTrailerGridData();
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetTrailerGridData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return tgData;
        }



        [System.Web.Services.WebMethod]
        public static object CheckIfBulkAndGetProductFromPO(int PONum)
        {
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;
            DataSet dataSet = new DataSet();
            DateTime timestamp = DateTime.Now;
            int productCount = 0;
            bool isBulkProductFound = false;
            int spotID = -999;
            object[] returnData = new object[3];

            try
            {
                
                    bool dataFound = false;
                //Get po details from CMS Server 
                //Retrieve Product Data or Sales Data from CMS
                //Check CMS PO details Table
                //KBOP# -PO num, KBITM# -item number, KBPT - Part num, KBQTYO- Qty ordered, KBQTYR- Qty received, 
                //KBOUNT unit, KBRDAT - required date , KBRDAT - date confirmed, KBISTS - status



                ///////////////////////////////////////


                odbcCmd.CommandText = string.Concat("SELECT isPurchaseOrder FROM( ",
                   "SELECT KAODAT AS OrderDate, 1 as isPurchaseOrder FROM CMSDAT.POH WHERE KAPO# = ? ",
                   "UNION ",
                   "SELECT  DCODAT AS OrderDate , -1 as isPurchaseOrder FROM CMSDAT.OCRH WHERE DCORD# = ? ",
                   ") AS POInfo ",
                   "order by OrderDate DESC ",
                   "fetch first 1 row only");


                odbcCmd.Parameters.Add("POnum1", OdbcType.Numeric).Value = PONum;
                odbcCmd.Parameters.Add("POnum2", OdbcType.Numeric).Value = PONum;

                //OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                //dsAdapter.Fill(dataSet);

                ////populate return object
                //foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                //{
                //    data.Add(row.ItemArray);


                //}
                int isPurchaseOrder = 0;
                object result = odbcCmd.ExecuteScalar();
                result = (result == DBNull.Value) ? null : result;
                isPurchaseOrder = Convert.ToInt32(result); //returns 0 if result == null

                odbcCmd.Parameters.Clear();
                if (1 == isPurchaseOrder)
                {
                    odbcCmd.CommandText = "SELECT KBPO#, KBITM#, KBPT#, KBQTYO, KBQTYR, KBOUNT, KBRDAT, KBCDAT, KBISTS FROM CMSDAT.POI WHERE KBPO# = ? ORDER BY KBPO#, KBITM#";
                    odbcCmd.Parameters.Add("POnum", OdbcType.Numeric).Value = PONum;


                }
                else if (-1 == isPurchaseOrder)
                {

                    //DDORD# -order num, DDITM# -item number, DDPART - Part num, DDQTOI- Qty ordered, DDQTSI- Qty shipped, 
                    //DDUNIT unit, DDRDAT - promised date , DDSDAT - ship date, DDITST - status

                    odbcCmd.CommandText = "SELECT DDORD#, DDITM#, DDPART, DDQTOI, DDQTSI, DDUNIT, DDRDAT, DDSDAT, DDITST FROM CMSDAT.OCRI WHERE DDORD# = ? ORDER BY DDORD#, DDITM#";
                    odbcCmd.Parameters.Add("SalesOrderNum", OdbcType.Numeric).Value = PONum;
                    
                }


                dataSet = new DataSet();
                if (0 != isPurchaseOrder)
                {
                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                    dsAdapter.Fill(dataSet);
                    if (dataSet.Tables[0].Rows.Count > 0)
                    {
                        dataFound = true;
                    }
                }

                /////////////////////////////////////




                string shippedProduct = string.Empty;
                    if (dataFound)
                    {
                        foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                        {
                            productCount = productCount + 1;
                            //Check if contains 17,18,22,23,24,25,26 for Bulk -- All others Van
                            shippedProduct = row.ItemArray[2].ToString();

                            if (shippedProduct.Contains("17") || shippedProduct.Contains("18") || shippedProduct.Contains("22") || shippedProduct.Contains("23") || shippedProduct.Contains("24") || shippedProduct.Contains("25") || shippedProduct.Contains("26"))
                            {
                                isBulkProductFound = true;
                            }
                        }
                    }
                    // retrieve if product has an associated spot based on product and trucktype
                    if (1 == productCount)
                    {
                        if (isBulkProductFound && !string.IsNullOrEmpty(shippedProduct.Trim()))
                        {
                            spotID = GetSpotIDByTypeAndProduct("Bulk", shippedProduct);
                        }
                        else
                        {
                            spotID = GetSpotIDByTypeAndProduct("Van", shippedProduct);
                        }
                    }
                   
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview CheckIfBulkAndGetProductFromPO(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            returnData[0] = productCount;
            returnData[1] = isBulkProductFound;
            returnData[2] = spotID;
            return returnData;
        }

        //---------------------
        [System.Web.Services.WebMethod]
        public static int GetSpotIDByTypeAndProduct(string spotType, string cmsProduct)
        {
            int SpotID = -999; //default to none

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText =
                        "SELECT TOP 1 ISNULL(TDS.SpotID, -999) FROM dbo.TruckDockSpots TDS " +
                        "INNER JOIN dbo.TruckDockSpotsProducts TDSP ON TDSP.SpotID = TDS.SpotID " +
                        "WHERE SpotType = @STYPE  AND ProductID_CMS = @PROD AND TDS.isDisabled = 0 AND TDSP.isDisabled = 0 " +
                        "ORDER BY SpotDescription DESC";

                    SpotID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@STYPE", spotType),
                                                                                                                new SqlParameter("@PROD", cmsProduct)));
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetSpotIDByTypeAndProduct(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }

            return SpotID;
        }

        //COMMENT IF ZXP WANTS TO MAKE SPOT PRODUCT BASED 
        ////TODO Expose the exception to user
        [System.Web.Services.WebMethod]
        public static List<object[]> GetSpotsBasedOnProductsUnderPODetails(string spotType, int MSID, int? PONUM)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();

            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;
            try
            {
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                }

                SqlParameter paramSpotType = new SqlParameter("@STYPE", SqlDbType.NVarChar);
                paramSpotType.Value = spotType;
                sqlCmd.Parameters.Add(paramSpotType);

                if (-1 == MSID)
                {

                    if (PONUM == null)
                    {
                        throw new Exception("Insufficient information. Need a PONUM to retrieve data from CMS");
                    }
                    else
                    {
                        bool dataFound = false;
                        bool isSalesOrder = false;
                        DataSet dsCMSProdData = new DataSet();

                        //dataFound = GetOrderDetailsFromCMS(PONUM.GetValueOrDefault(), ref dsCMSProdData, ref isSalesOrder);
                        dataFound = GetOrderDetailsFromCMS(PONUM.GetValueOrDefault(), ref dsCMSProdData, ref isSalesOrder, odbcCmd);
                        if (dataFound)
                        {
                            string prodDetails = string.Empty;
                            foreach (System.Data.DataRow row in dsCMSProdData.Tables[0].Rows)
                            {
                                if (prodDetails == string.Empty)
                                {
                                    prodDetails = "'" + row[2].ToString() + "'";
                                }
                                else
                                {
                                    prodDetails = prodDetails + ", '" + row[2].ToString() + "'";
                                }
                            }

                            //SqlParameter paramPONumList = new SqlParameter("@POLIST", SqlDbType.NVarChar);
                            //paramPONumList.Value = prodDetails;
                            //sqlCmd.Parameters.Add(paramPONumList);

                            sqlCmd.CommandText = "SELECT -999 AS SpotID, '(None)' AS SpotDescription, NULL AS SpotType UNION " +
                            "SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON ST.SpotTypeShort = " +
                            "TDS.SpotType WHERE SpotTypeShort IN ('Yard', 'Wait') UNION " +
                             "SELECT TDS.SpotID, TDS.SpotDescription, SpotType  FROM dbo.TruckDockSpots TDS " +
                                "INNER JOIN dbo.TruckDockSpotsProducts TDSP ON TDSP.SpotID = TDS.SpotID " +
                                "WHERE SpotType = @STYPE AND TDSP.ProductID_CMS IN (" + prodDetails + ")" +
                                "AND TDS.isDisabled = 0 AND TDSP.isDisabled = 0 ";
                        }
                    }
                }
                else
                {
                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    paramMSID.Value = MSID;
                    sqlCmd.Parameters.Add(paramMSID);

                    sqlCmd.CommandText = "SELECT -999 AS SpotID, '(None)' AS SpotDescription, NULL AS SpotType UNION " +
                        "SELECT SpotID, SpotDescription, SpotType FROM dbo.TruckDockSpots TDS INNER JOIN dbo.SpotType ST ON ST.SpotTypeShort = TDS.SpotType WHERE SpotTypeShort IN ('Yard', 'Wait') UNION " +
                         "SELECT TDS.SpotID, TDS.SpotDescription, SpotType  FROM dbo.TruckDockSpots TDS " +
                            "INNER JOIN dbo.TruckDockSpotsProducts TDSP ON TDSP.SpotID = TDS.SpotID " +
                            "INNER JOIN dbo.PODetails PD ON PD.ProductID_CMS = TDSP.ProductID_CMS " +
                            "INNER JOIN dbo.MainSchedule MS ON MS.MSID= PD.MSID " +
                            "WHERE SpotType = @STYPE AND MS.MSID = @MSID " +
                            "AND TDS.isDisabled = 0 AND TDSP.isDisabled = 0 ";
                }
                sqlCmd.Connection = sqlConn;

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
                string strErr = " SQLException Error in TrailerOverview GetSpotsBasedOnProductsUnderPODetails(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetSpotsBasedOnProductsUnderPODetails(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static bool GetOrderDetailsFromCMS(int POnum, ref DataSet dsLoadData, ref bool isSalesOrder, OdbcCommand odbcCmd)
        {
            //OdbcConnection odbcConn = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Conn;
            //OdbcCommand odbcCmd = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Cmd;
            bool dataFound = false;

            try
            {

                odbcCmd.CommandText = string.Concat("SELECT isPurchaseOrder FROM( ",
                   "SELECT KAODAT AS OrderDate, 1 as isPurchaseOrder FROM CMSDAT.POH WHERE KAPO# = ? ",
                   "UNION ",
                   "SELECT  DCODAT AS OrderDate , -1 as isPurchaseOrder FROM CMSDAT.OCRH WHERE DCORD# = ? ",
                   ") AS POInfo ",
                   "order by OrderDate DESC ",
                   "fetch first 1 row only");


                odbcCmd.Parameters.Add("POnum1", OdbcType.Numeric).Value = POnum;
                odbcCmd.Parameters.Add("POnum2", OdbcType.Numeric).Value = POnum;

                //OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                //dsAdapter.Fill(dataSet);

                ////populate return object
                //foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                //{
                //    data.Add(row.ItemArray);


                //}
                int isPurchaseOrder = 0;
                object result =odbcCmd.ExecuteScalar();
                result = (result == DBNull.Value) ? null : result;
                isPurchaseOrder = Convert.ToInt32(result); //returns 0 if result == null

                odbcCmd.Parameters.Clear();
                if (1 == isPurchaseOrder)
                {
                    odbcCmd.CommandText = "SELECT KBPO#, KBITM#, KBPT#, KBQTYO, KBQTYR, KBOUNT, KBRDAT, KBCDAT, KBISTS FROM CMSDAT.POI WHERE KBPO# = ? ORDER BY KBPO#, KBITM#";
                    odbcCmd.Parameters.Add("POnum", OdbcType.Numeric).Value = POnum;
                   


                }
                else if(-1 == isPurchaseOrder)
                {

                    //DDORD# -order num, DDITM# -item number, DDPART - Part num, DDQTOI- Qty ordered, DDQTSI- Qty shipped, 
                    //DDUNIT unit, DDRDAT - promised date , DDSDAT - ship date, DDITST - status
                    odbcCmd.CommandText = "SELECT DDORD#, DDITM#, DDPART, DDQTOI, DDQTSI, DDUNIT, DDRDAT, DDSDAT, DDITST FROM CMSDAT.OCRI WHERE DDORD# = ? ORDER BY DDORD#, DDITM#";
                    odbcCmd.Parameters.Add("SalesOrderNum", OdbcType.Numeric).Value = POnum;
                    isSalesOrder = true;
                }

                dsLoadData = new DataSet();
                if (0 != isPurchaseOrder) {
                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                    dsAdapter.Fill(dsLoadData);
                    if (dsLoadData.Tables[0].Rows.Count > 0)
                    {
                        dataFound = true;
                    }
                }
                
                

                  
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetOrderDetailsFromCMS(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            finally
            {
                //dont close odbc connection here
                //if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                //{
                //    odbcConn.Close();
                //    odbcConn.Dispose();
                //}
            }
            return dataFound;
        }

        [System.Web.Services.WebMethod]
        public static string GetInternalLoadOutOrderNum(int POnum, OdbcCommand odbcCmd)
        {
           // OdbcConnection odbcConn = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Conn;
            //OdbcCommand odbcCmd = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Cmd;
            string LoadOutOrderNum = string.Empty;

            try
            {
                
                    //Check CMS PO details Table
                    odbcCmd.CommandText = "SELECT DCPO FROM CMSDAT.OCRH WHERE DCORD#  = ?";
                    odbcCmd.Parameters.Add("POnum", OdbcType.Char).Value = POnum;

                    object objOrderNum = odbcCmd.ExecuteScalar();
                    if (null != objOrderNum)
                    {
                        LoadOutOrderNum = objOrderNum.ToString();
                    }
                   
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetInternalLoadOutOrderNum(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            finally
            {
                
            }
            return LoadOutOrderNum;
        }

        [System.Web.Services.WebMethod]
        public static string AddProductToDBIfNonexistent(string productID, OdbcCommand odbcCmd)
        {
            string returnMessage = string.Empty;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(ProductID_CMS) " +
                                        "FROM ProductsCMS " +
                                        "WHERE UPPER(ProductID_CMS) LIKE @PROD";
                    int prodCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PROD", productID)));

                    if (0 == prodCount)
                    { //if not in sql db
                        //get description
                    
                        odbcCmd.CommandText = "SELECT PRODNAME " +
                                                "FROM ( SELECT AVDES1 AS PRODNAME FROM CMSDAT.STKMM  WHERE UPPER(AVPART) = UPPER(?) " +
                                                "UNION SELECT AWDES1 AS PRODNAME FROM CMSDAT.STKMP WHERE UPPER(AWPART) = UPPER(?)) as A " +
                                                "ORDER BY PRODNAME FETCH FIRST 1 ROW ONLY";
                        odbcCmd.Parameters.Clear();
                        odbcCmd.Parameters.Add("@PRODAVPART", OdbcType.Char).Value =  productID;
                        odbcCmd.Parameters.Add("@PRODAWPART", OdbcType.Char).Value = productID;
                        object returnObj = odbcCmd.ExecuteScalar();
                        string prodCMSDescription = returnObj.ToString();

                        //add prodid and description to sql db
                        sqlCmdText = "INSERT INTO ProductsCMS (ProductID_CMS, ProductName_CMS) VALUES (@PROD, @PRODDESC)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PROD", productID), new SqlParameter("@PRODDESC", prodCMSDescription));

                        returnMessage = "Product added to database";
                    }
                    else
                    {
                        returnMessage = "Product already exists. Continue below to edit";
                    }
                    scope.Complete();
                }
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview AddProductToDBIfNonexistent(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TrailerOverview AddProductToDBIfNonexistent(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview AddProductToDBIfNonexistent(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return returnMessage;
        }


        [System.Web.Services.WebMethod]
        public static void InsertNewTruckScheduleData(List<object> rowData)
        {
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;

            DateTime timestamp = DateTime.Now;
            int newMsid;

            try
            {
                //Get PO Details from CMS 
                int PONUM = Convert.ToInt32(rowData[3]);
                DataSet dsLoadData = new DataSet();
                bool isSalesOrder = false;
                bool detailDataFound = GetOrderDetailsFromCMS(PONUM, ref dsLoadData, ref isSalesOrder, odbcCmd);

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                //GET internal ZXP  DCPO FROM CMS
                string ZXPLoadOutPONum = string.Empty;


                if (isSalesOrder)
                {
                    ZXPLoadOutPONum = GetInternalLoadOutOrderNum(PONUM, odbcCmd);
                }

                //Write TO SQL Database
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //if exists, insert zxp Load PO Number 
                    if (!string.IsNullOrEmpty(ZXPLoadOutPONum))
                    {
                        sqlCmdText = "INSERT INTO dbo.MainSchedule (ETA, CustomerID, Comments, PONumber, LoadType, " +
                                                "isDropTrailer, Shipper,  DockSpotID, TruckType, LastUpdated, isHidden, isRejected, TrailerNumber, " +
                                                "LocationShort, StatusID, PONumber_ZXPOutbound, isUrgent, CreatedBy) " +
                                                "VALUES (@ETA, @CUST, @COMM, @PONUM, @LOAD, @DROP, @SHIP, @SPOT, @TRUCKTYPE, @TIME, 0, 0, @TRAIL, @LOC, @STATID, @ZXPPO, @URGENT, @CREATEDBY); " +
                                                "SELECT SCOPE_IDENTITY()";
                        newMsid = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ETA", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0])),
                                                                                                                         new SqlParameter("@CUST", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[1])),
                                                                                                                         new SqlParameter("@COMM", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[2])),
                                                                                                                         new SqlParameter("@PONUM", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[3])),
                                                                                                                         new SqlParameter("@LOAD", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[4])),
                                                                                                                         new SqlParameter("@DROP", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[5])),
                                                                                                                         new SqlParameter("@SHIP", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[6])),
                                                                                                                         new SqlParameter("@SPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[7])),
                                                                                                                         new SqlParameter("@TRUCKTYPE", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[8])),
                                                                                                                         new SqlParameter("@TIME", timestamp),
                                                                                                                         new SqlParameter("@TRAIL", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[9])),
                                                                                                                         new SqlParameter("@LOC", "NOS"),
                                                                                                                         new SqlParameter("@STATID", 1),
                                                                                                                         new SqlParameter("@ZXPPO", ZXPLoadOutPONum),
                                                                                                                         new SqlParameter("@URGENT", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[10])),
                                                                                                                         new SqlParameter("@CREATEDBY", zxpUD._uid)

                                                                                                                         ));
                    }
                    else
                    {
                        sqlCmdText = "INSERT INTO dbo.MainSchedule (ETA, CustomerID, Comments, PONumber, LoadType, " +
                                                "isDropTrailer, Shipper,  DockSpotID, TruckType, LastUpdated, isHidden, isRejected, TrailerNumber, " +
                                                "LocationShort, StatusID, isUrgent, CreatedBy) " +
                                                "VALUES (@ETA, @CUST, @COMM, @PONUM, @LOAD, @DROP, @SHIP, @SPOT, @TRUCKTYPE, @TIME, 0, 0, @TRAIL, @LOC, @STATID, @URGENT, @CREATEDBY); " +
                                                "SELECT SCOPE_IDENTITY()";
                        newMsid = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ETA", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0])),
                                                                                                                         new SqlParameter("@CUST", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[1])),
                                                                                                                         new SqlParameter("@COMM", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[2])),
                                                                                                                         new SqlParameter("@PONUM", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[3])),
                                                                                                                         new SqlParameter("@LOAD", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[4])),
                                                                                                                         new SqlParameter("@DROP", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[5])),
                                                                                                                         new SqlParameter("@SHIP", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[6])),
                                                                                                                         new SqlParameter("@SPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[7])),
                                                                                                                         new SqlParameter("@TRUCKTYPE", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[8])),
                                                                                                                         new SqlParameter("@TIME", timestamp),
                                                                                                                         new SqlParameter("@TRAIL", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[9])),
                                                                                                                         new SqlParameter("@LOC", "NOS"),
                                                                                                                         new SqlParameter("@STATID", 1),
                                                                                                                         new SqlParameter("@URGENT", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[10])),
                                                                                                                         new SqlParameter("@CREATEDBY", zxpUD._uid)
                                                                                                                         ));
                    }
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 1, @TIME, @USER, 'false'); " +
                                        "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", newMsid),
                                                                                                                     new SqlParameter("@TIME", timestamp),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "ETA", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "CustomerID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[1]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "Comments", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[2]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "PONumber", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[3]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "LoadType", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[4]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "isDropTrailer", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[5]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "Shipper", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[6]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "DockSpotID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[7]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "TruckType", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[8]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "LastUpdated", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0", eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "isRejected", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0", eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "TrailerNumber", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[9]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "LocationShort", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NOS", eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "StatusID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, 1.ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "Urgent", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[10]).ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "CreatedBy", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), eventID, "MSID", newMsid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    if (!string.IsNullOrEmpty(ZXPLoadOutPONum))
                    {
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainSchedule", "PONumber_ZXPOutbound", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, ZXPLoadOutPONum.ToString(), eventID, "MSID", newMsid.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }

                    //Populate POdetails

                    if (detailDataFound) // Create PO Details using CMS Detail data found 
                    {
                        foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                        {
                            if (!string.IsNullOrWhiteSpace(row[2].ToString().Trim()))
                            {
                                AddProductToDBIfNonexistent(row[2].ToString(), odbcCmd);
                            }

                            sqlCmdText = "INSERT INTO dbo.PODetails (ProductID_CMS, MSID, QTY, UnitOfMeasure) " +
                                                "VALUES (@PROD, @MSID, @QTY, @UNIT); " +
                                                "SELECT SCOPE_IDENTITY()";
                            int poDetailsID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PROD", row[2]),
                                                                                                                                 new SqlParameter("@MSID", newMsid),
                                                                                                                                 new SqlParameter("@QTY", row[3]),
                                                                                                                                 new SqlParameter("@UNIT", row[5])));

                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PODetails", "ProductID_CMS", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, row[2].ToString(), null, "PODetailsID", poDetailsID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PODetails", "MSID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, newMsid.ToString(), null, "PODetailsID", poDetailsID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PODetails", "QTY", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, row[3].ToString(), null, "PODetailsID", poDetailsID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                            cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PODetails", "UnitOfMeasure", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, row[5].ToString(), null, "PODetailsID", poDetailsID.ToString());
                            cLog.CreateChangeLogEntryIfChanged();
                        }
                    }
                    bool isDrop = bool.Parse(rowData[5].ToString());
                    if (rowData[8].ToString().ToUpper().Trim().Contains("BULK") && isDrop == false)
                    {
                        int loaderTypePerson = 1; //loader
                        int RequestType;
                        if (rowData[4].ToString().ToUpper().Trim().Contains("LOADOUT"))
                        {
                            RequestType = 1; // load
                            CreateRequest(Convert.ToInt32(newMsid), TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[9]).ToString(), "Autorequest: Load truck", null, null, loaderTypePerson, RequestType);//, DateTime DueDateTIme)
                        }
                        else
                        {
                            RequestType = 2; //unload
                            CreateRequest(Convert.ToInt32(newMsid), TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[9]).ToString(), "Autorequest: Unload truck", null, null, loaderTypePerson, RequestType);//, DateTime DueDateTIme)
                        }
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TrailerOverview InsertNewTruckScheduleData(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview InsertNewTruckScheduleData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
        }

        [System.Web.Services.WebMethod]
        public static void CreateRequest(int rMSID, string trailnum, string task, int? assignee, int? newSpotID, int RequestPersonType, int RequestTypeID)//, DateTime DueDateTIme)
        {
            DateTime now = DateTime.Now;
            try
            {
                using (var scope = new TransactionScope())
                {

                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    //------INSERT NEW REQUEST 
                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramTrailNum = new SqlParameter("@TRAILER", SqlDbType.NVarChar);
                    SqlParameter paramTask = new SqlParameter("@TASK", SqlDbType.NVarChar);
                    SqlParameter paramAssignee = new SqlParameter("@ASSIGN", SqlDbType.Int);
                    SqlParameter paramRequester = new SqlParameter("@REQUESTER", SqlDbType.Int);
                    SqlParameter paramNewSpot = new SqlParameter("@NEWSPOT", SqlDbType.Int);
                    SqlParameter paramRPerson = new SqlParameter("@RPERSON", SqlDbType.Int);
                    SqlParameter paramRType = new SqlParameter("@RTYPE", SqlDbType.Int);
                    SqlParameter paramDueDate = new SqlParameter("@DUEDATE", SqlDbType.DateTime);

                    paramMSID.Value = rMSID;
                    paramTrailNum.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(trailnum);
                    paramTask.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(task);
                    paramAssignee.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(assignee);
                    paramRequester.Value = zxpUD._uid;
                    paramNewSpot.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString());
                    paramRPerson.Value = RequestPersonType;
                    paramRType.Value = RequestTypeID;

                    sqlCmdText = "INSERT INTO dbo.Requests (MSID, TrailerNumber, Task, Assignee, Requester, NewSpotID, RequestPersonTypeID, RequestTypeID, isVisible) " + //, RequestDueDateTime
                                    "VALUES (@MSID, @TRAILER, @TASK, @ASSIGN, @REQUESTER, @NEWSPOT, @RPERSON, @RTYPE, 1); " +//, @DUEDATE
                                    "SELECT SCOPE_IDENTITY()";
                    int requestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", rMSID),
                                                                                                                       new SqlParameter("@TRAILER", TransportHelperFunctions.convertStringEmptyToDBNULL(trailnum)),
                                                                                                                       new SqlParameter("@TASK", TransportHelperFunctions.convertStringEmptyToDBNULL(task)),
                                                                                                                       new SqlParameter("@ASSIGN", TransportHelperFunctions.convertStringEmptyToDBNULL(assignee)),
                                                                                                                       new SqlParameter("@REQUESTER", zxpUD._uid),
                                                                                                                       new SqlParameter("@NEWSPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(newSpotID.ToString())),
                                                                                                                       new SqlParameter("@RPERSON", RequestPersonType),
                                                                                                                       new SqlParameter("@RTYPE", RequestTypeID)));
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "MSID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, rMSID.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "TrailerNumber", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, paramTrailNum.Value.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Task", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, paramTask.Value.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Assignee", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, assignee.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "Requester", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, zxpUD._uid.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "NewSpotID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, paramNewSpot.Value.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "RequestPersonTypeID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, RequestPersonType.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "RequestTypeID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, RequestTypeID.ToString(), null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Requests", "isVisible", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "RequestID", requestID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //------log request created into mainscheduleevents table
                    SqlParameter paramTimeStamp = new SqlParameter("@TIME", SqlDbType.DateTime);
                    paramTimeStamp.Value = now;

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
                    //log into mainschedulerequestevents table
                    sqlCmdText = "INSERT INTO dbo.MainScheduleRequestEvents(RequestID, EventID) " +
                                            "VALUES(@RID, @EID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@RID", requestID),
                                                                                         new SqlParameter("@EID", eventID));

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "RequestID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, requestID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleRequestEvents", "EventID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "RequestID", requestID.ToString(), "EventID", eventID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview CreateRequest(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }


        [System.Web.Services.WebMethod]
        public static Object GetPOProductsDataForValidation(int POnum, string strUTC_ETA)
        {
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;
            DateTime ETA = DateTime.Parse(strUTC_ETA);
            DateTime endOfDayOfETA = DateTime.Parse(ETA.AddDays(1).Date.ToString());
            List<object> returnData = new List<object>();

            try
            {
                
                    //Get po details from CMS Server 
                    //Retrieve Product Data or Sales Data from CMS
                    bool dataFound = false;
                    bool isSalesOrder = false; //Loadin == PO Details Load out == Sales Order; 

                    DataSet dsLoadData = new DataSet();
                    dataFound = GetOrderDetailsFromCMS(POnum, ref dsLoadData, ref isSalesOrder, odbcCmd);

                    foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                    {

                        //get product qty on hand from cms
                        string productCMS = row.ItemArray[2].ToString();
                        double qtyFromPONUM = Convert.ToDouble(row.ItemArray[3]);
                        string prodUnit = row.ItemArray[5].ToString();
                        List<object[]> cmsProdData = GetOnHandDataOfCMSProduct(productCMS, odbcConn, odbcCmd);
                        double qtyOrderedUptoETA = GetQtyOrderedOfCMSProductBetween2Dates(productCMS, DateTime.Today, endOfDayOfETA, odbcCmd);
                        double qtyOnHandAmount = 0;
                        double qtyIncomingLoadInOrders = GetQtyFromTruckScheduleByCMSProductBetween2Dates("LOADIN", productCMS, DateTime.Today, endOfDayOfETA);
                        double qtyIncomingLoadOutOrders = GetQtyFromTruckScheduleByCMSProductBetween2Dates("LOADOUT", productCMS, DateTime.Today, endOfDayOfETA);
                        string affectedPOs = GetAffectedFutureOrders(productCMS, ETA);
                        List<object[]> tankProdData = GetTankDataByProduct(productCMS);
                        double qtyInTankAmount = Convert.ToDouble(tankProdData[0][1]);


                        foreach (object[] oQty in cmsProdData)
                        {
                            qtyOnHandAmount = Convert.ToDouble(oQty[0]) + qtyOnHandAmount;
                        }

                        double projectedVolumeUsingCMS;
                        double projectedVolumeUsingTankData;
                        if (isSalesOrder)
                        {
                            projectedVolumeUsingCMS = qtyOnHandAmount + qtyIncomingLoadInOrders - qtyIncomingLoadOutOrders - qtyFromPONUM - qtyOrderedUptoETA;
                            projectedVolumeUsingTankData = qtyInTankAmount + qtyIncomingLoadInOrders - qtyIncomingLoadOutOrders - qtyFromPONUM - qtyOrderedUptoETA;
                        }
                        else
                        {
                            projectedVolumeUsingCMS = qtyOnHandAmount + qtyIncomingLoadInOrders - qtyIncomingLoadOutOrders + qtyFromPONUM - qtyOrderedUptoETA;
                            projectedVolumeUsingTankData = qtyInTankAmount + qtyIncomingLoadInOrders - qtyIncomingLoadOutOrders + qtyFromPONUM - qtyOrderedUptoETA;
                        }

                        List<object> productInfo = new List<object>();
                        productInfo.Add(productCMS);
                        productInfo.Add(isSalesOrder);
                        productInfo.Add(prodUnit);
                        productInfo.Add(qtyFromPONUM);
                        productInfo.Add(qtyOrderedUptoETA);
                        productInfo.Add(qtyIncomingLoadInOrders);
                        productInfo.Add(qtyIncomingLoadOutOrders);
                        productInfo.Add(qtyOnHandAmount);
                        productInfo.Add(projectedVolumeUsingCMS);
                        productInfo.Add(qtyInTankAmount);
                        productInfo.Add(projectedVolumeUsingTankData);
                        productInfo.Add(cmsProdData); //cms detail data including qty amounts in plant 
                        productInfo.Add(tankProdData); //app detail data including qty amounts in tank 
                        productInfo.Add(affectedPOs);

                        returnData.Add(productInfo);
                    }
                   
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetPOProductsDataForValidation(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetPOProductsDataForValidation(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {

                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return returnData;
        }

        // GET Total tanks capacities
        [System.Web.Services.WebMethod]
        public static List<object[]> GetTankDataByProduct(string CmsProduct)
        {
            DataSet dataSet = new DataSet();
            List<object[]> tankData = new List<object[]>();

            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT ISNULL(SUM(TankCapacity),0) AS ttlTankCapacity " +
                                            ",ISNULL(SUM(CurrentTankVolume),0) AS ttlCurrentTankVolume " +
                                            ",COUNT(T.TankID) AS numberOfTanksWithProducts " +
                                            ",ISNULL(MAX(TankProdData.ProdCount),0) AS maxProdCount " +
                                        "FROM dbo.Tanks T " +
                                        "INNER JOIN dbo.TankProducts TP ON TP.TankID = T.TankID " +
                                        "INNER JOIN (SELECT SUB1_T.TankID,  COUNT(SUB1_TP.ProductID_CMS) AS ProdCount " +
                                                        "FROM dbo.Tanks SUB1_T " +
                                                        "INNER JOIN dbo.TankProducts SUB1_TP ON SUB1_T.TankID = SUB1_TP.TankID " +
                                                        "WHERE SUB1_T.isDisabled = 0 AND SUB1_TP.isDisabled = 0 " +
                                                        "GROUP BY SUB1_T.TankID " +
                                                    ") AS TankProdData ON TankProdData.TankID = TP.TankID " +
                                        "WHERE TP.ProductID_CMS = @CMSPROD AND T.isDisabled = 0 AND TP.isDisabled = 0";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", CmsProduct));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        tankData.Add(row.ItemArray);
                    }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetTankDataByProduct(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return tankData;
        }


        [System.Web.Services.WebMethod]
        public static string GetAffectedFutureOrders(string CmsProduct, DateTime StartDate)
        {
            string POList = string.Empty;
            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText =
                                "SELECT STUFF( " +
                                        "(   SELECT  ', ' + CONVERT(NVARCHAR(10), MS.PONumber)  AS [text()]  " +
                                            "FROM dbo.MainSchedule MS " +
                                            "INNER JOIN dbo.PODetails PD ON MS.MSID = PD.MSID " +
                                            "WHERE MS.ETA >= @SDATE AND PD.ProductID_CMS = @CMSPROD AND MS.isHidden = 0 " +
                                            "FOR XML PATH('') " +
                                        "), 1, 1, '')";

                    POList = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SDATE", StartDate),
                                                                                                                 new SqlParameter("@CMSPROD", CmsProduct)));
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetAffectedFutureOrders(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return POList;
        }

        [System.Web.Services.WebMethod]
        public static double GetQtyFromTruckScheduleByCMSProductBetween2Dates(string LoadType, string CmsProduct, DateTime StartDate, DateTime EndDate)
        {
            double totalQty = 0;
            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT ISNULL(SUM(ISNULL(PD.QTY,0)), 0) As prodTotalQty " +
                                    "FROM dbo.MainSchedule MS " +
                                    "INNER JOIN dbo.PODetails PD ON PD.MSID = MS.MSID " +
                                    "WHERE (ETA >= @SDATE AND ETA <= @EDATE) " +
                                    "AND isOpenInCMS = 1 AND MS.LoadType = @LOAD AND ProductID_CMS = @CMSPROD AND isHidden = 0 AND isRejected = 0";

                    totalQty = Convert.ToDouble(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SDATE", StartDate),
                                                                                                                   new SqlParameter("@EDATE", EndDate),
                                                                                                                   new SqlParameter("@CMSPROD", CmsProduct),
                                                                                                                   new SqlParameter("@LOAD", LoadType)));
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetQtyFromTruckScheduleByCMSProductBetween2Dates(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return totalQty;
        }

        //Create a function that checks if volume order is within the limit of what can be in zxp for a given product

        [System.Web.Services.WebMethod]
        public static List<object[]> GetOnHandDataOfCMSProduct(string ProductID_CMS)
        {
            List<object[]> data = new List<object[]>();
            TruckScheduleConfigurationKeysHelper_ODBC odbc_Helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            try
            {
                using (var scope = new TransactionScope())
                {
                    data = GetOnHandDataOfCMSProduct(ProductID_CMS, odbc_Helper.ODBC_Conn, odbc_Helper.ODBC_Cmd);
                    scope.Complete();
                }
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetOnHandDataOfCMSProduct(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetOnHandDataOfCMSProduct(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                if (odbc_Helper.ODBC_Conn != null && odbc_Helper.ODBC_Conn.State != ConnectionState.Closed)
                {
                    odbc_Helper.ODBC_Conn.Close();
                    odbc_Helper.ODBC_Conn.Dispose();
                }
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static List<object[]> GetOnHandDataOfCMSProduct(string ProductID_CMS, OdbcConnection odbcConn, OdbcCommand odbcCmd)
        {
            
            List<object[]> data = new List<object[]>();

            try
            {
                    //Get product qty on hand details from CMS Server 
                    if (odbcConn.State != ConnectionState.Open)
                    {
                        odbcConn.Open();
                    }

                    odbcCmd.Connection = odbcConn;
                    odbcCmd.CommandText = "SELECT SUM(IFNULL(YCQTYH,0)) AS SumQtyOnHand, IFNULL(YCMINQ, 0) AS MinQty, IFNULL(YCMAXQ, 0) AS MaxQty, YCUNIT AS Unit FROM CMSDAT.MRPIX1 " +
                                            "WHERE YCPART = ? " +
                                            "GROUP BY YCMINQ, YCMAXQ, YCUNIT";
                    odbcCmd.Parameters.Add("Product", OdbcType.Char).Value = ProductID_CMS;
                    odbcCmd.CommandType = System.Data.CommandType.Text;

                    DataSet dsLoadData = new DataSet();
                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                    dsAdapter.Fill(dsLoadData);

                    foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in TrailerOverview GetOnHandDataOfCMSProduct(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TrailerOverview GetOnHandDataOfCMSProduct(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetOnHandDataOfCMSProduct(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                //do not close odbc connection in this function
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static double GetQtyOrderedOfCMSProductBetween2Dates(string CmsProduct, DateTime StartDate, DateTime EndDate)
        {
            double returnData = 0;
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            OdbcConnection odbcConn = odbc_helper.ODBC_Conn;
            OdbcCommand odbcCmd = odbc_helper.ODBC_Cmd;

            try
            {
                    returnData = GetQtyOrderedOfCMSProductBetween2Dates(CmsProduct, StartDate, EndDate, odbcCmd);
            }
            catch (OdbcException excep)
            {
                string strErr = string.Concat(" ODBCException Error in TrailerOverview GetQtyOrderedOfCMSProductBetween2Dates",
                                                "(string ProductID_CMS, DateTime StartDate, DateTime EndDate). Details: ",
                                                excep.ToString());
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (Exception ex)
            {
                string strErr = string.Concat(" Exception Error in TrailerOverview GetQtyOrderedOfCMSProductBetween2Dates",
                                                "(string ProductID_CMS, DateTime StartDate, DateTime EndDate). Details: ",
                                                ex.ToString());
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static double GetQtyOrderedOfCMSProductBetween2Dates(string ProductID_CMS, DateTime StartDate, DateTime EndDate, OdbcCommand odbcCmd) //OdbcConnection odbcConn, OdbcCommand odbcCmd)
        {
            //OdbcCommand odbcCmd = new OdbcCommand();
            double returnData = 0;

            try
            {
                
                    odbcCmd.CommandText = "SELECT IFNULL(SUM(IFNULL(DQQTY,0)) , 0) AS OrderQty " +
                                            "FROM CMSDAT.MRPRX2 " +
                                            "WHERE DQPART = ? AND (DQDDAT >= ? AND DQDDAT <=?) ";
                    odbcCmd.Parameters.Clear();
                    odbcCmd.Parameters.Add("Product", OdbcType.Char).Value = ProductID_CMS;
                    odbcCmd.Parameters.Add("SDate", OdbcType.DateTime).Value = StartDate;
                    odbcCmd.Parameters.Add("EDate", OdbcType.DateTime).Value = EndDate;
                    returnData = Convert.ToDouble(odbcCmd.ExecuteScalar());

            }
            catch (OdbcException excep)
            {
                string strErr = string.Concat(" ODBCException Error in TrailerOverview GetQtyOrderedOfCMSProductBetween2Dates",
                                                "(string ProductID_CMS, DateTime StartDate, DateTime EndDate, OdbcConnection odbcConn). Details: ",
                                                excep.ToString());
                ErrorLogging.LogErrorAndRedirect(3, strErr);
            }
            catch (Exception ex)
            {
                string strErr = string.Concat(" Exception Error in TrailerOverview GetQtyOrderedOfCMSProductBetween2Dates",
                                                "(string ProductID_CMS, DateTime StartDate, DateTime EndDate, OdbcConnection odbcConn). Details: ",
                                                ex.ToString());
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
                //Don't close the odbcConn, method calling this function should close it
            }
            return returnData;
        }
        /*-----------------------------------END-----------------------------------------------------*/

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
                string strErr = " Exception Error in TrailerOverview UpdateFileUploadData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static void UpdateTruckSheduleData(List<object> rowData)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (!(Convert.ToInt32(rowData[0]) > 0))
                    {
                        throw new Exception("Invalid MSID given in updateTruckScheduleData.");
                    }
                    //EventTypeID = 2035= Truck Schedule Edited
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 2035, @TIME, @USER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0])),
                                                                                                                     new SqlParameter("@TIME", timestamp),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    //add to change log the updated values 
                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "ETA", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[1]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Comments", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[2]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LoadType", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[3]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isDropTrailer", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[4]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "Shipper", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[5]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "DockSpotID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[6]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "TruckType", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[7]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isUrgent", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[8]).ToString(), eventID, "MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0]).ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET ETA=@ETA, Comments=@COMM, LoadType=@LOAD, isDropTrailer=@DROP, Shipper=@SHIP, DockSpotID=@SPOT, " +
                                        "TruckType=@TRUCKTYPE, isUrgent = @Urgent " +
                                        "WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ETA", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[1])),
                                                                                         new SqlParameter("@COMM", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[2])),
                                                                                         new SqlParameter("@LOAD", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[3])),
                                                                                         new SqlParameter("@DROP", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[4])),
                                                                                         new SqlParameter("@SHIP", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[5])),
                                                                                         new SqlParameter("@SPOT", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[6])),
                                                                                         new SqlParameter("@TRUCKTYPE", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[7])),
                                                                                         new SqlParameter("@MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[0])),
                                                                                         new SqlParameter("@Urgent", TransportHelperFunctions.convertStringEmptyToDBNULL(rowData[8])));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview UpdateTruckSheduleData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
        }

        [System.Web.Services.WebMethod]
        public static int GetUserIDOfScheduleCreator(int msid)
        {
            int userID = 0;
            try
            {
               
                    if (!(msid > 0))
                    {
                        throw new Exception("Invalid MSID given in updateTruckScheduleData.");
                    }
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    
                    sqlCmdText = "SELECT UserId FROM dbo.MainScheduleEvents WHERE EventTypeID = 1  AND MSID = @MSID AND isHidden = 0"; //eventtypeID == 1 -> schedule created
                    userID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", msid)));
               
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetUserIDOfScheduleCreator(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return userID;
        }

        [System.Web.Services.WebMethod]
        public static List<object> IsUserAllowedToDeleteSchedule(int msid)
        {
            bool isAllowed = false;
            string outputMsg = string.Empty;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                //1) get user who created schedule
                int schedCreator = GetUserIDOfScheduleCreator(msid);

                //2) check if logged in user is the same as schedule creator
                bool isSameUser = (schedCreator == zxpUD._uid);

                isAllowed = (zxpUD._isAdmin || (isSameUser && zxpUD.CanUserCRUDSchedules())) ? true : false; //check if admin or is the user who created the schedule
                if (!isAllowed)
                {
                    outputMsg = "You do not have permission to delete a schedule you did not create. Please see a truck scheduler admin to continue deleting this schedule.";
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TrailerOverview IsUserAllowedToDeleteSchedule(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview IsUserAllowedToDeleteSchedule(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {

            }
            List<object> outputData = new List<object>();
            outputData.Add(isAllowed);
            outputData.Add(outputMsg);

            return outputData;
        }



        [System.Web.Services.WebMethod]
        public static void DeleteTruckScheduleData(int msid)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {

                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (!(msid > 0))
                    {
                        throw new Exception("Invalid MSID given in updateTruckScheduleData.");
                    }

                    //EventTypeID = 2035= Truck Schedule Edited
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                "VALUES (@MSID, 2035, @TIME, @USER, 'false'); " +
                                "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", msid),
                                                                                                                     new SqlParameter("@TIME", timestamp),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));


                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isHidden", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", eventID, "MSID", msid.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET isHidden = 1 WHERE MSID = @MSID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", msid));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview DeleteTruckScheduleData(). Details: " + ex.ToString();
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
                string strErr = " Exception Error in TrailerOverview ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return null;
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
                string strErr = " SQLException Error in TrailerOverview GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in TrailerOverview GetLogList(). Details: " + excep.ToString();
                ErrorLogging.LogErrorAndRedirect(2, strErr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview GetLogList(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            finally
            {
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static bool CheckIfCheckedIn(int MSID)
        {
            DateTime checkInTime;
            bool hasCheckedIn = false;
            DateTime dateComparer = new DateTime(1900, 1, 1, 0, 0, 0);

            try
            {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT ISNULL(TimeArrived, 1/1/1900) FROM dbo.MainSchedule where MSID = @MSID";

                    checkInTime = Convert.ToDateTime(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (checkInTime.Date == dateComparer)
                    {
                        hasCheckedIn = false;
                    }
                    else
                    {
                        hasCheckedIn = true;
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview CheckIfCheckedIn(). Details: " + ex.ToString();
                ErrorLogging.LogErrorAndRedirect(1, strErr);
            }
            return hasCheckedIn;
        }
    }
}