using Microsoft.ApplicationBlocks.Data;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;

namespace TransportationProject
{
    public partial class Site_Mobile : System.Web.UI.MasterPage
    {
        protected static String sql_connStr;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                if (sql_connStr == String.Empty)
                {
                    throw new Exception("Missing SQLConnectionString in web.config");
                }
                Response.AddHeader("pragma", "no-cache");
                Response.AddHeader("cache-control", "private, no-cache, no-store, must-revalidate");
                Response.AddHeader("cache-control", "post-check=0, pre-check=0");
                Response.AddHeader("Expires", DateTime.Now.AddDays(-1).ToString());
                Response.AddHeader("Last-Modified", DateTime.Now.ToString());
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.Now.AddDays(-1));
                Response.Cache.SetNoStore();
                createMenuItems();
                getDeploymentData();
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in guardStation Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in guardStation Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

        }


        private void createMenuItems()
        {
            try
            {
                string currentUrl = Request.Url.ToString();

                HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    ZXPUserData zxpUD = new ZXPUserData();
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);
                    AuditLog aLog = new AuditLog(zxpUD._uid);
                    aLog.createNewAuditLogEntry(aLog);
                    MenuItem temp = new MenuItem();
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isGuard || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin || zxpUD._isAccountManager)
                    {
                        temp.NavigateUrl = "~/trailerOverview.aspx";
                        temp.Text = "Truck Schedule";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem(); //need to set to new Menuitem for next and prevent index bound error 
                    }
                    if (zxpUD._isAdmin || zxpUD._isGuard || zxpUD._isAccountManager)
                    {
                        temp.NavigateUrl = "~/guardStation.aspx";
                        temp.Text = "Guard Station";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem(); //need to set to new Menuitem for next and prevent index bound error 
                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin || zxpUD._isGuard || zxpUD._isYardMule)
                    {
                        temp.NavigateUrl = "~/yardAndWaiting.aspx";
                        temp.Text = "Yard and Waiting Area";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLoader)
                    {

                        temp.NavigateUrl = "~/inspectionMobile.aspx";
                        temp.Text = "Inspections";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();

                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin)
                    {
                        temp.NavigateUrl = "~/Samples.aspx";
                        temp.Text = "Samples";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._uid != -1) //make available to everyone logged in
                    {
                        temp.NavigateUrl = "~/waitAndDockOverview.aspx";
                        temp.Text = "Dashboard";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager)
                    {
                        temp.NavigateUrl = "~/dockManager.aspx";
                        temp.Text = "Dock Manager";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (true)
                    {
                        temp.NavigateUrl = "~/loadermobile.aspx";
                        temp.Text = "Loader Mobile";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isLoader)
                    {
                        temp.NavigateUrl = "~/loaderTimeTracking.aspx";
                        temp.Text = "Loader Requests";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isYardMule)
                    {
                        temp.NavigateUrl = "~/yardMuleRequestOverview.aspx";
                        temp.Text = "Yard Mule Requests";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._canViewReports)
                    {
                        temp.NavigateUrl = Properties.Settings.Default.ReportViewerLink;
                        temp.Text = "Reports";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._isGuard || zxpUD._isLabAdmin || zxpUD._isLabPersonnel || zxpUD._isAccountManager || zxpUD._isAdmin)
                    {
                        temp.NavigateUrl = "~/COFAUpload.aspx";
                        temp.Text = "COFA Upload";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._isLabAdmin || zxpUD._isLabPersonnel || zxpUD._isGuard || zxpUD._isAdmin)
                    {
                        temp.NavigateUrl = "~/rejectTruck.aspx";
                        temp.Text = "Reject Truck";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }
                    if (zxpUD._isAdmin)
                    {
                        temp.NavigateUrl = "~/AdminMainPage.aspx";
                        temp.Text = "Admin";
                        NavigationMenu.Items.Add(temp);
                        temp = new MenuItem();
                    }

                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Site.Master createMenuItems(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

        }
        private void getDeploymentData()
        {
            string sqlGetDeploymentInfo = "SELECT TOP 1 DI.DeploymentVersion, DI.DeploymentDate " +
                                                "FROM dbo.DeploymentInfo AS DI " +
                                                "ORDER BY DI.DeploymentVersion DESC";

            DataSet dsDeploymentInfo;
            try
            {
                dsDeploymentInfo = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlGetDeploymentInfo);

                System.Data.DataRow row = dsDeploymentInfo.Tables[0].Rows[0];
                string depVer = row["DeploymentVersion"].ToString();
                DateTime depDate = Convert.ToDateTime(row["DeploymentDate"]);
                string stringBuilder = "Version: " + depVer + " Date: " + depDate.ToShortDateString().ToString();
                this.deploymentInfo.Text = stringBuilder;

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Site.Master getDeploymentData(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Site.Master getDeploymentData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }



    }
}