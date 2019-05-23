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
namespace TransportationProject
{
    public partial class Admin_Products : System.Web.UI.Page
    {
        protected static String sql_connStr;
        protected static String as400_connStr;
        private TransportationProjectDataProvider tsDataProvider = new TransportationProjectDataProvider();

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

                        //as400_connStr = ConfigurationManager.AppSettings["AS400ConnectionString"];
                        //if (string.IsNullOrEmpty(as400_connStr))
                        //{
                        //    throw new Exception("Missing AS400ConnectionString in web.config");
                        //}
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
                string strErr = " SQLException Error in Admin_Products Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetProductsAndAssociationsGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT ProductID_CMS, ProductName_CMS, TankData, InspectionListsData, PatternData, SpotData " +
                                          "FROM dbo.getProductAssociationTableData  " +
                                          "ORDER BY ProductID_CMS ";
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
                string strErr = " Exception Error in Admin_Products GetProductsAndAssociationsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static Object GetInspectionListsGridData(string cmsProdID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT ILP.InspectionProductID " +
                          ",ILP.InspectionListID " +
                          ",IL.InspectionListName " +
                      "FROM dbo.InspectionListsProducts ILP " +
                      "INNER JOIN dbo.InspectionLists IL ON ILP.InspectionListID = IL.InspectionListID " +
                      "WHERE IL.isHidden = 0 AND ILP.isDisabled = 0 AND ILP.ProductID_CMS = @CMSPROD " +
                      "ORDER BY InspectionListName";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", cmsProdID));

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
                string strErr = " Exception Error in Admin_Products GetInspectionListsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetAvailableInspectionLists(bool isRebind, string cmsProdID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (isRebind)
                    {
                        sqlCmdText = "SELECT InspectionListID, InspectionListName " +
                                                "FROM dbo.InspectionLists " +
                                                "WHERE isHidden = 0 " +
                                                "EXCEPT " +
                                                "SELECT IL.InspectionListID, IL.InspectionListName " +
                                                "FROM dbo.InspectionListsProducts ILP " +
                                                "INNER JOIN dbo.InspectionLists IL ON ILP.InspectionListID = IL.InspectionListID " +
                                                "WHERE IL.isHidden = 0 AND ILP.isDisabled = 0 " +
                                                "AND ILP.ProductID_CMS = @CMSPROD " +
                                                "ORDER BY InspectionListName ";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", cmsProdID));
                    }
                    else
                    {
                        sqlCmdText = "SELECT InspectionListID, InspectionListName " +
                                                "FROM dbo.InspectionLists " +
                                                "WHERE isHidden = 0 " +
                                                "ORDER BY InspectionListName";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    }
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
                string strErr = " Exception Error in Admin_Products GetAvailableInspectionLists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void AddNewInspectionListProductRelationship(int InspectionListID, string PRODUCTID)
        {
            int inspectProdID = 0;
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.InspectionListsProducts " +
                                        "(InspectionListID, ProductID_CMS, isDisabled) " +
                                        "VALUES (@INSPLISTID, @ProductID_CMS, 'false'); " +
                                        "SELECT CAST(scope_identity() AS int)";
                    inspectProdID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@INSPLISTID", InspectionListID),
                                                                                                                       new SqlParameter("@ProductID_CMS", PRODUCTID)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "InspectionListsProducts", "InspectionListID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, InspectionListID.ToString(), null, "InspectionProductID", inspectProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "InspectionListsProducts", "ProductID_CMS", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, PRODUCTID.ToString(), null, "InspectionProductID", inspectProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "InspectionListsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "InspectionProductID", inspectProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products AddNewInspectionListProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void EditInspectionListProductRelationship(int InspectionListID, int InspectionProductID)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionListsProducts SET InspectionListID = @InspectionListID WHERE InspectionProductID = @InspectionProductID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", InspectionListID),
                                                                                         new SqlParameter("@InspectionProductID", InspectionProductID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products EditInspectionListProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void DisableInspectionListProductRelationship(int inspectionlistProdID)
        {
            SqlConnection sqlConn = new SqlConnection();
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "UPDATE dbo.InspectionListsProducts " +
                                 "SET isDisabled = 'true' WHERE InspectionProductID = @InspListProdID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspListProdID", inspectionlistProdID));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "InspectionListsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "InspectionProductID", inspectionlistProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products DisableInspectionListProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetTanksGridData(string cmsProdID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TankProductID, TP.TankID, T.TankName, T.TankCapacity " +
                                        "FROM dbo.TankProducts TP  " +
                                        "INNER JOIN dbo.Tanks T ON T.TankID = TP.TankID  " +
                                        "WHERE TP.isDisabled = 0 AND T.isDisabled = 0  " +
                                        "AND TP.ProductID_CMS = @CMSPROD " +
                                        "ORDER BY TankName";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", cmsProdID));

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
                string strErr = " Exception Error in Admin_Products GetTanksGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object GetAvailableTanks(bool isRebind, string cmsProdID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (isRebind)
                    {
                        sqlCmdText = "SELECT T.TankId, T.TankName, T.TankCapacity " +
                                        "FROM dbo.Tanks T " +
                                        "WHERE T.isDisabled = 0  " +
                                        "EXCEPT " +
                                        "SELECT T.TankID, T.TankName, T.TankCapacity " +
                                        "FROM dbo.TankProducts TP  " +
                                        "INNER JOIN dbo.Tanks T ON T.TankID = TP.TankID  " +
                                        "WHERE TP.isDisabled = 0 AND T.isDisabled = 0  " +
                                        "AND TP.ProductID_CMS = @CMSPROD " +
                                        "ORDER BY TankName";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", cmsProdID));
                    }
                    else
                    {
                        sqlCmdText = "SELECT T.TankId, T.TankName, T.TankCapacity " +
                                        "FROM dbo.Tanks T " +
                                        "WHERE T.isDisabled = 0  " +
                                         "ORDER BY TankName";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    }
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
                string strErr = " Exception Error in Admin_Products GetAvailableTanks(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static void AddNewTankProductRelationship(int TANKID, string PRODUCTID)
        {
            int tankProdID = 0;
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.TankProducts " +
                                        "(TankID, ProductID_CMS, isDisabled) " +
                                        "VALUES (@TankID, @ProductID_CMS, 'false'); " +
                                        "SELECT CAST(scope_identity() AS int)";
                    tankProdID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankID", TANKID),
                                                                                                                    new SqlParameter("@ProductID_CMS", PRODUCTID)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TankProducts", "TankID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, TANKID.ToString(), null, "TankProductID", tankProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TankProducts", "ProductID_CMS", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, PRODUCTID.ToString(), null, "TankProductID", tankProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TankProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "TankProductID", tankProdID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products AddNewTankProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void EditTankProductRelationship(int TANKID, int TankProductID)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.TankProducts SET TankID = @TankID WHERE TankProductID = @TankProductID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankID", TANKID),
                                                                                         new SqlParameter("@TankProductID", TankProductID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products EditTankProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void DisableTankProductRelationship(int tankprodID)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.TankProducts " +
                                    "SET isDisabled = '1' WHERE TankProductID = @TankProductID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TankProductID", tankprodID));

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TankProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "TankProductID", tankprodID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products DisableTankProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }


        [System.Web.Services.WebMethod]
        public static Object GetSpotsGridData(string cmsProdID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TDSP.SpotProductID, TDSP.SpotID, SpotDescription, SpotType " +
                        "FROM dbo.TruckDockSpotsProducts TDSP " +
                        "INNER JOIN dbo.TruckDockSpots TDS ON TDS.SpotID = TDSP.SpotID " +
                        "WHERE TDS.isDisabled = 0 AND TDSP.isDisabled = 0  " +
                        "AND TDSP.ProductID_CMS = @CMSPROD " +
                        "ORDER BY SpotDescription ";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", cmsProdID));

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
                string strErr = " Exception Error in Admin_Products GetSpotsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static Object GetAvailableSpots(bool isRebind, string cmsProdID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (isRebind)
                    {
                        sqlCmdText = "SELECT TDS.SpotID, SpotDescription, SpotType " +
                                        "FROM dbo.TruckDockSpots TDS " +
                                        "WHERE TDS.isDisabled = 0  " +
                                        "EXCEPT " +
                                         "SELECT TDSP.SpotID, SpotDescription, SpotType " +
                                        "FROM dbo.TruckDockSpotsProducts TDSP " +
                                        "INNER JOIN dbo.TruckDockSpots TDS ON TDS.SpotID = TDSP.SpotID " +
                                        "WHERE TDS.isDisabled = 0 AND TDSP.isDisabled = 0 AND SpotType != 'Wait' AND SpotType != 'Yard' " +
                                        "AND TDSP.ProductID_CMS = @CMSPROD " +
                                        "ORDER BY SpotDescription ";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", cmsProdID));
                    }
                    else
                    {
                        sqlCmdText = "SELECT TDS.SpotID, SpotDescription, SpotType " +
                                        "FROM dbo.TruckDockSpots TDS " +
                                        "WHERE TDS.isDisabled = 0 AND SpotType != 'Wait' AND SpotType != 'Yard' " +
                                         "ORDER BY SpotDescription";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    }

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
                string strErr = " Exception Error in Admin_Products GetAvailableSpots(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void AddNewSpotProductRelationship(int SPOTID, string PRODUCTID)
        {
            int SpotProductID = 0;
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "INSERT INTO dbo.TruckDockSpotsProducts " +
                                        "(SpotID, ProductID_CMS, isDisabled) " +
                                        "VALUES (@SpotID, @ProductID_CMS, 'false'); " +
                                        "SELECT CAST(scope_identity() AS int)";
                    SpotProductID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotID", SPOTID),
                                                                                                                       new SqlParameter("@ProductID_CMS", PRODUCTID)));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpotsProducts", "SpotID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, SPOTID.ToString(), null, "SpotProductID", SpotProductID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpotsProducts", "ProductID_CMS", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, PRODUCTID.ToString(), null, "SpotProductID", SpotProductID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "TruckDockSpotsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "SpotProductID", SpotProductID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products AddNewSpotProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void EditSpotProductRelationship(int SPOTID, int SpotProductID)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.TruckDockSpotsProducts SET SpotID = @SpotID WHERE SpotProductID = @SpotProductID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotID", SPOTID),
                                                                                         new SqlParameter("@SpotProductID", SpotProductID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products EditSpotProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void DisableSpotProductRelationship(int spotprodID)
        {
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.TruckDockSpotsProducts " +
                                         "SET isDisabled = 'true' WHERE SpotProductID = @SpotProductID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SpotProductID", spotprodID));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "TruckDockSpotsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "SpotProductID", spotprodID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products DisableSpotProductRelationship(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetPatternsGridData(string cmsProdID)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd;
            List<object[]> data = new List<object[]>();

            try
            {
                sqlCmd = new SqlCommand();
                sqlConn = new SqlConnection(sql_connStr);
                sqlConn.Open();

                //Connects to DB
                sqlCmd.Connection = sqlConn;
                SqlParameter paramCMSPROD = new SqlParameter("@CMSPROD", SqlDbType.Char);
                paramCMSPROD.Value = cmsProdID;
                sqlCmd.Parameters.Add(paramCMSPROD);


                sqlCmd.CommandText = "SELECT PP.ProductPatternID, PP.PatternID, P.PatternName, P.FilePath, P.FileNameNew, P.FileNameOld " +
                            "FROM PatternsProducts PP " +
                            "INNER JOIN dbo.Patterns P ON P.PatternID = PP.PatternID " +
                            "WHERE PP.isDisabled = 0 AND P.isHidden = 0 AND " +
                            "PP.ProductID_CMS = @CMSPROD " +
                            "ORDER BY P.PatternName";

                DataSet dsGridData = new DataSet();
                DataTable tblGridData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsGridData.Tables.Add(tblGridData);
                dsGridData.Load(sqlReader, LoadOption.OverwriteChanges, tblGridData);
                //populate return object
                foreach (System.Data.DataRow row in dsGridData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products GetPatternsGridData(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products GetPatternsGridData(). Details: " + ex.ToString();
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
            return data;
        } //


        [System.Web.Services.WebMethod]
        public static Object GetAvailablePatterns(bool isRebind, string cmsProdID)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd;
            List<object[]> data = new List<object[]>();

            try
            {
                sqlCmd = new SqlCommand();
                sqlConn = new SqlConnection(sql_connStr);
                sqlConn.Open();

                //Connects to DB
                sqlCmd.Connection = sqlConn;


                if (isRebind)
                {
                    SqlParameter paramCMSPROD = new SqlParameter("@CMSPROD", SqlDbType.Char);
                    paramCMSPROD.Value = cmsProdID;
                    sqlCmd.Parameters.Add(paramCMSPROD);

                    sqlCmd.CommandText = "SELECT P.PatternID, P.PatternName, P.FilePath, P.FileNameNew, P.FileNameOld " +
                                    "FROM dbo.Patterns P " +
                                    "WHERE P.isHidden = 0 " +
                                    "EXCEPT " +
                                    "SELECT PP.PatternID, P.PatternName, P.FilePath, P.FileNameNew, P.FileNameOld " +
                                    "FROM PatternsProducts PP " +
                                    "INNER JOIN dbo.Patterns P ON P.PatternID = PP.PatternID " +
                                    "WHERE PP.isDisabled = 0 AND P.isHidden = 0 AND " +
                                    "PP.ProductID_CMS = @CMSPROD " +
                                    "ORDER BY P.PatternName";
                }
                else
                {

                    sqlCmd.CommandText = "SELECT P.PatternID, P.PatternName, P.FilePath, P.FileNameNew, P.FileNameOld " +
                                    "FROM dbo.Patterns P " +
                                    "WHERE P.isHidden = 0 " +
                                    "ORDER BY P.PatternName";

                }

                DataSet dsGridData = new DataSet();
                DataTable tblGridData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsGridData.Tables.Add(tblGridData);
                dsGridData.Load(sqlReader, LoadOption.OverwriteChanges, tblGridData);
                //populate return object
                foreach (System.Data.DataRow row in dsGridData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products GetAvailablePatterns(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products GetAvailablePatterns(). Details: " + ex.ToString();
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
            return data;
        } //


        [System.Web.Services.WebMethod]
        public static void AddNewPatternProductRelationship(int PATTERNID, string PRODUCTID)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            int prodPatID = 0;
            DateTime timestamp = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    SqlParameter paramPatternID = new SqlParameter("@PatternID", SqlDbType.Int);
                    SqlParameter paramProductID = new SqlParameter("@ProductID_CMS", SqlDbType.Char);

                    paramPatternID.Value = PATTERNID;
                    paramProductID.Value = PRODUCTID;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramPatternID);
                    sqlCmd.Parameters.Add(paramProductID);

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;
                    sqlCmd.CommandText = "INSERT INTO dbo.PatternsProducts " +
                                        "(PatternID, ProductID_CMS, isDisabled) " +
                                        "VALUES (@PatternID, @ProductID_CMS, 'false'); " +
                                        "SELECT CAST(scope_identity() AS int)";
                    prodPatID = Convert.ToInt32(sqlCmd.ExecuteScalar());
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PatternsProducts", "PatternID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, PATTERNID.ToString(), null, "ProductPatternID", prodPatID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PatternsProducts", "ProductID_CMS", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, PRODUCTID.ToString(), null, "ProductPatternID", prodPatID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PatternsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "ProductPatternID", prodPatID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                   
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products AddNewPatternProductRelationship(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products AddNewPatternProductRelationship(). Details: " + ex.ToString();
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
        }

        [System.Web.Services.WebMethod]
        public static void EditPatternProductRelationship(int PATTERNID, int ProductPatternID)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            DateTime timestamp = DateTime.Now;
            try
            {
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    SqlParameter paramPatternID = new SqlParameter("@PatternID", SqlDbType.Int);
                    SqlParameter paramProductPatternID = new SqlParameter("@ProductPatternID", SqlDbType.Int);

                    paramPatternID.Value = PATTERNID;
                    paramProductPatternID.Value = ProductPatternID;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramPatternID);
                    sqlCmd.Parameters.Add(paramProductPatternID);

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;
                    sqlCmd.CommandText = "UPDATE dbo.PatternsProducts SET PatternID = @PatternID WHERE ProductPatternID = @ProductPatternID";
                    sqlCmd.ExecuteNonQuery();

                    //ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PatternsProducts", "PatternID", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, PATTERNID.ToString(), null, "ProductPatternID", prodPatID.ToString());
                    //cl.CreateChangeLogEntryIfChanged(sqlConn);

                    //cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PatternsProducts", "ProductID_CMS", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, PRODUCTID.ToString(), null, "ProductPatternID", prodPatID.ToString());
                    //cl.CreateChangeLogEntryIfChanged(sqlConn);

                    //cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "PatternsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "ProductPatternID", prodPatID.ToString());
                    //cl.CreateChangeLogEntryIfChanged(sqlConn);

                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products EditPatternProductRelationship(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products EditPatternProductRelationship(). Details: " + ex.ToString();
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
        }
        [System.Web.Services.WebMethod]
        public static void DisablePatternProductRelationship(int patternprodID)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd;
            DateTime timestamp = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection();
                    sqlCmd = new SqlCommand();

                    sqlConn = new SqlConnection(sql_connStr);
                    sqlConn.Open();

                    SqlParameter paramProductPatternID = new SqlParameter("@PATPRODID", SqlDbType.Int);
                    paramProductPatternID.Value = patternprodID;
                    sqlCmd.Parameters.Add(paramProductPatternID);


                    sqlCmd.Connection = sqlConn;
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "PatternsProducts", "isDisabled", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, "1", null, "ProductPatternID", patternprodID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    sqlCmd.CommandText = "UPDATE dbo.PatternsProducts " +
                        "SET isDisabled = 'true' WHERE ProductPatternID = @PATPRODID";

                    sqlCmd.ExecuteNonQuery();
                    scope.Complete();
                }
            }//end of try
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products DisablePatternProductRelationship(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products DisablePatternProductRelationship(). Details: " + ex.ToString();
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
        }


       
        [System.Web.Services.WebMethod]
        public static Object GetProductsFromCMS()
        {
            OdbcConnection odbcConn = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Conn;
            OdbcCommand odbcCmd = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Cmd;
            List<string> data = new List<string>();
            
            try
            {
                using (var scope = new TransactionScope())
                {
                    odbcCmd.CommandText = "SELECT BC1PART FROM CMSDAT.STKAS ORDER BY TRIM(BC1PART)"; //no filter on plant , use if need to add product not in plant 

                    DataSet dsLoadData = new DataSet();
                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                    dsAdapter.Fill(dsLoadData);

                    foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows) {
                        data.Add(row.ItemArray[0].ToString());
                    }
                    scope.Complete();
                }
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in Admin_Products getProducts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products getProducts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products getProducts(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (odbcConn == null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return data;
        }


        public IEnumerable<CMSProduct> GetTruckScheduleDBCMSProducts(string product)
        {
            return this.tsDataProvider.GetProductCMS(product);
        }


        [System.Web.Services.WebMethod]
        public static string AddProductToDBIfNonexistent(string productID)
        {
            string returnMessage = string.Empty;
            OdbcConnection odbcConn = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Conn;
            OdbcCommand odbcCmd = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Cmd;

            try
            {
                string sqlCmdText;
                sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                //check if exists in sql
                sqlCmdText = "SELECT COUNT(ProductID_CMS) " +
                                    "FROM ProductsCMS " +
                                    "WHERE UPPER(ProductID_CMS) LIKE @PROD";
                int prodCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PROD", productID)));

                if (0 == prodCount)
                {
                    //if not in sql db
                    //get description
                    odbcCmd.CommandText = "SELECT PRODNAME " +
                                            "FROM ( SELECT AVDES1 AS PRODNAME FROM CMSDAT.STKMM  WHERE UPPER(AVPART) LIKE UPPER(?) " +
                                            "UNION SELECT AWDES1 AS PRODNAME FROM CMSDAT.STKMP WHERE UPPER(AWPART) LIKE UPPER(?)) as A " +
                                            "ORDER BY PRODNAME FETCH FIRST 1 ROW ONLY";

                    odbcCmd.Parameters.Add("@PRODAVPART", OdbcType.Char).Value = "%" + productID + "%";
                    odbcCmd.Parameters.Add("@PRODAWPART", OdbcType.Char).Value = "%" + productID + "%";

                    string prodCMSDescription = odbcCmd.ExecuteScalar().ToString();

                    //add prodid and description to sql db
                    using (var scope = new TransactionScope())
                    {

                        sqlCmdText = "INSERT INTO ProductsCMS (ProductID_CMS, ProductName_CMS) VALUES (@PROD, @PRODDESC)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PROD", productID), new SqlParameter("@PRODDESC", prodCMSDescription));
                        scope.Complete();
                    }
                    returnMessage = "Product added to database";
                }
                else
                {
                    returnMessage = "Product already exists. Continue below to edit";
                }
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in Admin_Products AddProductToDBIfNonexistent(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Products AddProductToDBIfNonexistent(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Products AddProductToDBIfNonexistentv(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (odbcConn != null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return returnMessage;
        } 

    }
}