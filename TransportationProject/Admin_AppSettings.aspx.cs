using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using Microsoft.ApplicationBlocks.Data;

namespace TransportationProject
{
    public partial class Admin_AppSettings : System.Web.UI.Page
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

                    if (zxpUD._isAdmin) //make sure this matches whats in Site.Master and Default
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
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); //zxp live url
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false);//zxp live url
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_Inspections Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }


        [System.Web.Services.WebMethod]
        public static bool getAppSettings()
        {
            bool ValidationSetting = false;
            try
            {
                ValidationSetting = InspectionsHelperFunctions.CheckInspectionValidationSetting(sql_connStr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_AppSettings getAppSettings(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return ValidationSetting;


        }

        [System.Web.Services.WebMethod]
        public static void setInspectionValidation(bool validationSetting)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.ApplicationSettings SET Value = @newSetting WHERE SettingName = 'IsInspectionValidationOn'";
                    int settingValue = validationSetting ? 1 : 0;
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@newSetting", settingValue));
                    
                    scope.Complete();
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_AppSettings setInspectionValidation(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
           


        }




    }
}