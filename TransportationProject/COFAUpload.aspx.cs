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
    public partial class COFAUpload : System.Web.UI.Page
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

                    if (zxpUD._isGuard || zxpUD._isLabAdmin || zxpUD._isLabPersonnel || zxpUD._isAccountManager || zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
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
                        Response.Redirect("/ErrorPage.aspx?ErrorCode=5", false);
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("/Account/Login.aspx?ReturnURL=/COFAUpload.aspx", false); //zxp live
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in COFAUpload Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //sqlCmdText = "SELECT PD.PODetailsID, S.SampleID, MS.MSID, MS.PONumber, MS.TrailerNumber, PD.ProductID_CMS, " +
                    //                    "MSF.FileID, MSF.Filepath, MSF.FilenameOld, MSF.FilenameNew, " +
                    //                    "S.COFAComment, MS.isOpenInCMS, MS.isRejected, PCMS.ProductName_CMS " +
                    //                    "FROM dbo.MainSchedule MS " +
                    //                    "INNER JOIN dbo.PODetails PD ON MS.MSID = PD.MSID " +
                    //                    "INNER JOIN dbo.Samples S ON S.PODetailsID = PD.PODetailsID " +
                    //                    "LEFT JOIN dbo.MainScheduleFiles MSF ON MSF.MSID = MS.MSID AND S.FileID_COFA = MSF.FileID " +
                    //                    "INNER JOIN dbo.ProductsCMS AS PCMS ON PD.ProductID_CMS = PCMS.ProductID_CMS " +
                    //                    "WHERE S.isHidden = 0 AND MS.isHidden = 0 AND MS.isOpenInCMS = 'true' AND S.TestApproved IS NULL AND S.bypassApproverUserID IS NULL " +
                    //                    "ORDER BY S.FileID_COFA, S.bypassApproverUserID, MS.PONumber, S.SampleID";
                    sqlCmdText = string.Concat("SELECT PODetailsID, SampleID, MSID, PONumber, TrailerNumber, ProductID_CMS ",
                        ", FileID, Filepath, FilenameOld, FilenameNew, COFAComment ",
                        ", isOpenInCMS, isRejected, ProductName_CMS ",
                        "FROM dbo.vw_COFAUploadGridData ",
                        "ORDER BY FileID_COFA, bypassApproverUserID, PONumber, SampleID");

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
                string strErr = " Exception Error in COFAUpload getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void DeleteFileDBEntry(int SampleID, int MSID)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@MSID, 4098, @TSTAMP, @UserID, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TSTAMP", now),
                                                                                                                     new SqlParameter("@UserID", zxpUD._uid)));
                    
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "FileID_COFA", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, null, eventID, "SampleID", SampleID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET FileID_COFA = NULL, COFAEventID = NULL WHERE SampleID = @SampleID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SampleID", SampleID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload DeleteFileDBEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
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
                string strErr = " Exception Error in COFAUpload ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return null;
        }

        [System.Web.Services.WebMethod]
        public static void AddFileDBEntry(int MSID, string fileType, string filenameOld, string filenameNew, string filepath, string fileDescription, int SampleID)
        {
            DateTime now = DateTime.Now;
            int eventID = 0;
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

                    //1. create event in Main Schedule Events
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID, TimeStamp, UserID, isHidden) VALUES (@PMSID, 4097, @TSTAMP, @UserID, 'false'); " +
                                                "SELECT CAST(scope_identity() AS int)";
                    eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                 new SqlParameter("@TSTAMP", now),
                                                                                                                 new SqlParameter("@UserID", zxpUD._uid)));
                    //2. create file data in Main Schedule Files
                    sqlCmdText = "INSERT INTO dbo.MainScheduleFiles (MSID, FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld, isHidden) " +
                                        "VALUES (@PMSID, @PFTID, @PDESC, @PFPATH, @PFNEW, @PFOLD, 0);" +
                                        "SELECT SCOPE_IDENTITY()";
                    int newFileID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PMSID", MSID),
                                                                                                                       new SqlParameter("@PFTID", filetypeID),
                                                                                                                       new SqlParameter("@PDESC", fileDescription),
                                                                                                                       new SqlParameter("@PFPATH", filepath),
                                                                                                                       new SqlParameter("@PFNEW", filenameNew),
                                                                                                                       new SqlParameter("@PFOLD", filenameOld)));
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "MSID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, MSID.ToString(), eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FileTyepID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, filetypeID.ToString(), eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FileDescription", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, fileDescription.ToString(), eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "Filepath", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filepath.ToString(), eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FilenameNew", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filenameNew.ToString(), eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "FilenameOld", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, filenameOld.ToString(), eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "MainScheduleFiles", "isHidden", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0", eventID, "FileID", newFileID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //3.Update LastUpdated in MainSchedule
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), eventID, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TSTAMP WHERE (MSID = @PMSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TSTAMP", now),
                                                                                         new SqlParameter("@PMSID", MSID));
                    //4. update samples tbl
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "FileID_COFA", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, newFileID.ToString(), eventID, "SampleID", SampleID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET FileID_COFA = @FID, COFAEventID = @eventID WHERE SampleID = @SampleID; ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FID", newFileID),
                                                                                         new SqlParameter("@eventID", eventID),
                                                                                         new SqlParameter("@SampleID", SampleID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload AddFileDBEntry(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in COFAUpload GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in COFAUpload GetLogList(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload GetLogList(). Details: " + ex.ToString();
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
        public static void setCOFAComment(int SAMPLEID, string COMMENT)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Samples", "COFAComment", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, COMMENT, null, "SampleID", SAMPLEID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Samples SET COFAComment = @COFAComment " +
                                    "WHERE (SampleID = @SampleID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@COFAComment", COMMENT),
                                                                                         new SqlParameter("@SampleID", SAMPLEID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload setCOFAComment(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }


        [System.Web.Services.WebMethod]
        public static Object checkIfCOFAcanBeDeleted(int MSID, int SampleID)
        {
            List<string> returnValue = new List<string>();
            bool isHidden;
            string testStatus;
            string location;
            int COFA_File;
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT S.isHidden, ISNULL(FileID_COFA, 0) AS FileID_COFA, \"testStatus\" = " +
                                                "CASE S.TestApproved " +
                                                "WHEN 'true' THEN 'approved' " +
                                                "WHEN 'false' THEN 'rejected' " +
                                                "ELSE 'incomplete' " +
                                                "END " +
                                         "FROM dbo.Samples AS S " +
                                         "WHERE S.SampleID = @sampleID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@sampleID", SampleID));

                    isHidden = Convert.ToBoolean(dataSet.Tables[0].Rows[0]["isHidden"]);
                    testStatus = Convert.ToString(dataSet.Tables[0].Rows[0]["testStatus"]);
                    COFA_File = Convert.ToInt32(dataSet.Tables[0].Rows[0]["FileID_COFA"]);

                    if (isHidden == true)
                    {
                        returnValue.Add("false");
                        returnValue.Add("This sample no longer exist. Please refresh the page to get the current list of samples.");
                        return returnValue;
                    }
                    if (testStatus != "incomplete")
                    {
                        returnValue.Add("false");
                        returnValue.Add("Sample has been " + testStatus + " and its COFA can not be deleted. You can reupload the COFA to replace the current file.");
                        return returnValue;
                    }
                    if (COFA_File == 0)
                    {
                        returnValue.Add("false");
                        returnValue.Add("COFA has already been deleted. Please refresh the page to get latest data.");
                        return returnValue;
                    }

                    sqlCmdText = "SELECT LocationShort from dbo.MainSchedule as MS WHERE MSID = @MSID";
                    location = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID)));

                    if (location == "NOS")
                    {
                        returnValue.Add("false");
                        returnValue.Add("This order is no longer on site and can not be updated. Please refresh the page to get latest data.");
                    }
                    returnValue.Add("true");
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in COFAUpload getAvailableDockSpots(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnValue;
        }
    }
}