using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Transactions;
using System.Web;

namespace TransportationProject
{
    public partial class dataProcessingAndCleanUp : System.Web.UI.Page
    {
        protected static String sql_connStr;
        protected static String as400_connStr;
        public static ZXPUserData zxpUD = new ZXPUserData();
        public enum processingActions
        {
            DefaultAction,
            UpdateTankVolumes,
            UpdateOpenInCMS,

        };

        protected void Page_Load(object sender, EventArgs e)
        {
            //1- Check if user already authenticated

            //2- IF user auth. then show all contents
            //else look for query string user/passhash params
            // if they exist - attempt to auth.
            //  if auth. success show all contents
            //else show error message and quit
            // else show error message and quit

            int exceptionErrorCode = 0;
            try
            {
                //sql_connStr = ConfigurationManager.AppSettings["SQLConnectionString"];
                sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                if (sql_connStr == String.Empty)
                {
                    throw new Exception("Missing SQLConnectionString in web.config");
                }
                as400_connStr = ConfigurationManager.ConnectionStrings["AS400ConnectionString"].ConnectionString;
                //as400_connStr = ConfigurationManager.AppSettings["AS400ConnectionString"];
                
                if (string.IsNullOrEmpty(as400_connStr))
                {
                    throw new Exception("Missing AS400ConnectionString in web.config");
                }

                HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);

                }
                else
                {
                    Response.BufferOutput = true;
                    bool isValidUser = false;
                    string userName = Request.QueryString["UN"];
                    string password = Request.QueryString["PS"];

                    if ((userName == null || userName == String.Empty) || (password == null || password == String.Empty))
                    {
                        exceptionErrorCode = 6;//error code for unable to validate login
                        throw new Exception("Unable to validate user: no login provided.");
                    }
                    else
                    {
                        isValidUser = isUserCredentialsValid(userName, password);
                    }

                    if (isValidUser == true)
                    {
                        string strUserData = zxpUD.SerializeZXPUserData(zxpUD);
                        System.Web.Security.FormsAuthenticationTicket ticket = new System.Web.Security.FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddDays(5), true, strUserData);
                        string enticket = System.Web.Security.FormsAuthentication.Encrypt(ticket);
                        System.Web.HttpCookie authcookie = new System.Web.HttpCookie(System.Web.Security.FormsAuthentication.FormsCookieName, enticket);
                        if (ticket.IsPersistent)
                        {
                            authcookie.Expires = ticket.Expiration;
                        }
                        Response.Cookies.Add(authcookie);

                        callAllCleanUpFunctions();
                        callAllUpdateFunctions();
                    }
                    else
                    {
                        exceptionErrorCode = 6;//error code for unable to validate login
                        throw new Exception("User is not valid or does not have permission.");
                    }
                    
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                if (exceptionErrorCode > 0)
                {
                    System.Web.HttpContext.Current.Session["ErrorNum"] = exceptionErrorCode;
                    ErrorLogging.sendtoErrorPage(exceptionErrorCode);
                }
                else {
                    System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                    ErrorLogging.sendtoErrorPage(1);
                } 
            }
        }

        private void callAllUpdateFunctions()
        {
            updateTanksWithCurrentVolumesFromCMS();
            updateIsOpenInCMSStatus();
            //TODO: ADD functions as needed
        }
        private void callAllCleanUpFunctions()
        {
            //TODO: ADD functions as needed
        }

        private bool isUserCredentialsValid(string userName, string password)
        {
            ZXPUserData zxpUD = new ZXPUserData();
            int rowCount = 0;
            bool isValidUser = false;

            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Users WHERE [Password] = @UPASS AND UserName = @UNAME AND isDisabled = 0";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UPASS", MD5Hash(password)),
                                                                                                new SqlParameter("@UNAME", userName)));
                    if (rowCount > 0)
                    {
                        isValidUser = true;
                    }
                    else
                    {
                        isValidUser = false;
                        throw new Exception("Invalid login.");
                    }
                
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanUp isUserCredentialsValid(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanUp isUserCredentialsValid(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
            }
            return isValidUser;
        }

        [System.Web.Services.WebMethod]
        public static List<object[]> getProductsAndVolumeDataFromCMS()
        {
            // OdbcConnection odbcConn = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Conn;
            //OdbcCommand odbcCmd = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Cmd;
            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            

            List<object[]> productVolumeData = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
               
                    //Get product qty on hand details from CMS Server 

                    odbc_helper.ODBC_Cmd.CommandText = "SELECT YCPART, SUM(IFNULL(YCQTYH,0)) AS SumQtyOnHand, IFNULL(YCMINQ, 0) AS MinQty, IFNULL(YCMAXQ, 0) AS MaxQty, YCUNIT AS Unit FROM CMSDAT.MRPIX1 " +
                                            "GROUP BY YCMINQ, YCMAXQ, YCUNIT, YCPART";

                    OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbc_helper.ODBC_Cmd);
                    dsAdapter.Fill(dataSet);

                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        productVolumeData.Add(row.ItemArray);
                    }
                
            }
            catch (OdbcException excep)
            {
                string strErr = "ODBCException Error in dataProcessingAndCleanup getProductVolumesFromCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
                throw excep;
            }
            catch (SqlException excep)
            {
                string strErr = "SQLException Error in dataProcessingAndCleanup getProductVolumesFromCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup getProductVolumesFromCMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
                if (odbc_helper.ODBC_Conn != null && odbc_helper.ODBC_Conn.State != ConnectionState.Closed)
                {
                    odbc_helper.ODBC_Conn.Close();
                    odbc_helper.ODBC_Conn.Dispose();
                }

            }
            return productVolumeData;
        }

        [System.Web.Services.WebMethod]
        public static void updateTankCurrentVolume(int tankID, double newVolume)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.Tanks SET CurrentTankVolume = @VOL WHERE TankID = @TANKID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TANKID", tankID), new SqlParameter("@VOL", newVolume));

                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup updateTankCurrentVolume(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup updateTankCurrentVolume(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
        }
        [System.Web.Services.WebMethod]
        public static List<object> GetTankDataByProduct(string CmsProduct)
        {
            List<object> tankData = new List<object>();
            DataSet dataSet = new DataSet();

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
                        tankData.AddRange(row.ItemArray);
                    }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup GetTankDataByProduct(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup GetTankDataByProduct(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return tankData;
        }

        [System.Web.Services.WebMethod]
        public static int getFirstTankIDOfTankContainingProduct(string CmsProduct)
        {
            int tankID;

            try
            {
                
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP 1 ISNULL(T.TankID, 0) " +
                                        "FROM dbo.Tanks T " +
                                        "INNER JOIN dbo.TankProducts TP ON TP.TankID = T.TankID " +
                                        "WHERE TP.ProductID_CMS = @CMSPROD AND T.isDisabled = 0 AND TP.isDisabled = 0 " +
                                        "ORDER BY T.TankID";
                    tankID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CMSPROD", CmsProduct)));

               
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup getFirstTankIDOfTankContainingProduct(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup getFirstTankIDOfTankContainingProduct(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return tankID;
        }


        [System.Web.Services.WebMethod]
        public static List<int> getTrucksWithPOStillOpenInCMS()
        {
            List<int> truckPO = new List<int>();
            DataSet dataSet = new DataSet();

            try
            {
              
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT PONumber FROM dbo.MainSchedule " +
                                            "WHERE (isHidden = 0 AND LocationShort = 'NOS' " +
                                            "AND StatusID = 10 AND isOpenInCMS = 1) OR  (isHidden = 0 AND LocationShort = 'NOS' " +
                                            "AND TimeDeparted IS NOT NULL AND isOpenInCMS = 1)" +
                                            "ORDER BY PONumber";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        truckPO.Add(Convert.ToInt32(row.ItemArray[0]));
                    }
                
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup getTrucksWithPOStillOpenInCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup getTrucksWithPOStillOpenInCMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return truckPO;
        }


        [System.Web.Services.WebMethod]
        public static bool isPONumOpenInCMSDB(int POnum)
        {
            //OdbcConnection odbcConn = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Conn;
            //OdbcCommand odbcCmd = new TruckScheduleConfigurationKeysHelper_ODBC().ODBC_Cmd;

            TruckScheduleConfigurationKeysHelper_ODBC odbc_helper = new TruckScheduleConfigurationKeysHelper_ODBC();
            try
            {
               
                    //get current status from cms
                    odbc_helper.ODBC_Cmd.CommandText = "SELECT KAOSTS AS openStatus " +
                                                                "FROM CMSDAT.POH AS A WHERE KAPO# = ? " +
                                                                "UNION " +
                                                                "SELECT DCSTAT AS openStatus " +
                                                                "FROM CMSDAT.OCRH AS B WHERE DCORD# = ? ";

                    odbc_helper.ODBC_Cmd.Parameters.Add("POnum", OdbcType.Numeric).Value = POnum;
                    odbc_helper.ODBC_Cmd.Parameters.Add("POnum2", OdbcType.Numeric).Value = POnum;
                    odbc_helper.ODBC_Cmd.CommandType = System.Data.CommandType.Text;
                object result = odbc_helper.ODBC_Cmd.ExecuteScalar();

                if (result != null)
                {
                    string POStatus = result.ToString().Trim().ToUpper();
                    if (POStatus == "C")
                    { //C status is closed/complete; all else keep open
                        return false;
                    }
                }
                else {
                    //at the moment, keep open; need to confirm with zxp what to do when PO cannot be found
                }
                  

                    
              
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in dataProcessingAndCleanup isPONumOpenInCMSDB(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup isPONumOpenInCMSDB(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
                if (odbc_helper.ODBC_Conn != null && odbc_helper.ODBC_Conn.State != ConnectionState.Closed)
                {
                    odbc_helper.ODBC_Conn.Close();
                    odbc_helper.ODBC_Conn.Dispose();
                }
            }
            return true;
        }



        [System.Web.Services.WebMethod]
        public static void closePOStatus(int POnum)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.MainSchedule SET isOpenInCMS = 0" +
                                        "WHERE isHidden = 0 AND PONumber = @PONUM ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PONUM", POnum));
                    ChangeLog cLog;
                    cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "isOpenInCMS", DateTime.Now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "0",null, "PONumber", POnum.ToString());
                    cLog.CreateChangeLogEntryIfChanged();

                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup closePOStatus(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup closePOStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
        }

        [System.Web.Services.WebMethod]
        public static List<bool> checkIfDropTrailerAndEmpty(int POnum)
        {
            bool isDropTrailer = false; 
            bool isEmpty = false;

            try
            {
               
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP 1 ISNULL(isDropTrailer, 'false') FROM dbo.MainSchedule " +
                                            "WHERE isHidden = 0 AND PONumber = @PONUM ";
                    isDropTrailer = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PONUM", POnum)));

                    sqlCmdText = "SELECT TOP 1 ISNULL(isEmpty, 'false') FROM dbo.MainSchedule " +
                                      "WHERE isHidden = 0 AND PONumber = @PONUM ";
                    isEmpty = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PONUM", POnum)));

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup checkIfDropTrailerAndEmpty(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup checkIfDropTrailerAndEmpty(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            List<bool> returnObject = new List<bool>();
            returnObject.Add(isDropTrailer);
            returnObject.Add(isEmpty);
            return returnObject;
        }

        [System.Web.Services.WebMethod]
        public static void removeMSIDAssociationFromTrailer(int POnum)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    
                    sqlCmdText = "UPDATE dbo.TrailersInYard SET MSID = null " +
                                        "WHERE MSID = (SELECT TOP 1 MSID FROM dbo.MainSchedule WHERE PONumber = @PONUM AND isHidden = 0)";
                    
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PONUM", POnum));
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup removeMSIDAssociationFromTrailer(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup removeMSIDAssociationFromTrailer(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
        }



        [System.Web.Services.WebMethod]
        public static List<int> updateIsOpenInCMSStatus()
        {
            List<int> unupdatedDropTrailerPO = new List<int>();
            
            try
            {
               //1 get PO released trucks that are open in trucksched db
                List<int> openPO = getTrucksWithPOStillOpenInCMS();
                foreach (int PONum in openPO) 
                {
                    if (!isPONumOpenInCMSDB(PONum)) { //check if status in cms is not open
                        
                        List<bool> isDropAndEmpty = checkIfDropTrailerAndEmpty(PONum); //check if PO has an umemptied drop trailer
                        bool isDrop = isDropAndEmpty[0];
                        bool isEmpty = isDropAndEmpty[1];
                        if (isDrop && !isEmpty) 
                        {   //do not update isOpen flag
                            //keep track of POs
                         //   msg = "There are PO's with drop trailers that could not be updated because they are not emptied.";
                            unupdatedDropTrailerPO.Add(PONum);
                        }
                        else { 
                            //update isOpen Flag
                            closePOStatus(PONum);
                            if (isDrop)
                            {
                                removeMSIDAssociationFromTrailer(PONum); //CMS Closes out drop trailers but trailers can remain onsite
                            }
                        }
                    }
                }
                   
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup updateIsOpenInCMSData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
            }
            return unupdatedDropTrailerPO;
        }

        [System.Web.Services.WebMethod]
        public static List<int> updateIsOpenInCMSStatusWithByPass()
        {
            List<int> unupdatedDropTrailerPO = new List<int>();

            try
            {
                //1 get PO released trucks that are open in trucksched db
                List<int> openPO = getTrucksWithPOStillOpenInCMS();
                foreach (int PONum in openPO)
                {
                    if (!isPONumOpenInCMSDB(PONum))
                    { //check if status in cms is not open

                        List<bool> isDropAndEmpty = checkIfDropTrailerAndEmpty(PONum); //check if PO has an umemptied drop trailer
                        bool isDrop = isDropAndEmpty[0];
                      
                        //update isOpen Flag
                        closePOStatus(PONum);
                        if (isDrop)
                        {
                            removeMSIDAssociationFromTrailer(PONum);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup updateIsOpenInCMSData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
            }
            return unupdatedDropTrailerPO;
        }


        [System.Web.Services.WebMethod]
        public static List<object> updateTanksWithCurrentVolumesFromCMS()
        {
            int specialTanksConfigurationCount = 0;
            int prodWithMismatchedUnit = 0;
            try
            {
                //TODO use webservice once set up on server
               // localhost.CleanUpAndProcessing CAPservice = new localhost.CleanUpAndProcessing();
               // CAPservice.Timeout = 10 * 60 * 60 * 1000; //set to 10 min
               // check = CAPservice.updateTanksWithCurrentVolumesFromCMS().ToList();
                List<object[]> cmsAllProdData = getProductsAndVolumeDataFromCMS().ToList();

                foreach (object[] cmsProd in cmsAllProdData)
                {
                    string productName = cmsProd[0].ToString();
                    double productVolume = Convert.ToDouble(cmsProd[1]);
                    List<object> tankData = GetTankDataByProduct(productName).ToList();
                    int numOfTanksWProductFound = Convert.ToInt32(tankData[2]);
                    int maxTotalNumOfProductsInTanksFound = Convert.ToInt32(tankData[3]);

                    if (1 == numOfTanksWProductFound && 1 == maxTotalNumOfProductsInTanksFound)
                    {
                        string unit = cmsProd[4].ToString().ToUpper();
                        if (unit.CompareTo("GAL") == 0 || unit.CompareTo("GALS") == 0) //TODO: ask if tanks update should only check for units with GAL
                        {
                            int tankID = getFirstTankIDOfTankContainingProduct(productName);
                            updateTankCurrentVolume(tankID, productVolume);
                        }
                        else
                        {
                            prodWithMismatchedUnit += 1;
                        }

                    }
                    else if (numOfTanksWProductFound > 1 || maxTotalNumOfProductsInTanksFound > 1)
                    {
                        specialTanksConfigurationCount += 1;
                    }
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in dataProcessingAndCleanup updateTanksWithCurrentVolumesFromCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in dataProcessingAndCleanup updateTanksWithCurrentVolumesFromCMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {

            }
            List<object> returnObj = new List<object>();
            returnObj.Add(specialTanksConfigurationCount);
            returnObj.Add(prodWithMismatchedUnit);
            return returnObj;
        }


        //password hasher
        private static string MD5Hash(string INPUT)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.UTF8.GetBytes(INPUT));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            return sBuilder.ToString();
        }
    }
}