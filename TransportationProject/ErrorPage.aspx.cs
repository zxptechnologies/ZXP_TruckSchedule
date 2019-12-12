using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;


namespace TransportationProject
{
    public partial class ErrorPage : System.Web.UI.Page
    {

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
                if (!IsPostBack)
                {
                    string errCode = Server.UrlDecode(Request.QueryString["ErrorCode"]);
                    string errClientSideMsg = Request.QueryString["ErrorClientMsg"];

                    if (!string.IsNullOrEmpty(errClientSideMsg))
                    {
                        string strErr = " Exception in client side code: " + errClientSideMsg;
                        ErrorLogging.WriteEvent(strErr, EventLogEntryType.Warning, "zxptransportationproject", "Application", false);
                    }
                    if (int.TryParse(errCode, out int intCode))
                    {
                        switch (intCode)
                        {
                            case 1: lblErrReason.Text = "ERROR " + errCode + ": Processing error occurred. Please try again."; break;
                            case 2: lblErrReason.Text = "ERROR " + errCode + ": Could not connect to SQL server. Please try again."; break;
                            case 3: lblErrReason.Text = "ERROR " + errCode + ": Could not connect to AS400 server. Please try again."; break;
                            case 4: lblErrReason.Text = "ERROR " + errCode + ": Could not connect to MYSQL server. Please try again."; break;
                            case 5: lblErrReason.Text = "ERROR " + errCode + ": User is not permitted to view this page. If this is incorrect, please contact your administrator."; break;
                            case 6: lblErrReason.Text = "ERROR " + errCode + ": Unable to validate user."; break;
                            default: lblErrReason.Text = "Error occurred. Please try again."; break;

                        }
                    }


                }

            }
            catch(Exception ex)
            {
                string strErr = " Exception Error in ErrorPage Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr,EventLogEntryType.Error);
            }
        }
    }
}