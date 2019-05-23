using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.Data.SqlClient;

namespace TransportationProject
{
    public partial class loaderInstructions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //TODO: AFTER DB Design is finalized, update this function to retrieve data from DB
        [System.Web.Services.WebMethod]
        public static Object getLoaderPO()
        {
            try
            {
                List<object[]> data = new List<object[]>();
                data.Add(new object[] { "112233", "Inbound" });
                data.Add(new object[] { "445566", "Outbound" });
                data.Add(new object[] { "778899", "Inbound" });
                data.Add(new object[] { "998877", "Outbound" });
                data.Add(new object[] { "665544", "Inbound" });
                data.Add(new object[] { "332211", "Outbound" });

                return data;
            }

            catch (SqlException excep)
            {
                string strErr = " SQLException Error in loaderInstructions getLoaderPO(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in loaderInstructions getLoaderPO(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

            return null;
        }
    }
}