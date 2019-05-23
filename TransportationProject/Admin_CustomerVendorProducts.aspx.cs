using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Data.Odbc;
using System.Web.Services;
using System.Transactions;
using System.Diagnostics;
using System.Configuration;


namespace TransportationProject.AdminSubPages
{
    public partial class Admin_CustomerVendorProducts : System.Web.UI.Page
    {
        protected static String sql_connStr;
        protected static String as400_connStr;
        protected static List<object[]> miData = new List<object[]>();


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
                        Response.Redirect("ErrorPage.aspx?ErrorCode=5", false); 
                    }
                }
                else
                {
                    Response.BufferOutput = true;
                    Response.Redirect("Account/Login.aspx?ReturnURL=~/AdminMainPage.aspx", false); 
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getCustomersWithProductsList()
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            try
            {
                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                }

                sqlCmd.Connection = sqlConn;
                sqlCmd.CommandText = "SELECT DISTINCT CP.CustomerID_CMS, CUSTCMS.CustomerName_CMS " +
                                    "FROM dbo.CustomersVendorsProducts AS CP " +
                                    "INNER JOIN dbo.CustomersVendorsCMS as CUSTCMS ON CP.CustomerID_CMS = CUSTCMS.CustomerID_CMS " +
                                    "WHERE (CP.isDisabled = 'false') ";

                DataSet dsLoadData = new DataSet();
                DataTable tblLoadData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsLoadData.Tables.Add(tblLoadData);
                dsLoadData.Load(sqlReader, LoadOption.OverwriteChanges, tblLoadData);

                //populate return object
                foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getCustomersWithProductsList(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getCustomersWithProductsList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;

        } //end of public static List<string> getCustomersWithProductsList()

        [System.Web.Services.WebMethod]
        public static Object getFirsBatchOfCustomers()
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            try
            {
                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                }

                sqlCmd.Connection = sqlConn;
                sqlCmd.CommandText = "SELECT TOP 10 CustomerID_CMS, CustomerName_CMS FROM dbo.CustomersVendorsCMS";

                DataSet dsLoadData = new DataSet();
                DataTable tblLoadData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsLoadData.Tables.Add(tblLoadData);
                dsLoadData.Load(sqlReader, LoadOption.OverwriteChanges, tblLoadData);

                //populate return object
                foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getFirsBatchOfCustomers(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getFirsBatchOfCustomers(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;

        } //end of public static Object getFirst10Customers()

        [System.Web.Services.WebMethod]
        public static int setNewProductToCustomer(string CUSTOMERID_CMS, string PRODUCTID_CMS)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd = new SqlCommand();
            Int32 CustProd_ComboID = 0;
            int rowCount = 0;
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection();
                    sqlCmd = new SqlCommand();
                    sqlConn = new SqlConnection(sql_connStr);


                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;
                    SqlParameter paramCustomerID_CMS = new SqlParameter("@CustomerID_CMS", SqlDbType.Char);
                    SqlParameter paramProductID_CMS = new SqlParameter("@ProductID_CMS", SqlDbType.Char);

                    paramCustomerID_CMS.Value = CUSTOMERID_CMS;
                    paramProductID_CMS.Value = PRODUCTID_CMS;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramCustomerID_CMS);
                    sqlCmd.Parameters.Add(paramProductID_CMS);


                    sqlCmd.CommandText = "SELECT COUNT(*) FROM dbo.CustomersVendorsProducts as CVP " +
                                            "WHERE (CVP.CustomerID_CMS = @CustomerID_CMS AND CVP.ProductID_CMS = @ProductID_CMS AND CVP.isDisabled = 'false')";
                    
                    rowCount = (int)sqlCmd.ExecuteScalar();
                    if(rowCount == 0){
                        sqlCmd.CommandText = "INSERT INTO dbo.CustomersVendorsProducts (CustomerID_CMS, ProductID_CMS, isDisabled) " +
                            "VALUES (@CustomerID_CMS, @ProductID_CMS, 'false'); " +
                            "SELECT CAST(scope_identity() AS int)";
                        CustProd_ComboID = (int)sqlCmd.ExecuteScalar();
                        ///////////////////////////////David 4-20-16
                        ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "CustomersVendorsProducts", "CustomerID_CMS", now, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, CUSTOMERID_CMS.ToString(), null, "CustomerProductID", CustProd_ComboID.ToString());
                        cl.CreateChangeLogEntryIfChanged(sqlConn);

                        cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "CustomersVendorsProducts", "ProductID_CMS", now, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, PRODUCTID_CMS.ToString(), null, "CustomerProductID", CustProd_ComboID.ToString());
                        cl.CreateChangeLogEntryIfChanged(sqlConn);

                        cl = new ChangeLog(ChangeLog.ChangeLogChangeType.INSERT, "CustomersVendorsProducts", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'false'", null, "CustomerProductID", CustProd_ComboID.ToString());
                        cl.CreateChangeLogEntryIfChanged(sqlConn);
                        ////////////////////////////////////////////
                    }
                    else
                    {
                        throw new Exception("This product already exist with this customer");
                    }
                    scope.Complete();
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts setNewProductToCustomer(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts setNewProductToCustomer(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return (int)CustProd_ComboID;


        } //end of setNewProductToCustomer(string CUSTOMERID_CMS, int PRODUCTID_CMS)

        [System.Web.Services.WebMethod]
        public static string getProductNameByID(string PRODUCTID)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            string productName = null;

            try
            {
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    SqlParameter paramProductID = new SqlParameter("@ProductID_CMS", SqlDbType.Char);
                    paramProductID.Value = PRODUCTID;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramProductID);

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;

                    sqlCmd.CommandText = "SELECT TOP (1) PCMS.ProductName_CMS " +
                                            "FROM dbo.ProductsCMS as PCMS " +
                                            "WHERE PCMS.ProductID_CMS = @ProductID_CMS";
                    
                    productName = (string)sqlCmd.ExecuteScalar();

                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getProductNameByID(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getProductNameByID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return productName;
        }//end of getProductNameByID(string PRODUCTID)

        [System.Web.Services.WebMethod]
        public static Object getProductIDByName(string PRODUCTNAME)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<string> productIDs = new List<string>();

            try
            {
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    SqlParameter paramProductName = new SqlParameter("@ProductName_CMS", SqlDbType.Char);
                    paramProductName.Value = PRODUCTNAME;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramProductName);

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;

                    sqlCmd.CommandText = "SELECT PCMS.ProductID_CMS " +
                                            "FROM dbo.ProductsCMS as PCMS " +
                                            "WHERE PCMS.ProductName_CMS = @ProductName_CMS";

                    DataSet dsData = new DataSet();
                    DataTable tblData = new DataTable();
                    System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                    dsData.Tables.Add(tblData);
                    dsData.Load(sqlReader, LoadOption.OverwriteChanges, tblData);

                    //populate return object
                    foreach (System.Data.DataRow row in dsData.Tables[0].Rows) { productIDs.Add(row.ItemArray[0].ToString()); }

                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getProductIDByName(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getProductIDByName(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return productIDs;
        }//end of getProductIDByName(string PRODUCTNAME)
        
        [System.Web.Services.WebMethod]
        public static Object getProductsByCustomerData(string CUSTOMERID_CMS)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            try
            {
                sqlConn = new SqlConnection(sql_connStr);
                if (sqlConn.State != ConnectionState.Open)
                {
                    sqlConn.Open();
                }

                SqlParameter paramCustomerID_CMS = new SqlParameter("@CUSTOMERID_CMS", SqlDbType.NVarChar);
                paramCustomerID_CMS.Value = CUSTOMERID_CMS;

                sqlCmd.Parameters.Clear();
                sqlCmd.Parameters.Add(paramCustomerID_CMS);

                //Connects to DB
                sqlCmd.Connection = sqlConn;

                sqlCmd.CommandText = "SELECT CP.CustomerProductID, CP.ProductID_CMS, PROD.ProductName_CMS " +
                                    "FROM dbo.CustomersVendorsProducts AS CP " + 
                                    "INNER JOIN dbo.ProductsCMS AS PROD ON CP.ProductID_CMS = PROD.ProductID_CMS " +
                                    "WHERE (CP.isDisabled = 'false') AND (CP.CustomerID_CMS = @CustomerID_CMS)";

                DataSet dsLocationData = new DataSet();
                DataTable tblGLocationData = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsLocationData.Tables.Add(tblGLocationData);
                dsLocationData.Load(sqlReader, LoadOption.OverwriteChanges, tblGLocationData);

                //populate return object
                foreach (System.Data.DataRow row in dsLocationData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getProductsByCustomerData(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getProductsByCustomerData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;
        }//end of public static Object getProductsByCustomerData(string CUSTOMERID_CMS)

        [System.Web.Services.WebMethod]
        public static Object getAvailableProducts()
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            try
            {
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;

                    sqlCmd.CommandText = "SELECT PCMS.ProductID_CMS, PCMS.ProductName_CMS " +
                                        "FROM dbo.ProductsCMS as PCMS";

                    DataSet dsData = new DataSet();
                    DataTable tblData = new DataTable();
                    System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                    dsData.Tables.Add(tblData);
                    dsData.Load(sqlReader, LoadOption.OverwriteChanges, tblData);

                    //populate return object
                    foreach (System.Data.DataRow row in dsData.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }

                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getAvailableProducts(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getAvailableProducts(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;
        }//end of public static Object getAvailableProducts()

        [System.Web.Services.WebMethod]
        public static void disableProductToCustomer(int CUSTOMERPROUDCTID)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd;
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    sqlConn = new SqlConnection();
                    sqlCmd = new SqlCommand();

                    sqlConn = new SqlConnection(sql_connStr);
                    sqlConn.Open();

                    SqlParameter paramCustomerProductID = new SqlParameter("@CustomerProductID", SqlDbType.Int);

                    paramCustomerProductID.Value = CUSTOMERPROUDCTID;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramCustomerProductID);

                    //connects to DB 
                    sqlCmd.Connection = sqlConn;
                    ///////////////////////////////David 4-20-16
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "CustomersVendorsProducts", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "CustomerProductID", CUSTOMERPROUDCTID.ToString());
                    cl.CreateChangeLogEntryIfChanged(sqlConn);
                     //////////////////////////////////////
                    sqlCmd.CommandText = "UPDATE dbo.CustomersVendorsProducts " +
                        "SET isDisabled = 'true' " +
                        "WHERE CustomerProductID = @CustomerProductID";

                    sqlCmd.ExecuteNonQuery();
                    scope.Complete();
                }
            }//end of try
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts disableProductToCustomer(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts disableProductToCustomer(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
        }//end of disableProductToCustomer(string CUSTOMERID_CMS, int PRODUCTID_CMS)

        [System.Web.Services.WebMethod]
        public static void disableCustomer(string CUSTOMERID)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd;
            DateTime now = DateTime.Now;
            try
            {
                ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                using (var scope = new TransactionScope())
                {
                    // TransactionScope scope = new TransactionScope();
                    sqlConn = new SqlConnection();
                    sqlCmd = new SqlCommand();

                    sqlConn = new SqlConnection(sql_connStr);
                    sqlConn.Open();

                    SqlParameter paramCustomerID_CMS = new SqlParameter("@CustomerID_CMS", SqlDbType.Char);

                    paramCustomerID_CMS.Value = CUSTOMERID;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramCustomerID_CMS);

                    //connects to DB 
                    sqlCmd.Connection = sqlConn;
                    sqlCmd.CommandText = "UPDATE dbo.CustomersVendorsProducts " +
                        "SET isDisabled = 'true' " +
                        "WHERE CustomerID_CMS = @CustomerID_CMS";
                    ///////////////////////////////David 4-20-16
                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "CustomersVendorsProducts", "isDisabled", now, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, "'true'", null, "CustomerProductID", CUSTOMERID.ToString());
                    cl.CreateChangeLogEntryIfChanged(sqlConn);
                    //////////////////////////////////////
                    sqlCmd.ExecuteNonQuery();


                    scope.Complete();
                }
            }//end of try
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts disableCustomer(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts disableCustomer(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
        }//end of disableCustomer(string CUSTOMERID)

        [System.Web.Services.WebMethod]
        public static Object getCustomerListBasedOnInput(string INPUT)
        {
            OdbcConnection odbcConn = new OdbcConnection();
            OdbcCommand odbcCmd = new OdbcCommand();
            List<object[]> data = new List<object[]>();
            try
            {
                INPUT = INPUT.ToUpper();
                odbcConn = new OdbcConnection(as400_connStr);

                if (odbcConn.State != ConnectionState.Open)
                {
                    odbcConn.Open();
                }
                odbcCmd.Connection = odbcConn;

                odbcCmd.CommandText = "SELECT DISTINCT CUSTID, CUSTNAME " +
                    " FROM (SELECT BVCUST AS CUSTID, BVNAME AS CUSTNAME FROM CMSDAT.CUST " +
                    "UNION SELECT BTVEND AS CUSTID, BTNAME AS CUSTNAME FROM CMSDAT.VEND ) as A " +
                    "WHERE (UPPER(CUSTID) LIKE UPPER(?)) OR (UPPER(CUSTNAME) LIKE UPPER(?)) ";

                odbcCmd.Parameters.Add("@CUSTID", OdbcType.Char).Value = "%" + INPUT + "%";
                odbcCmd.Parameters.Add("@CUSTNAME", OdbcType.Char).Value = "%" + INPUT + "%";

                odbcCmd.CommandType = System.Data.CommandType.Text;
                DataSet dsLoadData = new DataSet();
                OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);

                dsAdapter.Fill(dsLoadData);

                //populate return object
                foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in Admin_CustomerVendorProducts getCustomerListBasedOnInput(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getCustomerListBasedOnInput(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getCustomerListBasedOnInput(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (odbcConn == null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return data;

        } //end of public static Object getFullCustomerList()

        [System.Web.Services.WebMethod]
        public static Object getProductListBasedOnInput(string INPUT)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            try
            {
                using (var scope = new TransactionScope())
                {

                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    SqlParameter paramProdID = new SqlParameter("@ProductID_CMS", SqlDbType.Char);
                    SqlParameter paramProdName = new SqlParameter("@ProductName_CMS", SqlDbType.Char);

                    paramProdID.Value = "%" + INPUT + "%";
                    paramProdName.Value = "%" + INPUT + "%";

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramProdID);
                    sqlCmd.Parameters.Add(paramProdName);

                    sqlCmd.Connection = sqlConn;
                    sqlCmd.CommandText = "SELECT DISTINCT pCMS.ProductID_CMS, pCMS.ProductName_CMS " +
                                        "FROM ProductsCMS as pCMS " +
                                        "WHERE (UPPER(pCMS.ProductID_CMS) LIKE UPPER(@ProductID_CMS)) OR (UPPER (pCMS.ProductName_CMS) LIKE UPPER(@ProductName_CMS))";


                    DataSet dsData = new DataSet();
                    DataTable tblData = new DataTable();
                    System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                    dsData.Tables.Add(tblData);
                    dsData.Load(sqlReader, LoadOption.OverwriteChanges, tblData);

                    //populate return object
                    foreach (System.Data.DataRow row in dsData.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin getTankOptions(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in trailerOverview getTankOptions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn == null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;

        } //end of public static Object getProductListBasedOnInput(string INPUT)

        [System.Web.Services.WebMethod]
        public static void updateProduct(int CUSTOMERPROUDCTID, string PRODUCTID_CMS, string CUSTOMERID_CMS)
        {
            SqlConnection sqlConn = new SqlConnection();
            SqlCommand sqlCmd = new SqlCommand();
            int rowCount = 0;
            DateTime now = DateTime.Now;
            try
            {
                using (var scope = new TransactionScope())
                {
                    ZXPUserData zxpUD = ZXPUserData.GetZXPUserDataFromCookie();
                    sqlConn = new SqlConnection();
                    sqlCmd = new SqlCommand();
                    sqlConn = new SqlConnection(sql_connStr);


                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    //Connects to DB
                    sqlCmd.Connection = sqlConn;
                    SqlParameter paramProductID_CMS = new SqlParameter("@ProductID_CMS", SqlDbType.Char);
                    SqlParameter paramCustomerProductID = new SqlParameter("@CustomerProductID", SqlDbType.Int);
                    SqlParameter paramCustomerID_CMS = new SqlParameter("@CustomerID_CMS", SqlDbType.Char);

                    paramCustomerProductID.Value = CUSTOMERPROUDCTID;
                    paramProductID_CMS.Value = PRODUCTID_CMS;
                    paramCustomerID_CMS.Value = CUSTOMERID_CMS;

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramCustomerProductID);
                    sqlCmd.Parameters.Add(paramProductID_CMS);
                    sqlCmd.Parameters.Add(paramCustomerID_CMS);


                    sqlCmd.CommandText = "SELECT COUNT(*) FROM dbo.CustomersVendorsProducts as CVP " +
                                            "WHERE (CVP.CustomerID_CMS = @CustomerID_CMS AND CVP.ProductID_CMS = @ProductID_CMS AND CVP.isDisabled = 'false')";

                    rowCount = (int)sqlCmd.ExecuteScalar();
                    if (rowCount == 0)
                    {     ///////////////////////////////David 4-20-16
                        ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "CustomersVendorsProducts", "PRODUCTID_CMS", now, zxpUD._uid, ChangeLog.ChangeLogDataType.CHAR, CUSTOMERID_CMS.ToString(), null, "CustomerProductID", CUSTOMERPROUDCTID.ToString());
                        cl.CreateChangeLogEntryIfChanged(sqlConn);
                        //////////////////////////////////////
                        sqlCmd.CommandText = "UPDATE dbo.CustomersVendorsProducts SET PRODUCTID_CMS = @PRODUCTID_CMS WHERE CustomerProductID = @CustomerProductID";
                        sqlCmd.ExecuteNonQuery();
                    }
                    else
                    {//if it does exist, throw exception
                        throw new Exception("This product already exist with this customer");
                    }
                    scope.Complete();
                }

            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts updateProduct(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts updateProduct(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
        } //end of updateProduct(int CUSTOMERPROUDCTID, string PRODUCTID_CMS)




        //with CMS connection string instead of DB. used for testing
        [System.Web.Services.WebMethod]
        public static Object getFirsBatchOfCustomersCMS()
        {
            OdbcConnection odbcConn = new OdbcConnection();
            OdbcCommand odbcCmd = new OdbcCommand();
            miData = new List<object[]>();
            try
            {
                odbcConn = new OdbcConnection(as400_connStr);

                if (odbcConn.State != ConnectionState.Open)
                {
                    odbcConn.Open();
                }

                odbcCmd.Connection = odbcConn;
                odbcCmd.CommandText = "SELECT BVCUST, BVNAME FROM CMSDAT.CUST ORDER BY TRIM(BVNAME) FETCH FIRST 25 ROWS ONLY";

                odbcCmd.CommandType = System.Data.CommandType.Text;

                DataSet dsLoadData = new DataSet();
                OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);
                dsAdapter.Fill(dsLoadData);

                //populate return object
                foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                {
                    miData.Add(row.ItemArray);
                }
            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in Admin_CustomerVendorProducts getFirsBatchOfCustomers(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getFirsBatchOfCustomers(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in AdminSubPages/Admin_CustomerProducts getFirsBatchOfCustomers(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (odbcConn == null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }

            return miData;

        } //end of public static Object getFullCustomerList()

        [System.Web.Services.WebMethod]
        public static Object getProductListBasedOnInputCMS(string INPUT)
        {
            OdbcConnection odbcConn = new OdbcConnection();
            OdbcCommand odbcCmd = new OdbcCommand();
            List<object[]> data = new List<object[]>();
            try
            {
                INPUT = INPUT.ToUpper();
                odbcConn = new OdbcConnection(as400_connStr);

                if (odbcConn.State != ConnectionState.Open)
                {
                    odbcConn.Open();
                }
                odbcCmd.Connection = odbcConn;

                odbcCmd.CommandText = "SELECT DISTINCT PRODID, PRODNAME " +
                                        "FROM ( SELECT AVPART AS PRODID, AVDES1 AS PRODNAME " +
                                        "FROM CMSDAT.STKMM " +
                                        "UNION SELECT AWPART AS PRODID, AWDES1 AS PRODNAME FROM CMSDAT.STKMP ) as A " +
                                        "WHERE (UPPER(PRODID) LIKE UPPER(?)) OR (UPPER(PRODNAME) LIKE UPPER(?)) ";


                odbcCmd.Parameters.Add("@PRODID", OdbcType.Char).Value = "%" + INPUT + "%";
                odbcCmd.Parameters.Add("@PRODNAME", OdbcType.Char).Value = "%" + INPUT + "%";

                odbcCmd.CommandType = System.Data.CommandType.Text;
                DataSet dsLoadData = new DataSet();
                OdbcDataAdapter dsAdapter = new OdbcDataAdapter(odbcCmd);

                dsAdapter.Fill(dsLoadData);

                //populate return object
                foreach (System.Data.DataRow row in dsLoadData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (OdbcException excep)
            {
                string strErr = " ODBCException Error in Admin_CustomerVendorProducts getProductListBasedOnInputCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 3;
                ErrorLogging.sendtoErrorPage(3);
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getProductListBasedOnInputCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getProductListBasedOnInputCMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (odbcConn == null && odbcConn.State != ConnectionState.Closed)
                {
                    odbcConn.Close();
                    odbcConn.Dispose();
                }
            }
            return data;

        } //end of public static Object getProductListBasedOnInput()

        [System.Web.Services.WebMethod]
        public static Object getCustomerListBasedOnInputOURDB(string INPUT)
        {
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            List<object[]> data = new List<object[]>();
            try
            {
                using (var scope = new TransactionScope())
                {

                    sqlConn = new SqlConnection(sql_connStr);
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    SqlParameter paramProdID = new SqlParameter("@ProductID_CMS", SqlDbType.Char);
                    SqlParameter paramProdName = new SqlParameter("@ProductName_CMS", SqlDbType.Char);

                    paramProdID.Value = "%" + INPUT + "%";
                    paramProdName.Value = "%" + INPUT + "%";

                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.Add(paramProdID);
                    sqlCmd.Parameters.Add(paramProdName);

                    sqlCmd.Connection = sqlConn;
                    sqlCmd.CommandText = "SELECT DISTINCT pCMS.ProductID_CMS, pCMS.ProductName_CMS " +
                                        "FROM ProductsCMS as pCMS " +
                                        "WHERE (UPPER(pCMS.ProductID_CMS) LIKE UPPER(@ProductID_CMS)) OR (UPPER (pCMS.ProductName_CMS) LIKE UPPER(@ProductName_CMS))";


                    DataSet dsData = new DataSet();
                    DataTable tblData = new DataTable();
                    System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                    dsData.Tables.Add(tblData);
                    dsData.Load(sqlReader, LoadOption.OverwriteChanges, tblData);

                    //populate return object
                    foreach (System.Data.DataRow row in dsData.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in Admin_CustomerVendorProducts getCustomerListBasedOnInputCMS(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_CustomerVendorProducts getCustomerListBasedOnInputCMS(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            finally
            {
                if (sqlConn == null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
            return data;

        } //end of public static Object getProductListBasedOnInput(string INPUT)

    }
}