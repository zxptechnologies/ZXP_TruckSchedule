using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;


namespace TransportationProject.AdminSubPages
{
    public partial class Admin_Inspections1 : System.Web.UI.Page
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
        public static bool CheckInspectionValidationSetting()
        {
            bool ValidationSetting = false;
            try
            {
                ValidationSetting = InspectionsHelperFunctions.CheckInspectionValidationSetting(sql_connStr);
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections CheckInspectionValidationSetting(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return ValidationSetting;

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
                string strErr = " Exception Error in Admin_Inspections getLoadTypes(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getInspectionList()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT IH.InspectionHeaderID, IH.InspectionHeaderName, LT.LoadTypeLong, IT.InspectionType, IH.needsVerificationTest " +
                                        "FROM dbo.InspectionHeader AS IH " +
                                        "LEFT OUTER JOIN dbo.LoadTypes AS LT ON LT.LoadTypeShort = IH.LoadType " +
                                        "LEFT OUTER JOIN dbo.InspectionTypes as IT ON IT.InspectionTypeID = IH.InspectionTypeID " +
                                        "WHERE isDisabled = 'false' ORDER BY InspectionHeaderID";
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
                string strErr = " Exception Error in Admin_Inspections getInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static Object getAdminInspectGridData(int INSPECTIONHEADERID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT TOP (100) PERCENT ITTs.TestID, ITTs.TestDescription, IHDs.SortOrder, IHDs.isDealBreaker " +
                        "FROM dbo.InspectionTestTemplates AS ITTs " +
                         "INNER JOIN dbo.InspectionHeaderDetails AS IHDs ON IHDs.TestID = ITTs.TestID " +
                         "INNER JOIN dbo.InspectionHeader AS IH ON IH.InspectionHeaderID = IHDs.InspectionHeaderID " +
                         "WHERE (IH.InspectionHeaderID = @InspectionHeaderID AND IHDs.isDisabled = 'false') " +
                         "ORDER BY IHDs.SortOrder";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

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
                string strErr = " Exception Error in Admin_Inspections getAdminInspectGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static int checkIfInspectionNameExist(string INSPECTIONNAME)
        {
            int rowCount = 0;
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(*) " +
                                            "FROM dbo.InspectionHeader as IH " +
                                            "WHERE IH.InspectionHeaderName = @InspectionHeaderName AND IH.isDisabled = 'false'";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderName", INSPECTIONNAME)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkIfInspectionNameExist(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static void updateInspectionHeader(int INSPECTIONHEADERID, string INSPECTIONHEADERNAME, int INSPECTIONTYPEID, string LOADTYPE, bool IS2RUNNER)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionHeader SET InspectionHeaderName = @InspectionHeaderName, InspectionTypeID = @InspectionTypeID, LoadType = @LoadType, " +
                                            "needsVerificationTest = @is2Runner WHERE InspectionHeaderID = @InspectionHeaderID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderName", INSPECTIONHEADERNAME),
                                                                                         new SqlParameter("@InspectionTypeID", INSPECTIONTYPEID),
                                                                                         new SqlParameter("@LoadType", LOADTYPE),
                                                                                         new SqlParameter("@is2Runner", IS2RUNNER),
                                                                                         new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections updateInspectionHeader(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static int checkInspectionHeaderNameForNewInspection(string INSPECTIONHEADERNAME)
        {
            int rowCount = 0;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(*) " +
                                            "FROM dbo.InspectionHeader as IH " +
                                            "WHERE IH.InspectionHeaderName = @InspectionHeaderName AND IH.isDisabled = 'false' ";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderName", INSPECTIONHEADERNAME)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkInspectionHeaderNameForNewInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }
        
        [System.Web.Services.WebMethod]
        public static int checkInspectionHeaderNameOfExisting(string INSPECTIONHEADERNAME, int SELECTEDINSPECTIONHEADERID)
        {
            int rowCount = 0;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(*) " +
                                  "FROM dbo.InspectionHeader as IH " +
                                  "WHERE IH.InspectionHeaderName = @InspectionHeaderName AND IH.isDisabled = 'false' AND IH.InspectionHeaderID != @SelectedInspectionHeaderID ";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderName", INSPECTIONHEADERNAME),
                                                                                                                  new SqlParameter("@SelectedInspectionHeaderID", SELECTEDINSPECTIONHEADERID)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkInspectionHeaderNameOfExisting(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        } 

        [System.Web.Services.WebMethod]
        public static Object setNewInspectionSetNewTestAndAssociate(string INSPECTIONHEADERNAME, int INSPECTIONTYPEID, string LOADTYPE, bool IS2RUNNER, int SORTORDER, string TESTTEXT, bool ISDEALBREAKER)
        {
            List<string> data = new List<string>();
            Int32 InspectionHeaderID = 0;
            Int32 TestID = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    // Query 1: create inspection header
                    sqlCmdText = "INSERT INTO dbo.InspectionHeader (InspectionHeaderName, InspectionTypeID, LoadType, needsVerificationTest, isDisabled) VALUES " +
                                            "(@InspectionHeaderName, @InspectionTypeID, @LoadType, @is2Runner, 'false') " +
                                            "SELECT CAST(scope_identity() AS int)";
                    InspectionHeaderID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderName", INSPECTIONHEADERNAME),
                                                                                                                            new SqlParameter("@InspectionTypeID", INSPECTIONTYPEID),
                                                                                                                            new SqlParameter("@LoadType", TransportHelperFunctions.convertStringEmptyToDBNULL(LOADTYPE)),
                                                                                                                            new SqlParameter("@is2Runner", IS2RUNNER)));
                    // Query 2: create test
                    sqlCmdText = "INSERT INTO dbo.InspectionTestTemplates (TestDescription) VALUES (@TestDescription) " +
                                            "SELECT CAST(scope_identity() AS int)";
                    TestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TestDescription", TESTTEXT)));
                    //Query 3: set new test to new inspection
                    sqlCmdText = "INSERT INTO dbo.InspectionHeaderDetails (InspectionHeaderID, TestID, SortOrder, isDealBreaker, isDisabled) VALUES (@InspectionHeaderID, @TestID, @SortOrder, @isDealBreaker, 'false') ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", InspectionHeaderID),
                                                                                         new SqlParameter("@TestID", TestID),
                                                                                         new SqlParameter("@SortOrder", SORTORDER),
                                                                                         new SqlParameter("@isDealBreaker", ISDEALBREAKER));
                    data.Add(InspectionHeaderID.ToString());
                    data.Add(TestID.ToString());
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections setNewInspectionSetNewTestAndAssociate(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }
        
        [System.Web.Services.WebMethod]
        public static void disableInspection(int INSPECTIONHEADERID)
        {
            DataSet dataSet = new DataSet();
            DataSet dataSet2 = new DataSet();
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionHeader SET isDisabled = 'true' WHERE InspectionHeaderID = @InspectionHeaderID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                    sqlCmdText = "SELECT InspectionListID from dbo.InspectionListsDetails WHERE (InspectionHeaderID = @InspectionHeaderID AND isHidden = 'false')";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                    int newSortOrderVal = 1;

                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        sqlCmdText = "SELECT InspectionHeaderID from dbo.InspectionListsDetails WHERE (InspectionListID = @InspectionListID AND isHidden = 'false' AND InspectionHeaderID != @InspectionHeaderID) ORDER BY SortOrder";
                        dataSet2 = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionListID", Convert.ToInt32(row.ItemArray[0])),
                                                                                                       new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));
                        if (dataSet2.Tables[0].Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow row2 in dataSet2.Tables[0].Rows)
                            {
                                sqlCmdText = "UPDATE dbo.InspectionListsDetails SET SortOrder = @SortOrder WHERE (InspectionHeaderID = @InspectionHeaderID)";
                                SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SortOrder", newSortOrderVal),
                                                                                                     new SqlParameter("@InspectionHeaderID", Convert.ToInt32(row2.ItemArray[0])));
                                newSortOrderVal++;
                            }
                        }
                    }
                    sqlCmdText = "UPDATE dbo.InspectionListsDetails SET isHidden = 'false' WHERE (InspectionHeaderID = @InspectionHeaderID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                    sqlCmdText = "UPDATE dbo.Alerts SET isDisabled = 'true' WHERE (InspectionHeaderID = @InspectionHeaderID) AND AlertTypeID = 4";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections disableInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static int checkIfOpenInspection(int INSPECTIONHEADERID)
        {
            int rowCount = 0;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(*) " +
                                    "FROM dbo.MainScheduleInspections as MSI " +
                                    "WHERE MSI.InspectionHeaderID = @InspectionHeaderID AND MSI.isHidden = 0 AND MSI.InspectionEndEventID IS NULL ";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkIfOpenInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static bool checkIfTestHasBeenUsed(int TESTID)
        {
            bool hasBeenUsed = true;
            int count = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT COUNT(*) FROM dbo.InspectionResults WHERE TestID = @TestID";
                    count = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TestID", TESTID)));

                    if (count == 0)
                    { hasBeenUsed = false; }
                    else
                    { hasBeenUsed = true; }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkIfTestHasBeenUsed(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return hasBeenUsed;
        }

        [System.Web.Services.WebMethod]
        public static int checkIfPartOfMultiInspection(int TESTID)
        {
            int rowCount = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(*) " +
                                     "FROM dbo.InspectionHeaderDetails as IHD " +
                                     "WHERE IHD.TestID = @TestID AND IHD.isDisabled = 'false'";
                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TestID", TESTID)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkIfPartOfMultiInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }

        [System.Web.Services.WebMethod]
        public static int setNewTestAndAssociateToInspection(int INSPECTIONHEADERID, int SORTORDER, string TESTTEXT, bool ISDEALBREAKER)
        {
            Int32 TestID = 0;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //Query 1: adds test to db
                    sqlCmdText = "INSERT INTO dbo.InspectionTestTemplates (TestDescription) VALUES (@TestDescription) " +
                                            "SELECT CAST(scope_identity() AS int)";
                    TestID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TestDescription", TESTTEXT)));

                    //Query 2: associate test to inspection
                    sqlCmdText = "INSERT INTO dbo.InspectionHeaderDetails (InspectionHeaderID, TestID, SortOrder, isDealBreaker, isDisabled) VALUES (@InspectionHeaderID, @TestID, @SortOrder, @isDealBreaker, 'false') ";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                         new SqlParameter("@TestID", TestID),
                                                                                         new SqlParameter("@SortOrder", SORTORDER),
                                                                                         new SqlParameter("@isDealBreaker", ISDEALBREAKER));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections setNewTestAndAssociateToInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return TestID;
        }

        [System.Web.Services.WebMethod]
        public static int checkIfLastTestAndDisable(int INSPECTIONHEADERID)
        {
            int testCount = 0;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT (*) FROM dbo.InspectionHeaderDetails " +
                                    "WHERE isDisabled = 'false' AND InspectionHeaderID = @InspectionHeaderID";
                    testCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkIfLastTestAndDisable(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return testCount;
        }

        [System.Web.Services.WebMethod]
        public static void updateTest(int INSPECTIONHEADERID, int TESTID, string TESTTEXT, bool ISDEALBREAKER)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //Query 1. update template
                    sqlCmdText = "UPDATE dbo.InspectionTestTemplates SET TestDescription = @TestDescription WHERE TestID = @TestID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TestDescription", TESTTEXT), new SqlParameter("@TestID", TESTID));

                    //Query 2. update Inspection details (sort order/deal breaker)
                    sqlCmdText = "UPDATE dbo.InspectionHeaderDetails SET isDealBreaker = @isDealBreaker WHERE (InspectionHeaderID = @InspectionHeaderID AND TestID = @TestID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@isDealBreaker", ISDEALBREAKER),
                                                                                         new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID), 
                                                                                         new SqlParameter("@TestID", TESTID));
                    
                    //Query 3. remove any 
                    sqlCmdText = "UPDATE dbo.Alerts SET isDisabled = 'true' WHERE (InspectionHeaderID = @InspectionHeaderID) AND AlertTypeID = 4";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections updateTest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void disableTest(int TESTID, int INSPECTIONHEADERID)
        {
            DataSet dataSet = new DataSet();
            int newSortOrderVal = 1;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionHeaderDetails " +
                                    "SET isDisabled = 'true' WHERE (InspectionHeaderID = @InspectionHeaderID AND TestID = @TestID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                         new SqlParameter("@TestID", TESTID));
                    sqlCmdText = "SELECT TestID " +
                                    "FROM dbo.InspectionHeaderDetails WHERE (InspectionHeaderID = @InspectionHeaderID AND isDisabled = 'false')";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        sqlCmdText = "UPDATE dbo.InspectionHeaderDetails SET SortOrder = @SortOrder WHERE (InspectionHeaderID = @InspectionHeaderID AND TestID = @TestID)";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SortOrder", newSortOrderVal),
                                                                                             new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID),
                                                                                             new SqlParameter("@TestID", Convert.ToInt32(row.ItemArray[0])));
                        newSortOrderVal++;
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections disableTest(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }
        
        [System.Web.Services.WebMethod]
        public static Object getProductsGridData(int INSPECTIONHEADERID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    //gets data specific data from table and save into readable format
                    sqlCmdText = "SELECT IP.InspectionProductID, IP.ProductID_CMS,  " +
                        "(SELECT PCMS.ProductName_CMS FROM dbo.ProductsCMS as PCMS WHERE PCMS.ProductID_CMS = IP.ProductID_CMS) AS ProductName " +
                        "FROM dbo.InspectionProducts as IP " +
                        "WHERE (IP.isDisabled = 'false') AND (IP.InspectionHeaderID = @InspectionHeaderID)";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

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
                string strErr = " Exception Error in Admin_Inspections getProductsGridData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static Object getAvailableProducts()
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT PCMS.ProductID_CMS, PCMS.ProductName_CMS " +
                                        "FROM dbo.ProductsCMS as PCMS";
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
                string strErr = " Exception Error in Admin_Inspections getAvailableProducts(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static void setNewSortOrder(int InspectionHeaderID, int TestID, int SortOrder)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "UPDATE dbo.InspectionHeaderDetails SET SortOrder = @SortOrder WHERE InspectionHeaderID = @InspectionHeaderID AND TestID = @TestID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@SortOrder", SortOrder),
                                                                                         new SqlParameter("@InspectionHeaderID", InspectionHeaderID),
                                                                                         new SqlParameter("@TestID", TestID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections setNewSortOrder(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static Object preDelete_checkIfInspectionHasAlert(int INSPECTIONHEADERID)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT A.Name " +
                                            "FROM dbo.Alerts AS A " +
                                            "WHERE A.AlertTypeID = 4 AND A.InspectionHeaderID = @InspectionHeaderID AND A.isDisabled = 'false'";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID));

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
                string strErr = " Exception Error in Admin_Inspections preDelete_checkIfInspectionHasAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }




        [System.Web.Services.WebMethod]
        public static int checkIfInspectionAddedToInspectionList(int INSPECTIONHEADERID)
        {
            int rowCount = 0;
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT COUNT(InspectionListDetailsID) " +
                                            "FROM dbo.InspectionListsDetails ILD " +
                                            "INNER JOIN dbo.InspectionLists IL ON IL.InspectionListID = ILD.InspectionListID " +
                                            "WHERE ILD.InspectionHeaderID = @InspectionHeaderID AND ILD.isHidden = 'false' AND IL.isHidden = 'false' ";

                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@InspectionHeaderID", INSPECTIONHEADERID)));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in Admin_Inspections checkIfInspectionAddedToInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return rowCount;
        }
    }
}