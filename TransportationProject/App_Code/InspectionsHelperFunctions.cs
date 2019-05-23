using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;
using System.Web;

namespace TransportationProject
{
    public class InspectionsHelperFunctions
    {




        [System.Web.Services.WebMethod]
        public static DataSet GetPOdetailsData(int prodDetailID, string sql_connStr)
        {
            DataSet dsPODetails = new DataSet();
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT TOP 1 ProductID_CMS, MSID, QTY, LotNumber, UnitOfMeasure, FileID_COFA FROM dbo.PODetails WHERE PODetailsID = @PDetailID";
                dsPODetails = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@PDetailID", prodDetailID));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions GetPOdetailsData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return dsPODetails;
        }

        [System.Web.Services.WebMethod]
        public static bool CheckInspectionValidationSetting(string sql_connStr)
        {
            bool ValidationSetting = false;
            try
            {
                
                string sqlQuery = "SELECT TOP 1 Value FROM dbo.ApplicationSettings WHERE SettingName = 'IsInspectionValidationOn'";
                object result = SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery);
                result = (result == DBNull.Value) ? null : result;
                int settingValue = Convert.ToInt32(result);

                ValidationSetting = (1 == settingValue) ? true : false;
                

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions CheckInspectionValidationSetting(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return ValidationSetting;
        }


        [System.Web.Services.WebMethod]
        public static int getPOdetailsIDForMSIDandProduct(int MSID, string ProductID_CMS, string sql_connStr)
        {
            int poDetailsID = 0;
            try
            {
                if (string.Empty != ProductID_CMS)
                {
                    string sqlQuery = "SELECT TOP 1 PODetailsID FROM dbo.PODetails WHERE MSID = @MSID AND ProductID_CMS = @PRODID";
                    object result = SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSID", MSID)
                                                                                              , new SqlParameter("@PRODID", ProductID_CMS));
                    poDetailsID = (result == null ? 0 : (int)result);
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getPOdetailsIDForMSIDandProduct(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return poDetailsID;
        }


        [System.Web.Services.WebMethod]
        public static List<object[]> getInspectionList(int prodDetailID, string sql_connStr )
        {
            List<object[]> data = new List<object[]>();
            try
            {

                DataSet dsGridData = GetPOdetailsData(prodDetailID, sql_connStr);
                if (0 == dsGridData.Tables[0].Rows.Count)
                {
                    throw new Exception("GetPOdetailsData() Failed");
                }
                string CMSProdID = dsGridData.Tables[0].Rows[0]["ProductID_CMS"].ToString();
                int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);
                data = getInspectionListUsingProductIDAndMSID(CMSProdID, MSID, sql_connStr);

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getInspectionList(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static List<object[]> getInspectionListUsingProductIDAndMSID(string CMSproductID, int MSID, string sql_connStr)
        {
            List<object[]> data = new List<object[]>();
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery =
                        //UNCOMMENT IF SHOULD ONLY SHOW NON DISABLED LISTS
                        //"SELECT  IL.InspectionListID,  IL.InspectionListName " +
                        //"FROM dbo.InspectionListsProducts ILP " +
                        //"INNER JOIN dbo.InspectionLists IL ON ILP.InspectionListID = IL.InspectionListID " +
                        //"INNER JOIN dbo.PODetails PD ON PD.ProductID_CMS = ILP.ProductID_CMS " +
                        //"INNER JOIN dbo.MainSchedule MS ON MS.MSID = PD.MSID " +
                        //"WHERE (ILP.ProductID_CMS = @PROD) AND IL.isHidden = 0 AND ILP.isDisabled = 0 AND MS.MSID = @MSID " +
                        //"ORDER BY IL.InspectionListName";

                        //UNCOMMENT IF SHOULD INCLUDE INSPECTIONS LIST ALREADY CREATED FOR PRODUCT ASSOCIATE AND MSID
                        "SELECT DISTINCT InspectionListID, InspectionListName FROM ( " +
                            "SELECT DISTINCT IL.InspectionListID,  IL.InspectionListName , 1 AS sortImportance " +
                        "FROM dbo.InspectionListsProducts ILP " +
                        "INNER JOIN dbo.InspectionLists IL ON ILP.InspectionListID = IL.InspectionListID " +
                        "INNER JOIN dbo.PODetails PD ON PD.ProductID_CMS = ILP.ProductID_CMS " +
                        "INNER JOIN dbo.MainSchedule MS ON MS.MSID = PD.MSID " +
                        "WHERE (ILP.ProductID_CMS = @PROD) AND IL.isHidden = 0 AND ILP.isDisabled = 0 AND MS.MSID = @MSID " +
                        "UNION " +
                        "SELECT DISTINCT " +
                              "InspectionListID, InspectionListName, 2 AS sortImportance " +
                          "FROM dbo.MainScheduleInspectionLists " +
                          "WHERE isHidden = 0 AND MSID =@MSID AND ProductID_CMS = @PROD " +
                          "AND RunNumber = 1 " +
                        ") AS AllData " +
                        "ORDER BY AllData.InspectionListName ";

                DataSet dsGridData = new DataSet();
                dsGridData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@PROD", TransportHelperFunctions.convertStringEmptyToDBNULL(CMSproductID)), new SqlParameter("@MSID", MSID));

                //populate return object
                foreach (System.Data.DataRow row in dsGridData.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getInspectionListUsingProductIDAndMSID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }

        [System.Web.Services.WebMethod]
        public static InspectionList getMSInspectionListAndData(int prodDetailID, int InspectionListID, string sql_connStr)
        {
            InspectionList inspList = new InspectionList();
            try
            {
                using (var scope = new TransactionScope())
                {
                    DataSet dsGridData = GetPOdetailsData(prodDetailID,sql_connStr);

                    //ErrorLogging.WriteEvent("1-" + dsGridData.Tables.Count.ToString(), EventLogEntryType.Information);
                    if (0 == dsGridData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }

                    string CMSproductID = dsGridData.Tables[0].Rows[0]["ProductID_CMS"].ToString();
                    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                    int MSInspectionListID = getMainscheduleInspectionListID(CMSproductID, MSID, InspectionListID, sql_connStr);
                    //get data  for ui

                    //ErrorLogging.WriteEvent("2-" + MSInspectionListID.ToString(), EventLogEntryType.Information);
                    if (0 == MSInspectionListID)
                    {
                        throw new Exception("getMainscheduleInspectioinListID() Failed");
                    }

                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT InspectionListName, RunNumber, isHidden " +
                                          "FROM dbo.MainScheduleInspectionLists " +
                                          "WHERE MSInspectionListID = @MSLID";
                    DataSet resultData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSLID", MSInspectionListID));

                    string InspectionListName = resultData.Tables[0].Rows[0]["InspectionListName"].ToString();
                    int runNumber = Convert.ToInt32(resultData.Tables[0].Rows[0]["RunNumber"]);
                    bool isHidden = Convert.ToBoolean(resultData.Tables[0].Rows[0]["isHidden"]);

                    //ErrorLogging.WriteEvent("3-" + resultData.Tables.Count.ToString(), EventLogEntryType.Information);
                    inspList = new InspectionList(MSInspectionListID, MSID, InspectionListID, InspectionListName, CMSproductID, runNumber, isHidden);


                    sqlQuery = "SELECT MSInspectionListDetailID, MSInspectionListID, InspectionListID, InspectionHeaderID, SortOrder, InspectionHeaderName " +
                                                "FROM dbo.MainScheduleInspectionListsDetails " +
                                                "WHERE MSInspectionListID = @MSLID " +
                                                "ORDER BY SortOrder";
                    DataSet MSInspectionListDetailsData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSLID", MSInspectionListID));

                    //ErrorLogging.WriteEvent("4", EventLogEntryType.Information);
                    for (int i = 0; i < MSInspectionListDetailsData.Tables[0].Rows.Count; i++)
                    {

                        int MSInspectionListDetailID = Convert.ToInt32(MSInspectionListDetailsData.Tables[0].Rows[i]["MSInspectionListDetailID"]);
                        int InspectionHeaderID = Convert.ToInt32(MSInspectionListDetailsData.Tables[0].Rows[i]["InspectionHeaderID"]);
                        int SortOrder = Convert.ToInt32(MSInspectionListDetailsData.Tables[0].Rows[i]["SortOrder"]);
                        string InspectionHeaderName = MSInspectionListDetailsData.Tables[0].Rows[i]["InspectionHeaderName"].ToString();
                        Inspection nInspection = getInspection(MSInspectionListDetailID, sql_connStr);

                        // ErrorLogging.WriteEvent("5", EventLogEntryType.Information);
                        if (0 == nInspection.MSInspectionID)
                        {
                            throw new Exception("getInspection() Failed");
                        }

                        InspectionListDetails inspListDetails = new InspectionListDetails(MSInspectionListDetailID, MSInspectionListID, InspectionHeaderID, InspectionHeaderName, SortOrder, nInspection);
                        inspList.addInspectionListDetail(inspListDetails);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getMSInspectionListAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return inspList;
        }

        [System.Web.Services.WebMethod]
        public static int getMainscheduleInspectionListID(string CMSproductID, int MSID, int InspectionListID, string sql_connStr )
        {
            int MSInspectionListID = 0;
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT TOP 1 MSIL.MSInspectionListID " +
                                    "FROM dbo.MainScheduleInspectionLists MSIL " +
                                    "WHERE MSIL.MSID = @MSID AND (MSIL.ProductID_CMS = @PROD OR  MSIL.ProductID_CMS IS NULL) AND MSIL.isHidden = 0 and MSIL.InspectionListID = @LISTID AND isHidden = 0 " +
                                    "ORDER BY MSIL.MSInspectionListID DESC";

                object resultData = SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@PROD", TransportHelperFunctions.convertStringEmptyToDBNULL(CMSproductID))
                                                                                , new SqlParameter("@MSID", MSID)
                                                                                , new SqlParameter("@LISTID", InspectionListID));

                //if no mainscheduleinspection exists then create else return existing
                if (resultData == null || string.IsNullOrEmpty(resultData.ToString()))
                {
                    MSInspectionListID = createNewMSInspectionListAndData(CMSproductID, MSID, InspectionListID, sql_connStr);

                }
                else
                {

                    MSInspectionListID = Convert.ToInt32(resultData);
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getMainscheduleInspectionListID(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return MSInspectionListID;
        }

        [System.Web.Services.WebMethod]
        public static int createNewMSInspectionListAndData(string CMSproductID, int MSID, int InspectionListID, string sql_connStr)
        {
            DateTime now = DateTime.Now;
            int MSInspectionListID = 0;

            //CREATE NEW INSPECTIONLIST, DETAIL, ETC
            using (var scope = new TransactionScope())
            {

                //1) Create InspectionList
                MSInspectionListID = createNewMainScheduleInspectionList(CMSproductID, MSID, InspectionListID, sql_connStr);
                if (0 == MSInspectionListID)
                {
                    throw new Exception("createMainScheduleInspectionList() Failed");
                }
                //2) Create InspectionListDetails
                DataSet newMSInspectionListDetailIDs = createNewMainScheduleInspectionListDetails(CMSproductID, MSID, InspectionListID, MSInspectionListID, sql_connStr);

                if (0 == newMSInspectionListDetailIDs.Tables[0].Rows.Count)
                {
                    throw new Exception("createNewMainScheduleInspectionListDetails() Failed");
                }
                //3) Create Inspections
                foreach (System.Data.DataRow row in newMSInspectionListDetailIDs.Tables[0].Rows)
                {
                    int didSucceed = createNewInspection(MSID, Convert.ToInt32(row.ItemArray[0]), sql_connStr);
                    if (0 == didSucceed)
                    {
                        throw new Exception("createNewInspection() Failed");
                    }
                }
                scope.Complete();
            }
            return MSInspectionListID;
        }

        [System.Web.Services.WebMethod]
        public static int createNewMainScheduleInspectionList(string CMSproductID, int MSID, int InspectionListID, string sql_connStr)
        {
            int MSInspectionListID = 0;
            DateTime now = DateTime.Now;

            //CREATE NEW INSPECTIONLIST, DETAIL, ETC
            using (var scope = new TransactionScope())
            {
                try
                {
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT ISNULL(MAX(RunNumber), 0) AS maxRuns " +
                                                    "FROM dbo.MainScheduleInspectionLists " +
                                                    "WHERE MSID = @MSID AND InspectionListID = @INSPECTLIST AND ProductID_CMS = @CMSProd AND isHidden = 0";
                    int runNumber = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@CMSProd", TransportHelperFunctions.convertStringEmptyToDBNULL(CMSproductID)), new SqlParameter("@MSID", MSID), new SqlParameter("@INSPECTLIST", InspectionListID)));
                    int newRunNumber = runNumber + 1;

                    sqlQuery = "INSERT INTO dbo.MainScheduleInspectionLists (MSID, InspectionListID, InspectionListName, RunNumber, ProductID_CMS) " +
                                                    "SELECT @MSID AS MSID, InspectionListID, InspectionListName, @RUN, @CMSProd " +
                                                    "FROM dbo.InspectionLists IL " +
                                                    "WHERE IL.InspectionListID = @INSPECTLIST AND IL.isHidden=0; " +
                                                    "SELECT SCOPE_IDENTITY()";

                    MSInspectionListID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@CMSProd", TransportHelperFunctions.convertStringEmptyToDBNULL(CMSproductID))
                                                                                                                            , new SqlParameter("@MSID", MSID)
                                                                                                                            , new SqlParameter("@INSPECTLIST", InspectionListID)
                                                                                                                            , new SqlParameter("@RUN", newRunNumber)
                                                                                                                            ));
                    scope.Complete();
                }
                catch (Exception ex)
                {
                    string error = ex.ToString();
                }

            }
            return MSInspectionListID;
        }


        [System.Web.Services.WebMethod]
        public static DataSet createNewMainScheduleInspectionListDetails(string CMSproductID, int MSID, int InspectionListID, int MSInspectionListID, string sql_connStr )
        {
            DateTime now = DateTime.Now;
            DataSet insertedMSInspectionListIDs = new DataSet();
            using (var scope = new TransactionScope())
            {
                try
                {
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT TOP 1 MSInspectionListDetailID FROM dbo.MainScheduleInspectionListsDetails ORDER BY MSInspectionListDetailID DESC ";
                    int lastMSInspectionListDetailIDBeforeInsert = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery));

                    sqlQuery = "INSERT INTO dbo.MainScheduleInspectionListsDetails (MSInspectionListID, InspectionListID, InspectionHeaderID , InspectionHeaderName, SortOrder) " +
                                           "SELECT @MSINSPLISTID AS MSInspectionListID, InspectionListID , ILD.InspectionHeaderID , InspectionHeaderName,  SortOrder " +
                                           "FROM dbo.InspectionListsDetails ILD " +
                                           "INNER JOIN dbo.InspectionHeader IH ON IH.InspectionHeaderID = ILD.InspectionHeaderID " +
                                           "WHERE ILD.isHidden = 0 AND ILD.InspectionListID = @INSPECTLIST; " +
                                            "SELECT SCOPE_IDENTITY()";

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@INSPECTLIST", InspectionListID),
                                                                                       new SqlParameter("@MSINSPLISTID", MSInspectionListID));

                    sqlQuery = "SELECT MSInspectionListDetailID FROM dbo.MainScheduleInspectionListsDetails WHERE MSInspectionListDetailID > @MSILDetailID  ";
                    insertedMSInspectionListIDs = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSILDetailID", lastMSInspectionListDetailIDBeforeInsert));
                }
                catch (Exception ex)
                {
                    throw new Exception("Error in createNewMainScheduleInspectionListDetails" + ex.ToString());
                }

                scope.Complete();
            }
            return insertedMSInspectionListIDs;
        }


        [System.Web.Services.WebMethod]
        public static int createNewInspection(int MSID, int MSInspectionListDetailID, string sql_connStr)
        {

            DateTime now = DateTime.Now;
            int didSucceed = 0;

            using (var scope = new TransactionScope())
            {
                try
                {
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;


                    string sqlQuery = "SELECT InspectionHeaderID FROM dbo.MainScheduleInspectionListsDetails " +
                                        "WHERE MSInspectionListDetailID = @MSINSPDETAILID";
                    int InspectionHeaderID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSINSPDETAILID", MSInspectionListDetailID)));

                    sqlQuery = "SELECT COALESCE(MAX(RunNumber), 0) AS MaxRunNum FROM dbo.MainScheduleInspections WHERE MSID = @MSID AND MSInspectionListDetailID = @MSINSPDETAILID"; //includes hidden entries for consistent increment
                    int runNum = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSINSPDETAILID", MSInspectionListDetailID)
                                                                                                                , new SqlParameter("@MSID", MSID)));

                    sqlQuery = "INSERT INTO dbo.MainScheduleInspections (InspectionHeaderID, MSID, isHidden, InspectionHeaderName, " +
                                                                                  "InspectionTypeID,LoadType, RunNumber, needsVerificationTest, MSInspectionListDetailID) " +
                                         "SELECT InspectionHeaderID, @MSID AS MSID, 0 AS isHidden, InspectionHeaderName, InspectionTypeID, LoadType, @RUN AS RunNumber, " +
                                                 "needsVerificationTest, @MSINSPDETAILID AS MSInspectionListDetailID FROM dbo.InspectionHeader WHERE InspectionHeaderID = @HID ; " +
                                         "SELECT SCOPE_IDENTITY()";
                    int MSInspectionID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSINSPDETAILID", MSInspectionListDetailID)
                                                                                                                                , new SqlParameter("@MSID", MSID)
                                                                                                                                , new SqlParameter("@HID", InspectionHeaderID)
                                                                                                                                , new SqlParameter("@RUN", runNum + 1))); //increment + 1 to new runnumber

                    sqlQuery = "SELECT InspectionHeaderName, InspectionTypeID, LoadType, needsVerificationTest FROM dbo.InspectionHeader WHERE InspectionHeaderID = @HID;  ";
                    DataSet dsData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@HID", InspectionHeaderID));

                    string InspectionHeaderName = Convert.ToString(dsData.Tables[0].Rows[0]["InspectionHeaderName"]);
                    int InspectionTypeID = Convert.ToInt32(dsData.Tables[0].Rows[0]["InspectionTypeID"]);
                    string LoadType = Convert.ToString(dsData.Tables[0].Rows[0]["LoadType"]);

                    //set result as Empty/Unanswered to indicate that test question has not been answered
                    sqlQuery = "INSERT INTO dbo.MainScheduleInspectionResults (MSInspectionID, TestID, Result, TestDescription, SortOrder , isDealBreaker) " +
                                         "SELECT @MSInspectID AS MSInspectionID, ITT.TestID, " +
                                         "(SELECT ResultValue FROM dbo.InspectionResultType WHERE ResultText = 'Empty/Unanswered') AS Result, " +
                                         "TestDescription, SortOrder, isDealBreaker FROM dbo.InspectionHeaderDetails IHD " +
                                         "INNER JOIN dbo.InspectionTestTemplates ITT ON ITT.TestID = IHD.TestID " +
                                         "WHERE InspectionHeaderID = @HID AND IHD.isDisabled = 'false'; ";


                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectID", MSInspectionID)
                                                                                        , new SqlParameter("@HID", InspectionHeaderID));
                    didSucceed = 1;

                }
                catch (Exception ex)
                {
                    throw new Exception("Error in InspectionsHelperFunctions CreateNewInspection" + ex.ToString());
                }
                scope.Complete();
            }
            return didSucceed;
        }

        [System.Web.Services.WebMethod]
        public static List<InspectionQuestion> GetInspectionQuestion(int MSInspectionID, string sql_connStr)
        {
            List<InspectionQuestion> questionsUnderInspection = new List<InspectionQuestion>();
            try
            {
                using (var scope = new TransactionScope())
                {
                    InspectionQuestion inspQuestion = new InspectionQuestion();
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT TestID, Result, SubmittedTimeStamp, UserID, Comment, TestDescription, SortOrder, isDealBreaker " +
                                      "FROM dbo.MainScheduleInspectionResults " +
                                      "WHERE MSInspectionID = @MSInspID " +
                                      "ORDER BY SortOrder";
                    DataSet MainScheduleInspectionResultsData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspID", MSInspectionID));
                    for (int i = 0; i < MainScheduleInspectionResultsData.Tables[0].Rows.Count; i++)
                    {
                        int TestID = Convert.ToInt32(MainScheduleInspectionResultsData.Tables[0].Rows[i]["TestID"]);
                        int Result = Convert.ToInt32(MainScheduleInspectionResultsData.Tables[0].Rows[i]["Result"]);
                        DateTime? SubmittedTimeStamp = (MainScheduleInspectionResultsData.Tables[0].Rows[0]["SubmittedTimeStamp"] == DBNull.Value) ? (DateTime?)null : Convert.ToDateTime(MainScheduleInspectionResultsData.Tables[0].Rows[0]["SubmittedTimeStamp"]);
                        int? UserID = (MainScheduleInspectionResultsData.Tables[0].Rows[0]["UserID"] == DBNull.Value) ? (int?)null : Convert.ToInt32(MainScheduleInspectionResultsData.Tables[0].Rows[0]["UserID"]);
                        string Comment = MainScheduleInspectionResultsData.Tables[0].Rows[i]["Comment"].ToString();
                        string TestDescription = MainScheduleInspectionResultsData.Tables[0].Rows[i]["TestDescription"].ToString();
                        int SortOrder = Convert.ToInt32(MainScheduleInspectionResultsData.Tables[0].Rows[i]["SortOrder"]);
                        bool isDealBreaker = Convert.ToBoolean(MainScheduleInspectionResultsData.Tables[0].Rows[i]["isDealBreaker"]);

                        inspQuestion = new InspectionQuestion(MSInspectionID, TestID, Result, SubmittedTimeStamp, UserID, Comment, TestDescription, SortOrder, isDealBreaker);
                        questionsUnderInspection.Add(inspQuestion);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions GetInspectionQuestion(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return questionsUnderInspection;
        }

        [System.Web.Services.WebMethod]
        public static ZXPUserData getUserData(int? UserID, string sql_connStr)
        {
            ZXPUserData ZXPUser = new ZXPUserData();
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT TOP 1 UserID, isAdmin,  isDockManager,  isInspector,  isGuard,  isLabPersonel,  isLoader,  isYardMule, canViewReports, isLabAdmin, isAccountManager," +
                                                    "UserName, FirstName, LastName FROM dbo.Users WHERE UserID=@USERID";

                DataSet dsUserData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@USERID", UserID));
                foreach (System.Data.DataRow row in dsUserData.Tables[0].Rows)
                {
                    ZXPUser = new ZXPUserData((int)row.ItemArray[0], true, (bool)row.ItemArray[1], (bool)row.ItemArray[2], (bool)row.ItemArray[3], (bool)row.ItemArray[4],
                        (bool)row.ItemArray[5], (bool)row.ItemArray[6], (bool)row.ItemArray[7], (bool)row.ItemArray[8], (bool)row.ItemArray[9], (bool)row.ItemArray[10],
                        row.ItemArray[11].ToString(), row.ItemArray[12].ToString(), row.ItemArray[13].ToString());

                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getUserData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return ZXPUser;
        }

        [System.Web.Services.WebMethod]
        public static int getSecondaryDoubleVerificationInspectionIfExists(int MSinspectionID, string sql_connStr)
        {
            int verificationMSinspectionID = 0;

            try
            {
                string sqlCmdText;
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                //get MSInspectionID of second verification test 
                sqlCmdText = "SELECT TOP 1 ISNULL(MSI.MSInspectionID,0)" +
                                        "FROM dbo.MainScheduleInspectionListsDetails  MSILD " +
                                        "INNER JOIN dbo.MainScheduleInspections MSI ON MSILD.MSInspectionListDetailID = MSI.MSInspectionListDetailID " +
                                        "INNER JOIN (SELECT MSI_1.InspectionHeaderID, MSI_1.MSID, MSI_1.MSInspectionListDetailID, MSILD_1.SortOrder, MSILD_1.MSInspectionListID " +
                                                    "FROM dbo.MainScheduleInspections MSI_1 " +
                                                    "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD_1 ON MSILD_1.MSInspectionListDetailID = MSI_1.MSInspectionListDetailID " +
                                                    "WHERE MSI_1.MSInspectionID = @MSInspID " +
                                                    ") OrigInspection ON OrigInspection.MSID = MSI.MSID AND OrigInspection.InspectionHeaderID = MSILD.InspectionHeaderID " +
                                        "WHERE MSI.needsVerificationTest = 1 " +
                                        "AND MSI.isHidden = 0 " +
                                        "AND MSILD.MSinspectionListID = OrigInspection.MSInspectionListID " +
                                        "ORDER BY MSILD.SortOrder DESC, RunNumber DESC";

                verificationMSinspectionID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSInspID", MSinspectionID)));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getSecondaryDoubleVerificationInspectionIfExists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return verificationMSinspectionID;
        }


        [System.Web.Services.WebMethod]
        public static int getUserIDFromInspection(int MSinspectionID, string sql_connStr)
        {
            int userID;
            try
            {

                ZXPUserData ZXPUser = new ZXPUserData();
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT ISNULL(UserID,0) FROM dbo.MainScheduleInspections WHERE MSInspectionID = @MSInspectionID";
                userID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSinspectionID)));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in getUserIDFromInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return userID;
        }

        [System.Web.Services.WebMethod]
        public static DataSet getLastModifiedInspectionData(int MSinspectionID, string sql_connStr)
        {
            DataSet dsLastModifiedData;
            try
            {

                ZXPUserData ZXPUser = new ZXPUserData();
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "sp_truckscheduleapp_getLastModifiedDataForInspectionResults";
                dsLastModifiedData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.StoredProcedure, sqlQuery, new SqlParameter("@pMSInspectionID", MSinspectionID.ToString()));

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getUserIDFromInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return dsLastModifiedData;
        }


        [System.Web.Services.WebMethod]
        public static Inspection getInspection(int MSInspectionListDetailID, string sql_connStr)
        {
            Inspection nInspection = new Inspection();
            try
            {
                using (var scope = new TransactionScope())
                {
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "SELECT MSInspectionID ,InspectionHeaderID ,MSID  ,InspectionStartEventID ,InspectionEndEventID ,isHidden ,InspectionHeaderName,InspectionTypeID " +
                                    ",LoadType ,UserID,RunNumber ,InspectionComment ,needsVerificationTest ,isFailed ,wasAutoClosed " +
                                    "FROM dbo.MainScheduleInspections " +
                                    "WHERE MSInspectionListDetailID = @MSILDetailID AND isHidden = 0";

                    DataSet MainScheduleInspectionsData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSILDetailID", MSInspectionListDetailID));

                    int MSInspectionID = Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["MSInspectionID"]);
                    int InspectionHeaderID = Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionHeaderID"]);
                    int MSID = Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["MSID"]);
                    int? InspectionStartEventID = (MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionStartEventID"] == DBNull.Value) ? (int?)null : Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionStartEventID"]);
                    int? InspectionEndEventID = (MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionEndEventID"] == DBNull.Value) ? (int?)null : Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionEndEventID"]);
                    bool isHidden = Convert.ToBoolean(MainScheduleInspectionsData.Tables[0].Rows[0]["isHidden"]);
                    string InspectionHeaderName = MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionHeaderName"].ToString();
                    int? InspectionTypeID = (MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionTypeID"] == DBNull.Value) ? (int?)null : Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionTypeID"]);
                    string LoadType = MainScheduleInspectionsData.Tables[0].Rows[0]["LoadType"].ToString();
                    int? UserID = (MainScheduleInspectionsData.Tables[0].Rows[0]["UserID"] == DBNull.Value) ? (int?)null : Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["UserID"]);
                    int? RunNumber = (MainScheduleInspectionsData.Tables[0].Rows[0]["RunNumber"] == DBNull.Value) ? (int?)null : Convert.ToInt32(MainScheduleInspectionsData.Tables[0].Rows[0]["RunNumber"]);
                    string InspectionComment = MainScheduleInspectionsData.Tables[0].Rows[0]["InspectionComment"].ToString();
                    bool needsVerificationTest = Convert.ToBoolean(MainScheduleInspectionsData.Tables[0].Rows[0]["needsVerificationTest"]);
                    bool isFailed = Convert.ToBoolean(MainScheduleInspectionsData.Tables[0].Rows[0]["isFailed"]);
                    bool wasAutoClosed = Convert.ToBoolean(MainScheduleInspectionsData.Tables[0].Rows[0]["wasAutoClosed"]);

                    List<InspectionQuestion> iQuestions = GetInspectionQuestion(MSInspectionID, sql_connStr);
                    if (0 == iQuestions.Count)
                    {
                        throw new Exception("GetInspectionQuestion() Failed - No Questions Found.");
                    }
                    ZXPUserData userWhoCreated = (UserID != null) ? getUserData(UserID, sql_connStr) : new ZXPUserData();

                    //get Verification user
                    int verInspID = getSecondaryDoubleVerificationInspectionIfExists(MSInspectionID, sql_connStr); // find second verification Inspection
                    int verUserID = (verInspID != 0) ? getUserIDFromInspection(verInspID, sql_connStr) : 0;
                    ZXPUserData userWhoPerformedVerification = (verUserID != 0) ? getUserData(verUserID, sql_connStr) : new ZXPUserData();
                    DataSet lastmodData = getLastModifiedInspectionData(MSInspectionID, sql_connStr);
                    DateTime lastModifiedTimestamp = new DateTime(1900, 1, 1);
                    ZXPUserData userWhoLastModified = new ZXPUserData();
                    if (0 != lastmodData.Tables[0].Rows.Count)
                    {

                        int userIDLastModified = (lastmodData.Tables[0].Rows[0]["ChangedBy"] == DBNull.Value) ? 0 : Convert.ToInt32(lastmodData.Tables[0].Rows[0]["ChangedBy"]);
                        if (userIDLastModified != 0)
                        {
                            userWhoLastModified = getUserData(userIDLastModified, sql_connStr);
                        }
                        lastModifiedTimestamp = (lastmodData.Tables[0].Rows[0]["Timestamp"] == DBNull.Value) ? new DateTime(1900, 1, 1) : Convert.ToDateTime(lastmodData.Tables[0].Rows[0]["Timestamp"]);

                    }
                    MainScheduleEvent MSStartEvent = (InspectionStartEventID != null) ? MainScheduleEvent.getEventData(InspectionStartEventID) : new MainScheduleEvent();
                    MainScheduleEvent MSEndEvent = (InspectionEndEventID != null) ? MainScheduleEvent.getEventData(InspectionEndEventID) : new MainScheduleEvent();

                    nInspection = new Inspection(MSInspectionID, InspectionHeaderID, MSInspectionListDetailID, InspectionStartEventID, InspectionEndEventID,
                                 isHidden, InspectionHeaderName, InspectionTypeID, LoadType, UserID, RunNumber, InspectionComment,
                                 needsVerificationTest, isFailed, wasAutoClosed, iQuestions, MSStartEvent, MSEndEvent, userWhoCreated, userWhoPerformedVerification, userWhoLastModified, lastModifiedTimestamp);

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return nInspection;
        }

        [System.Web.Services.WebMethod]
        public static bool isQuestionADealBreaker(int MSInspectionID, int testID, string sql_connStr)
        {
            bool isDealBreaker = false;
            try
            {
                string sqlCmdText;
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT isDealBreaker FROM dbo.MainScheduleInspectionResults WHERE TestID = @TESTID AND MSInspectionID = @MSInspectionID";
                isDealBreaker = Convert.ToBoolean(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TESTID", testID),
                                                                                                                     new SqlParameter("@MSInspectionID", MSInspectionID)));
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions isQuestionADealBreaker(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isDealBreaker;
        }

        [System.Web.Services.WebMethod]
        public static bool isLastAnsweredQuestion(int testID, int MSInspectionID, string sql_connStr)
        {
            bool isLast = false;
            try
            {

                string sqlCmdText;
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT ISNULL(COUNT(MSIR.TestID),0) " +
                                    "FROM dbo.MainScheduleInspectionResults MSIR " +
                                    "WHERE MSIR.MSInspectionID = @MSInspectionID AND MSIR.TestID <> @TESTID AND MSIR.Result = -999; ";  // -999 indicates unanswered
                int result = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TESTID", testID),
                                                                                                                new SqlParameter("@MSInspectionID", MSInspectionID)));
                if (0 == result)
                {
                    isLast = true;
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions isLastAnsweredQuestion(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isLast;
        }

        [System.Web.Services.WebMethod]
        public static void setIsFailedStatus(int MSInspectionID, bool isFailed, DateTime timestamp, string sql_connStr, ZXPUserData zxpUD)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "isFailed", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, isFailed.ToString(), null, "MSInspectionID", MSInspectionID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    //set isFailed flag for the inspection
                    sqlCmdText = "UPDATE dbo.MainScheduleInspections SET isFailed = @ISFAILED WHERE  MSInspectionID = @INSPID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ISFAILED", isFailed),
                                                                                         new SqlParameter("@INSPID", MSInspectionID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions setIsFailedStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void endInspection(int MSID, int MSInspectionID, DateTime timeStamp, Boolean isAutoClosed, string sql_connStr, ZXPUserData zxpUD)
        {
            try
            {

                if (!(MSID > 0 && MSInspectionID > 0))
                {
                    throw new Exception("Invalid MSID:" + MSID.ToString() + " or MSInspectionID: " + MSInspectionID.ToString() + " given in endInspection.");
                }
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    int eventID;
                    if (isAutoClosed)
                    {
                        // EventTypeID = 5098 --> "Inspection Automatically Failed "
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                        "VALUES (@MSID, 5098, @TIME, @INSPECTOR, 'false'); SELECT SCOPE_IDENTITY()";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@INSPECTOR", zxpUD._uid)));
                        sqlCmdText = "UPDATE dbo.MainScheduleInspections SET wasAutoClosed = 1 WHERE MSInspectionID = @INSPID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@INSPID", MSInspectionID));

                        ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "wasAutoClosed", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "1", eventID, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    else
                    {
                        // EventTypeID =22 --> "Inspection Completed "
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                "VALUES (@MSID, 22, @TIME, @INSPECTOR, 'false'); SELECT SCOPE_IDENTITY()";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@INSPECTOR", zxpUD._uid)));
                        sqlCmdText = "UPDATE dbo.MainScheduleInspections SET wasAutoClosed = 0, InspectionEndEventID = @EID WHERE MSInspectionID = @INSPID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID), new SqlParameter("@INSPID", MSInspectionID));

                        ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionEndEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "wasAutoClosed", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "0", eventID, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "9", null, "MSID", MSID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, StatusID = 9 WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp),
                                                                                         new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions endInspection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static List<object[]> getInspectionInformationforAlert(int MSID, int MSInspectionID, string sql_connStr)
        {
            List<object[]> data = new List<object[]>();
            DataSet dataSet = new DataSet();
            try
            {
                string sqlCmdText;
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                sqlCmdText = "SELECT TOP 1 MSI.MSID, MS.PONumber, MS.TrailerNumber, MSIL.ProductID_CMS, PCMS.ProductName_CMS, MSE.TimeStamp AS InspectionEndTime, MSI.InspectionHeaderName " +
                                        ",MSI.RunNumber, MSI.isFailed, MSE.UserId, U.FirstName, U.LastName " +
                                        "FROM dbo.MainScheduleInspections MSI " +
                                        "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD ON MSILD.MSInspectionListDetailID = MSI.MSInspectionListDetailID " +
                                        "INNER JOIN dbo.MainScheduleInspectionLists MSIL ON MSIL.MSInspectionListID = MSILD.MSInspectionListID " +
                                        "INNER JOIN dbo.MainSchedule MS ON MS.MSID = MSI.MSID " +
                                        "LEFT JOIN dbo.ProductsCMS PCMS ON PCMS.ProductID_CMS = MSIL.ProductID_CMS " +
                                        "LEFT JOIN dbo.MainScheduleEvents MSE ON MSE.EventID = MSI.InspectionEndEventID " +
                                        "LEFT JOIN dbo.Users U ON MSE.UserId = U.UserID " +
                                        "WHERE MSI.MSID = @MSID AND MSI.MSInspectionID = @MSInspectionID AND MSI.isHidden = 0 AND MSIL.isHidden = 0";
                dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                              new SqlParameter("@MSInspectionID", MSInspectionID));

                //populate return object
                foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                {
                    data.Add(row.ItemArray);
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions getInspectionInformationforAlert(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return data;
        }


        [System.Web.Services.WebMethod]
        public static string createCustomInspectionFailedMessage(int MSID, int MSInspectionID, string sql_connStr)
        {
            string customAlertMsg = string.Empty;
            try
            {

                List<object[]> inspectionInfo = getInspectionInformationforAlert(MSID, MSInspectionID, sql_connStr);
                if (inspectionInfo != null && inspectionInfo.Count != 0)
                {
                    string sMSID = inspectionInfo[0][0].ToString();
                    string sPONumber = inspectionInfo[0][1].ToString();
                    string sTrailer = inspectionInfo[0][2].ToString();
                    string sCMSProdID = inspectionInfo[0][3].ToString();
                    string sCMSProdName = inspectionInfo[0][4].ToString();
                    string sInspectionEndTime = inspectionInfo[0][5].ToString();
                    string sInspectionName = inspectionInfo[0][6].ToString();
                    string sRunNumber = inspectionInfo[0][7].ToString();
                    string sIsFailed = inspectionInfo[0][8].ToString();
                    string sUserID = inspectionInfo[0][9].ToString();
                    string sFirstName = inspectionInfo[0][10].ToString();
                    string sLastName = inspectionInfo[0][11].ToString();

                    customAlertMsg = "Inspection failed. Details: " + System.Environment.NewLine +
                        "Inspection name: " + sInspectionName + " Run #" + sRunNumber + System.Environment.NewLine +
                        "For PO-Trailer: " + sPONumber + "-" + sTrailer + System.Environment.NewLine +
                        "For product: " + sCMSProdID + "(" + sCMSProdName + ")" + System.Environment.NewLine +
                        "Inspection done by: " + sFirstName + " " + sLastName + System.Environment.NewLine +
                        "On: " + sInspectionEndTime + System.Environment.NewLine;
                }
                else
                {
                    Exception ex = new Exception("No inspection Information was found. Please check if this is the correct inspection.");
                    throw ex;
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions createCustomInspectionFailedMessage(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return customAlertMsg;
        }

        [System.Web.Services.WebMethod]
        public static int checkifAnyQuestionsAreNotFailed(int MSInspectionID, string sql_connStr)
        {
            int numOfNonFailedQuestions = -1;
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                      "FROM dbo.MainScheduleInspectionResults MSIR " +
                      "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                      "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (1, -1) ";

                numOfNonFailedQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));
                if (-1 == numOfNonFailedQuestions)
                {
                    throw new Exception("checkifAnyQuestionsAreNotFailed Query Failed");
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions checkifAllQuestionsAreFailed(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return numOfNonFailedQuestions;
        }

        [System.Web.Services.WebMethod]
        public static int checkForNumberOfUnansweredQuestions(int MSInspectionID, string sql_connStr)
        {
            int numOfUnansweredQuestions = -1;
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                      "FROM dbo.MainScheduleInspectionResults MSIR " +
                      "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                      "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (-999) "; //-999 = unanswered


                numOfUnansweredQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));

                if (-1 == numOfUnansweredQuestions)
                {
                    throw new Exception("checkForNumberOfUnansweredQuestions Query Failed");
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions checkForNumberOfUnansweredQuestions(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return numOfUnansweredQuestions;
        }

        public static int checkifAnyQuestionsAreNotPassedThatAreDealBreakers(int MSInspectionID, string sql_connStr)
        {
            int numOfFailedQuestions = -1;
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                      "FROM dbo.MainScheduleInspectionResults MSIR " +
                      "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                      "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (0) AND isDealBreaker = 1";  


                numOfFailedQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));

                if (-1 == numOfFailedQuestions)
                {
                    throw new Exception("checkifAnyQuestionsAreNotPassed Query Failed");
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions checkifAnyQuestionsAreNotPassedThatAreDealBreakers(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return numOfFailedQuestions;
        }
        
        [System.Web.Services.WebMethod]
        public static int checkifAnyQuestionsAreNotPassed(int MSInspectionID, string sql_connStr)
        {
            int numOfFailedQuestions = -1;
            try
            {

                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                string sqlQuery = "SELECT ISNULL(COUNT(Result),0) " +
                      "FROM dbo.MainScheduleInspectionResults MSIR " +
                      "INNER JOIN dbo.MainScheduleInspections MSI ON MSI.MSInspectionID = MSIR.MSInspectionID " +
                      "WHERE MSIR.MSInspectionID = @MSInspectionID AND Result IN (0) "; //0 = failed


                numOfFailedQuestions = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@MSInspectionID", MSInspectionID)));

                if (-1 == numOfFailedQuestions)
                {
                    throw new Exception("checkifAnyQuestionsAreNotPassed Query Failed");
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions checkifAnyQuestionsAreNotPassed(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }
            return numOfFailedQuestions;
        }

        [System.Web.Services.WebMethod]
        public static void setAutoClosedStatus(int MSInspectionID, bool isAutoClosed, DateTime timestamp, string sql_connStr, ZXPUserData zxpUD)
        {
            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    ChangeLog cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "wasAutoClosed", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.BIT, isAutoClosed.ToString(), null, "MSInspectionID", MSInspectionID.ToString());
                    cLog.CreateChangeLogEntryIfChanged();
                    //set isFailed flag for the inspection
                    sqlCmdText = "UPDATE dbo.MainScheduleInspections SET wasAutoClosed = @ISAUTOCLOSED WHERE  MSInspectionID = @INSPID";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@ISAUTOCLOSED", isAutoClosed),
                                                                                         new SqlParameter("@INSPID", MSInspectionID));
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions setAutoClosedStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        [System.Web.Services.WebMethod]
        public static void setCompleteStatus(int MSID, int MSInspectionID, DateTime timeStamp, Boolean isComplete, string sql_connStr, ZXPUserData zxpUD)
        {
            try
            {
                if (!(MSID > 0 && MSInspectionID > 0))
                {
                    throw new Exception("Invalid MSID:" + MSID.ToString() + " or MSInspectionID: " + MSInspectionID.ToString() + " given in endInspection.");
                }
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    ChangeLog cLog;

                    SqlParameter paramMSID = new SqlParameter("@MSID", SqlDbType.Int);
                    SqlParameter paramTimeStamp = new SqlParameter("@TIME", SqlDbType.NVarChar);
                    SqlParameter paramInspector = new SqlParameter("@INSPECTOR", SqlDbType.Int);
                    SqlParameter paramMSInspectionID = new SqlParameter("@INSPID", SqlDbType.Int);
                    paramTimeStamp.Value = timeStamp;
                    paramMSID.Value = MSID;
                    paramInspector.Value = zxpUD._uid;
                    paramMSInspectionID.Value = MSInspectionID;

                    if (isComplete)
                    {
                        int eventID;
                        // EventTypeID =22 --> "Inspection Completed "
                        sqlCmdText = "INSERT INTO dbo.MainScheduleEvents (MSID, EventTypeID,Timestamp, UserId, isHidden) " +
                                                "VALUES (@MSID, 22, @TIME, @INSPECTOR, 'false'); SELECT SCOPE_IDENTITY()";
                        eventID = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID),
                                                                                                                     new SqlParameter("@TIME", timeStamp),
                                                                                                                     new SqlParameter("@INSPECTOR", zxpUD._uid)));
                        sqlCmdText = "UPDATE dbo.MainScheduleInspections SET InspectionEndEventID = @EID WHERE MSInspectionID = @INSPID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@EID", eventID),
                                                                                             new SqlParameter("@INSPID", MSInspectionID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionEndEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, eventID.ToString(), eventID, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, timeStamp.ToString(), eventID, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "9", null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    else
                    {
                        sqlCmdText = "UPDATE dbo.MainScheduleInspections SET InspectionEndEventID = NULL WHERE MSInspectionID = @INSPID";
                        SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@INSPID", MSInspectionID));

                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspections", "InspectionEndEventID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "NULL", null, "MSInspectionID", MSInspectionID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "LastUpdated", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, timeStamp.ToString(), null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                        cLog = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainSchedule", "StatusID", timeStamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, "9", null, "MSID", MSID.ToString());
                        cLog.CreateChangeLogEntryIfChanged();
                    }
                    sqlCmdText = "UPDATE dbo.MainSchedule SET LastUpdated = @TIME, StatusID = 9 WHERE (MSID = @MSID)";
                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TIME", timeStamp), new SqlParameter("@MSID", MSID));

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions setCompleteStatus(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
        }

        //Checks if the current user performing/view/editing/creating the inspection is associated to a verification inspectiion 
        [System.Web.Services.WebMethod]
        public static bool didUserStartAnotherVerificationInspectionOfSameType(int MSInspectListID, int MSInspectID, int userID, int MSID, string sql_connStr)
        {
            bool didStart = false;
            try
            {

                string sqlCmdText;
                //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                //1) Check if there are same existing inspections of the selected started by users that are verifications test

                //Check if there exists a verification inspection of the same type under the selected list that was started by user excluding the selected inspection
                sqlCmdText = "SELECT ISNULL(COUNT(MSI.MSInspectionID), 0) " +
                                        "FROM dbo.MainScheduleInspectionListsDetails  MSILD " +
                                        "INNER JOIN dbo.MainScheduleInspections MSI ON MSILD.MSInspectionListDetailID = MSI.MSInspectionListDetailID " +
                                        "WHERE MSILD.MSInspectionListID = @MSIListID  " +
                                        "AND MSI.InspectionHeaderID =  " +                      //check for same type of inspection as selected
                                                "(	SELECT InspectionHeaderID " +
                                                    "FROM dbo.MainScheduleInspections MSI_1  " +
                                                    "WHERE MSI_1.MSInspectionID = @MSInspID " +
                                                ") " +
                                        "AND MSI.needsVerificationTest = 1 " +                 //filter to make sure inspection is a verification test 
                                        "AND MSI.isHidden = 0 " +
                                        "AND USERID = @UID " +
                                        "AND MSI.MSID = @MSID " +  //only count inspections under the truck/MSID
                                        "AND MSI.wasAutoClosed = 0 " +
                                        "AND MSI.MSInspectionID <> @MSInspID";
                int inspectionCount = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSIListID", MSInspectListID),
                                                                                                                         new SqlParameter("@MSInspID", MSInspectID),
                                                                                                                         new SqlParameter("@UID", userID),
                                                                                                                         new SqlParameter("@MSID", MSID)));
                if (inspectionCount > 0)
                {  //if count > 0 then there exists an inspection by user of same type. User cannot perform inspection.
                    didStart = true;
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions didUserStartAnotherVerificationInspectionOfSameType(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return didStart;
        }

        [System.Web.Services.WebMethod]
        public static bool haveAllPreviousInspectionsBeenDoneInOrder(int MSInspectListID, int MSInspectID, string sql_connStr)
        {
            bool isDone = false;
            try
            {
                string sqlCmdText;

                //find if there exists an inspection under the list with a sort order lower than the selected inspection that has not been completed
                sqlCmdText = "SELECT ISNULL(COUNT(MSI.MSInspectionID), 0) " +
                                        "FROM dbo.MainScheduleInspections MSI " +
                                        "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD ON MSI.MSInspectionListDetailID = MSILD.MSInspectionListDetailID " +
                                        "WHERE MSILD.MSInspectionListID = @MSIListID " +
                                        "AND MSI.isHidden = 0 " +
                                        "AND MSI.InspectionEndEventID IS NULL " + //check if not completed
                                                                                  //"AND MSI.wasAutoClosed = 0 " +          //TODO: CL: ask zxp if they should be able to continue other inspections if previous inspections have not been started but was autoclosed
                                        "AND MSILD.SortOrder <= ( SELECT  MSILD_1.SortOrder " +
                                                                "FROM dbo.MainScheduleInspections MSI_1 " +
                                                                "INNER JOIN dbo.MainScheduleInspectionListsDetails MSILD_1 ON MSI_1.MSInspectionListDetailID = MSILD_1.MSInspectionListDetailID " +
                                                                "WHERE MSI_1.MSInspectionID = @MSInspID ) " +
                                        "AND MSI.MSInspectionID <> @MSInspID";
                int countOfInspectionsNotCompleted = Convert.ToInt32(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSIListID", MSInspectListID),
                                                                                                                                        new SqlParameter("@MSInspID", MSInspectID)));
                if (0 == countOfInspectionsNotCompleted)
                {
                    isDone = true;
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions haveAllPreviousInspectionsBeenDoneInOrder(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            return isDone;
        }

        [System.Web.Services.WebMethod]
        public static List<object> canInspectionBeEdited(int prodDetailID, int MSInspectionListID, int MSInspectionID, string sql_connStr, ZXPUserData zxpUD)
        {
            string outputMsg = string.Empty;
            bool canEdit = false;
            try
            {

                DataSet dsGridData = GetPOdetailsData(prodDetailID, sql_connStr);
                if (0 == dsGridData.Tables[0].Rows.Count)
                {
                    throw new Exception("GetPOdetailsData() Failed");
                }
                int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);


                //1) CHECK if the logged in inspector can start this inspectionID
                bool didUserStartDoVerifyInspectionBefore = didUserStartAnotherVerificationInspectionOfSameType(MSInspectionListID, MSInspectionID, zxpUD._uid, MSID,sql_connStr);

                if (didUserStartDoVerifyInspectionBefore)
                {
                    outputMsg = outputMsg + "You are not permitted to start this inspection as you have already started or done an inspection of this kind for this truck. Please ask another user to perform the inspection. ";
                }
                //2) Check if previous necessary inspections have been completed 
                bool arePrevInspectionsDone = haveAllPreviousInspectionsBeenDoneInOrder(MSInspectionListID, MSInspectionID, sql_connStr);

                if (!arePrevInspectionsDone)
                {
                    outputMsg = outputMsg + "There are inspections that need to be done prior to starting the selected inspection. Please make sure those are completed before continuing. ";
                }
                canEdit = !didUserStartDoVerifyInspectionBefore && arePrevInspectionsDone;

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions canInspectionBeStarted(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);

            }
            List<object> returnObj = new List<object>();
            returnObj.Add(canEdit);
            returnObj.Add(outputMsg);
            return returnObj;
        }

        [System.Web.Services.WebMethod]
        public static List<object> setInspectionResult(int MSInspectionID, int testID, int result, int prodDetailID, string sql_connStr, ZXPUserData zxpUD)
        {
            DateTime timestamp = DateTime.Now; //Initialize the timestamp here
            String returnMsg = String.Empty;
            bool isDealBreaker = false;
            bool isLastQuestion = false;
            int verInspID = 0;
            bool hasEnded = false;
            int numOfUnansweredQuestions = 0;

            try
            {
                using (var scope = new TransactionScope())
                {
                    DataSet dsGridData = GetPOdetailsData(prodDetailID, sql_connStr);
                    if (0 == dsGridData.Tables[0].Rows.Count)
                    {
                        throw new Exception("GetPOdetailsData() Failed");
                    }
                    int MSID = Convert.ToInt32(dsGridData.Tables[0].Rows[0]["MSID"]);

                    ChangeLog cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspectionResults", "Result", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.INT, result.ToString(), null, "MSInspectionID", MSInspectionID.ToString(), "testID", testID.ToString());
                    cl.CreateChangeLogEntryIfChanged();
                    cl = new ChangeLog(ChangeLog.ChangeLogChangeType.UPDATE, "MainScheduleInspectionResults", "SubmittedTimeStamp", timestamp, zxpUD._uid, ChangeLog.ChangeLogDataType.DATETIME, timestamp.ToString(), null, "MSInspectionID", MSInspectionID.ToString(), "testID", testID.ToString());
                    cl.CreateChangeLogEntryIfChanged();

                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    string sqlQuery = "UPDATE dbo.MainScheduleInspectionResults SET Result = @Result, SubmittedTimeStamp = @TIME, UserID = @USER " +
                                    "WHERE (TestID = @TID AND MSInspectionID = @INSPID)";

                    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@Result", result)
                                                                                                , new SqlParameter("@TIME", timestamp)
                                                                                                , new SqlParameter("@USER", zxpUD._uid)
                                                                                                , new SqlParameter("@TID", testID)
                                                                                                , new SqlParameter("@INSPID", MSInspectionID));

                    //check if inspection needs to end based on different conditions
                    verInspID = getSecondaryDoubleVerificationInspectionIfExists(MSInspectionID, sql_connStr); // find second verification Inspection
                    isDealBreaker = isQuestionADealBreaker(MSInspectionID, testID, sql_connStr);// check if is dealbreaker
                    isLastQuestion = isLastAnsweredQuestion(testID, MSInspectionID, sql_connStr);

                    if (0 == result) //if question is failed
                    {
                        //If a deal breaker question is failed, inspection fails
                        //All questions in a second verification inspection are deal breakers
                        if (isDealBreaker || (verInspID == MSInspectionID)) //if this is a dealbreaker question or if this is the second verification inspection, set isFailed flag
                        {
                            if (verInspID == MSInspectionID)
                            {
                                returnMsg = "This inspection is for the secondary validation. All questions are critical questions. ";
                            }
                            returnMsg = returnMsg + "The inspection has failed and will end due to failing a critical inspection question. ";
                            setIsFailedStatus(MSInspectionID, true, timestamp, sql_connStr, zxpUD);

                            endInspection(MSID, MSInspectionID, timestamp, false, sql_connStr, zxpUD);
                            hasEnded = true;
                            //Log event failed

                            MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                            MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                            string newAlertMsg = createCustomInspectionFailedMessage(MSID, MSInspectionID, sql_connStr);
                            msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, returnMsg + newAlertMsg);
                        }
                        //Automatically fail a second verification inspection because the user does not need to complete it
                        //if it double verification exists and it is not the same as the current inspection set isFail flag
                        if (isDealBreaker && verInspID > 0 && verInspID != MSInspectionID)
                        {
                            setIsFailedStatus(verInspID, true, timestamp, sql_connStr, zxpUD);
                            endInspection(MSID, verInspID, timestamp, true, sql_connStr, zxpUD);
                            MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                            MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                            string newAlertMsg = createCustomInspectionFailedMessage(MSID, verInspID, sql_connStr);
                            msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, "Secondary Inspection Autofailed." + newAlertMsg);

                            returnMsg = returnMsg + "Because a verification inspection exists, that secondary inspection was also set to \"Failed\" and does not need to be completed.";
                        }

                        if (!hasEnded)
                        {
                            //check if all questions are failed and set isFailed
                            int numOfNonFailedQuestions = checkifAnyQuestionsAreNotFailed(MSInspectionID, sql_connStr);
                            numOfUnansweredQuestions = checkForNumberOfUnansweredQuestions(MSInspectionID, sql_connStr);

                            if (0 == numOfNonFailedQuestions && numOfUnansweredQuestions == 0)
                            {
                                //All questions failed. update inspection status to fail;
                                setIsFailedStatus(MSInspectionID, true, timestamp, sql_connStr, zxpUD);
                                endInspection(MSID, MSInspectionID, timestamp, false, sql_connStr, zxpUD);
                                returnMsg = returnMsg + "The inspection has failed and will end due to failing all questions. ";

                                MainScheduleEventLogger msEventLog = new MainScheduleEventLogger();
                                MainScheduleEvent msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                                string newAlertMsg = createCustomInspectionFailedMessage(MSID, MSInspectionID, sql_connStr);
                                msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, returnMsg + newAlertMsg);
                                hasEnded = true;

                                if (verInspID > 0 && verInspID != MSInspectionID)
                                {
                                    setIsFailedStatus(verInspID, true, timestamp, sql_connStr, zxpUD);
                                    endInspection(MSID, verInspID, timestamp, true, sql_connStr, zxpUD);
                                    msEventLog = new MainScheduleEventLogger();
                                    msEvent = new MainScheduleEvent(MSID, 7098, null, timestamp, zxpUD._uid, false);
                                    newAlertMsg = createCustomInspectionFailedMessage(MSID, verInspID, sql_connStr);
                                    msEventLog.createNewEventLogAndTriggerExistingAlerts(msEvent, "Secondary Inspection Autofailed." + newAlertMsg);

                                    returnMsg = returnMsg + "Because a verification inspection exists, that secondary inspection was also set to \"Failed\" and does not need to be completed.";
                                }
                            }
                        }
                    }

                    //automatically end inspection if last question
                    int numOfNonPassedQuestions = checkifAnyQuestionsAreNotPassed(MSInspectionID, sql_connStr);
                    numOfUnansweredQuestions = checkForNumberOfUnansweredQuestions(MSInspectionID,sql_connStr);
                    int numOfDealBreakerNonPassedQuestions = checkifAnyQuestionsAreNotPassedThatAreDealBreakers(MSInspectionID, sql_connStr);

                    if ((!hasEnded && 0 == numOfNonPassedQuestions && numOfUnansweredQuestions == 0) ||
                        (!hasEnded && 0 < numOfNonPassedQuestions && 0 == numOfUnansweredQuestions && 0 == numOfDealBreakerNonPassedQuestions))
                    {
                        //All questions passed. update inspection status to pass;

                        setIsFailedStatus(MSInspectionID, false, timestamp, sql_connStr, zxpUD);
                        if (verInspID > 0 && verInspID != MSInspectionID)
                        {
                            int numOfFailedVerificationQuestions = checkifAnyQuestionsAreNotPassed(verInspID,sql_connStr);
                            bool verificationFailed = true;
                            if (0 == numOfFailedVerificationQuestions)
                            {
                                verificationFailed = false;
                            }
                            setAutoClosedStatus(verInspID, false, timestamp, sql_connStr, zxpUD);
                            setIsFailedStatus(verInspID, verificationFailed, timestamp, sql_connStr, zxpUD);
                        }
                    }
                    if (!hasEnded && isLastQuestion) //close the inspection if all question have been answered; this will trigger even if only updating comments 
                    {

                        endInspection(MSID, MSInspectionID, timestamp, false, sql_connStr, zxpUD);
                        returnMsg = returnMsg + Environment.NewLine + "All questions answered. Inspection has ended.";
                        hasEnded = true;
                    }
                    if (!hasEnded && !isLastQuestion)
                    {
                        setCompleteStatus(MSID, MSInspectionID, timestamp, false, sql_connStr, zxpUD);
                    }
                    if (hasEnded && isLastQuestion)
                    {
                        setCompleteStatus(MSID, MSInspectionID, timestamp, true, sql_connStr, zxpUD);
                    }
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in InspectionsHelperFunctions setInspectionResult(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            List<object> returnData = new List<object>();
            returnData.Add(timestamp);
            returnData.Add(returnMsg);
            returnData.Add(hasEnded);
            returnData.Add(isLastQuestion);
            return returnData;


        }
    }
}