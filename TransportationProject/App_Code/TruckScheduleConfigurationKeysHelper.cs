using System;
using System.Configuration;
using System.Data;
using System.Data.Odbc;
using System.Diagnostics;

namespace TransportationProject
{
    public class TruckScheduleConfigurationKeysHelper
    {
        public String sql_connStr { get; private set; }
        public String truckReservationEmail { get; private set; }
        public string ErrorAlertEmailAddress { get; private set; }

        public TruckScheduleConfigurationKeysHelper()
        {
            initialize();
        }

        private void initialize()
        {
            setConnectionStringFromConfig();
            setTruckReservationEmail();
            setErrorAlertEmailAddress();
        }

        private void setConnectionStringFromConfig()
        {
            try
            {
                sql_connStr = ConfigurationManager.ConnectionStrings["SQLConnectionString"].ConnectionString;
                if (sql_connStr == String.Empty)
                {
                    throw new Exception("Missing SQLConnectionString in web.config");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in ConfigurationKeysHelper setConnectionStringFromConfig(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        private void setErrorAlertEmailAddress()
        {
            try
            {
                ErrorAlertEmailAddress = ConfigurationManager.AppSettings["ErrorAlertEmailAddress"];
                if (truckReservationEmail == String.Empty)
                {
                    throw new Exception("Missing ErrorAlertEmailAddress in web.config");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in ConfigurationKeysHelper setErrorAlertEmailAddress(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        private void setTruckReservationEmail()
        {
            try
            {
                truckReservationEmail = ConfigurationManager.AppSettings["SmtpUser"];
                if (truckReservationEmail == String.Empty)
                {
                    throw new Exception("Missing SmtpUser in web.config");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in ConfigurationKeysHelper setTruckReservationEmail(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
    }


    public class TruckScheduleConfigurationKeysHelper_ODBC
    {
        public OdbcConnection ODBC_Conn { get; private set; }
        public OdbcCommand ODBC_Cmd { get; private set; }

        public TruckScheduleConfigurationKeysHelper_ODBC()
        {
            //initialize
            setODBCConnectionFromConfig();
            setODBCCommandSettings();
        }


        private void setODBCConnectionFromConfig()
        {
            String as400_connStr;
            try
            {
                as400_connStr = ConfigurationManager.ConnectionStrings["AS400ConnectionString"].ConnectionString;
                if (as400_connStr == String.Empty)
                {
                    throw new Exception("Missing ODBCConnectionString in web.config");
                }
                else
                {
                    ODBC_Conn = new OdbcConnection();
                    ODBC_Conn = new OdbcConnection(as400_connStr);

                    if (ODBC_Conn.State != ConnectionState.Open)
                    {
                        ODBC_Conn.Open();
                    }
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in ConfigurationKeysHelper setODBCConnectionFromConfig(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
        private void setODBCCommandSettings()
        {
            ODBC_Cmd = new OdbcCommand();
            ODBC_Cmd.Connection = ODBC_Conn;
            ODBC_Cmd.CommandTimeout = 300;
            ODBC_Cmd.CommandType = CommandType.Text;
        }

    }
}