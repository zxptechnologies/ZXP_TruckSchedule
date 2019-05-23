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
using System.Web.UI.WebControls;

namespace TransportationProject
{
    public partial class alertsprocessing : System.Web.UI.Page
    {
        protected static String sql_connStr;
        protected static String truckReservationEmail;
        public static ZXPUserData zxpUD = new ZXPUserData();

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
            int autotrigger = 0;
            try
            {
                //HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                //sql_connStr = ConfigurationManager.AppSettings["SQLConnectionString"];
                truckReservationEmail = ConfigurationManager.AppSettings["SmtpUser"];
                //if (null != cookie && !string.IsNullOrEmpty(cookie.Value))

                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                if (zxpUD._uid != new ZXPUserData()._uid)
                {
                    //System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    //zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);

                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (sql_connStr == String.Empty)
                    {
                        throw new Exception("Missing SQLConnectionString in web.config");
                    }
                    if (truckReservationEmail == String.Empty)
                    {
                        throw new Exception("Missing SmtpUser in web.config");
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    bool isValidLoginURL = false;
                    string userName = Request.QueryString["UN"];
                    string password = Request.QueryString["PS"];
                    string strAuto = Request.QueryString["AUTOTRIGGER"];  //check if this should trigger all 
                    autotrigger = Convert.ToInt32(strAuto);
                    if ((userName == null || userName == String.Empty) || (password == null || password == String.Empty))
                    {
                        exceptionErrorCode = 6;//error code for unable to validate login
                        throw new Exception("Unable to validate user: no login provided.");
                    }
                    else
                    {
                        isValidLoginURL = loginForAlertProcessing(userName, password);
                    }

                    if (isValidLoginURL == true)
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
                    }
                    else
                    {
                        exceptionErrorCode = 6;//error code for unable to validate login
                        throw new Exception("Unable to validate user.");
                    }

                }
                if (1 == autotrigger) {
                    sendAllAlertsAutomatically();
                }

                showContents();
                

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);

                if (exceptionErrorCode > 0)
                {
                    System.Web.HttpContext.Current.Session["ErrorNum"] = exceptionErrorCode;
                    ErrorLogging.sendtoErrorPage(exceptionErrorCode);
                }
                else
                {
                    System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                    ErrorLogging.sendtoErrorPage(1);
                }
            }
        }

        private void sendAllAlertsAutomatically()
        {
             
            DataSet dsDemurrage = getDemurrageAlerts();

            DataSet dsReleased = getReleasedTrucksButOpenInCMSAlerts();
            DataSet dsDrop = getDropTrailerAlerts();
            DataSet dsTanks = getTankNearingCapacityAlerts();
            DataSet dsTrucks = getInactiveTruckAlerts();
            DataSet dsCOFA = getCOFAAlerts();
            DateTime timestamp = DateTime.Now;
            processDataSetAndSendAlertEmail(dsDemurrage, timestamp);
            processDataSetAndSendAlertEmail(dsReleased, timestamp);
            processDataSetAndSendAlertEmail(dsDrop, timestamp);
            processDataSetAndSendAlertEmail(dsTanks, timestamp);
            processDataSetAndSendAlertEmail(dsTrucks, timestamp);
            processDataSetAndSendAlertEmail(dsCOFA, timestamp);

        }

        private void processDataSetAndSendAlertEmail(DataSet dsAlerts, DateTime timestamp)
        {
            foreach (DataRow row in dsAlerts.Tables[0].Rows)
            {
                int alertID = Convert.ToInt32(row["alertID"]);
                int MSID = (row.Table.Columns.Contains("MSID")) ? Convert.ToInt32(row["MSID"]): 0 ;
                string objName = string.Empty;
                string objValue = string.Empty;
                if(row.Table.Columns.Contains("ProductID_CMS"))
                {
                    //objName = "ProductID_CMS";
                    objValue = row["ProductID_CMS"].ToString();
                    
                }

                else if(row.Table.Columns.Contains("TankID"))
                {
                    //objName = "TankID";
                    objValue = row["TankID"].ToString();
                    
                }

                string trailerMsg = getTruckIdentifierMessage(row);
                string tankMsg = getTankCapacityMessage(row);

                if (alertID > 0) {
                    
                    EventAlertsHelper eaHelper = new EventAlertsHelper();
                    eaHelper.createAndSendAlertEmail(alertID, trailerMsg + tankMsg);
                    eaHelper.createAndSendAlertSMS(alertID, trailerMsg + tankMsg);

                    if (row.Table.Columns.Contains("MSID"))
                    {
                        updateAlertRunsTable(alertID, timestamp, Convert.ToInt32(row["MSID"]), objValue);
                    }
                    else {

                        updateAlertRunsTable(alertID, timestamp, null, objValue);
                    }

                }

            }
        }

        
        protected string getTruckIdentifierMessage(DataRow row)
        {


            string PO = (row.Table.Columns.Contains("PONumber")) ? row["PONumber"].ToString() : string.Empty;
            string zxpPO = (row.Table.Columns.Contains("PONumber_ZXPOutbound")) ? row["PONumber_ZXPOutbound"].ToString() : string.Empty;
            string trailer = (row.Table.Columns.Contains("TrailerNumber")) ? row["TrailerNumber"].ToString() : string.Empty;
            List<string> trailerInfo = new List<string>();
            trailerInfo.Add(PO);
            trailerInfo.Add(zxpPO);
            trailerInfo.Add(trailer);
            return createTruckIdentifierMessage(trailerInfo); ;
        }

        protected string getTruckIdentifierMessage(Button btnObj)
        {

            string PONumber = (btnObj.Attributes["PONumber"] != null) ? btnObj.Attributes["PONumber"].ToString() : string.Empty;
            string trailerNumber = (btnObj.Attributes["TrailerNumber"] != null) ? btnObj.Attributes["TrailerNumber"].ToString() : string.Empty;
            string ZXPPONumber = (btnObj.Attributes["PONumber_ZXPOutbound"] != null) ? btnObj.Attributes["PONumber_ZXPOutbound"].ToString() : string.Empty;
            List<string> truckInfo = new List<string>();
            truckInfo.Add(PONumber);
            truckInfo.Add(trailerNumber);
            truckInfo.Add(ZXPPONumber);

            return createTruckIdentifierMessage(truckInfo);
        }


        protected string getTankCapacityMessage(Button btnObj)
        {

            string tankID = (btnObj.Attributes["TankID"] != null) ? btnObj.Attributes["TankID"].ToString() : string.Empty;
            string currentCap = (btnObj.Attributes["CurrentTankVolume"] != null) ? btnObj.Attributes["CurrentTankVolume"].ToString() : string.Empty;
            string tankCap = (btnObj.Attributes["TankCapacity"] != null) ? btnObj.Attributes["TankCapacity"].ToString() : string.Empty;
            string tankPercentage = (btnObj.Attributes["Percentage"] != null) ? btnObj.Attributes["Percentage"].ToString() : string.Empty;
            string tankName = (btnObj.Attributes["TankName"] != null) ? btnObj.Attributes["TankName"].ToString() : string.Empty;
            List<string> tankinfo = new List<string>();
            tankinfo.Add(tankID);
            tankinfo.Add(currentCap);
            tankinfo.Add(tankCap);
            tankinfo.Add(tankPercentage);
            tankinfo.Add(tankName);

            return createTankCapacityMessage(tankinfo);

        }

        protected string getTankCapacityMessage(DataRow row)
        {
            string tankID = (row.Table.Columns.Contains("TankID")) ? row["TankID"].ToString() : string.Empty;
            string currentVol = (row.Table.Columns.Contains("CurrentTankVolume"))? row["CurrentTankVolume"].ToString() : string.Empty;
            string tankCapacity = (row.Table.Columns.Contains("TankCapacity")) ? row["TankCapacity"].ToString() : string.Empty;
            string tankPercentage = (row.Table.Columns.Contains("Percentage")) ? row["Percentage"].ToString() : string.Empty;
            string tankName = (row.Table.Columns.Contains("TankName")) ? row["TankName"].ToString() : string.Empty;
            List<string> tankInfo = new List<string>();
            tankInfo.Add(tankID);
            tankInfo.Add(currentVol);
            tankInfo.Add(tankCapacity);
            tankInfo.Add(tankPercentage);
            tankInfo.Add(tankName);
            return createTankCapacityMessage(tankInfo); ;
        }

        private string createTruckIdentifierMessage(List<string> truckInfo)
        {
            string PONumber = truckInfo[0];
            string trailerNumber = truckInfo[1];
            string ZXPPONumber = truckInfo[2];
            string truckIdentifierMsg = string.Empty;
            truckIdentifierMsg = (PONumber != string.Empty) ? truckIdentifierMsg + " -PO: " + PONumber : truckIdentifierMsg;
            truckIdentifierMsg = (trailerNumber != string.Empty) ? truckIdentifierMsg + " -TrailerNumber: " + trailerNumber : truckIdentifierMsg;
            truckIdentifierMsg = (ZXPPONumber != string.Empty) ? truckIdentifierMsg + " -ZXP PONumber: " + ZXPPONumber : truckIdentifierMsg;
            truckIdentifierMsg = (truckIdentifierMsg != string.Empty) ? Environment.NewLine  + "Regarding" + truckIdentifierMsg + Environment.NewLine : truckIdentifierMsg;

            return truckIdentifierMsg;
        }

        private string createTankCapacityMessage(List<string> tankData)
        {
            string tankMsg = string.Empty;
            string tankID = tankData[0];
            string currentCap = tankData[1];
            string tankCap = tankData[2];
            string tankPercentage = tankData[3];
            string tankName = tankData[4];

            tankMsg = (tankID != string.Empty) ? tankMsg + " -TankID: " + tankName : tankMsg;
            tankMsg = (tankName != string.Empty) ? tankMsg + " -TankName: " + tankID : tankMsg;
            tankMsg = (currentCap != string.Empty) ? tankMsg + " -Current Capacity: " + currentCap : tankMsg;
            tankMsg = (tankCap != string.Empty) ? tankMsg + " -Tank Capacity: " + tankCap : tankMsg;
            tankMsg = (tankPercentage != string.Empty) ? tankMsg + " -Alerting because reached percentage: " + tankPercentage : tankMsg;
            tankMsg = (tankMsg != string.Empty) ? Environment.NewLine + "Regarding" + tankMsg + Environment.NewLine : tankMsg;

            return tankMsg;
            
        }

        public void showContents() 
        {
            createDemurrageAlertsGrid();
            createReleasedTrucksButOpenInCMSGrid();
            createDropTrailerAlertsGrid();
            createTankCapacityAlertsGrid();
            createInactiveTruckAlertsGrid();
            createCOFAAlertsGrid();
        }

        protected int getTimesAlertRan(int alertID, int? MSID, string AlertRunsObjectID)
        {
            int runNum = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TimesRan FROM dbo.AlertRuns WHERE AlertID = @ALERTID";

                    if (MSID == null && string.IsNullOrEmpty(AlertRunsObjectID))
                    {
                        runNum = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ALERTID", alertID)));
                    }
                    else if (MSID != null && string.IsNullOrEmpty(AlertRunsObjectID))
                    {
                        sqlCmdText = sqlCmdText + " AND MSID = @MSID";
                        runNum = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(MSID)),
                                                                                                                    new SqlParameter("@ALERTID", alertID)));
                    }
                    else if (!string.IsNullOrEmpty(AlertRunsObjectID) && MSID == null)
                    {
                        sqlCmdText = sqlCmdText + " AND ObjectID = @OBJID";
                        runNum = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ALERTID", alertID),
                                                                                                                    new SqlParameter("@OBJID", TransportHelperFunctions.convertStringEmptyToDBNULL(AlertRunsObjectID))));
                    }
                    else if (!string.IsNullOrEmpty(AlertRunsObjectID) && MSID != null)
                    {
                        sqlCmdText = sqlCmdText + " AND ObjectID = @OBJID AND MSID = @MSID";
                        runNum = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ALERTID", alertID),
                                                                                                                    new SqlParameter("@MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(MSID)),
                                                                                                                    new SqlParameter("@OBJID", TransportHelperFunctions.convertStringEmptyToDBNULL(AlertRunsObjectID))));
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getTimesAlertRan(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing getTimesAlertRan(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return runNum;
        }

        protected void updateAlertRunsTable(int alertID, DateTime timestamp, int? MSID, string AlertsRunObjectValue)
        {
            try
            {
                int runNum = getTimesAlertRan(alertID, MSID, AlertsRunObjectValue);

                if (runNum > 0)
                {
                    updateAlertRunsEntry(alertID, timestamp, runNum + 1, MSID, AlertsRunObjectValue);
                }
                else
                {
                    createAlertRunsEntry(alertID, timestamp, MSID, AlertsRunObjectValue);
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing updateAlertRunsTable(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing updateAlertRunsTable(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        private void createAlertRunsEntry(int alertID, DateTime timestamp, int? MSID, string AlertRunsObjectID)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_LogAlertRuns", new SqlParameter("@pALERTID", alertID),
                                                                                                                         new SqlParameter("@pTIME", timestamp),
                                                                                                                         new SqlParameter("@pMSID", TransportHelperFunctions.convertStringEmptyToDBNULL(MSID)),
                                                                                                                         new SqlParameter("@pOBJID", TransportHelperFunctions.convertStringEmptyToDBNULL(AlertRunsObjectID)));
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing createAlertRunsEntry(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing createAlertRunsEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
        }

        private void updateAlertRunsEntry(int alertID, DateTime timestamp, int newRunNum, int? MSID, string AlertRunsObjectID)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.AlertRuns SET TimeStampAlertLastRan = @TIME, TimesRan = @RUN WHERE AlertID = @ALERTID";

                    if (MSID == null && string.IsNullOrEmpty(AlertRunsObjectID))
                    {
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ALERTID", alertID));
                    }
                    else if (MSID != null && string.IsNullOrEmpty(AlertRunsObjectID))
                    {
                        sqlCmdText = sqlCmdText + " AND MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(MSID)),
                                                                                             new SqlParameter("@ALERTID", alertID));
                    }
                    else if (!string.IsNullOrEmpty(AlertRunsObjectID) && MSID == null)
                    {
                        sqlCmdText = sqlCmdText + " AND ObjectID = @OBJID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ALERTID", alertID),
                                                                                             new SqlParameter("@OBJID", TransportHelperFunctions.convertStringEmptyToDBNULL(AlertRunsObjectID)));
                    }
                    else if (!string.IsNullOrEmpty(AlertRunsObjectID) && MSID != null)
                    {
                        sqlCmdText = sqlCmdText + " AND ObjectID = @OBJID AND MSID = @MSID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ALERTID", alertID),
                                                                                             new SqlParameter("@MSID", TransportHelperFunctions.convertStringEmptyToDBNULL(MSID)),
                                                                                             new SqlParameter("@OBJID", TransportHelperFunctions.convertStringEmptyToDBNULL(AlertRunsObjectID)));
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing updateAlertRunsEntry(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing updateAlertRunsEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
        }
        
        
        //protected void createAndSendAlertEmail(int alertID, string additionalMsg)
        //{
        //    SqlCommand sqlCmd;
        //    SqlConnection sqlConn = new SqlConnection();
        //    AlertMessenger aMsgr = new AlertMessenger();

        //    try
        //    {

        //        EventAlertsHelper EAHelper = new EventAlertsHelper();
        //        EAHelper.createAndSendAlertEmail(alertID, additionalMsg);

        //        TODO CALL 

        //            sqlConn = new SqlConnection(sql_connStr);
        //            if (sqlConn.State != ConnectionState.Open)
        //            {
        //                sqlConn.Open();
        //            }

        //            SqlParameter paramAlertID = new SqlParameter("@pAlertID", SqlDbType.Int);
        //            paramAlertID.Value = alertID;

    
        //            sqlCmd = new SqlCommand("sp_truckschedapp_getEmailSubscribersForAlertwAll", sqlConn);

        //            sqlCmd.Parameters.Clear();
        //            sqlCmd.Parameters.Add(paramAlertID);
        //            sqlCmd.CommandType = CommandType.StoredProcedure;

        //            DataSet dsAlertData = new DataSet();
        //            DataTable tblAlertData = new DataTable();
        //            System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
        //            dsAlertData.Tables.Add(tblAlertData);
        //            dsAlertData.Load(sqlReader, LoadOption.OverwriteChanges, tblAlertData);
        //            //populate return object
        //            foreach (System.Data.DataRow row in dsAlertData.Tables[0].Rows)
        //            {
        //                aMsgr._emailAddressesTO.Add(Convert.ToString(dsAlertData.Tables[0].Rows[0]["EmailAddress"]));
        //                aMsgr._from = truckReservationEmail;
                        
        //                aMsgr._subject =  Convert.ToString(dsAlertData.Tables[0].Rows[0]["EmailMessageSubject"]);
        //                aMsgr._body = "Default Message: " + Convert.ToString(dsAlertData.Tables[0].Rows[0]["EmailMessageBody"]);
        //                aMsgr._body =  (additionalMsg != string.Empty) ? ("Additional Message:" + additionalMsg + aMsgr._body) : aMsgr._body; 

        //                aMsgr.sendAlertMessage();
                        
        //            }
        //    }
        //    catch (SqlException excep)
        //    {
        //        string strErr = " SQLException Error in alertsProcessing createAndSendAlertEmail(). Details: " + excep.ToString();
        //        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
        //        System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
        //        ErrorLogging.sendtoErrorPage(2);
        //        throw excep;
        //    }
        //    catch (Exception ex)
        //    {
        //        string strErr = " Exception Error in alertsProcessing createAndSendAlertEmail(). Details: " + ex.ToString();
        //        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
        //        System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
        //        ErrorLogging.sendtoErrorPage(1);
        //        throw ex;
        //    }
        //    finally
        //    {
                
        //        if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
        //        {
        //            sqlConn.Close();
        //            sqlConn.Dispose();
        //        }
        //    }
        //}
        //protected void createAndSendAlertSMS(int alertID, string additionalMsg)
        //{
        //    SqlCommand sqlCmd;
        //    SqlConnection sqlConn = new SqlConnection();
        //    AlertMessenger aMsgr = new AlertMessenger();

        //    try
        //    {
        //        EventAlertsHelper EAHelper = new EventAlertsHelper();
        //        EAHelper.createAndSendAlertEmail(alertID, additionalMsg);

        //        sqlConn = new SqlConnection(sql_connStr);
        //        if (sqlConn.State != ConnectionState.Open)
        //        {
        //            sqlConn.Open();
        //        }

        //        SqlParameter paramAlertID = new SqlParameter("@pAlertID", SqlDbType.Int);
        //        paramAlertID.Value = alertID;


        //        sqlCmd = new SqlCommand("sp_truckschedapp_getSMSSubscribersForAlertwAll", sqlConn);

        //        sqlCmd.Parameters.Clear();
        //        sqlCmd.Parameters.Add(paramAlertID);
        //        sqlCmd.CommandType = CommandType.StoredProcedure;

        //        DataSet dsAlertData = new DataSet();
        //        DataTable tblAlertData = new DataTable();
        //        System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
        //        dsAlertData.Tables.Add(tblAlertData);
        //        dsAlertData.Load(sqlReader, LoadOption.OverwriteChanges, tblAlertData);
        //        //populate return object
        //        foreach (System.Data.DataRow row in dsAlertData.Tables[0].Rows)
        //        {
        //            aMsgr._emailAddressesTO.Add(Convert.ToString(dsAlertData.Tables[0].Rows[0]["SMSemail"]));
        //            aMsgr._from = truckReservationEmail;

        //            aMsgr._subject = Convert.ToString(dsAlertData.Tables[0].Rows[0]["SMSMessageSubject"]);
        //            aMsgr._body = "Default Message: " + Convert.ToString(dsAlertData.Tables[0].Rows[0]["SMSMessageBody"]);
        //            aMsgr._body = (additionalMsg != string.Empty) ? ("Additional Message:" + additionalMsg + aMsgr._body) : aMsgr._body;

        //            aMsgr.sendAlertMessage();

        //        }
        //    }
        //    catch (SqlException excep)
        //    {
        //        string strErr = " SQLException Error in alertsProcessing createAndSendAlertSMS(). Details: " + excep.ToString();
        //        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
        //        System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
        //        ErrorLogging.sendtoErrorPage(2);
        //        throw excep;
        //    }
        //    catch (Exception ex)
        //    {
        //        string strErr = " Exception Error in alertsProcessing createAndSendAlertSMS(). Details: " + ex.ToString();
        //        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
        //        System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
        //        ErrorLogging.sendtoErrorPage(1);
        //        throw ex;
        //    }
        //    finally
        //    {
        //        if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
        //        {
        //            sqlConn.Close();
        //            sqlConn.Dispose();
        //        }
        //    }


        //}


        protected void sendOneAlert(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            List<object[]> data = new List<object[]>();
            AlertMessenger aMsgr = new AlertMessenger();
            
            string truckMsg = getTruckIdentifierMessage(btn);
            string tankMsg = getTankCapacityMessage(btn);
            try
            { 
                int alertID = Convert.ToInt32(btn.CommandArgument);
                EventAlertsHelper eaHelper = new EventAlertsHelper();
                eaHelper.createAndSendAlertEmail(alertID, truckMsg + tankMsg);
                eaHelper.createAndSendAlertSMS(alertID, truckMsg + tankMsg);

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing sendOneAlert(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing sendOneAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {

            }
            
        }

        private void createDemurrageAlertsGrid() {

            DataSet dsDemurrage = getDemurrageAlerts();
            int rowCount = 0;
            foreach (DataRow row in dsDemurrage.Tables[0].Rows)
            {
                TableRow tRow = new TableRow();

                TableCell tCell_alertID = new TableCell();
                tCell_alertID.Text = row["alertID"].ToString();
                tRow.Cells.Add(tCell_alertID);

                TableCell tCell_MSID = new TableCell();
                tCell_MSID.Text = row["MSID"].ToString();
                tRow.Cells.Add(tCell_MSID);

                TableCell tCell_TS = new TableCell();
                tCell_TS.Text = row["TimeStamp"].ToString();
                tRow.Cells.Add(tCell_TS);

                TableCell tCell_MinsPassed = new TableCell();
                tCell_MinsPassed.Text = row["MinutesPassed"].ToString();
                tRow.Cells.Add(tCell_MinsPassed);

                TableCell tCell_TriggerMins = new TableCell();
                tCell_TriggerMins.Text = row["TriggerAfterXMinutes"].ToString();
                tRow.Cells.Add(tCell_TriggerMins);

                TableCell tCell_LastRun = new TableCell();
                tCell_LastRun.Text = row["LastRun"].ToString();
                tRow.Cells.Add(tCell_LastRun);

                TableCell tCell_EventID = new TableCell();
                tCell_EventID.Text = row["EventID"].ToString();
                tRow.Cells.Add(tCell_EventID);

                Button btnAlert = new Button();
                TableCell tCell_alertButton = new TableCell();
                btnAlert.ID = ("btnAlertDem_" + row["AlertID"].ToString() + "_" + rowCount.ToString());
                btnAlert.Text = "Send Alert";
                btnAlert.Click += new EventHandler(this.sendOneAlert);
                btnAlert.CommandArgument = row["AlertID"].ToString();
                btnAlert.Attributes.Add("alertID", row["AlertID"].ToString());
                if (row.Table.Columns.Contains("PONumber"))
                {
                    btnAlert.Attributes.Add("PONumber", row["PONumber"].ToString());
                }
                if (row.Table.Columns.Contains("TrailerNumber"))
                {
                    btnAlert.Attributes.Add("TrailerNumber", row["TrailerNumber"].ToString());
                }
                if (row.Table.Columns.Contains("PONumber_ZXPOutbound"))
                {
                    btnAlert.Attributes.Add("PONumber_ZXPOutbound", row["PONumber_ZXPOutbound"].ToString());
                }
                tCell_alertButton.Controls.Add(btnAlert);
                tRow.Cells.Add(tCell_alertButton);


                tblDemmurage.Rows.Add(tRow);
                rowCount++;
            }

        }

        private DataSet getDemurrageAlerts()
        {

            string sqlGetAlerts = "SELECT * FROM dbo.vw_Alerts_isNearDemurrageTimeLimit"; 
            DataSet dsDemurrageAlerts ;
            try {
                dsDemurrageAlerts = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetAlerts);
            }
            catch  (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getAndPopulateDemurrageAlerts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }

            return dsDemurrageAlerts;
        }

        private void createCOFAAlertsGrid() 
        {
            DataSet dsCOFAAlerts = getCOFAAlerts();
            int rowCount = 0;

            foreach (DataRow row in dsCOFAAlerts.Tables[0].Rows)
            {
                TableRow tRow = new TableRow();

                TableCell tCell_alertID = new TableCell();
                tCell_alertID.Text = row["alertID"].ToString();
                tRow.Cells.Add(tCell_alertID);

                TableCell tCell_MSID = new TableCell();
                tCell_MSID.Text = row["MSID"].ToString();
                tRow.Cells.Add(tCell_MSID);

                TableCell tCell_TS = new TableCell();
                tCell_TS.Text = row["TimeStamp"].ToString();
                tRow.Cells.Add(tCell_TS);

                TableCell tCell_MinsPassed = new TableCell();
                tCell_MinsPassed.Text = row["MinutesPassed"].ToString();
                tRow.Cells.Add(tCell_MinsPassed);

                TableCell tCell_TriggerMins = new TableCell();
                tCell_TriggerMins.Text = row["TriggerAfterXMinutes"].ToString();
                tRow.Cells.Add(tCell_TriggerMins);

                TableCell tCell_LastRun = new TableCell();
                tCell_LastRun.Text = row["LastRun"].ToString();
                tRow.Cells.Add(tCell_LastRun);

                Button btnAlert = new Button();
                TableCell tCell_alertButton = new TableCell();
                //btnAlert.ID = ("btnAlert_" + row["AlertID"].ToString());
                btnAlert.ID = ("btnAlertCOFA_" + row["AlertID"].ToString() + "_" + rowCount.ToString());
                btnAlert.Text = "Send Alert";
                btnAlert.Click += new EventHandler(this.sendOneAlert);
                btnAlert.Attributes.Add("alertID", row["AlertID"].ToString());
                if (row.Table.Columns.Contains("PONumber"))
                {
                    btnAlert.Attributes.Add("PONumber", row["PONumber"].ToString());
                }
                if (row.Table.Columns.Contains("TrailerNumber"))
                {
                    btnAlert.Attributes.Add("TrailerNumber", row["TrailerNumber"].ToString());
                }
                if (row.Table.Columns.Contains("PONumber_ZXPOutbound"))
                {
                    btnAlert.Attributes.Add("PONumber_ZXPOutbound", row["PONumber_ZXPOutbound"].ToString());
                }
                btnAlert.CommandArgument = row["AlertID"].ToString();
                tCell_alertButton.Controls.Add(btnAlert);
                tRow.Cells.Add(tCell_alertButton);

                tblFailedToUploadCOFATrailer.Rows.Add(tRow);
                rowCount++;
            }
        }

        private DataSet getCOFAAlerts()
        {
            string sqlGetAlerts = "SELECT * FROM dbo.vw_Alerts_NeedsCOFAUpload";

            DataSet dsCOFAAlerts;
            try
            {
                dsCOFAAlerts = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetAlerts);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getAndPopulateCOFAAlerts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            return dsCOFAAlerts;
        }

        private void createInactiveTruckAlertsGrid()
        {
            DataSet dsInactiveAlerts = getInactiveTruckAlerts();
            int rowCount = 0;

            foreach (DataRow row in dsInactiveAlerts.Tables[0].Rows)
            {
                TableRow tRow = new TableRow();

                TableCell tCell_alertID = new TableCell();
                tCell_alertID.Text = row["alertID"].ToString();
                tRow.Cells.Add(tCell_alertID);

                TableCell tCell_MSID = new TableCell();
                tCell_MSID.Text = row["MSID"].ToString();
                tRow.Cells.Add(tCell_MSID);

                TableCell tCell_TS = new TableCell();
                tCell_TS.Text = row["LastUpdated"].ToString();
                tRow.Cells.Add(tCell_TS);

                TableCell tCell_MinsPassed = new TableCell();
                tCell_MinsPassed.Text = row["MinutesPassed"].ToString();
                tRow.Cells.Add(tCell_MinsPassed);

                TableCell tCell_TriggerMins = new TableCell();
                tCell_TriggerMins.Text = row["TriggerAfterXMinutes"].ToString();
                tRow.Cells.Add(tCell_TriggerMins);

                TableCell tCell_LastRun = new TableCell();
                tCell_LastRun.Text = row["LastRun"].ToString();
                tRow.Cells.Add(tCell_LastRun);

                Button btnAlert = new Button();
                TableCell tCell_alertButton = new TableCell();

                btnAlert.ID = ("btnAlertInactiveTrucks_" + row["AlertID"].ToString() + "_" + rowCount.ToString());
                btnAlert.Text = "Send Alert";
                btnAlert.Click += new EventHandler(this.sendOneAlert);
                btnAlert.Attributes.Add("alertID", row["AlertID"].ToString());
                if (row.Table.Columns.Contains("PONumber"))
                {
                    btnAlert.Attributes.Add("PONumber", row["PONumber"].ToString());
                }
                if (row.Table.Columns.Contains("TrailerNumber"))
                {
                    btnAlert.Attributes.Add("TrailerNumber", row["TrailerNumber"].ToString());
                }
                if (row.Table.Columns.Contains("PONumber_ZXPOutbound"))
                {
                    btnAlert.Attributes.Add("PONumber_ZXPOutbound", row["PONumber_ZXPOutbound"].ToString());
                }
                btnAlert.CommandArgument = row["AlertID"].ToString();
                tCell_alertButton.Controls.Add(btnAlert);
                tRow.Cells.Add(tCell_alertButton);
                tblInactiveTruck.Rows.Add(tRow);
                rowCount++;
            }
        }

        private DataSet getInactiveTruckAlerts()
        { 
            string sqlGetAlerts = "SELECT * FROM dbo.vw_Alerts_InactiveTruck"; 
            
            DataSet dsInactiveAlerts;
            try
            {
                dsInactiveAlerts = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetAlerts);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getAndPopulateInactiveAlerts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            return dsInactiveAlerts;
        }




        private void createDropTrailerAlertsGrid()
        {
            DataSet dsDropTrailerAlerts = getDropTrailerAlerts();
            int rowCount = 0;

            foreach (DataRow row in dsDropTrailerAlerts.Tables[0].Rows)
            {
                TableRow tRow = new TableRow();

                TableCell tCell_alertID = new TableCell();
                tCell_alertID.Text = row["alertID"].ToString();
                tRow.Cells.Add(tCell_alertID);

                TableCell tCell_MSID = new TableCell();
                tCell_MSID.Text = row["MSID"].ToString();
                tRow.Cells.Add(tCell_MSID);

                TableCell tCell_TS = new TableCell();
                tCell_TS.Text = row["TimeStamp"].ToString();
                tRow.Cells.Add(tCell_TS);

                TableCell tCell_MinsPassed = new TableCell();
                tCell_MinsPassed.Text = row["MinutesPassed"].ToString();
                tRow.Cells.Add(tCell_MinsPassed);

                TableCell tCell_TriggerMins = new TableCell();
                tCell_TriggerMins.Text = row["TriggerAfterXMinutes"].ToString();
                tRow.Cells.Add(tCell_TriggerMins);

                TableCell tCell_LastRun = new TableCell();
                tCell_LastRun.Text = row["LastRun"].ToString();
                tRow.Cells.Add(tCell_LastRun);

                TableCell tCell_EventID = new TableCell();
                tCell_EventID.Text = row["EventID"].ToString();
                tRow.Cells.Add(tCell_EventID);

                Button btnAlert = new Button();
                TableCell tCell_alertButton = new TableCell();

                btnAlert.ID = ("btnAlertDropTrailer_" + row["AlertID"].ToString() + "_" + rowCount.ToString());
                btnAlert.Text = "Send Alert";
                btnAlert.Click += new EventHandler(this.sendOneAlert);
                btnAlert.Attributes.Add("alertID", row["AlertID"].ToString());
                if (row.Table.Columns.Contains("PONumber"))
                {
                    btnAlert.Attributes.Add("PONumber", row["PONumber"].ToString());
                }
                if (row.Table.Columns.Contains("TrailerNumber"))
                {
                    btnAlert.Attributes.Add("TrailerNumber", row["TrailerNumber"].ToString());
                }
                if (row.Table.Columns.Contains("PONumber_ZXPOutbound"))
                {
                    btnAlert.Attributes.Add("PONumber_ZXPOutbound", row["PONumber_ZXPOutbound"].ToString());
                }
                btnAlert.CommandArgument = row["AlertID"].ToString();
                tCell_alertButton.Controls.Add(btnAlert);
                tRow.Cells.Add(tCell_alertButton);
                tblDropTrailer.Rows.Add(tRow);
                rowCount++;
            }
        
        }

        private DataSet getDropTrailerAlerts()
        {
            string sqlGetAlerts = "SELECT * FROM dbo.vw_Alerts_InactiveDropTrailers"; 
           
            DataSet dsDropTrailerAlerts;
            try
            {
                dsDropTrailerAlerts = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetAlerts);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getAndPopulateDropTrailerAlerts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            return dsDropTrailerAlerts;
        }

        private void createTankCapacityAlertsGrid()
        {
            DataSet dsTankCapacityAlerts = getTankNearingCapacityAlerts();
            int rowCount = 0;

            foreach (DataRow row in dsTankCapacityAlerts.Tables[0].Rows)
            {
                TableRow tRow = new TableRow();

                TableCell tCell_alertID = new TableCell();
                tCell_alertID.Text = row["AlertID"].ToString();
                tRow.Cells.Add(tCell_alertID);

                TableCell tCell_TankID = new TableCell();
                tCell_TankID.Text = row["TankID"].ToString();
                tRow.Cells.Add(tCell_TankID);

                TableCell tCell_TankName = new TableCell();
                tCell_TankName.Text = row["TankName"].ToString();
                tRow.Cells.Add(tCell_TankName);

                TableCell tCell_TankCurrentCapcity = new TableCell();
                tCell_TankCurrentCapcity.Text = row["CurrentTankVolume"].ToString();
                tRow.Cells.Add(tCell_TankCurrentCapcity);

                TableCell tCell_TankMaxCapcity = new TableCell();
                tCell_TankMaxCapcity.Text = row["TankCapacity"].ToString();
                tRow.Cells.Add(tCell_TankMaxCapcity);

                TableCell tCell_Percentage = new TableCell();
                tCell_Percentage.Text = row["Percentage"].ToString();
                tRow.Cells.Add(tCell_Percentage);

                TableCell tCell_LastRun = new TableCell();
                tCell_LastRun.Text = row["LastRun"].ToString();
                tRow.Cells.Add(tCell_LastRun);

                TableCell tCell_VolumeNeededForTrigger = new TableCell();
                tCell_VolumeNeededForTrigger.Text = row["VolumeNeededForTrigger"].ToString();
                tRow.Cells.Add(tCell_VolumeNeededForTrigger);

                Button btnAlert = new Button();
                TableCell tCell_alertButton = new TableCell();
                //btnAlert.ID = ("btnAlert_" + row["AlertID"].ToString());
                btnAlert.ID = ("btnAlertTankCapacity_" + row["AlertID"].ToString() + "_" + rowCount.ToString());
                btnAlert.Text = "Send Alert";
                btnAlert.Click += new EventHandler(this.sendOneAlert);
                btnAlert.Attributes.Add("alertID", row["AlertID"].ToString());

                if (row.Table.Columns.Contains("TankID"))
                {
                    btnAlert.Attributes.Add("TankID", row["TankID"].ToString());
                }
                if (row.Table.Columns.Contains("TankName"))
                {
                    btnAlert.Attributes.Add("TankName", row["TankName"].ToString());
                }
                if (row.Table.Columns.Contains("CurrentTankVolume"))
                {
                    btnAlert.Attributes.Add("CurrentTankVolume", row["CurrentTankVolume"].ToString());
                }
                if (row.Table.Columns.Contains("TankCapacity"))
                {
                    btnAlert.Attributes.Add("TankCapacity", row["TankCapacity"].ToString());
                }

                if (row.Table.Columns.Contains("Percentage"))
                {
                    btnAlert.Attributes.Add("Percentage", row["Percentage"].ToString());
                }
                btnAlert.CommandArgument = row["AlertID"].ToString();
                tCell_alertButton.Controls.Add(btnAlert);
                tRow.Cells.Add(tCell_alertButton);

                tblTankCapacity.Rows.Add(tRow);
                rowCount++;
            }
        }


        private DataSet getTankNearingCapacityAlerts()
        {

            string sqlGetAlerts = "SELECT * FROM dbo.vw_Alerts_isNearingTankCapacity";

            DataSet dsTankCapacityAlerts;
            try
            {
                dsTankCapacityAlerts = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetAlerts);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getAndPopulateCapacityAlerts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            return dsTankCapacityAlerts;
        }


        private void createReleasedTrucksButOpenInCMSGrid()
        {
            DataSet dsReleasedButOpenAlerts = getReleasedTrucksButOpenInCMSAlerts();
            int rowCount = 0;

            foreach (DataRow row in dsReleasedButOpenAlerts.Tables[0].Rows)
            {
                TableRow tRow = new TableRow();

                TableCell tCell_alertID = new TableCell();
                tCell_alertID.Text = row["alertID"].ToString();
                tRow.Cells.Add(tCell_alertID);

                TableCell tCell_MSID = new TableCell();
                tCell_MSID.Text = row["MSID"].ToString();
                tRow.Cells.Add(tCell_MSID);


                TableCell tCell_MinsPassed = new TableCell();
                tCell_MinsPassed.Text = row["MinutesPassed"].ToString();
                tRow.Cells.Add(tCell_MinsPassed);

                TableCell tCell_TriggerMins = new TableCell();
                tCell_TriggerMins.Text = row["TriggerAfterXMinutes"].ToString();
                tRow.Cells.Add(tCell_TriggerMins);

                TableCell tCell_LastRun = new TableCell();
                tCell_LastRun.Text = row["LastRun"].ToString();
                tRow.Cells.Add(tCell_LastRun);

                Button btnAlert = new Button();
                TableCell tCell_alertButton = new TableCell();
                btnAlert.ID = ("btnRelAlert_" + row["AlertID"].ToString() + "_" + rowCount.ToString());
                btnAlert.Text = "Send Alert";
                btnAlert.Click += new EventHandler(this.sendOneAlert);
                btnAlert.Attributes.Add("alertID", row["AlertID"].ToString());
                if (row.Table.Columns.Contains("PONumber"))
                {
                    btnAlert.Attributes.Add("PONumber", row["PONumber"].ToString());
                }
                if (row.Table.Columns.Contains("TrailerNumber"))
                {
                    btnAlert.Attributes.Add("TrailerNumber", row["TrailerNumber"].ToString());
                }
                if (row.Table.Columns.Contains("PONumber_ZXPOutbound"))
                {
                    btnAlert.Attributes.Add("PONumber_ZXPOutbound", row["PONumber_ZXPOutbound"].ToString());
                }
                btnAlert.CommandArgument = row["AlertID"].ToString();
                tCell_alertButton.Controls.Add(btnAlert);
                tRow.Cells.Add(tCell_alertButton);

                tblReleasedButOpenInCMS.Rows.Add(tRow);
                rowCount++;
            }
        }

        private DataSet getReleasedTrucksButOpenInCMSAlerts()
        {
            string sqlGetAlerts = "SELECT * FROM dbo.vw_Alerts_getPOsOpenInCMSNotInZXP"; 

            DataSet dsReleasedButOpenAlerts;
            try
            {
                dsReleasedButOpenAlerts = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetAlerts);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing getAndPopulateReleasedTrucksButOpenInCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }

            return dsReleasedButOpenAlerts;

        }

        [System.Web.Services.WebMethod]
        public static Object testEmail()
        {
            AlertMessenger aMsgr = new AlertMessenger();
            object rObj = null;
            aMsgr._emailAddressesTO.Add("treservation@zxptech.com");
            aMsgr._emailAddressesTO.Add("treservation@zxptech.com");
            aMsgr._from = truckReservationEmail;
            aMsgr._subject = "TEST EMAIL";
            aMsgr._body = "This is a truck appliction test for sending email.";

            try
            {
                rObj = aMsgr.sendAlertMessage();
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertProcessing testEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return rObj;
        }
        private bool loginForAlertProcessing(string userName, string password)
        {
            ZXPUserData zxpUD = new ZXPUserData();
            int rowCount = 0;
            bool isValidUser = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.Users WHERE [Password] = @UPASS AND UserName = @UNAME AND isDisabled = 0";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@UNAME", userName), new SqlParameter("@UPASS", MD5Hash(password))));

                    if (rowCount > 0)
                    {
                        isValidUser = true;
                    }
                    else
                    {
                        isValidUser = false;
                        throw new Exception("Invalid login.");
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in alertsProcessing loginForAlertProcessing(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in alertsProcessing loginForAlertProcessing(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
            }
            return isValidUser;
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