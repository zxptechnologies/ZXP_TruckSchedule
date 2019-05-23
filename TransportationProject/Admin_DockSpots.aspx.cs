using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;

namespace TransportationProject.AdminSubPages
{
    public partial class Admin_DockSpots : System.Web.UI.Page
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
                string strErr = " SQLException Error in Admin_DockSpots Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_DockSpots Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }


        [System.Web.Services.WebMethod]
        public static Object GetDockType()
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
                    sqlCmdText = "SELECT SpotTypeShort, SpotTypeLong FROM dbo.SpotType WHERE SpotTypeShort != 'Yard' AND SpotTypeShort != 'Wait'";

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
                string strErr = " Exception Error in Admin_DockSpots GetDockType(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetDockSpotGridData()
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
                    sqlCmdText = "SELECT TDS.SpotID, TDS.SpotDescription, TDS.HoursInTimeBlock,TDS.SpotType " +
                                    "FROM dbo.TruckDockSpots as TDS " +
                                    "WHERE TDS.isDisabled = 'false' AND TDS.SpotType != 'Yard' AND TDS.SpotType != 'Wait' " +
                        // excludes waiting(3017) and yard(3015). waiting and yard are required for dock manager (loader grid) pre-fill when assigning new request
                                    "ORDER BY TDS.SpotType, TDS.SpotDescription";
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
                string strErr = " Exception Error in Admin_DockSpots GetDockSpotGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int SetNewSpot(string SPOTDESCRIPTION, string SPOTTYPE, float HOURSINTIMENBLOCK)
        {
            Int32 SpotID = 0;
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(SpotID) FROM dbo.TruckDockSpots WHERE (isDisabled = 'false') AND (SpotDescription = @SpotDescription)";
                    int hasRows = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotDescription", SPOTDESCRIPTION)));

                    if (hasRows == 0)
                    {
                        sqlCmdText = "INSERT INTO dbo.TruckDockSpots (SpotDescription, SpotType, HoursInTimeBlock, isDisabled) " +
                                        "VALUES (@SpotDescription, @SpotType, @HoursInTimeBlock, 'false'); " +
                                        "SELECT CAST(scope_identity() AS int)";
                    }
                    else
                    {//if it does exist, throw exception
                        throw new Exception("The combination of Spot Name and Spot Type already exist");
                    }
                    SpotID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotDescription", SPOTDESCRIPTION),
                                                                                                                new SqlParameter("@SpotType", SPOTTYPE),
                                                                                                                new SqlParameter("@HoursInTimeBlock", HOURSINTIMENBLOCK)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpots", "SpotDescription", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, SPOTDESCRIPTION.ToString(), null, "SpotID", SpotID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpots", "SpotType", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, SPOTTYPE.ToString(), null, "SpotID", SpotID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpots", "HoursInTimeBlock", now, zxpUD._uid, ChangeLog.ChangeLogDataType.FLOAT, HOURSINTIMENBLOCK.ToString(), null, "SpotID", SpotID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpots", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "SpotID", SpotID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_DockSpots SetNewSpot(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return SpotID;
        }

        [System.Web.Services.WebMethod]
        public static void UpdateDockSpot(int SPOTID, string SPOTDESCRIPTION, string SPOTTYPE, string HOURSINTIMEBLOCK)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramSpotID = new SqlParameter("@SpotID", SqlDbType.Int);
                    SqlParameter paramSpotType = new SqlParameter("@SpotType", SqlDbType.NVarChar);
                    SqlParameter paramSpotDescription = new SqlParameter("@SpotDescription", SqlDbType.NVarChar);
                    SqlParameter paramHoursInTimeBlock = new SqlParameter("@HoursInTimeBlock", SqlDbType.Float);

                    paramSpotID.Value = SPOTID;
                    paramSpotType.Value = SPOTTYPE;
                    paramSpotDescription.Value = SPOTDESCRIPTION;
                    paramHoursInTimeBlock.Value = HOURSINTIMEBLOCK;

                    sqlCmdText = "SELECT COUNT(SpotID) FROM dbo.TruckDockSpots WHERE (isDisabled = 'false') AND (SpotDescription = @SpotDescription) AND SpotID != @SpotID";
                    int hasRows = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotDescription", SPOTDESCRIPTION),
                                                                                                                     new SqlParameter("@SpotID", SPOTID)));


                    if (hasRows == 0)
                    {
                        ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TruckDockSpots", "SpotDescription", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, SPOTDESCRIPTION.ToString(), null, "SpotID", SPOTID.ToString());
                        cl.CreateChangeLogEntryIfChanged();
                        cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TruckDockSpots", "SpotType", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, SPOTTYPE.ToString(), null, "SpotID", SPOTID.ToString());
                        cl.CreateChangeLogEntryIfChanged();
                        cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TruckDockSpots", "HoursInTimeBlock", now, zxpUD._uid, ChangeLog.ChangeLogDataType.FLOAT, HOURSINTIMEBLOCK.ToString(), null, "SpotID", SPOTID.ToString());
                        cl.CreateChangeLogEntryIfChanged();

                        sqlCmdText = "UPDATE dbo.TruckDockSpots SET SpotType = @SpotType, SpotDescription = @SpotDescription, HoursInTimeBlock = @HoursInTimeBlock WHERE SpotID = @SpotID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotType", SPOTTYPE),
                                                                                             new SqlParameter("@SpotDescription", SPOTDESCRIPTION),
                                                                                             new SqlParameter("@HoursInTimeBlock", HOURSINTIMEBLOCK),
                                                                                             new SqlParameter("@SpotID", SPOTID));
                    }
                    else
                    {//if it does exist, throw exception
                        throw new Exception("Another spot with that name already exist");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_DockSpots UpdateDockSpot(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static bool PerDeleteDockSpot_UpcomingOrderCheck(int SPOTID)
        {
            bool hasFutureInventory = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP(1) MS.ETA " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "WHERE (MS.DockSpotID = @DockSpotID) AND ((SELECT DATEADD(dd, DATEDIFF(dd, 0, MS.ETA), 0)) > (SELECT CAST (GETDATE() as DATE)))";
                    DateTime dtServerReturn = Convert.ToDateTime(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@DockSpotID", SPOTID)));
                    if (dtServerReturn != DateTime.Parse("1/1/0001 12:00:00 AM"))
                    {
                        hasFutureInventory = true;
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_DockSpots PerDeleteDockSpot_UpcomingOrderCheck(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return hasFutureInventory;
        }

        [System.Web.Services.WebMethod]
        public static void DisableDockSpot(int SPOTID)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TruckDockSpots", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "SpotID", SPOTID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.TruckDockSpots SET isDisabled = 'true' WHERE SpotID = @SpotID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotID", SPOTID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_DockSpots DisableDockSpot(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
        
    } 

} 