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

namespace TransportationProject.AdminSubPages
{
    public partial class Admin_Users : System.Web.UI.Page
    {
     

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (zxpUD._uid != new ZXPUserData()._uid)
                {

                    if (!zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
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
                string strErr = " SQLException Error in Admin_Users Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Users Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getCellularProvider()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT CellProviderID, CellProviderName FROM dbo.CellPhoneProviders";

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
                string strErr = " Exception Error in Admin_Users getCellularProvider(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getUsersGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT UserID, UserName, FirstName, LastName, EmailAddress, Phone, CellProviderID, isAdmin, isDockManager," +
                                    "isInspector, isGuard, isLabPersonel, isLoader, isYardMule, canViewReports, isLabAdmin, isAccountManager FROM dbo.Users WHERE isDisabled = 'false' ";//order by FirstName, LastName";
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
                string strErr = " Exception Error in Admin_Users getUsersGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int setNewUser(string USERNAME, string FIRSTNAME, string LASTNAME, string EMAIL, string CELLPHONENUMBER, int? CELLPHONEPROVIDER, bool ADMIN, bool DOCKMANAGER, bool INSPECTOR, bool GUARD, bool LABPERSONEL, bool LOADER, bool YARDMULE, bool LABADMIN, bool REPORTER, bool ACCTMANAGER)
        {
            Int32 userID = 0;
            bool DISABLED = false;
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                   
                        if (CELLPHONENUMBER == null && CELLPHONEPROVIDER == null)
                        {
                            sqlCmdText = "INSERT INTO dbo.Users ( UserName, FirstName, LastName, EmailAddress, Password, isAdmin, isDockManager, isInspector, isGuard, isLabPersonel, isLoader, isYardMule, canViewReports, isLabAdmin, isAccountManager, isDisabled ) " +
                                "values (@UserName, @FirstName, @LastName, @EmailAddress, @Password, @isAdmin, @isDockManager, @isInspector, @isGuard, @isLabPersonel, @isLoader, @isYardMule, @canViewReports, @isLabAdmin, @isAccountManager, @isDisabled); " +
                                "SELECT CAST(scope_identity() AS int)";
                            userID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UserName", USERNAME),
                                                                                                                        new SqlParameter("@FirstName", FIRSTNAME),
                                                                                                                        new SqlParameter("@LastName", LASTNAME),
                                                                                                                        new SqlParameter("@EmailAddress", EMAIL),
                                                                                                                        new SqlParameter("@Password", DataTransformer.PasswordHash("ZXPpassword1!")),
                                                                                                                        new SqlParameter("@isAdmin", ADMIN),
                                                                                                                        new SqlParameter("@isDockManager", DOCKMANAGER),
                                                                                                                        new SqlParameter("@isInspector", INSPECTOR),
                                                                                                                        new SqlParameter("@isGuard", GUARD),
                                                                                                                        new SqlParameter("@isLabPersonel", LABPERSONEL),
                                                                                                                        new SqlParameter("@isLoader", LOADER),
                                                                                                                        new SqlParameter("@isYardMule", YARDMULE),
                                                                                                                        new SqlParameter("@canViewReports", REPORTER),
                                                                                                                        new SqlParameter("@isLabAdmin", LABADMIN),
                                                                                                                        new SqlParameter("@isAccountManager", ACCTMANAGER),
                                                                                                                        new SqlParameter("@isDisabled", DISABLED)));

                            ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "UserName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, USERNAME.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "FirstName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FIRSTNAME.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "LastName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, LASTNAME.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "EmailAddress", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, EMAIL.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "Password", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, DataTransformer.PasswordHash("ZXPpassword1!").ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ADMIN.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isDockManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, DOCKMANAGER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isInspector", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, INSPECTOR.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isGuard", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, GUARD.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isLabPersonel", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABPERSONEL.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isLoader", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LOADER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isYardMule", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, YARDMULE.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "canViewReports", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, REPORTER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isLabAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABADMIN.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isAccountManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ACCTMANAGER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, DISABLED.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                        }
                        else if (CELLPHONEPROVIDER != null && CELLPHONENUMBER != null)
                        {
                            sqlCmdText = "INSERT INTO dbo.Users ( UserName, FirstName, LastName, EmailAddress, Password, Phone, CellProviderID, isAdmin, isDockManager, isInspector, isGuard, isLabPersonel, isLoader, isYardMule, canViewReports, isLabAdmin, isAccountManager, isDisabled ) " +
                                "values (@UserName, @FirstName, @LastName, @EmailAddress, @Password, @Phone, @CellProviderID, @isAdmin, @isDockManager, @isInspector, @isGuard, @isLabPersonel, @isLoader, @isYardMule, @canViewReports, @isLabAdmin, @isAccountManager, @isDisabled); " +
                                "SELECT CAST(scope_identity() AS int)";
                            userID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UserName", USERNAME),
                                                                                                                        new SqlParameter("@FirstName", FIRSTNAME),
                                                                                                                        new SqlParameter("@LastName", LASTNAME),
                                                                                                                        new SqlParameter("@EmailAddress", EMAIL),
                                                                                                                        new SqlParameter("@Password", DataTransformer.PasswordHash("ZXPpassword1!")),
                                                                                                                        new SqlParameter("@Phone", CELLPHONENUMBER),
                                                                                                                        new SqlParameter("@CellProviderID", CELLPHONEPROVIDER),
                                                                                                                        new SqlParameter("@isAdmin", ADMIN),
                                                                                                                        new SqlParameter("@isDockManager", DOCKMANAGER),
                                                                                                                        new SqlParameter("@isInspector", INSPECTOR),
                                                                                                                        new SqlParameter("@isGuard", GUARD),
                                                                                                                        new SqlParameter("@isLabPersonel", LABPERSONEL),
                                                                                                                        new SqlParameter("@isLoader", LOADER),
                                                                                                                        new SqlParameter("@isYardMule", YARDMULE),
                                                                                                                        new SqlParameter("@canViewReports", REPORTER),
                                                                                                                        new SqlParameter("@isLabAdmin", LABADMIN),
                                                                                                                        new SqlParameter("@isAccountManager", ACCTMANAGER),
                                                                                                                        new SqlParameter("@isDisabled", DISABLED)));

                            ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "UserName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, USERNAME.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "FirstName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FIRSTNAME.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "LastName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, LASTNAME.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "EmailAddress", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, EMAIL.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "Password", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, DataTransformer.PasswordHash("ZXPpassword1!").ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "Phone", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, CELLPHONENUMBER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "CellProviderID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, CELLPHONEPROVIDER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ADMIN.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isDockManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, DOCKMANAGER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isInspector", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, INSPECTOR.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isGuard", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, GUARD.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isLabPersonel", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABPERSONEL.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isLoader", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LOADER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isYardMule", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, YARDMULE.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "canViewReports", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, REPORTER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isLabAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABADMIN.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isAccountManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ACCTMANAGER.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, DISABLED.ToString(), null, "UserID", userID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                        }
                        else if (CELLPHONEPROVIDER == null && CELLPHONENUMBER != null)
                        {
                            throw new Exception("Trying to add a cell phone provider without a cell phone number to a user.");
                        }
                        else if (CELLPHONEPROVIDER != null && CELLPHONENUMBER == null)
                        {
                            throw new Exception("Trying to add a cell phone number without a cell phone provider to a user.");
                        }
                    else
                    {
                        throw new Exception("Username already exists");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Users setNewUser(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return userID;
        }

        [System.Web.Services.WebMethod]
        public static void disableUser(int USERID)
        {
            string PASSWORD = DataTransformer.PasswordHash("D3l3t3dUs3r!_AJ_CL");
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "UserID", USERID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "Password", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, PASSWORD.ToString(), null, "UserID", USERID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Users " +
                                 "SET isDisabled = 'true', Password = @Password " +
                                 "WHERE UserID = @UserID ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Password", PASSWORD),
                                                                                         new SqlParameter("@UserID", USERID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Users disableUser(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updateUser(int USERID, string USERNAME, string FIRSTNAME, string LASTNAME, string EMAIL, string CELLPHONENUMBER, int? CELLPHONEPROVIDER, bool ADMIN, bool DOCKMANAGER, bool INSPECTOR, bool GUARD, bool LABPERSONEL, bool LOADER, bool YARDMULE, bool LABADMIN, bool REPORTER, bool ACCTMANAGER)
        {
           
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;

                        if (CELLPHONENUMBER == null && CELLPHONEPROVIDER == null)
                        {
                            ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "UserName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, USERNAME.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "FirstName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FIRSTNAME.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "LastName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, LASTNAME.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "EmailAddress", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, EMAIL.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ADMIN.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isDockManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, DOCKMANAGER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isInspector", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, INSPECTOR.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isGuard", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, GUARD.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isLabPersonel", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABPERSONEL.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isLoader", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LOADER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isYardMule", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, YARDMULE.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "canViewReports", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, REPORTER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isLabAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABADMIN.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isAccountManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ACCTMANAGER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "Phone", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "NULL", null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "CellProviderID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "NULL", null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();

                            sqlCmdText = "UPDATE dbo.Users SET UserName = @UserName, FirstName = @FirstName, LastName = @LastName, EmailAddress = @EmailAddress, isAdmin = @isAdmin, isDockManager = @isDockManager, isInspector = @isInspector, " +
                                                    "isGuard = @isGuard, isLabPersonel = @isLabPersonel, isLoader = @isLoader, isYardMule = @isYardMule, isLabAdmin = @isLabAdmin, canViewReports = @canViewReports, isAccountManager = @isAccountManager, " +
                                                    "Phone = null, CellProviderID = null WHERE UserID = @UserID";
                            SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UserName", USERNAME),
                                                                                               new SqlParameter("@FirstName", FIRSTNAME),
                                                                                               new SqlParameter("@LastName", LASTNAME),
                                                                                               new SqlParameter("@EmailAddress", EMAIL),
                                                                                               new SqlParameter("@Password", DataTransformer.PasswordHash("ZXPpassword1!")),
                                                                                               new SqlParameter("@isAdmin", ADMIN),
                                                                                               new SqlParameter("@isDockManager", DOCKMANAGER),
                                                                                               new SqlParameter("@isInspector", INSPECTOR),
                                                                                               new SqlParameter("@isGuard", GUARD),
                                                                                               new SqlParameter("@isLabPersonel", LABPERSONEL),
                                                                                               new SqlParameter("@isLoader", LOADER),
                                                                                               new SqlParameter("@isYardMule", YARDMULE),
                                                                                               new SqlParameter("@canViewReports", REPORTER),
                                                                                               new SqlParameter("@isLabAdmin", LABADMIN),
                                                                                               new SqlParameter("@isAccountManager", ACCTMANAGER),
                                                                                               new SqlParameter("@UserID", USERID));
                        }
                        else if (CELLPHONEPROVIDER != null && CELLPHONENUMBER != null)
                        {
                            ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "UserName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, USERNAME.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "FirstName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, FIRSTNAME.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "LastName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, LASTNAME.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "EmailAddress", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, EMAIL.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ADMIN.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isDockManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, DOCKMANAGER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isInspector", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, INSPECTOR.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isGuard", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, GUARD.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isLabPersonel", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABPERSONEL.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isLoader", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LOADER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isYardMule", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, YARDMULE.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "canViewReports", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, REPORTER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "isLabAdmin", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, LABADMIN.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Users", "isAccountManager", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, ACCTMANAGER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "Phone", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, CELLPHONENUMBER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();
                            cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "CellProviderID", now, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, CELLPHONEPROVIDER.ToString(), null, "UserID", USERID.ToString());
                            cl.CreateChangeLogEntryIfChanged();

                            sqlCmdText = "UPDATE dbo.Users SET UserName = @UserName, FirstName = @FirstName, LastName = @LastName, EmailAddress = @EmailAddress, Phone = @Phone, CellProviderID = @CellProviderID, " +
                                                    "isAdmin = @isAdmin, isDockManager = @isDockManager, isInspector = @isInspector, isGuard = @isGuard, isLabPersonel = @isLabPersonel, isLoader = @isLoader, isYardMule = @isYardMule, " +
                                                    "isLabAdmin = @isLabAdmin, canViewReports = @canViewReports, isAccountManager = @isAccountManager WHERE UserID = @UserID";
                            SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UserName", USERNAME),
                                                                                               new SqlParameter("@FirstName", FIRSTNAME),
                                                                                               new SqlParameter("@LastName", LASTNAME),
                                                                                               new SqlParameter("@EmailAddress", EMAIL),
                                                                                               new SqlParameter("@Phone", CELLPHONENUMBER),
                                                                                               new SqlParameter("@CellProviderID", CELLPHONEPROVIDER),
                                                                                               new SqlParameter("@Password", DataTransformer.PasswordHash("ZXPpassword1!")),
                                                                                               new SqlParameter("@isAdmin", ADMIN),
                                                                                               new SqlParameter("@isDockManager", DOCKMANAGER),
                                                                                               new SqlParameter("@isInspector", INSPECTOR),
                                                                                               new SqlParameter("@isGuard", GUARD),
                                                                                               new SqlParameter("@isLabPersonel", LABPERSONEL),
                                                                                               new SqlParameter("@isLoader", LOADER),
                                                                                               new SqlParameter("@isYardMule", YARDMULE),
                                                                                               new SqlParameter("@canViewReports", REPORTER),
                                                                                               new SqlParameter("@isLabAdmin", LABADMIN),
                                                                                               new SqlParameter("@isAccountManager", ACCTMANAGER),
                                                                                               new SqlParameter("@UserID", USERID));
                        }
                        else if (CELLPHONEPROVIDER == null && CELLPHONENUMBER != null)
                        {
                            throw new Exception("Trying to add a cell phone provider without a cell phone number to a user.");
                        }
                        else if (CELLPHONEPROVIDER != null && CELLPHONENUMBER == null)
                        {
                            throw new Exception("Trying to add a cell phone number without a cell phone provider to a user.");
                        }
                    else
                    {
                        throw new Exception("Username already exists");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Users updateUser(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void updatePassword(int USERID, string PASSWORD)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Users", "Password", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, DataTransformer.PasswordHash(PASSWORD).ToString(), null, "UserID", USERID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Users SET Password = @Password WHERE UserID = @UserID";
                    SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@Password", DataTransformer.PasswordHash(PASSWORD)),
                                                                                       new SqlParameter("@UserID", USERID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Users GetPODetailsFromMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

    }
}