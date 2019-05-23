using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Transactions;
using System.Diagnostics;
using System.Web.UI.HtmlControls;

namespace TransportationProject
{
    public partial class AdministratorMainPage : System.Web.UI.Page
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
                        Response.Redirect("/ErrorPage.aspx?ErrorCode=5", false);
                    }

                }
                else
                {
                    Response.BufferOutput = true;
                    //Response.Redirect("/Account/Login.aspx?ReturnURL=/AdminMainPage.aspx", false); mi4 url
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false);//zxp live url
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in AdminMainPage Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        protected void adminMenuItemClick(object sender, MenuEventArgs e)
        {
            iframeContent.Attributes["src"] = NavigationMenu.SelectedItem.NavigateUrl;
            iframeContent.DataBind();
            string JS = "javascript:onclick:hideContent()";

            e.Item.NavigateUrl = JS;
        }

    }
}