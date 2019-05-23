using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;


namespace TransportationProject
{
    public partial class Admin_InspectionLists : System.Web.UI.Page
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
                string strErr = " SQLException Error in Admin_InspectionLists Page_Load(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists Page_Load(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

        }

        [System.Web.Services.WebMethod]
        public static Object getLoadTypes()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT LoadTypeShort, LoadTypeLong FROM dbo.LoadTypes";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);
                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists getLoadTypes(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInspectionTypes()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT InspectionTypeID, InspectionType FROM dbo.InspectionTypes";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists getInspectionTypes(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInspectionLists()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT IL.InspectionListID, IL.InspectionListName " +
                                        "FROM dbo.InspectionLists AS IL " +
                                        "WHERE IL.isHidden = 'false' ORDER BY IL.InspectionListName";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists getInspectionLists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void disableInspectionList(int InspectionListID)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionLists " +
                        "SET isHidden = 'true' WHERE InspectionListID = @InspectionListID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", InspectionListID));

                    sqlCmdText = "UPDATE dbo.InspectionListsProducts " +
                        "SET isDisabled = 'true' WHERE InspectionListID = @InspectionListID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", InspectionListID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists disableInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getListOfInspectionsAndTheirDetails()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT IH.InspectionHeaderID, IH.InspectionHeaderName, IT.InspectionType, LT.LoadTypeLong, IH.needsVerificationTest " +
                                        "FROM dbo.InspectionHeader AS IH " +
                                        "INNER JOIN dbo.LoadTypes AS LT ON LT.LoadTypeShort = IH.LoadType " +
                                        "INNER JOIN dbo.InspectionTypes AS IT ON IT.InspectionTypeID = IH.InspectionTypeID " +
                                        "WHERE IH.isDisabled = 'false' ORDER BY IH.InspectionHeaderName";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists getListOfInspectionsAndTheirDetails(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getListOfInspectionsByInspectionListID(int INSPECTIONLISTID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT ILD.SortOrder, ILD.InspectionHeaderID, IH.InspectionHeaderName, IT.InspectionType, LT.LoadTypeLong, IH.needsVerificationTest, ILD.InspectionListDetailsID " +
                                        "FROM dbo.InspectionListsDetails AS ILD " +
                                        "INNER JOIN dbo.InspectionHeader AS IH ON IH.InspectionHeaderID = ILD.InspectionHeaderID " +
                                        "INNER JOIN dbo.LoadTypes AS LT ON LT.LoadTypeShort = IH.LoadType " +
                                        "INNER JOIN dbo.InspectionTypes AS IT ON IT.InspectionTypeID = IH.InspectionTypeID " +
                                        "WHERE ILD.isHidden = 'false' AND ILD.InspectionListID = @InspectionListID ORDER BY ILD.SortOrder";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID));

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }
                scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists getListOfInspectionsByInspectionListID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int[] setNewInspectionListSetNewInspectionAndAssociate(string INSPECTIONLISTNAME, int INSPECTIONHEADERID)
        {
            int rowCount = 0;
            Int32 InspectionListID = 0;
            bool needsVerificationTest = false;
            int[] returnArray = new int[2];

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramInspectionListName = new SqlParameter("@InspectionListName", SqlDbType.NVarChar);
                    paramInspectionListName.Value = INSPECTIONLISTNAME;

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.InspectionLists WHERE (InspectionListName = @InspectionListName AND isHidden = 'false')";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListName", INSPECTIONLISTNAME)));


                    if (rowCount > 0)
                    {
                        throw new Exception("Inspection List Name already exist.");
                    }
                    else
                    {
                        sqlCmdText = "INSERT INTO dbo.InspectionLists (InspectionListName, isHidden) " +
                                                "VALUES (@InspectionListName, 'false'); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        InspectionListID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListName", INSPECTIONLISTNAME)));
                        returnArray[0] = InspectionListID;

                        sqlCmdText = "Select ISNULL(needsVerificationTest, 0) FROM dbo.InspectionHeader WHERE InspectionHeaderID =  @InspectionHeaderID";
                        needsVerificationTest = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID)));

                        sqlCmdText = "INSERT INTO dbo.InspectionListsDetails (InspectionListID, InspectionHeaderID, SortOrder, isHidden) " +
                                                "VALUES (@InspectionListID, @InspectionHeaderID, 1, 'false'); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", InspectionListID),
                                                                                             new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                        if (needsVerificationTest == true)
                        {
                            sqlCmdText = "INSERT INTO dbo.InspectionListsDetails (InspectionListID, InspectionHeaderID, SortOrder, isHidden) " +
                                                    "VALUES (@InspectionListID, @InspectionHeaderID, 2, 'false'); " +
                                                    "SELECT CAST(scope_identity() AS int)";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", InspectionListID),
                                                                                                 new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));
                            returnArray[1] = 1;
                        }

                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists setNewInspectionListSetNewInspectionAndAssociate(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return returnArray;
        }

        [System.Web.Services.WebMethod]
        public static bool setNewInspectionToListAndAssociate(int INSPECTIONLISTID, int INSPECTIONHEADERID, int SORTORDER)
        {
            bool needsVerificationTest = false;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "Select ISNULL(needsVerificationTest, 0) FROM dbo.InspectionHeader WHERE InspectionHeaderID =  @InspectionHeaderID";
                    needsVerificationTest = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID)));

                    if (needsVerificationTest == true)
                    {
                        for (var i = 0; i < 2; i++)
                        {
                            if (i == 0)
                            {
                                sqlCmdText = "INSERT INTO dbo.InspectionListsDetails (InspectionListID, InspectionHeaderID, SortOrder, isHidden) " +
                                                        "VALUES (@InspectionListID, @InspectionHeaderID, @SortOrder, 'false'); " +
                                                        "SELECT CAST(scope_identity() AS int)";
                            }
                            else
                            {
                                SORTORDER = SORTORDER + 1;
                                sqlCmdText = "INSERT INTO dbo.InspectionListsDetails (InspectionListID, InspectionHeaderID, SortOrder, isHidden) " +
                                                        "VALUES (@InspectionListID, @InspectionHeaderID, @SortOrder, 'false'); " +
                                                        "SELECT CAST(scope_identity() AS int)";
                            }
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID),
                                                                                                 new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                                 new SqlParameter("@SortOrder", SORTORDER));
                        }
                    }
                    else
                    {
                        sqlCmdText = "INSERT INTO dbo.InspectionListsDetails (InspectionListID, InspectionHeaderID, SortOrder, isHidden) " +
                                                "VALUES (@InspectionListID, @InspectionHeaderID, @SortOrder, 'false'); " +
                                                "SELECT CAST(scope_identity() AS int)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID),
                                                                                             new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                             new SqlParameter("@SortOrder", SORTORDER));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists setNewInspectionToListAndAssociate(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return needsVerificationTest;
        }

        [System.Web.Services.WebMethod]
        public static void setNewSortOrder(int INSPECTIONLISTID, int INSPECTIONHEADERID, int SORTORDER, int InspectionListDetailsID)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionListsDetails SET SortOrder = @SortOrder WHERE (InspectionListDetailsID = @InspectionListDetailsID AND InspectionListID = @InspectionListID AND isHidden = 'false')";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SortOrder", SORTORDER),
                                                                                         new SqlParameter("@InspectionListDetailsID", InspectionListDetailsID),
                                                                                         new SqlParameter("@InspectionListID", INSPECTIONLISTID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists setNewSortOrder(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object getProductsGridData(int INSPECTIONLISTID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramInspectionListID = new SqlParameter("@InspectionListID", SqlDbType.Int);
                    paramInspectionListID.Value = INSPECTIONLISTID;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT ILP.InspectionProductID, ILP.ProductID_CMS, " +
                        "(SELECT PCMS.ProductName_CMS FROM dbo.ProductsCMS as PCMS WHERE PCMS.ProductID_CMS = ILP.ProductID_CMS) AS ProductName " +
                        "FROM dbo.InspectionListsProducts AS ILP " +
                        "WHERE (ILP.isDisabled = 'false') AND (ILP.InspectionListID = @InspectionListID)";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists getProductsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static void deleteInspectionFromInspectionList(int INSPECTIONLISTID, int INSPECTIONHEADERID, int SORTORDER)
        {
            DateTime now = DateTime.Now;
            Int32 rowCount = 0;
            bool needsVerificationTest = false;
            int highSortOrderOfTwo = 0;
            int lowerSortOrderOfTwo = 0;
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    SqlParameter paramInspectionHeaderID = new SqlParameter("@InspectionHeaderID", SqlDbType.Int);
                    SqlParameter paramSortOrder = new SqlParameter("@SortOrder", SqlDbType.Int);
                    SqlParameter paramInspectionListID = new SqlParameter("@InspectionListID", SqlDbType.Int);

                    paramInspectionHeaderID.Value = INSPECTIONHEADERID;
                    paramInspectionListID.Value = INSPECTIONLISTID;


                    sqlCmdText = "Select ISNULL(needsVerificationTest, 0) FROM dbo.InspectionHeader WHERE InspectionHeaderID = @InspectionHeaderID";
                    needsVerificationTest = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID)));

                    if (needsVerificationTest == true)
                    {
                        sqlCmdText = "Select SortOrder FROM dbo.InspectionListsDetails WHERE (InspectionHeaderID = @InspectionHeaderID AND InspectionListID = @InspectionListID) order by SortOrder desc";
                        dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                                     new SqlParameter("@InspectionListID", INSPECTIONLISTID));
                        var index = 1;
                        //populate return object
                        foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                        {
                            if (index == 1)
                            {
                                highSortOrderOfTwo = Convert.ToInt16(row.ItemArray[0]);
                            }
                            else
                            {
                                lowerSortOrderOfTwo = Convert.ToInt16(row.ItemArray[0]);
                            }
                            index++;
                        }
                    }
                    sqlCmdText = "UPDATE dbo.InspectionListsDetails SET isHidden = 'true' WHERE (InspectionHeaderID = @InspectionHeaderID AND InspectionListID = @InspectionListID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                             new SqlParameter("@InspectionListID", INSPECTIONLISTID));

                    sqlCmdText = "SELECT COUNT(InspectionHeaderID) FROM dbo.InspectionListsDetails WHERE InspectionListID = @InspectionListID";
                    rowCount = Convert.ToInt16(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID)));

                    if (rowCount == 0)
                    {
                        //disable inspection list if no inspections are present
                        sqlCmdText = "UPDATE dbo.InspectionLists SET isHidden = 'true' WHERE InspectionListID = @InspectionListID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID));
                    }
                    else
                    {
                        if (needsVerificationTest == true)
                        {
                            dataSet = new DataSet();
                            sqlCmdText = "SELECT InspectionListDetailsID from dbo.InspectionListsDetails WHERE (InspectionListID = @InspectionListID AND isHidden = 'false') ORDER BY SortOrder";
                            dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID));
                            int newSortOrderVal = 1;

                            foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                            {
                                sqlCmdText = "UPDATE dbo.InspectionListsDetails SET SortOrder = @SortOrder WHERE (InspectionListDetailsID = @InspectionListDetailsID AND InspectionListID = @InspectionListID AND isHidden = 'false')";
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SortOrder", newSortOrderVal),
                                                                                                     new SqlParameter("@InspectionListDetailsID", Convert.ToInt32(row.ItemArray[0])),
                                                                                                     new SqlParameter("@InspectionListID", INSPECTIONLISTID));
                                newSortOrderVal++;
                            }
                        }
                        else
                        {
                            //other wise reorder existing inspections in list 
                            sqlCmdText = "UPDATE dbo.InspectionListsDetails SET SortOrder = (SortOrder - 1) WHERE (InspectionListID = @InspectionListID AND SortOrder > @SortOrder)";
                            SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", INSPECTIONLISTID),
                                                                                                 new SqlParameter("@SortOrder", SORTORDER));
                        }
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists deleteInspectionFromInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static int renameInspectionList(int INSPECTIONLISTID, string INSPECTIONLISTNAME)
        {
            int rowCount = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter paramInspectionListName = new SqlParameter("@InspectionListName", SqlDbType.NVarChar);
                    SqlParameter paramInspectionListID = new SqlParameter("@InspectionListID", SqlDbType.Int);

                    paramInspectionListID.Value = INSPECTIONLISTID;
                    paramInspectionListName.Value = INSPECTIONLISTNAME;

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.InspectionLists WHERE (InspectionListName = @InspectionListName AND isHidden = 'false' AND InspectionListID != @InspectionListID)";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListName", INSPECTIONLISTNAME),
                                                                                                                  new SqlParameter("@InspectionListID", INSPECTIONLISTID)));
                    if (rowCount > 0)
                    {
                        throw new Exception("Inspection List Name already exist.");
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.InspectionLists SET InspectionListName = @InspectionListName WHERE InspectionListID = @InspectionListID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListName", INSPECTIONLISTNAME),
                                                                                             new SqlParameter("@InspectionListID", INSPECTIONLISTID));
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_InspectionLists renameInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return INSPECTIONLISTID;
        }

    }
}