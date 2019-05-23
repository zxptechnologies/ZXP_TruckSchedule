using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;

namespace TransportationProject
{
    public partial class _Default : Page
    {
        private class summaryMenuItem
        {
            public string strURL { get; set; }
            public string strTitle { get; set; }
            public string strSummary { get; set; }
        }

        public static ZXPUserData zxpUD = new ZXPUserData();


        void Page_PreInit(Object sender, EventArgs e)
        {
            if (Request.Browser.IsMobileDevice)
            {
                this.MasterPageFile = "~/Site.Mobile.master";
            }
            else
            {
                this.MasterPageFile = "~/Site.master";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try 
            {

                HttpCookie cookie = Request.Cookies[System.Web.Security.FormsAuthentication.FormsCookieName];
                if (null != cookie && !string.IsNullOrEmpty(cookie.Value))
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(cookie.Value);
                    zxpUD = ZXPUserData.DeserializeZXPUserData(ticket.UserData);
                }
                else 
                {
                    Response.BufferOutput = true;
                  //  Response.Redirect("/Account/Login.aspx?ReturnURL=/Default.aspx", false); mi4 url
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/Default.aspx", false);//zxp live url
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Default Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }


        [System.Web.Services.WebMethod]
        public static object getMenuSummaryItems()
        {
            List<summaryMenuItem> summaryItems = new List<summaryMenuItem>();
            try
            {
                if (zxpUD._isValid)
                {
                    summaryMenuItem temp = new summaryMenuItem();

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isGuard || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin || zxpUD._isAccountManager)
                    {
                        temp.strURL = "trailerOverview.aspx";
                        temp.strTitle = "Truck Schedule";
                        temp.strSummary = "View, create, edit, and delete schedule for trucks";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem(); //need to set to new Menuitem for next and prevent index bound error 
                        
                    }

                    if (zxpUD._isAdmin || zxpUD._isGuard || zxpUD._isAccountManager)
                    {
                        temp.strURL = "guardStation.aspx";
                        temp.strTitle = "Guard Station";
                        temp.strSummary = "Check and Weigh in/out trucks";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem(); //need to set to new Menuitem for next and prevent index bound error 

                    }

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin || zxpUD._isGuard || zxpUD._isYardMule)
                    {
                        temp.strURL = "yardAndWaiting.aspx";
                        temp.strTitle = "Yard and Waiting Area";
                        temp.strSummary = "View Trucks and Drop Trailers currently in Yard and Waiting Area";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();

                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLoader)
                    {
                        temp.strURL = "inspectionMobile.aspx";
                        temp.strTitle = "Inspections";
                        temp.strSummary = "View, create, edit, and delete inspections for a PO";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();

                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isInspector || zxpUD._isLabPersonnel || zxpUD._isLoader || zxpUD._isLabAdmin)
                    {
                        temp.strURL = "Samples.aspx";
                        temp.strTitle = "Samples";
                        temp.strSummary = "View, create, edit, and delete samples";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                    if (zxpUD._uid != -1) //make available to everyone logged in
                    {
                        temp.strURL = "waitAndDockOverview.aspx";
                        temp.strTitle = "Dashboard";
                        temp.strSummary = "View trucks and their current location and status";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager)
                    {
                        temp.strURL = "dockManager.aspx";
                        temp.strTitle = "Dock Manager";
                        temp.strSummary = "Assign, edit, and view current requests for loaders and yardmule";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }

                    if (true)
                    {
                        temp.strURL = "loadermobile.aspx";
                        temp.strTitle = "Loader Mobile";
                        temp.strSummary = "Loader Quick Launch Page";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }

                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isLoader)
                    {
                        temp.strURL = "loaderTimeTracking.aspx";
                        temp.strTitle = "Loader Requests";
                        temp.strSummary = "View requests for Loader";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                    if (zxpUD._isAdmin || zxpUD._isDockManager || zxpUD._isYardMule)
                    {
                        temp.strURL = "yardMuleRequestOverview.aspx";
                        temp.strTitle = "Yard Mule Requests";
                        temp.strSummary = "View requests for Yard Mule";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                    if (zxpUD._canViewReports)
                    {
                        temp.strURL = Properties.Settings.Default.ReportViewerLink;
                        temp.strTitle = "Reports";
                        temp.strSummary = "View Reports";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                    if (zxpUD._isGuard || zxpUD._isLabAdmin || zxpUD._isLabPersonnel  || zxpUD._isAccountManager || zxpUD._isAdmin)
                    {
                        temp.strURL = "COFAUpload.aspx";
                        temp.strTitle = "COFA Upload";
                        temp.strSummary = "View, upload, or bypass COFAs";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                    if (zxpUD._isLabAdmin || zxpUD._isLabPersonnel || zxpUD._isGuard || zxpUD._isAdmin)
                    {
                        temp.strURL = "rejectTruck.aspx";
                        temp.strTitle = "Reject Truck";
                        temp.strSummary = "Reject trucks";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }

                    if (zxpUD._isAdmin)
                    {
                        temp.strURL = "AdminMainPage.aspx";
                        temp.strTitle = "Admin";
                        temp.strSummary = "View Admin page for creating, editing  and deleting application related data";
                        summaryItems.Add(temp);
                        temp = new summaryMenuItem();
                    }
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Default getMenuSummaryItems(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return summaryItems;

        }

        
    }
}