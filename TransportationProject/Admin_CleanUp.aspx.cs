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
    public partial class AdminCleanUp : System.Web.UI.Page
    {
        protected static String sql_connStr;
        protected static String as400_connStr;
       
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
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false); //zxp live url
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in AdminCleanUp Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in AdminCleanUp Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object GetGridData()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                string sqlCmdText;
                sqlCmdText = string.Concat("SELECT MSID, ETA, Comments, PONumber, isDropTrailer ",
                    ",TruckType, isRejected ",
                    ", StatusText, isOpenInCMS, ProdCount, topProdID ",
                    ", ProductName_CMS, PONumber_ZXPOutbound, LocationLong ",
                    "FROM dbo.vw_TrailerGridData ",
                    "ORDER BY ETA, PoNumber");
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in AdminCleanUp GetTrailerGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void CloseOutTruckSchedules(List<int> MSIDs)
        {

            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                DataTable tvp = new DataTable();
                tvp.Columns.Add(new DataColumn("MSID", typeof(int)));

                foreach (int id in MSIDs)
                {
                    tvp.Rows.Add(id);
                }

                using (var scope = new TransactionScope())
                {

                    SqlCommand cmd = new SqlCommand("dbo.sp_truckschedapp_closeOutTruckSchedule");
                    SqlConnection sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }
                    cmd.Connection = sqlConn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlParameter msidarray = cmd.Parameters.AddWithValue("@MSIDList", tvp);
                    msidarray.SqlDbType = SqlDbType.Structured;
                    msidarray.TypeName = "dbo.MSIDList";
                    cmd.Parameters.AddWithValue("@UserID", zxpUD._uid);
                    cmd.ExecuteNonQuery();
                    
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in AdminCleanUp CloseOutTruckSchedules(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

    }
}