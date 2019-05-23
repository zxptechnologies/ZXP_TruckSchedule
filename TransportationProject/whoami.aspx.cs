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

namespace TransportationProject
{
    public partial class whoami : System.Web.UI.Page
    {
        protected static String sql_connStr;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
              
                HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    //ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();



                        sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                        if (sql_connStr == String.Empty)
                        {
                            throw new Exception("Missing SQLConnectionString in web.config");
                        }
                     
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/trailerOverview.aspx", false); //zxp live url
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TrailerOverview Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TrailerOverview Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static ZXPUserData GetLoggedInUser()
        {
            return ZXPUserData.GetZXPUserDataFromCookie(); ;
        }

    }
}