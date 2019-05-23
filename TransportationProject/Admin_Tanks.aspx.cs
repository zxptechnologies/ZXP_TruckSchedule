using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Transactions;
using System.Web;

namespace TransportationProject.AdminSubPages
{
    public partial class Admin_Tanks1 : System.Web.UI.Page
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
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false); //zxp live url
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Tanks Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }
        [System.Web.Services.WebMethod]
        public static Object GetTanksGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            double yellowCellSetting;
            double orangeCellSetting;
            double redCellSetting;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (ConfigurationManager.AppSettings["yellowTank"] == null)
                    {
                        throw new Exception("Missing yellowTank param from webconfig.");
                    }
                    else
                    {
                        yellowCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["yellowTank"]);
                    }

                    if (ConfigurationManager.AppSettings["orangeTank"] == null)
                    {
                        throw new Exception("Missing yellowTank param from webconfig.");
                    }
                    else
                    {
                        orangeCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["orangeTank"]);
                    }

                    if (ConfigurationManager.AppSettings["redTank"] == null)
                    {
                        throw new Exception("Missing yellowTank param from webconfig.");
                    }
                    else
                    {
                        redCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["redTank"]);
                    }

                    sqlCmdText = "SELECT Tnks.TankID, Tnks.TankName, Tnks.TankCapacity, CurrentTankVolume, " +
                                        "(SELECT Tnks.TankCapacity * @yellowCellSetting), (SELECT Tnks.TankCapacity * @orangeCellSetting), (SELECT Tnks.TankCapacity * @redCellSetting) " + 
                                        "FROM dbo.Tanks as Tnks WHERE Tnks.isDisabled = 'false'";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@yellowCellSetting", yellowCellSetting),
                                                                                                  new SqlParameter("@orangeCellSetting", orangeCellSetting),
                                                                                                  new SqlParameter("@redCellSetting", redCellSetting));

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
                string strErr = " Exception Error in Admin_Tanks GetTanksGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void disableTank(int TANKID)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "Tanks", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "TankID", TANKID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.Tanks SET isDisabled = 'true' WHERE TankID = @TankID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankID", TANKID));

                    sqlCmdText = "UPDATE dbo.Alerts SET isDisabled = 'true' WHERE TankID = @TankID AND AlertTypeID = 2";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankID", TANKID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks disableTank(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static int setNewTank(string TANKNAME, decimal CAPACITY, decimal CURRENTVOL)
        {
            Int32 tankID = 0;
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (CAPACITY <= 0) {
                        throw new Exception("Max capacity can not be 0.");
                    }
                    else if (CAPACITY < CURRENTVOL) {
                        throw new Exception("Current capacity can not be a greater volume than the max capcity.");
                    }
                    else if (CURRENTVOL < 0) {
                        throw new Exception("Current capacity can not be less than 0.");
                    }

                    //checks to see if a tank with that name exsist
                    sqlCmdText = "SELECT COUNT(*) FROM dbo.Tanks WHERE (TankName = @TankName) AND (isDisabled = 'false')";
                    int tankCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankName", TANKNAME)));

                    //checks to see if tank exists
                    if (tankCount == 0)
                    {
                        //if it doesnt exist, go ahead and create tank
                        sqlCmdText = "INSERT INTO dbo.Tanks (TankName, TankCapacity, CurrentTankVolume, isDisabled) VALUES (@TankName, @TankCapacity, @CurrentVol, 'false'); " +
                            "SELECT CAST(scope_identity() AS int)";
                        tankID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankName", TANKNAME),
                                                                                                                    new SqlParameter("@TankCapacity", CAPACITY),
                                                                                                                    new SqlParameter("@CurrentVol", CURRENTVOL)));
                    }
                    else
                    {//if it does exist, throw exception
                        throw new Exception("A tank by that name already exist");
                    }

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Tanks", "TankName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TANKNAME.ToString(), null, "TankID", tankID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Tanks", "TankCapacity", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, CAPACITY.ToString(), null, "TankID", tankID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Tanks", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "TankID", tankID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks setNewTank(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return tankID;

        }

        [System.Web.Services.WebMethod]
        public static void updateTank(int TANKID, string TANKNAME, decimal CAPACITY, decimal CURRENTVOL)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (CAPACITY <= 0)
                    {
                        throw new Exception("Max capacity can not be 0.");
                    }
                    else if (CAPACITY < CURRENTVOL)
                    {
                        throw new Exception("Current capacity can not be a greater volume than the max capcity.");
                    }
                    else if (CURRENTVOL < 0)
                    {
                        throw new Exception("Current capacity can not be less than 0.");
                    }
                    sqlCmdText = "UPDATE dbo.Tanks SET TankName = @TankName, TankCapacity = @TankCapacity, CurrentTankVolume = @CurrentTankVolume WHERE TankID = @TankID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankName", TANKNAME),
                                                                                         new SqlParameter("@TankCapacity", CAPACITY),
                                                                                         new SqlParameter("@CurrentTankVolume", CURRENTVOL),
                                                                                         new SqlParameter("@TankID", TANKID));
                    //No errors
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Tanks", "TankName", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TANKNAME.ToString(), null, "TankID", TANKID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "Tanks", "TankCapacity", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DECIMAL, CAPACITY.ToString(), null, "TankID", TANKID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks updateTank(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }


        [System.Web.Services.WebMethod]
        public static Object preTankDisabledCheck_IncomingOrderBasedOnProducts(int TANKID)
        {
            DataSet dataSet = new DataSet();
            int rowCount = 0;
            List<object> returnData = new List<object>();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT TP.ProductID_CMS, P.ProductName_CMS " +
                                            "FROM dbo.TankProducts as TP " +
                                            "INNER JOIN dbo.ProductsCMS AS P ON P.ProductID_CMS = TP.ProductID_CMS " +
                                            "WHERE (TP.isDisabled = 'false') AND (TP.TankID = @TankID)";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankID", TANKID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        sqlCmdText = "SELECT COUNT (MS.ETA) " +
                                          "FROM dbo.MainSchedule AS MS " +
                                          "INNER JOIN dbo.PODetails AS POD ON POD.MSID = MS.MSID " +
                                          "WHERE (POD.ProductID_CMS = @ProductID_CMS) AND ((SELECT DATEADD(dd, DATEDIFF(dd, 0, MS.ETA), 0)) >= (SELECT CAST (GETDATE() as DATE)))";
                        rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ProductID_CMS", row["ProductID_CMS"].ToString())));


                        if (rowCount > 0)
                        {
                            List<object> newList = row.ItemArray.ToList();
                            newList.Add(rowCount);
                            returnData.Add(newList);
                        }
                        rowCount = 0;
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks preTankDisabledCheck_IncomingOrderBasedOnProducts(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnData;
        }

        [System.Web.Services.WebMethod]
        public static Object preTankDisabledCheck_Alert(int TANKID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT AC.Name, (SELECT AC.Percentage * 100 ) FROM dbo.Alerts AS AC WHERE TankID = @TankID AND AlertTypeID = 2 AND isDisabled = 'false'";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankID", TANKID));

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
                string strErr = " Exception Error in Admin_Tanks preTankDisabledCheck_Alert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static List<double> getColorCellSettings()
        {
            List<double> listOfCellColorSettings = new List<double>();
            double yellowCellSetting;
            double orangeCellSetting;
            double redCellSetting;

            try
            {
                using (var scope = new TransactionScope())
                {
                    yellowCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["yellowTank"]);
                    orangeCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["orangeTank"]);
                    redCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["redTank"]);

                    listOfCellColorSettings.Add(yellowCellSetting);
                    listOfCellColorSettings.Add(orangeCellSetting);
                    listOfCellColorSettings.Add(redCellSetting);
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks getColorCellSettings(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return listOfCellColorSettings;
        }


        [System.Web.Services.WebMethod]
        public static List<double> UpdateFillPercentageAlert(int TANKID)
        {
            DataSet dataSet = new DataSet();
            DateTime now = DateTime.Now;
            double yellowCellSetting;
            double orangeCellSetting;
            double redCellSetting;
            List<double> returnData = new List<double>();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    yellowCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["yellowTank"]);
                    orangeCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["orangeTank"]);
                    redCellSetting = Convert.ToDouble(ConfigurationManager.AppSettings["redTank"]);

                    sqlCmdText = "SELECT (SELECT Tnks.TankCapacity * @yellowCellSetting) AS YellowCell, (SELECT Tnks.TankCapacity * @orangeCellSetting) AS OrangeCell, (SELECT Tnks.TankCapacity * @redCellSetting) AS RedCell " +
                                    "FROM dbo.Tanks as Tnks WHERE Tnks.TankID = @TankID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@yellowCellSetting", yellowCellSetting),
                                                                                                  new SqlParameter("@orangeCellSetting", orangeCellSetting),
                                                                                                  new SqlParameter("@redCellSetting", redCellSetting),
                                                                                                  new SqlParameter("@TankID", TANKID));
                    if (dataSet.Tables[0].Rows.Count != 0)
                    {
                        returnData.Add(Convert.ToDouble(dataSet.Tables[0].Rows[0]["YellowCell"]));
                        returnData.Add(Convert.ToDouble(dataSet.Tables[0].Rows[0]["OrangeCell"]));
                        returnData.Add(Convert.ToDouble(dataSet.Tables[0].Rows[0]["RedCell"]));
                    }
                    else
                    {
                        throw new Exception("Tank setting missing from webConfig");
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Tanks UpdateFillPercentageAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnData;
        }
    }
}