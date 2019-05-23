using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Diagnostics;
using System.Configuration;

namespace TransportationProject
{
    public class AlertMessenger
    {
        public List<string> _emailAddressesTO {get; set;}
        public List<string> _emailAddressesCC {get; set;}
        public List<string> _emailAddressesBCC {get; set;}
        public string _subject {get; set;}
        public string _body {get; set;}
        public string _from {get; set;}


        public AlertMessenger()
        {
            
        this._emailAddressesTO = new List<string>();
        this._emailAddressesCC = new List<string>();
        this._emailAddressesBCC = new List<string>();
        this._subject = string.Empty;
        this._body = string.Empty;
        this._from = string.Empty;
        }

        public AlertMessenger(List<string> eAddressTo, List<string> eAddressCC, List<string> eAddressBCC, string eSubject, string eBody, string eFrom)
        {

            this._emailAddressesTO = eAddressTo;
            this._emailAddressesCC = eAddressCC;
            this._emailAddressesBCC = eAddressBCC;
            this._subject = eSubject;
            this._body = eBody;
            this._from = eFrom;
      

        }
        public List<object> sendAlertMessage()
        {
            return sendAlertMessage(false);
        }

        
        public List<object> sendAlertMessage(bool isHtml)
            {   
            bool didSucceed = false;
            string returnMsg = string.Empty;

            MailMessage newAlertMsg = new MailMessage();
            newAlertMsg.IsBodyHtml = isHtml;
            newAlertMsg.From = new MailAddress(this._from);
            foreach(string eaTO in this._emailAddressesTO)
            {
               newAlertMsg.To.Add(eaTO);
            }
            foreach(string eaCC in this._emailAddressesCC)
            {
               newAlertMsg.CC.Add(eaCC);
            }

            foreach (string eaCC in this._emailAddressesCC)
            {
                newAlertMsg.CC.Add(eaCC);
            }

            newAlertMsg.Subject = this._subject;
            newAlertMsg.Body = this._body;

            try
            {
                string smtpHost = ConfigurationManager.AppSettings["SmtpHost"];
                string smtpIP = ConfigurationManager.AppSettings["SmtpIPAddress"];
                
                int smtpPort =  Convert.ToInt16(ConfigurationManager.AppSettings["SmtpPort"]);
                string smtpUser = ConfigurationManager.AppSettings["SmtpUser"];
                string smtpPass = ConfigurationManager.AppSettings["SmtpPass"];
                if (string.IsNullOrEmpty(smtpHost) || string.IsNullOrEmpty(smtpIP) || (0 == smtpPort) || string.IsNullOrEmpty(smtpUser) || string.IsNullOrEmpty(smtpPass))
                {
                    returnMsg = "Missing Configuration for Alert Messaging. ";
                    throw new Exception(returnMsg);
                    
                }

                using (SmtpClient smtp = new SmtpClient(smtpIP))
                {
                    smtp.Host = smtpHost;
                    smtp.EnableSsl = true;
                    smtp.Port = smtpPort;
                    smtp.Credentials = new System.Net.NetworkCredential(smtpUser, smtpPass);
                    smtp.Send(newAlertMsg);
                    didSucceed = true;
                    returnMsg = "Alert message sent successfully.";
                }
                   
                    
                
            }
            catch(Exception ex) 
            {
                string strErr = " Exception Error in AlertMessenger sendAlertMessage(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                didSucceed = false;
                returnMsg = returnMsg + "Unable to send alert message due to an error. Please try again. If the error continues please contact your IT Administrator or Application Manager. ";
                throw ex; 
            }


            List<object> returnObj = new List<object>();
            returnObj.Add(didSucceed);
            returnObj.Add(returnMsg);

            return returnObj;
            
        }
        
    }
}