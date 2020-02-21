using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Specialized;
using System.Data;
using Microsoft.ApplicationBlocks.Data;
using System.Diagnostics;
using NLog;
using Newtonsoft.Json;


namespace TransportationProjectDataLayer
{
    public interface IDataProvider
    {
        IEnumerable<CMSProduct> GetProductCMS();
        IEnumerable<CMSProduct> GetProductCMS(string product);
        List<TrailerGridData> GetTrailerGridData();
        List<LoadTypes> GetLoadTypes(bool? isUsedForInspections);
        List<PODetails> GetPODetails(int? MSID);
        int GetRowCountForPO(int PO);
        List<DomainModels.Status> GetStatuses();
        List<DomainModels.Status> GetStatusesFilteredByLocation(string locationShort);
        List<DomainModels.Locations> GetLocations();
        List<DomainModels.FileTypes> GetFileTypes();
        List<DomainModels.TruckTypes> GetTruckTypes();
        List<DomainModels.UnitOfMeasure> GetUnitsOfMeasure();
        List<DomainModels.MainScheduleFiles> GetMainScheduleFiles(int MSID);
        List<DomainModels.CalendarEvents> GetDatesToDisableInSchedule();


    }


    public class TransportationProjectDataProvider : IDataProvider

    {
        protected static Logger logger = LogManager.GetLogger("dpLogger");
        protected string getConnectionStringFromSettings()
        {

            try
            {

                string connStr = ConfigurationManager.ConnectionStrings["SQLConnectionString"].ConnectionString;
                if (connStr == String.Empty)
                {
                    throw new Exception("Missing SQLConnectionString in web.config");
                }
                return connStr;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetTrailerGridData(). Details: " + ex.ToString();
                MessageLog alog = new MessageLog(MessageType.Exception, "User called function with param companyName =" + strErr);
                logger.Error(alog.CreateAuditLogMessage());
                throw;
            }

        }

        public BulkReport GetBulkReport(int MSID, int UserID)
        {
            BulkReport bulkReport = new BulkReport();

            try
            {
                SqlDataReader sReader;
                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    string sqlCmdText = "sp_truckschedapp_getTruckScheduleBulkReport";
                    sqlConn.Open();
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@MSID", MSID));
                        cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                        sReader = cmd.ExecuteReader();

                    }

                    while (sReader.Read())
                    {

                        bulkReport = new BulkReport(MSID, (int)sReader["CreatedByUserID"], (int)sReader["LastModifiedByUserID"], (int)sReader["TankStrapBeforeSectionID"], 
                                                    (int)sReader["TankStrapAfterSectionID"], (DateTime)sReader["LastModifiedDateTimeUTC"]);

                        bulkReport.LoaderUnloaderName = sReader["LoaderUnloaderName"].ToString();
                        bulkReport.LogNumber = sReader["LogNumber"].ToString();
                        bulkReport.ReleaseNumber = sReader["ReleaseNumber"].ToString();
                        bulkReport.InputStartUTC = sReader["InputStartUTC"] != DBNull.Value ? (DateTime?)sReader["InputStartUTC"] : null;
                        bulkReport.InputStartUTC = sReader["InputEndUTC"] != DBNull.Value ? (DateTime?)sReader["InputEndUTC"] : null;
                        bulkReport.TankNumber = sReader["TankNumber"].ToString();
                        bulkReport.TotalGalLoadedOrUnloaded = sReader["TotalGalLoadedOrUnloaded"] != DBNull.Value ? (double?)sReader["TotalGalLoadedOrUnloaded"] : null;
                        bulkReport.FlushGal = sReader["FlushGal"] != DBNull.Value ? (double?)sReader["FlushGal"] : null;
                        bulkReport.TotalNetGal = sReader["TotalNetGal"] != DBNull.Value ? (double?)sReader["TotalNetGal"] : null;
                        bulkReport.BOLNetWeight = sReader["BOLNetWeight"] != DBNull.Value ? (double?)sReader["BOLNetWeight"] : null;
                        bulkReport.Comments = sReader["Comments"].ToString();
                        bulkReport.Seals = sReader["Seals"].ToString();
                        
                    }
    
                }

                TankStrapping beforeStrap = GetTankStrap(bulkReport.BeforeTankStrap.TankStrapID);
                bulkReport.BeforeTankStrap = beforeStrap;
                TankStrapping afterStrap = GetTankStrap(bulkReport.AfterTankStrap.TankStrapID);
                bulkReport.AfterTankStrap = afterStrap;

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetBulkReport(). Details: " + ex.ToString();
                string msg = string.Concat("User called function with param MSID =", MSID.ToString(), " , UserID= ", UserID.ToString(), " with exception  =",  strErr);
                MessageLog alog = new MessageLog(MessageType.Exception, msg);
                logger.Error(alog.CreateAuditLogMessage());
                throw;

            }

            return bulkReport;


        }



        public TankStrapping GetTankStrap(int TankStrapID)
        {
            TankStrapping tankstrap = new TankStrapping();

            try
            {
                SqlDataReader sReader;
                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    string sqlCmdText = "sp_truckschedapp_getTruckScheduleTankStrap";
                    sqlConn.Open();
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@TankStrapID", TankStrapID));
                        sReader = cmd.ExecuteReader();

                    }

                    while (sReader.Read())
                    {
                        tankstrap = new TankStrapping((int)sReader["TankStrapID"], (bool) sReader["isBefore"]);


                        tankstrap.TemperatureF = sReader["TemperatureF"] != DBNull.Value ? (double?) sReader["TemperatureF"] : null;
                        tankstrap.Feet = sReader["Feet"] != DBNull.Value ? (int?)sReader["Feet"]: null;
                        tankstrap.Inches = sReader["Inches"] != DBNull.Value ? (int?)sReader["Inches"]: null ;
                        tankstrap.GalFromFtandIn = sReader["GalFromFtandIn"] != DBNull.Value ? (double?)sReader["GalFromFtandIn"] : null;
                        tankstrap.Fraction = sReader["Fraction"].ToString();
                        tankstrap.GalFromFraction = sReader["GalFromFraction"] != DBNull.Value ? (double?)sReader["GalFromFraction"] : null;
                        tankstrap.Conv = sReader["Conv"].ToString();
                        tankstrap.XGAL = sReader["XGAL"].ToString();

                    }
                }
                
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetTankStrap(). Details: " + ex.ToString();
                string msg = string.Concat("User called function with param TankStrapID =", TankStrapID.ToString(), " with exception  =", strErr);
                MessageLog alog = new MessageLog(MessageType.Exception, msg);
                logger.Error(alog.CreateAuditLogMessage());
                throw;

            }

            return tankstrap;
            
        }

        public void EditBulkReport(int MSID, int UserID, BulkReport bulkReportInfo)
        {
            try
            {
                //update tank straps
                EditTankStrap(bulkReportInfo.BeforeTankStrap);
                EditTankStrap(bulkReportInfo.AfterTankStrap);

                //Edit BulkReport Entry
                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    string sqlCmdText = "sp_truckschedapp_editTruckScheduleBulkReport";
                    sqlConn.Open();
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@MSID", bulkReportInfo.MSID));
                        cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                        cmd.Parameters.Add(new SqlParameter("@LoaderUnloaderName", bulkReportInfo.LoaderUnloaderName));
                        cmd.Parameters.Add(new SqlParameter("@LogNumber", bulkReportInfo.LogNumber));
                        cmd.Parameters.Add(new SqlParameter("@ReleaseNumber", bulkReportInfo.ReleaseNumber));
                        cmd.Parameters.Add(new SqlParameter("@InputStartUTC", bulkReportInfo.InputStartUTC));
                        cmd.Parameters.Add(new SqlParameter("@InputEndUTC", bulkReportInfo.InputEndUTC));
                        cmd.Parameters.Add(new SqlParameter("@TankNumber", bulkReportInfo.TankNumber));
                        cmd.Parameters.Add(new SqlParameter("@TotalGalLoadedOrUnloaded", bulkReportInfo.TotalGalLoadedOrUnloaded));
                        cmd.Parameters.Add(new SqlParameter("@FlushGal", bulkReportInfo.FlushGal));
                        cmd.Parameters.Add(new SqlParameter("@TotalNetGal", bulkReportInfo.TotalNetGal));
                        cmd.Parameters.Add(new SqlParameter("@BOLNetWeight", bulkReportInfo.BOLNetWeight));
                        cmd.Parameters.Add(new SqlParameter("@Comments", bulkReportInfo.Comments));
                        cmd.Parameters.Add(new SqlParameter("@LastModifiedDateTimeUTC", bulkReportInfo.LastModifiedDateTimeUTC));
                        cmd.Parameters.Add(new SqlParameter("@Seals", bulkReportInfo.Seals); 
                        
                        cmd.ExecuteNonQuery();

                    }

                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider EditBulkReport(). Details: " + ex.ToString();
                string strbulkReport = JsonConvert.SerializeObject(bulkReportInfo);
                string msg = string.Concat("User called function with param MSID =", MSID.ToString(), ", UserID = ", UserID.ToString(), "bulkRpeportInfo =  ", strbulkReport, " with exception  =", strErr);
                MessageLog alog = new MessageLog(MessageType.Exception, msg);
                logger.Error(alog.CreateAuditLogMessage());
                throw;

            }

        }
        public void EditTankStrap(TankStrapping TankStrapInfo)
        {
            
            try
            {
                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    string sqlCmdText = "sp_truckschedapp_editTruckScheduleTankStrap";
                    sqlConn.Open();
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@TankStrapID", TankStrapInfo.TankStrapID));
                        cmd.Parameters.Add(new SqlParameter("@TemperatureF", TankStrapInfo.TemperatureF));
                        cmd.Parameters.Add(new SqlParameter("@Feet", TankStrapInfo.Feet));
                        cmd.Parameters.Add(new SqlParameter("@Inches", TankStrapInfo.Inches));
                        cmd.Parameters.Add(new SqlParameter("@GalFromFtandIn", TankStrapInfo.GalFromFtandIn));
                        cmd.Parameters.Add(new SqlParameter("@Fraction", TankStrapInfo.Fraction));
                        cmd.Parameters.Add(new SqlParameter("@GalFromFraction", TankStrapInfo.GalFromFraction));
                        cmd.Parameters.Add(new SqlParameter("@Conv", TankStrapInfo.Conv));
                        cmd.Parameters.Add(new SqlParameter("@XGAL", TankStrapInfo.XGAL));
                        cmd.ExecuteNonQuery();

                    }
                    
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider EditTankStrap(). Details: " + ex.ToString();
                string strTankStrap = JsonConvert.SerializeObject(TankStrapInfo);
                string msg = string.Concat("User called function with param TankStrapID =", TankStrapID.ToString(), ", TankStrapInfo =", strTankStrap,  " with exception  =", strErr);
                MessageLog alog = new MessageLog(MessageType.Exception, msg);
                logger.Error(alog.CreateAuditLogMessage());
                throw;

            }

        }





        public List<LoadTypes> GetLoadTypes(bool? isUsedForInspections)
        {
            List<LoadTypes> data = new List<LoadTypes>();

            try
            {
                string sqlCmdText;

                sqlCmdText = "SELECT LoadTypeShort, LoadTypeLong , isUsedOnlyForInspections FROM dbo.LoadTypes ";
                sqlCmdText = (isUsedForInspections.HasValue) ? string.Concat(sqlCmdText, "  WHERE(isUsedOnlyForInspections = @isForInspection) ") : sqlCmdText;

                sqlCmdText = string.Concat(sqlCmdText, " ORDER BY LoadTypeLong");
        
                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    sqlConn.Open();
                    SqlDataReader sReader;
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.Text;
                        if (isUsedForInspections.HasValue)
                        {
                            cmd.Parameters.Add(new SqlParameter("@isForInspection", isUsedForInspections));
                        }
                        sReader = cmd.ExecuteReader();

                    }

                    while (sReader.Read())
                    {

                        string shortName = sReader["LoadTypeShort"].ToString();
                        string longName = sReader["LoadTypeShort"].ToString();
                        bool isForInspection = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isUsedOnlyForInspections"));

                        LoadTypes lData = new LoadTypes(shortName, longName, isForInspection);
                        data.Add(lData);
                    }
                }

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetLoadTypes(). Details: " + ex.ToString();
                MessageLog alog = new MessageLog(MessageType.Exception, "GetLoadTypes Exception Message=" + strErr);
                logger.Error(alog.CreateAuditLogMessage());

                throw;
            }
            return data;

        }
        public List<PODetails> GetPODetails(int? MSID)
        {
            List<PODetails> data = new List<PODetails>();
            try
            {
                string sqlCmdText;
                sqlCmdText = string.Concat("SELECT  ProductName_CMS, PODetailsID, ProductID_CMS, MSID",
                                          ", QTY, LotNumber, UnitOfMeasure, FileID_COFA ",
                                          "FROM dbo.vw_PODetails ");
                sqlCmdText = (MSID.HasValue) ? string.Concat(sqlCmdText, " WHERE MSID = @MSID ") : sqlCmdText;

                sqlCmdText = string.Concat(sqlCmdText, " ORDER BY ProductName_CMS ");


                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    sqlConn.Open();
                    SqlDataReader sReader;
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.Text;
                        if (MSID.HasValue)
                        {
                            cmd.Parameters.Add(new SqlParameter("@MSID", MSID));
                        }
                        sReader = cmd.ExecuteReader();

                    }

                    while (sReader.Read())
                    {
                        PODetails pData = new PODetails();


                        pData.ProductName_CMS = sReader["ProductName_CMS"].ToString();
                        pData.PODetailsID = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("PODetailsID"));
                        pData.ProductID_CMS = sReader["ProductID_CMS"].ToString();
                        pData.MSID = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("MSID"));
                        pData.QTY = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("QTY"));
                        pData.LotNumber = sReader["LotNumber"].ToString();
                        pData.UnitOfMeasure = sReader["UnitOfMeasure"].ToString();
                        pData.FileID_COFA = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("FileID_COFA"));

                        data.Add(pData);
                    }
                }
            }

            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetPODetails(). Details: " + ex.ToString();
                MessageLog alog = new MessageLog(MessageType.Exception, "GetPODetails Exception Message=" + strErr);
                logger.Error(alog.CreateAuditLogMessage());

                throw;
            }
            return data;

        }

        public List<CMS_AvailablePO> GetAvailableCMSPOs()
        {
            List<CMS_AvailablePO> data = new List<CMS_AvailablePO>();
            try
            {
                string sqlCmdText;
                sqlCmdText = string.Concat("SELECT PONUM, Prod1 , Prod2 , Prod3 , isOrder , ZXPPONUM ",
                                     "FROM ZXPTruckSchedules.dbo.CMS_AvailablePO ORDER BY PONUM DESC");
               

                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    sqlConn.Open();
                    SqlDataReader sReader;
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.Text;
                        sReader = cmd.ExecuteReader();

                    }

                    while (sReader.Read())
                    {
                        CMS_AvailablePO pData = new CMS_AvailablePO();

                        
                        pData.PONUM = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("PONUM"));
                        pData.Prod1 = sReader["Prod1"].ToString();
                        pData.Prod2 = sReader["Prod2"].ToString();
                        pData.Prod3 = sReader["Prod3"].ToString();
                        pData.isOrder = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isOrder"));
                        pData.ZXPPONUM = sReader["ZXPPONUM"].ToString();
                        data.Add(pData);
                    }
                }
            }

            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetAvailableCMSPOs(). Details: " + ex.ToString();
                MessageLog alog = new MessageLog(MessageType.Exception, "GetAvailableCMSPOs Exception Message=" + strErr);
                logger.Error(alog.CreateAuditLogMessage());

                throw;
            }
            return data;



        }
        public List<TrailerGridData> GetTrailerGridData()
        {
            List<TrailerGridData> data = new List<TrailerGridData>();

            try
            {

                string sqlCmdText;
                sqlCmdText = string.Concat("SELECT MSID, ETA, Comments, LoadTypeShort, LoadTypeLong, PONumber, CustomerID, isDropTrailer ",
                                ", Shipper, DockSpotID, TruckType, isRejected, TrailerNumber, LocationShort, LocationLong ",
                                ", StatusID, StatusText, SpotDescription, isOpenInCMS, ProdCount, topProdID ",
                                ", ProductName_CMS, PONumber_ZXPOutbound, isUrgent, isManuallyClosed, ClosedBy ",
                                "FROM dbo.vw_TrailerGridData ",
                                "ORDER BY ETA, PoNumber"
                                );

                using (SqlConnection sqlConn = new SqlConnection(getConnectionStringFromSettings()))
                {
                    sqlConn.Open();
                    SqlDataReader sReader;
                    using (SqlCommand cmd = new SqlCommand(sqlCmdText, sqlConn))
                    {
                        cmd.CommandType = CommandType.Text;
                        sReader = cmd.ExecuteReader();

                    }

                    while (sReader.Read())
                    {
                        TrailerGridData tgData = new TrailerGridData();
                        tgData.MSID = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("MSID"));
                        tgData.ETA = (DateTime)DBHelper.getNullableDateTime(sReader, "ETA");
                        tgData.Comments = sReader["Comments"].ToString();
                        tgData.LoadTypeShort = sReader["LoadTypeShort"].ToString();
                        tgData.LoadTypeLong = sReader["LoadTypeLong"].ToString();
                        tgData.PONumber = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("PONumber"));
                        tgData.CustomerID = sReader["CustomerID"].ToString();
                        tgData.isDropTrailer = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isDropTrailer"));
                        tgData.Shipper = sReader["Shipper"].ToString();
                        tgData.DockSpotID = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("DockSpotID"));
                        tgData.TruckType = sReader["TruckType"].ToString();
                        tgData.isRejected = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isRejected"));
                        tgData.TrailerNumber = sReader["TrailerNumber"].ToString();
                        tgData.LocationShort = sReader["LocationShort"].ToString();
                        tgData.LocationLong = sReader["LocationLong"].ToString();
                        tgData.StatusID = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("StatusID"));
                        tgData.StatusText = sReader["StatusText"].ToString();
                        tgData.SpotDescription = sReader["SpotDescription"].ToString();
                        tgData.isOpenInCMS = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isOpenInCMS"));
                        tgData.ProdCount = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("ProdCount"));
                        tgData.topProdID = sReader["topProdID"].ToString();
                        tgData.ProductName_CMS = sReader["ProductName_CMS"].ToString();
                        tgData.PONumber_ZXPOutbound = sReader["PONumber_ZXPOutbound"].ToString();
                        tgData.isUrgent = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isUrgent"));
                        tgData.isManuallyClosed = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isManuallyClosed"));
                        tgData.ClosedBy = sReader["ClosedBy"].ToString();

                        data.Add(tgData);
                    }
                }


            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in DataProvider GetTrailerGridData(). Details: " + ex.ToString();
                MessageLog alog = new MessageLog(MessageType.Exception, "User called function GetTrailerGridData. Exception Message=" + strErr);
                logger.Error(alog.CreateAuditLogMessage());

                throw;
            }
            return data;
        }

        
        public List<DomainModels.CalendarEvents> GetDatesToDisableInSchedule()
        {
            List<DomainModels.CalendarEvents> disabledDates = new List<DomainModels.CalendarEvents>();

            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string qryGetUsers = "SELECT id, EventDate, Description, isDisabled FROM dbo.CalendarEvents";
                    using (SqlCommand command = new SqlCommand(qryGetUsers, con))
                    {

                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            int newID = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("id"));
                            DateTime newDate = (DateTime)DBHelper.getNullableDateTime(sReader, "EventDate");
                            String reason = sReader["Description"].ToString();
                            bool dateDisabled = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isDisabled"));

                            DomainModels.CalendarEvents eDate = new DomainModels.CalendarEvents(newID, newDate, reason, dateDisabled);
                            disabledDates.Add(eDate);
                        }
                    }
                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetDatesToDisableInSchedule(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, "GetDatesToDisableInSchedule Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;
                }
            }

            return disabledDates;
        }


        public IEnumerable<CMSProduct> GetProductCMS()
        {
            List<CMSProduct> products = new List<CMSProduct>();

            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string qryGetUsers = "SELECT ProductID_CMS, ProductName_CMS, DockSpotTimeslotDuration FROM dbo.ProductsCMS";
                    using (SqlCommand command = new SqlCommand(qryGetUsers, con))
                    {

                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            products.Add(CMSProduct.adaptToProductCMS(sReader));
                        }
                    }
                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetProductCMS(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, "GetProductCMS Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;
                }
            }

            return products;
        }
        public IEnumerable<CMSProduct> GetProductCMS(string product)
        {
            List<CMSProduct> products = new List<CMSProduct>();

            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string qryGetUsers = "SELECT ProductID_CMS, ProductName_CMS, DockSpotTimeslotDuration FROM dbo.ProductsCMS WHERE ProductID_CMS = @prod";
                    using (SqlCommand command = new SqlCommand(qryGetUsers, con))
                    {
                        command.Parameters.Add(new SqlParameter("@prod", product));
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            products.Add(CMSProduct.adaptToProductCMS(sReader));
                        }
                    }
                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetProductCMS(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, "GetProductCMS Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
            }

            return products;
        }
        
        public int GetRowCountForPO(int PO)
        {
            int rowCount = 0;
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = "SELECT COUNT(*) FROM dbo.MainSchedule MS WHERE PONumber = @PONUM AND MS.isHidden = 0";

                    rowCount = Convert.ToInt32(SqlHelper.ExecuteScalar(con, CommandType.Text, sqlCmdText, new SqlParameter("@PONUM", PO)));

                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetRowCountForPO(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, "GetRowCountForPO Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return rowCount;
            }
        }

        public List<DomainModels.Status> GetStatuses()
        {
            List<DomainModels.Status> StatusOptions = new List<DomainModels.Status>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = "SELECT StatusID, StatusText, StatusObjectID FROM dbo.Status";
                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            int id = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("StatusID"));
                            string text = sReader["StatusText"].ToString();
                            int statObjId = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("StatusObjectID"));
                            DomainModels.Status nStat = new DomainModels.Status(id, text, statObjId);
                            StatusOptions.Add(nStat);
                        }
                    }


                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetStatuses(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetStatuses Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return StatusOptions;
            }
        }

        public List<DomainModels.Status> GetStatusesFilteredByLocation(string locationShort)
        {
            List<DomainModels.Status> StatusOptions = new List<DomainModels.Status>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = string.Empty;

                    if (locationShort.CompareTo("NOS") == 0)
                    {
                        sqlCmdText = "SELECT S.StatusID, StatusText, StatusObjectID FROM dbo.Status S INNER JOIN dbo.LocationStatusRelation LSR ON LSR.StatusID = S.StatusID " +
                                            "WHERE LocationShort = @LOCATION AND S.StatusID <> 10 ORDER BY SortOrder"; //Filter out Departed option
                    }
                    else
                    {
                        sqlCmdText = "SELECT S.StatusID, StatusText, StatusObjectID FROM dbo.Status S INNER JOIN dbo.LocationStatusRelation LSR ON LSR.StatusID = S.StatusID WHERE LocationShort = @LOCATION ORDER BY SortOrder";
                    }

                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        command.Parameters.Add(new SqlParameter("@LOCATION", locationShort));
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            int id = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("StatusID"));
                            string text = sReader["StatusText"].ToString();
                            int? statObjId = DBHelper.GetValueOrDefault<int?>(sReader, sReader.GetOrdinal("StatusObjectID"));
                            DomainModels.Status nStat = new DomainModels.Status(id, text, statObjId);
                            StatusOptions.Add(nStat);
                        }
                    }


                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetStatuses(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetStatuses Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return StatusOptions;
            }
        }



        public List<DomainModels.Locations> GetLocations()
        {
            List<DomainModels.Locations> locations = new List<DomainModels.Locations>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = "SELECT LocationShort, LocationLong FROM dbo.Locations";
                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            string locShort = sReader["LocationShort"].ToString();
                            string locLong = sReader["LocationLong"].ToString();
                            DomainModels.Locations nLoc = new DomainModels.Locations(locShort, locLong);
                            locations.Add(nLoc);
                        }
                    }


                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetLocations(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetLocations Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return locations;
            }
        }

        public List<DomainModels.FileTypes> GetFileTypes()
        {
            List<DomainModels.FileTypes> fTypes = new List<DomainModels.FileTypes>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = "SELECT FileTypeID, FileType FROM dbo.FileTypes";
                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            int id = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("FileTypeID"));
                            string ftypename = sReader["FileType"].ToString();
                            DomainModels.FileTypes fType = new DomainModels.FileTypes(id, ftypename);
                            fTypes.Add(fType);
                        }
                    }


                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetFileTypes(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetFileTypes Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return fTypes;
            }
        }
        
        public List<DomainModels.TruckTypes> GetTruckTypes()
        {
            List<DomainModels.TruckTypes> TTypes = new List<DomainModels.TruckTypes>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = "SELECT TruckTypeShort, TruckTypeLong FROM dbo.TruckTypes ORDER BY TruckTypeLong";
                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            string shortname = sReader["TruckTypeShort"].ToString();
                            string longname = sReader["TruckTypeLong"].ToString();
                            DomainModels.TruckTypes ttype = new DomainModels.TruckTypes(shortname, longname);
                            TTypes.Add(ttype);
                        }
                    }
                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetTruckTypes(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetTruckTypes Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return TTypes;
            }
        }


        public List<DomainModels.UnitOfMeasure> GetUnitsOfMeasure()
        {
            List<DomainModels.UnitOfMeasure> uMeasures = new List<DomainModels.UnitOfMeasure>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = "SELECT UnitShort, UnitLong FROM dbo.UnitOfMeasure";
                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {
                            string shortname = sReader["UnitShort"].ToString();
                            string longname = sReader["UnitLong"].ToString();
                            DomainModels.UnitOfMeasure unit = new DomainModels.UnitOfMeasure(shortname, longname);
                            uMeasures.Add(unit);
                        }
                    }
                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetUnitsOfMeasure(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetUnitsOfMeasure Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return uMeasures;
            }
        }

        public List<DomainModels.MainScheduleFiles> GetMainScheduleFiles(int MSID)
        {
            List<DomainModels.MainScheduleFiles> msFiles = new List<DomainModels.MainScheduleFiles>();
            using (SqlConnection con = new SqlConnection(getConnectionStringFromSettings()))
            {
                try
                {
                    con.Open();
                    string sqlCmdText = string.Concat("SELECT FileID, MSID, MSF.FileTypeID, FileDescription, Filepath, FilenameNew, FilenameOld, MSF.isHidden FROM dbo.MainScheduleFiles MSF ", 
                                   "INNER JOIN dbo.FileTypes FT ON FT.FileTypeID = MSF.FileTypeID " ,
                                   "WHERE isHidden = 0 AND MSID = @PMSID");
                    using (SqlCommand command = new SqlCommand(sqlCmdText, con))
                    {
                        command.Parameters.Add(new SqlParameter("@PMSID", MSID));
                        SqlDataReader sReader = command.ExecuteReader();
                        while (sReader.Read())
                        {

                            int fid = DBHelper.GetValueOrDefault<int>(sReader, sReader.GetOrdinal("FileID"));
                            DomainModels.MainScheduleFiles msFile = new DomainModels.MainScheduleFiles(fid);
                            msFile.Msid = DBHelper.GetValueOrDefault<int?>(sReader, sReader.GetOrdinal("MSID"));
                            msFile.FileTypeId = DBHelper.GetValueOrDefault<int?>(sReader, sReader.GetOrdinal("FileTypeID"));
                            msFile.FileDescription = sReader["FileDescription"].ToString();
                            msFile.Filepath = sReader["Filepath"].ToString();
                            msFile.FilenameNew = sReader["FilenameNew"].ToString();
                            msFile.FilenameOld = sReader["FilenameOld"].ToString();
                            msFile.IsHidden = DBHelper.GetValueOrDefault<bool>(sReader, sReader.GetOrdinal("isHidden"));
                            msFiles.Add(msFile);
                        }
                    }
                }
                catch (Exception ex)
                {
                    string strErr = " Exception Error in DataProvider GetMainScheduleFiles(). Details: " + ex.ToString();
                    MessageLog alog = new MessageLog(MessageType.Exception, " GetMainScheduleFiles Exception Message=" + strErr);
                    logger.Error(alog.CreateAuditLogMessage());
                    throw;

                }
                return msFiles;
            }
        }


    }


}
