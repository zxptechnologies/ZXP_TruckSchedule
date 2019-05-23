using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using Microsoft.ApplicationBlocks.Data;

namespace TransportationProject
{


    public class MainScheduleEventLogger
    {
        public MainScheduleEvent MSEvent;
        private TruckScheduleConfigurationKeysHelper TSCKHelper;

        public MainScheduleEventLogger()
        {
            initialize();
        }

        private void initialize()
        {
            TSCKHelper = new TruckScheduleConfigurationKeysHelper();
        }

        public int createNewEventLogAndTriggerExistingAlerts(MainScheduleEvent MSEvent, string customAlertMsg)
        {
            this.MSEvent = new MainScheduleEvent(MSEvent);
            int newEventID = 0;
            newEventID = this.createNewEventLogAndTriggerExistingAlerts(customAlertMsg);
            return newEventID;
        }

        public int createNewEventLogAndTriggerExistingAlerts(string customAlertMsg)
        {
            int newEventID = 0;
            try
            {
                newEventID = createNewEventLog(this.MSEvent);
                if (newEventID > 0)
                {
                    this.MSEvent.setEventID(newEventID);
                    EventAlertsHelper eaHelper = new EventAlertsHelper();
                    eaHelper.sendAlertsForEvent(newEventID, customAlertMsg);
                }
                else
                {
                    throw new Exception("Error: Create New Log and Send Alert failed.)");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in MainScheduleEventLogger LogEventAndTriggerExistingAlerts(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }

            return newEventID;
        }

        public void TriggerExistingAlertForEvent(int EventID, string customAlertMsg)
        {
            try
            {
                EventAlertsHelper eaHelper = new EventAlertsHelper();
                eaHelper.sendAlertsForEvent(EventID, customAlertMsg);

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in MainScheduleEventLogger TriggerExistingAlertForEvent(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }
        }


        public int createNewEventLog(MainScheduleEvent MSEvent)
        {
            int nEventID = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    nEventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.StoredProcedure, "sp_truckschedapp_LogMainScheduleEvent", new SqlParameter("@pMSID", MSEvent.MSID),
                                                                                                                                                          new SqlParameter("@pEventTypeID", MSEvent.EventTypeID),
                                                                                                                                                          new SqlParameter("@pEventSubTypeID", TransportHelperFunctions.convertStringEmptyToDBNULL(MSEvent.EventSubtypeID)),
                                                                                                                                                          new SqlParameter("@pTimestamp", MSEvent.TimeStamp),
                                                                                                                                                          new SqlParameter("@pUserID", MSEvent.UserID),
                                                                                                                                                          new SqlParameter("@pIsHidden", MSEvent.isHidden)));
                    if (nEventID == 0)
                    {
                        throw new Exception("CreateNewEventLog Failed");
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in MainScheduleEventLogger createNewEventLog(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                ErrorLogging.sendtoErrorPage(2);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in MainScheduleEventLogger createNewEventLog(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return nEventID;
        }
    }


}