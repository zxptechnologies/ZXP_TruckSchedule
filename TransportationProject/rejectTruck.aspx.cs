using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;

namespace TransportationProject
{
    public partial class rejectTruck : System.Web.UI.Page
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

                    if (zxpUD._isLabAdmin || zxpUD._isLabPersonnel || zxpUD._isGuard || zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
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
                    Response.Redirect("/Account/Login.aspx?ReturnURL=/rejectTruck.aspx", false); //zxp live
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in RejectTruck Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck Page_Load(). Details: " + ex.ToString();
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
              
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets MSID and other data needed 
                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber, LS.LocationLong, " +
                                            "(SELECT TOP 1 TimeStamp FROM dbo.MainScheduleEvents MSE WHERE (MSE.MSID = MS.MSID) AND (MS.isRejected = 'true') AND (isHidden = 'false') ORDER BY Timestamp DESC) AS TimeRejected, " +
                                            "MS.RejectionComment, MS.isOpenInCMS, " +
                                            "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS " +
                                            "FROM dbo.MainSchedule AS MS " +
                                            "INNER JOIN dbo.Locations LS ON LS.LocationShort = MS.LocationShort  " +
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
                                            "WHERE isHidden = 0 AND LS.LocationShort != 'NOS' " +
                                            "ORDER BY MSID";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                  
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck GetGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static string RejectATruck(int MSID)
        {
            DateTime now = DateTime.Now;
            string nowFormatted;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isRejected", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "1", null, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), null, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET isRejected = 1, LastUpdated = @TIME " +
                                    "WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", now),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 2037, null, now, zxpUD._uid, false);
                int newEventID = msEventLog.createNewEventLog(msEvent);
                string customAlertMsg = CreateCustomRejectTruckMessage(MSID);
                msEventLog.TriggerExistingAlertForEvent(newEventID, customAlertMsg);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck GetGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            nowFormatted = now.ToString("ddd MMM dd yyyy HH:mm:ss K");
            return now.ToString();
        }

        [System.Web.Services.WebMethod]
        public static DataSet GetTruckInfoForRejectCustomMessage(int MSID)
        {
            DataSet TruckData = new DataSet();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT MS.PONumber, MS.PONumber_ZXPOutbound, MS.CustomerID, MS.TrailerNumber, MS.RejectionComment, U.FirstName, U.LastName, " +
                                        "ISNULL(ProdDet.PDCount, 0) AS ProdCount, ProdDet.topProdID, PCMS.ProductName_CMS " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "INNER JOIN dbo.MainScheduleEvents MSE ON MS.MSID = MSE.MSID " +
                                        "INNER JOIN dbo.Users U ON U.UserID = MSE.UserId " +
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
                                        "WHERE MS.MSID = @MSID AND MSE.EventTypeID = 2037";

                    TruckData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck GetTruckInfoForRejectCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }

            return TruckData;
        }


        [System.Web.Services.WebMethod]
        public static ICollection<Tuple<string, string>> GetProductInfoRejectCustomMessage(int MSID)
        {
            DataSet productInfo = new DataSet();
            string productName;
            string partNum;
            ICollection<Tuple<string, string>> listOfProductDetails = new List<Tuple<string, string>>();
            try
            {
                
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    sqlCmdText = "SELECT PODetailsID, ProductID_CMS " +
                                        "FROM dbo.PODetails POD " +
                                        "WHERE MSID = @MSID";

                    productInfo = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));
                    foreach (System.Data.DataRow row in productInfo.Tables[0].Rows)
                    {
                        if (productInfo.Tables[0].Rows[0]["ProductID_CMS"].Equals(DBNull.Value))
                        {
                            productName = "";
                        }
                        else
                        {
                            productName = Convert.ToString(productInfo.Tables[0].Rows[0]["ProductID_CMS"]);
                        }

                        if (productInfo.Tables[0].Rows[0]["PODetailsID"].Equals(DBNull.Value))
                        {
                            partNum = "";
                        }
                        else
                        {
                            partNum = Convert.ToString(productInfo.Tables[0].Rows[0]["PODetailsID"]);
                        }


                        listOfProductDetails.Add(Tuple.Create(partNum, productName));
                    }

                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck GetProductInfoRejectCustomMessage(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }

            return listOfProductDetails;
        }




        [System.Web.Services.WebMethod]
        public static string CreateCustomRejectTruckMessage(int MSID)
        {
            string customAlertMsg = string.Empty;
            string PONum = null;
            string customerOrderNum = null;
            string customerID = null;
            string trailerNum = null;
            int prodCount = 0;
            string prodName = null;
            string prodDesc = null;
            string rejComment = null;
            string firstName = null;
            string lastName = null;


            try
            {
                DataSet truckDetailsDS = GetTruckInfoForRejectCustomMessage(MSID);

                if (truckDetailsDS != null && truckDetailsDS.Tables.Count != 0)
                {

                    if (truckDetailsDS.Tables[0].Rows[0]["PONumber"].Equals(DBNull.Value))
                    {
                        PONum = "N/A";
                    }
                    else
                    {
                        PONum = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["PONumber"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["PONumber_ZXPOutbound"].Equals(DBNull.Value))
                    {
                        customerOrderNum = "N/A";
                    }
                    else
                    {
                        customerOrderNum = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["PONumber_ZXPOutbound"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["CustomerID"].Equals(DBNull.Value))
                    {
                        customerID = "N/A";
                    }
                    else
                    {
                        customerID = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["CustomerID"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["TrailerNumber"].Equals(DBNull.Value))
                    {
                        trailerNum = "N/A";
                    }
                    else
                    {
                        trailerNum = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["TrailerNumber"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["RejectionComment"].Equals(DBNull.Value))
                    {
                        rejComment = " ";
                    }
                    else
                    {
                        rejComment = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["RejectionComment"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["FirstName"].Equals(DBNull.Value))
                    {
                        firstName = " ";
                    }
                    else
                    {
                        firstName = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["FirstName"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["LastName"].Equals(DBNull.Value))
                    {
                        lastName = " ";
                    }
                    else
                    {
                        lastName = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["LastName"]);
                    }
                    if (truckDetailsDS.Tables[0].Rows[0]["ProdCount"].Equals(DBNull.Value))
                    {
                        prodCount = 0;
                    }
                    else
                    {
                        prodCount = Convert.ToInt32(truckDetailsDS.Tables[0].Rows[0]["ProdCount"]);
                    }
                    if (prodCount == 0)
                    {
                        customAlertMsg = "Truck Rejected. Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Rejected by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Rejected Comment: " + rejComment + System.Environment.NewLine +
                            "Product: Not defined" + System.Environment.NewLine;
                    }
                    if (prodCount == 1)
                    {
                        if (truckDetailsDS.Tables[0].Rows[0]["topProdID"].Equals(DBNull.Value))
                        {
                            prodName = "N/A";
                        }
                        else
                        {
                            prodName = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["topProdID"]);
                        }

                        if (truckDetailsDS.Tables[0].Rows[0]["ProductName_CMS"].Equals(DBNull.Value))
                        {
                            prodDesc = "N/A";
                        }
                        else
                        {
                            prodDesc = Convert.ToString(truckDetailsDS.Tables[0].Rows[0]["ProductName_CMS"]);
                        }

                        customAlertMsg = "Truck Rejected. Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Rejected by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Rejected Comment: " + rejComment + System.Environment.NewLine +
                            "Product: " + prodName + " Part # " + prodDesc + System.Environment.NewLine;
                    }
                    else if (prodCount > 1)
                    {
                        string productString = "Products: " + System.Environment.NewLine;
                        ICollection<Tuple<string, string>> listOfProductDetails = new List<Tuple<string, string>>();
                        listOfProductDetails = GetProductInfoRejectCustomMessage(MSID);

                        foreach (var item in listOfProductDetails)
                        {
                            productString = productString + "Product Name: " + Convert.ToString(item.Item1) + "Part# :" + Convert.ToString(item.Item2) + System.Environment.NewLine;
                        }

                        customAlertMsg = "Truck Rejected. Details: " + System.Environment.NewLine +
                            "PO - Trailer: " + PONum + "  -  " + trailerNum + System.Environment.NewLine +
                            "Customer Order #: " + customerOrderNum + " Customer ID:" + customerID + System.Environment.NewLine +
                            "Rejected by: " + firstName + " " + lastName + System.Environment.NewLine +
                            "Rejected Comment: " + rejComment + System.Environment.NewLine +
                            productString + System.Environment.NewLine;
                    }
                }
                else
                {
                    Exception ex = new Exception("No truck info was found. Please check if this is the correct inspection");
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck CreateCustomRejectTruckMessage(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return customAlertMsg;
        }


        [System.Web.Services.WebMethod]
        public static void UndoARejectedTruck(int MSID)
        {
            DateTime now = DateTime.Now;

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //Create an entry in Event Log
                    sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                            "VALUES (@MSID, 3037, @TIME, @USER, 'false'); " +
                                            "SELECT SCOPE_IDENTITY()";
                    int eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", now),
                                                                                                                     new SqlParameter("@USER", zxpUD._uid)));
                    sqlCmdText = "UPDATE dbo.MainScheduleEvents SET isHidden = 'true' " +
                                            "WHERE (MSID = @MSID) AND EventTypeID = 2037;";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isRejected", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "false", eventID, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", now, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, now.ToString(), eventID, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET isRejected = 'false', LastUpdated = @TIME " +
                                          "WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                         new SqlParameter("@TIME", now));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck UndoARejectedTruck(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object CheckCurrentStatus(int MSID)
        {
            DataSet dataSet = new DataSet();
            List<string> data = new List<string>();
            string loc;
            string stat;
            bool isRejected;
            string rejTime;

            try
            {
               
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP (1) MS.LocationShort, (SELECT S.StatusText FROM dbo.Status AS S WHERE S.StatusID = MS.StatusID) AS Status, MS.isRejected, " +
                                            "(SELECT TOP (1) MSE.TimeStamp FROM dbo.MainScheduleEvents AS MSE WHERE (MSE.MSID = MS.MSID) AND (MSE.isHidden = 'false') AND (MSE.EventTypeID = 2037)) AS RejectTime " +
                                            "FROM dbo.MainSchedule AS MS WHERE MSID = @MSID";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    loc = Convert.ToString(dataSet.Tables[0].Rows[0]["LocationShort"]);
                    stat = Convert.ToString(dataSet.Tables[0].Rows[0]["Status"]);
                    isRejected = Convert.ToBoolean(dataSet.Tables[0].Rows[0]["isRejected"]);

                    if (dataSet.Tables[0].Rows[0]["RejectTime"].Equals(DBNull.Value))
                    {
                        rejTime = "0";
                    }
                    else
                    {
                        rejTime = dataSet.Tables[0].Rows[0]["RejectTime"].ToString();
                    }
                    data.Add(loc);
                    data.Add(stat.ToString());
                    data.Add(isRejected.ToString());
                    data.Add(rejTime.ToString());

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck CheckCurrentStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;

        }

        [System.Web.Services.WebMethod]
        public static void SetRejectionComment(int MSID, string COMMENT)
        {
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "RejectionComment", now, zxpUD._uid, ChangeLog.ChangeLogDataType.NVARCHAR, TransportHelperFunctions.convertStringEmptyToDBNULL(COMMENT).ToString(), null, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET RejectionComment = @COMMENT " +
                                            "WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@COMMENT", TransportHelperFunctions.convertStringEmptyToDBNULL(COMMENT)),
                                                                                         new SqlParameter("@MSID", MSID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck SetRejectionComment(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in RejectTruck GetLogDataByMSID(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck GetLogDataByMSID(). Details: " + ex.ToString();
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
                string strErr = " SQLException Error in RejectTruck GetLogList(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in RejectTruck GetLogList(). Details: " + ex.ToString();
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
                string strErr = " Exception Error in dockManager getYardMules(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }
    }
}