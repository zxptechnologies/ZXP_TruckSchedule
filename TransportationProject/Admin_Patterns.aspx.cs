using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Transactions;
using System.Web;


namespace TransportationProject.AdminSubPages
{
    public partial class Admin_Patterns : System.Web.UI.Page
    {
        protected static String sql_connStr;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                //if (null != cookie && !string.IsNullOrEmpty(cookie.Value))

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (zxpUD._uid != new ZXPUserData()._uid)
                {

                    //ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    if (zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
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
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false);//zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Patterns Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Patterns Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getPatternGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT PAT.PatternID, PAT.PatternName, PAT.FilePath, PAT.FileNameOld, PAT.FileNameNew " +
                        "FROM dbo.Patterns as PAT " +
                        "WHERE PAT.isHidden = 'false' ";
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
                string strErr = " Exception Error in Admin_Patterns GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void updatePatternName(int PATTERNID, string PATTERNNAME)
        {
            int rowCount;
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Patterns " +
                                                "WHERE PatternName = @PatternName AND isHidden = 'false' AND PatternID != @PatternID";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PatternName", PATTERNNAME),
                                                                                                                  new SqlParameter("@PatternID", PATTERNID)));
                    if (rowCount <= 0)
                    {
                        ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Patterns", "PatternName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, PATTERNNAME.ToString(), null, "PatternID", PATTERNID.ToString());
                        cl.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.Patterns SET PatternName = @PatternName WHERE PatternID = @PatternID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PatternName", PATTERNNAME),
                                                                                             new SqlParameter("@PatternID", PATTERNID));
                    }
                    else
                    {
                        throw new Exception("Pattern name already exist");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Patterns updatePatternName(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void disablePattern(int PATTERNID)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Patterns", "isHidden", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "PatternID", PATTERNID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Patterns " +
                        "SET isHidden = 'true' WHERE PatternID = @PatternID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PatternID", PATTERNID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Patterns disablePattern(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        public static String getTimestamp(DateTime value)
        {
            return value.ToString("yyyyMMddHHmmssffff");
        }

        public static string[] renameAndMoveFile(string filename)
        {
            string[] pathObj = new string[3];
            string filepath = ConfigurationManager.AppSettings["fileUploadPath"];

            filepath = filepath.Replace("~/", string.Empty).Replace('/', '\\');
            filename = filename.Replace("~/", string.Empty).Replace('/', '\\');

            string newFilePath = string.Empty;
            string newFilename = Path.GetFileNameWithoutExtension(filename) + TransportHelperFunctions.getTimestamp(DateTime.UtcNow) + Path.GetExtension(filename);

            if (File.Exists(HttpRuntime.AppDomainAppPath + filepath + filename))
            {
                newFilePath = filepath + ConfigurationManager.AppSettings["PatternsPath"];

                newFilePath = newFilePath.Replace("~/", "").Replace('/', '\\');
                newFilename = newFilename.Replace("~/", "").Replace('/', '\\');

                File.Move(HttpRuntime.AppDomainAppPath + filepath + filename, HttpRuntime.AppDomainAppPath + newFilePath + newFilename);
                ErrorLogging.WriteEvent(HttpRuntime.AppDomainAppPath + filepath + filename, EventLogEntryType.Information);
                ErrorLogging.WriteEvent(HttpRuntime.AppDomainAppPath + newFilePath + newFilename, EventLogEntryType.Information);

                pathObj[0] = filename;
                pathObj[1] = newFilename;
                pathObj[2] = HttpRuntime.AppDomainAppPath + newFilePath;
            }
            return pathObj;
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
                string strErr = " Exception Error in Admin_Patterns ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

            return null;
        }

        [System.Web.Services.WebMethod]
        public static Object setNewPatternAndProcessFile(string PATTERNNAME, string FILENAME)
        {
            Int32 patternID = 0;
            List<string> data = new List<string>();
            Int32 rowCount;
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string[] newFileAndPath = TransportHelperFunctions.ProcessFileAndData(FILENAME, "PATTERN");

                if (2 == newFileAndPath.Length)
                {
                    using (var scope = new TransactionScope())
                    {
                        string sqlCmdText;
                        //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                        sqlCmdText = "SELECT COUNT (*) FROM dbo.Patterns " +
                                                "WHERE PatternName = @PatternName AND isHidden = 'false'";
                        rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PatternName", PATTERNNAME)));

                        if (rowCount <= 0)
                        {
                            sqlCmdText = "INSERT INTO dbo.Patterns (FileNameOld, FileNameNew, FilePath, PatternName, isHidden) VALUES (@FileNameOld, @FileNameNew, @FilePath, @PatternName, 'false'); " +
                                                "SELECT CAST(scope_identity() AS int)";

                            patternID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FileNameOld", FILENAME),
                                                                                                                           new SqlParameter("@FileNameNew", newFileAndPath[1]),
                                                                                                                           new SqlParameter("@FilePath", newFileAndPath[0]),
                                                                                                                           new SqlParameter("@PatternName", PATTERNNAME)));

                            ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "isHidden", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "PatternID", patternID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "FileNameOld", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FILENAME.ToString(), null, "PatternID", patternID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "FileNameNew", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, newFileAndPath[1].ToString(), null, "PatternID", patternID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "PatternName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, PATTERNNAME.ToString(), null, "PatternID", patternID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "FilePath", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, PATTERNNAME.ToString(), null, "PatternID", patternID.ToString());
                            cl.CreateChangeLogEntryIfChanged();

                            data.Add(patternID.ToString());
                            data.Add(newFileAndPath[0]);
                            data.Add(newFileAndPath[1]);
                        }
                        else
                        {
                            throw new Exception("Pattern name already exist");
                        }
                        scope.Complete();
                    }

                }
                else
                {
                    throw new Exception("renameAndMoveFile returned null or empty string");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Patterns setNewPatternAndProcessFile(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void updatePatternAndProcessFile(int PATTERNID, string FILENAME)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string[] newFileAndPath = TransportHelperFunctions.ProcessFileAndData(FILENAME, "PATTERN");

                if (2 == newFileAndPath.Length)
                {
                    using (var scope = new TransactionScope())
                    {
                        string sqlCmdText;
                        //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                        string filepath = ConfigurationManager.AppSettings["fileUploadPath"];
                        string newFilePath = string.Empty;
                        newFilePath = filepath + ConfigurationManager.AppSettings["PATTERNPATH"];
                        newFilePath = newFilePath.Replace("~/", "").Replace('/', '\\');

                        ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Patterns", "FileNameOld", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FILENAME.ToString(), null, "PatternID", PATTERNID.ToString());
                        cl.CreateChangeLogEntryIfChanged();
                        cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Patterns", "FileNameNew", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, newFileAndPath[1].ToString(), null, "PatternID", PATTERNID.ToString());
                        cl.CreateChangeLogEntryIfChanged();
                        cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Patterns", "FilePath", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, newFileAndPath[0].ToString(), null, "PatternID", PATTERNID.ToString());
                        cl.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.Patterns " +
                                                "SET FileNameOld = @FileNameOld, FileNameNew = @FileNameNew, FilePath = @FilePath " +
                                                "WHERE PatternID = @PatternID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FileNameOld", FILENAME),
                                                                                             new SqlParameter("@FileNameNew", newFileAndPath[1]),
                                                                                             new SqlParameter("@FilePath", newFileAndPath[0]),
                                                                                             new SqlParameter("@PatternID", PATTERNID));
                        scope.Complete();
                    }

                }
                else
                {
                    throw new Exception("renameAndMoveFile returned null or empty string");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Patterns updatePatternAndProcessFile(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        public static int insertPatternToDBEntry(string FILENAMEOLD, string FILENAMENEW, string FILEPATH, string PATTERNNAME)
        {
            Int32 patternID = 0;
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.Patterns (FileNameOld, FileNameNew, FilePath, PatternName, isHidden) VALUES (@FileNameOld, @FileNameNew, @FilePath, @PatternName, 'false'); " +
                                        "SELECT CAST(scope_identity() AS int)";
                    patternID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@FileNameOld", FILENAMEOLD),
                                                                                                                  new SqlParameter("@FileNameNew", FILENAMENEW),
                                                                                                                  new SqlParameter("@FilePath", FILEPATH),
                                                                                                                  new SqlParameter("@PatternName", PATTERNNAME)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "FileNameOld", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FILENAMEOLD.ToString(), null, "PatternID", patternID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "FileNameNew", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FILENAMENEW.ToString(), null, "PatternID", patternID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "FilePath", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FILEPATH.ToString(), null, "PatternID", patternID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "PatternName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, PATTERNNAME.ToString(), null, "PatternID", patternID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Patterns", "isHidden", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "'false'", null, "PatternID", patternID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Patterns insertPatternToDBEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return patternID;
        }
    }
}