using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;

namespace TransportationProject
{
    public class TruckLogHelperFunctions     
    {

        public static List<object[]> logListConnection(string sql_connStr, List<object[]> data)
        {
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    //string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    sqlCmdText = "SELECT MS.MSID, MS.PONumber, MS.TrailerNumber " +
                                        "FROM dbo.MainSchedule AS MS " +
                                        "WHERE (MS.isHidden = 'false' AND MS.isOpenInCMS = 'true')";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText);

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TruckLogHelperFunction logListConnection(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TruckLogHelperFunction logListConnection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }
            finally
            {
            }
            return data;
        }

        public static List<object[]> logByMSIDConnection(string sql_connStr, int MSID, List<object[]> data)
        {
            DataSet dataSet = new DataSet();

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sqlCmdText = "SELECT TOP 10 MSE.TimeStamp, ET.EventType, USRS.FirstName " +
                                            "FROM dbo.MainScheduleEvents AS MSE " +
                                            "INNER JOIN dbo.Users as USRS ON USRS.UserID = MSE.UserId " +
                                            "INNER JOIN dbo.EventTypes as ET ON ET.EventTypeID = MSE.EventTypeID " +
                                            "WHERE MSE.MSID = @MSID " +
                                            "ORDER BY MSE.TimeStamp DESC";
                    dataSet = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@MSID", MSID));

                    //populate return object
                    foreach (System.Data.DataRow row in dataSet.Tables[0].Rows)
                    {
                        data.Add(row.ItemArray);
                    }
                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in TruckLogHelperFunction logByMSIDConnection(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw excep;
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TruckLogHelperFunction logByMSIDConnection(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }
            finally
            {
            }
            return data;
        }


    }
}