using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using System.Threading;

namespace TransportationProject
{
    public class ErrorLogging
    {

        public static bool WriteEvent(string MessageText,
                            EventLogEntryType eventType = EventLogEntryType.Information, 
                            string SourceApp = "zxptransportationproject",
                            string logName = "Application")
        {
            EventLog EventLog1 = new EventLog();

            try
            {
                if (!EventLog.SourceExists(SourceApp))
                {
                    EventLog.CreateEventSource(SourceApp, logName);
                }
                EventLog1.Source = SourceApp;
                EventLog1.WriteEntry(MessageText, eventType);
                if (eventType == EventLogEntryType.Error) {
                    sendEmailWithErrorDetails(MessageText, eventType);
                }
                EventLog1.Close();
                return true;
            }
            catch (Exception ex)
            {
                ex.ToString();
                //throw ex;
                //Could not write to log; but shouldn't error out application
            }
            return false;
        }


        public static void sendEmailWithErrorDetails(string MessageText, EventLogEntryType eventType = EventLogEntryType.Information)
        {   try
            {
                string ipOfServer = Convert.ToString(HttpContext.Current.Request.Url.Host);
                //System.Net.Dns.GetHostName();
                string truckReservationEmail = new TruckScheduleConfigurationKeysHelper().truckReservationEmail;
                string alertEmails = new TruckScheduleConfigurationKeysHelper().ErrorAlertEmailAddress;
                AlertMessenger aMsgr = new AlertMessenger();
                object rObj = null;
                aMsgr._emailAddressesTO.Add(alertEmails);
                //aMsgr._emailAddressesTO.Add("clloren@mi4.com");
                aMsgr._from = truckReservationEmail;
                aMsgr._subject = "[Error Logging]- Truck Schedule Application Auto Email";
                aMsgr._body = "EventLogEntryType " + eventType.ToString() + " found :" + MessageText + " . From address : " + ipOfServer;

                
                   rObj = aMsgr.sendAlertMessage();
            }
            catch (Exception ex)
            {
                ex.ToString();

             
            }
            
        
        }


        public static void sendtoErrorPage(int ErrorCode)
        {
            string strRedirect = "~/ErrorPage.aspx?ErrorCode=" + ErrorCode.ToString();
            try
            {
                HttpContext.Current.Response.Redirect(strRedirect,false);
              
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
            
               
            }
        }
    }


}