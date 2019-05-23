using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;

namespace TransportationProject
{
    public partial class patternList : System.Web.UI.Page
    {
        protected static String sql_connStr;
        //protected static String as400_connStr;


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
                sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                if (sql_connStr == String.Empty)
                {
                    throw new Exception("Missing SQLConnectionString in web.config");
                }
                //sql_connStr = ConfigurationManager.AppSettings["SQLConnectionString"];

                //if (string.IsNullOrEmpty(sql_connStr))
                //{
                //    throw new Exception("Missing SQLConnectionString in web.config");
                //}
                //as400_connStr = ConfigurationManager.AppSettings["AS400ConnectionString"];
                //if (string.IsNullOrEmpty(as400_connStr))
                //{
                //    throw new Exception("Missing AS400ConnectionString in web.config");
                //}
                
                //SqlConnection sqlConn = new SqlConnection();

                //close connection if exists
                //sqlConn = new SqlConnection(sql_connStr);
                //if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                //{
                //    sqlConn.Close();
                //    sqlConn.Dispose();
                //}


            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in patternList Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in patternList Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }



        [System.Web.Services.WebMethod]
        public static Object GetPatternsGridData(int MSID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            
            try
            {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT POD.ProductID_CMS, pCMS.ProductName_CMS, PAT.PatternID, PAT.PatternName, PAT.FilePath, " +
                        "PAT.FileNameOld, PAT.FileNameNew " +
                        "FROM dbo.PODetails AS POD " +
                        "INNER JOIN dbo.ProductsCMS AS pCMS ON POD.ProductID_CMS = pCMS.ProductID_CMS " +
                        "INNER JOIN dbo.PatternsProducts AS PatProd ON PatProd.ProductID_CMS = pCMS.ProductID_CMS " +
                        "INNER JOIN dbo.Patterns AS PAT ON PAT.PatternID = PatProd.PatternID " +
                        "WHERE POD.MSID = @MSID AND PatProd.isDisabled = 'false' AND PAT.isHidden = 'false'";

                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in PatternList GetPatternsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;

        } 
        
    }
}