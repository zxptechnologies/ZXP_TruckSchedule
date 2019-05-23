using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;
using Microsoft.ApplicationBlocks.Data;

namespace TransportationProject
{
    public partial class Admin_Weights : System.Web.UI.Page
    {
        protected static String sql_connStr;
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

                    if (true) //make sure this matches whats in Site.Master and Default
                    {
                        sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                        if (sql_connStr == String.Empty)
                        {
                            throw new Exception("Missing SQLConnectionString in web.config");
                        }
                    }
                    //else 
                    //{
                    //    Response.BufferOutput = true;
                    //    Response.Redirect("/ErrorPage.aspx?ErrorCode=5", false);
                    //}

                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false);//zxp live url
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Weights Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

        }
        [System.Web.Services.WebMethod]
        public static bool checkIfEnabled()
        {
            bool isEnabled = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT isEnabled FROM dbo.ManualWeights";
                    isEnabled = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Weights checkIfEnabled(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isEnabled;
        }

        [System.Web.Services.WebMethod]
        public static void updateManualInputValue(bool isEnabled)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    if (isEnabled == true)
                    {
                        sqlCmdText = "UPDATE dbo.ManualWeights SET isEnabled = 'true'";
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.ManualWeights SET isEnabled = 'false'";
                    }

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText);
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Weights updateManualInputValue(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
    }
}