using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;

namespace TransportationProject
{
    public class EventAlertsHelper
    {
        protected static String sql_connStr;
        private AlertMessenger aMsgr;
        private TruckScheduleConfigurationKeysHelper TSConfigHelper;

        public EventAlertsHelper()
        { 
            aMsgr = new AlertMessenger();
            TSConfigHelper = new TruckScheduleConfigurationKeysHelper();
        }

        public List<int> getAlertsToTrigger(int eventID)
        {
            List<int> alertsToTrigger = new List<int>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getAlertIDsToTriggerForEvent", new SqlParameter("@pEventID", eventID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        alertsToTrigger.Add(Convert.ToInt32(row["AlertID"]));
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in EventAlertsHelper getAlertsToTrigger(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EventAlertsHelper getAlertsToTrigger(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return alertsToTrigger;
        }

        public void sendAlertsForEvent(int eventID, string customAlertMsg)
        {
            List<int> alertIDs = getAlertsToTrigger(eventID);
            foreach (int aID in alertIDs) 
            {
                createAndSendAlertEmail(aID, customAlertMsg);
                createAndSendAlertSMS(aID, customAlertMsg);
            }
        
        }

        public void createAndSendAlertSMS(int alertID, string additionalMsg)
        {
            DataSet dataSet = new DataSet();
            aMsgr = new AlertMessenger();

            try
            {
                using (var scope = new TransactionScope())
                {
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getSMSSubscribersForAlertwAll", new SqlParameter("@pAlertID", alertID));

                    List<string> SentList = new List<string>();
                    bool canSendAlert = true;

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        canSendAlert = true;
                        if (SentList.Contains(Convert.ToString(row["SMSemail"])))
                        {
                            canSendAlert = false;
                        }

                        if (canSendAlert == true)
                        {
                            aMsgr._emailAddressesTO.Add(Convert.ToString(row["SMSemail"]));
                            aMsgr._from = TSConfigHelper.truckReservationEmail;

                            aMsgr._subject = Convert.ToString(row["SMSMessageSubject"]);
                            aMsgr._body = "Default Message: " + Convert.ToString(row["SMSMessageBody"]);
                            aMsgr._body = (additionalMsg != string.Empty) ? ("Additional Message: " + additionalMsg + aMsgr._body) : aMsgr._body;

                            aMsgr.sendAlertMessage();

                            SentList.Add(Convert.ToString(row["SMSemail"]));
                            aMsgr._emailAddressesTO.Clear();
                        }
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in EventAlertsHelper createAndSendAlertSMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EventAlertsHelper createAndSendAlertSMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {

            }
        }

        public void createAndSendAlertEmail(int alertID, string additionalMsg)
        {
            DataSet dataSet = new DataSet();
            aMsgr = new AlertMessenger();

            try
            {
                using (var scope = new TransactionScope())
                {
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_getEmailSubscribersForAlertwAll", new SqlParameter("@pAlertID", alertID));

                    DateTime now = DateTime.Now;
                    List<string> SentList = new List<string>();
                    bool canSendEmail = true;

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        canSendEmail = true;

                        if (SentList.Contains(Convert.ToString(row["EmailAddress"])))
                        {
                            canSendEmail = false;
                        }

                        if (canSendEmail == true)
                        {
                            aMsgr._emailAddressesTO.Add(Convert.ToString(row["EmailAddress"]));
                            aMsgr._from = TSConfigHelper.truckReservationEmail;

                            aMsgr._subject = Convert.ToString(row["EmailMessageSubject"]);
                            aMsgr._body = "Default Message: " + Convert.ToString(row["EmailMessageBody"]);
                            aMsgr._body = (additionalMsg != string.Empty) ? ("Additional Message: " + additionalMsg + aMsgr._body) : aMsgr._body;

                            aMsgr.sendAlertMessage();

                            SentList.Add(Convert.ToString(row["EmailAddress"]));
                            aMsgr._emailAddressesTO.Clear();
                        }
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in EventAlertsHelper createAndSendAlertEmail(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in EventAlertsHelper createAndSendAlertEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
        }
    }
}