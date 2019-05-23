using Microsoft.ApplicationBlocks.Data;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Transactions;

namespace TransportationProject
{
    public class ChangeLog
    {
        protected static String sql_connStr;

        //Keep synced with database entries in table dbo.ChangeLogDataType
        public enum ChangeLogDataType
        {
            BIT,
            CHAR,
            DATE,
            DATETIME,
            FLOAT,
            INT,
            NVARCHAR,
            DECIMAL,
        }

        //Keep synced with database entries in table dbo.ChangeLogChangeType
        public enum ChangeLogChangeType
        {
            DELETE,
            INSERT,
            UPDATE,
        }

        public ChangeLogChangeType _ChangeType { get; private set; }
        public string _TableName { get; private set; }
        public string _ColumnName { get; private set; }
        public DateTime _Timestamp { get; private set; }
        public int _ChangedBy { get; private set; }
        public ChangeLogDataType _DataType { get; private set; }
        public string _Value_Old { get; private set; }
        public string _Value_New { get; private set; }
        public int? _EventID { get; private set; }
        public string _PK1_ColumnName { get; private set; }
        public string _PK1_Value { get; private set; }
        public string _PK2_ColumnName { get; private set; }
        public string _PK2_Value { get; private set; }
        public string _PK3_ColumnName { get; private set; }
        public string _PK3_Value { get; private set; }
        public bool _writeLogEvenIfNotNewValue { get; set; }
        public bool _setByUndo { get; set; }
        public bool _closeConnectionAfter { get; set; }

        public ChangeLog(ChangeLogChangeType changetype, string tablename, string columnname, DateTime timestamp, int changeby, ChangeLogDataType datatype,
           string valuenew, int ?eventid, string pk1colname, string pk1value, string pk2colname, string pk2value, string pk3colname, string pk3value) 
        {
            this._ChangeType = changetype;
            this._TableName = tablename;
            this._ColumnName = columnname;
            this._Timestamp = timestamp;
            this._ChangedBy = changeby;
            this._DataType = datatype;
            this._Value_Old = null;
            this._Value_New = valuenew;
            this._EventID = eventid;
            this._PK1_ColumnName = pk1colname;
            this._PK1_Value = pk1value;
            this._PK2_ColumnName = pk2colname;
            this._PK2_Value = pk2value;
            this._PK3_ColumnName = pk3colname;
            this._PK3_Value = pk3value;
            this._writeLogEvenIfNotNewValue = false;
            this._setByUndo = false;
            this._closeConnectionAfter = false;            
        }

        public ChangeLog(ChangeLogChangeType changetype, string tablename, string columnname, DateTime timestamp, int changeby, ChangeLogDataType datatype,
                   string valuenew, int ?eventid, string pk1colname, string pk1value, string pk2colname, string pk2value) 
            :this(changetype, tablename, columnname, timestamp, changeby, datatype,
                   valuenew, eventid, pk1colname, pk1value, pk2colname, pk2value, null, null) { }

        public ChangeLog(ChangeLogChangeType changetype, string tablename, string columnname, DateTime timestamp, int changeby, ChangeLogDataType datatype,
                    string valuenew, int? eventid, string pk1colname, string pk1value)
            : this(changetype, tablename, columnname, timestamp, changeby, datatype,
                     valuenew, eventid, pk1colname, pk1value, null, null, null, null) { }

        public void CreateChangeLogEntryIfChanged()
        {
            SqlConnection sqlConn = new SqlConnection(new TruckScheduleConfigurationKeysHelper().sql_connStr);
            this._closeConnectionAfter = true;
            CreateChangeLogEntryIfChanged(sqlConn, false, false);
        }

        public void CreateChangeLogEntryIfChanged(SqlConnection _sqlconn)
        {
            CreateChangeLogEntryIfChanged(_sqlconn, false, false);
        }

        public string checkDatatypeOfColumn(string tableName, string columnName, SqlConnection _sqlconn)
        {
            string sDatatype;

            try
            {
                using (var scope = new TransactionScope())
                {
                    string sqlCmdText;
                    sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

                    SqlParameter pTable = new SqlParameter("@TABLE", SqlDbType.NVarChar);
                    SqlParameter pColumn = new SqlParameter("@COLUMN", SqlDbType.NVarChar);

                    pTable.Value = tableName;
                    pColumn.Value = columnName;

                    sqlCmdText = "SELECT TOP 1 DATA_TYPE " +
                                 "FROM INFORMATION_SCHEMA.COLUMNS " +
                                "WHERE TABLE_NAME = @TABLE AND COLUMN_NAME = @COLUMN";
                    sDatatype = Convert.ToString(SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@TABLE", tableName),
                                                                                                                    new SqlParameter("@COLUMN", columnName)));

                    scope.Complete();
                }
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in ChangeLog checkDatatypeOfColumn(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                throw excep;

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in ChangeLog checkDatatypeOfColumn(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                throw ex;
            }
            finally
            {
            }
            return sDatatype; 
        }


        public void CreateChangeLogEntryIfChanged(SqlConnection _sqlconn, bool writeLog, bool setbyUndo)
        {
            bool rethrow = false;
            Exception ExToRethrow = new Exception();
            SqlCommand sqlCmd = new SqlCommand();
            SqlConnection sqlConn = _sqlconn;
             
            try
            {
                using (var scope = new TransactionScope())
                {

                    this._writeLogEvenIfNotNewValue = writeLog;
                    this._setByUndo = setbyUndo;
                    //string sqlCmdText;
                    //sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;
                    if (sqlConn.State != ConnectionState.Open)
                    {
                        sqlConn.Open();
                    }

                    sqlCmd.Connection = sqlConn;
                    SqlParameter paramChangeType = new SqlParameter("@CHANGETYPE", SqlDbType.NVarChar);
                    SqlParameter paramTableName = new SqlParameter("@TABLE", SqlDbType.NVarChar);
                    SqlParameter paramColumnName = new SqlParameter("@COLNAME", SqlDbType.NVarChar);
                    SqlParameter paramTimestamp = new SqlParameter("@TIME", SqlDbType.DateTime);
                    SqlParameter paramChangeBy = new SqlParameter("@CHANGEBY", SqlDbType.Int);
                    SqlParameter paramDataType = new SqlParameter("@DATA", SqlDbType.NVarChar);
                    SqlParameter paramValueOld = new SqlParameter("@OLDVAL", SqlDbType.NVarChar);
                    SqlParameter paramValueNew = new SqlParameter("@NEWVAL", SqlDbType.NVarChar);
                    SqlParameter paramEventID = new SqlParameter("@EID", SqlDbType.Int);
                    SqlParameter paramPK1ColName = new SqlParameter("@PK1COL", SqlDbType.NVarChar);
                    SqlParameter paramPK1Value = new SqlParameter("@PK1VAL", SqlDbType.NVarChar);
                    SqlParameter paramPK2ColName = new SqlParameter("@PK2COL", SqlDbType.NVarChar);
                    SqlParameter paramPK2Value = new SqlParameter("@PK2VAL", SqlDbType.NVarChar);
                    SqlParameter paramPK3ColName = new SqlParameter("@PK3COL", SqlDbType.NVarChar);
                    SqlParameter paramPK3Value = new SqlParameter("@PK3VAL", SqlDbType.NVarChar);
                    SqlParameter paramSetBYUndo = new SqlParameter("@UNDO", SqlDbType.Bit);

                    paramChangeType.Value = this._ChangeType;
                    paramTableName.Value = this._TableName;
                    paramColumnName.Value = this._ColumnName;
                    paramTimestamp.Value = this._Timestamp;
                    paramChangeBy.Value = this._ChangedBy;
                    paramDataType.Value = this._DataType;
                    paramValueNew.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(this._Value_New);
                    paramEventID.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(this._EventID);
                    paramPK1ColName.Value = this._PK1_ColumnName;
                    paramPK1Value.Value = this._PK1_Value;
                    paramPK2ColName.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK2_ColumnName);
                    paramPK2Value.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK2_Value);
                    paramPK3ColName.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK3_ColumnName);
                    paramPK3Value.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK3_Value);
                    paramSetBYUndo.Value = this._setByUndo;

                    sqlCmd.Parameters.Add(paramChangeType);
                    sqlCmd.Parameters.Add(paramTableName);
                    sqlCmd.Parameters.Add(paramColumnName);
                    sqlCmd.Parameters.Add(paramTimestamp);
                    sqlCmd.Parameters.Add(paramChangeBy);
                    sqlCmd.Parameters.Add(paramDataType);
                    sqlCmd.Parameters.Add(paramValueNew);
                    sqlCmd.Parameters.Add(paramEventID);
                    sqlCmd.Parameters.Add(paramPK1ColName);
                    sqlCmd.Parameters.Add(paramPK1Value);
                    sqlCmd.Parameters.Add(paramPK2ColName);
                    sqlCmd.Parameters.Add(paramPK2Value);
                    sqlCmd.Parameters.Add(paramPK3ColName);
                    sqlCmd.Parameters.Add(paramPK3Value);
                    sqlCmd.Parameters.Add(paramSetBYUndo);




                    // !!!!!!!!!Update version of change log. Will be for 2.0!!!!!!!!!!
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        
                    //object oldVal = new object();
                    //bool hasOldValUpdated = false;

                    //if (this._ChangeType == ChangeLog.ChangeLogChangeType.UPDATE)
                    //{

                    //    sqlCmdText = "SELECT " + this._ColumnName + " FROM " + this._TableName + " WHERE " + this._PK1_ColumnName + "= @PK1VAL";

                    //    if (!string.IsNullOrEmpty(this._PK2_ColumnName))
                    //    {
                    //        sqlCmdText = sqlCmdText + " AND " + this._PK2_ColumnName + "= @PK2VAL";
                    //    }
                    //    if (!string.IsNullOrEmpty(this._PK3_ColumnName))
                    //    {
                    //        sqlCmdText = sqlCmdText + " AND " + this._PK3_ColumnName + " = @PK3VAL";
                    //    }



                    //    if (string.IsNullOrEmpty(this._PK2_ColumnName) && string.IsNullOrEmpty(this._PK3_ColumnName))
                    //    {
                    //        oldVal = SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PK1VAL", this._PK1_Value));
                    //    }
                    //    else if (!string.IsNullOrEmpty(this._PK2_ColumnName) && string.IsNullOrEmpty(this._PK3_ColumnName))
                    //    {
                    //        oldVal = SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PK1VAL", this._PK1_Value)
                    //                                                        , new SqlParameter("@PK2VAL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK2_Value)));
                    //    }
                    //    else if (!string.IsNullOrEmpty(this._PK2_ColumnName) && !string.IsNullOrEmpty(this._PK3_ColumnName))
                    //    {
                    //        oldVal = SqlHelper.ExecuteScalar(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@PK1VAL", this._PK1_Value)
                    //                                                        , new SqlParameter("@PK2VAL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK2_Value))
                    //                                                        , new SqlParameter("@PK3VAL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK3_Value)));
                    //    }
                    //}

                    //var needsNewLog = false;

                    //sqlCmdText = "";

                    //if (this._ChangeType == ChangeLogChangeType.UPDATE)
                    //{
                    //    //Check if values are different. If different, create log
                    //    //if date type, parse before compare
                    //    if (this._DataType == ChangeLog.ChangeLogDataType.DATE || this._DataType == ChangeLog.ChangeLogDataType.DATETIME)
                    //    {

                    //        if (DBNull.Value.Equals(oldVal))
                    //        {
                    //            needsNewLog = true;
                    //        }
                    //        else
                    //        {
                    //            DateTime oldDate = DateTime.Parse(oldVal.ToString());
                    //            DateTime newDate = DateTime.Parse(this._Value_New);
                    //            if (oldDate.CompareTo(newDate) != 0)
                    //            {
                    //                needsNewLog = true;
                    //            }
                    //        }
                    //    }
                    //    else if (!string.Equals(oldVal.ToString(), this._Value_New)) //all other non date/datetime type
                    //    {
                    //        needsNewLog = true;
                    //    }

                    //}
                    //else
                    //{
                    //    needsNewLog = true;
                    //}

                    //if (needsNewLog || this._writeLogEvenIfNotNewValue)
                    //{
                    //    sqlCmdText = "INSERT INTO dbo.ChangeLog VALUES (@CHANGETYPE, @TABLE, @COLNAME, @TIME, @CHANGEBY, @DATA, @OLDVAL, @NEWVAL, @EID, @PK1COL, @PK1VAL, @PK2COL, @PK2VAL, @PK3COL, @PK3VAL, @UNDO)";
                    //    SqlHelper.ExecuteNonQuery(sql_connStr, CommandType.Text, sqlCmdText, new SqlParameter("@CHANGETYPE", this._ChangeType),
                    //                                                new SqlParameter("@TABLE", this._TableName),
                    //                                                new SqlParameter("@COLNAME", this._ColumnName),
                    //                                                new SqlParameter("@TIME", this._Timestamp),
                    //                                                new SqlParameter("@CHANGEBY", this._ChangedBy),
                    //                                                new SqlParameter("@DATA", this._DataType),
                    //                                                new SqlParameter("@OLDVAL", TransportHelperFunctions.convertStringEmptyToDBNULL(oldVal)),
                    //                                                new SqlParameter("@NEWVAL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._Value_New)),
                    //                                                new SqlParameter("@EID", TransportHelperFunctions.convertStringEmptyToDBNULL(this._EventID)),
                    //                                                new SqlParameter("@PK1COL", this._PK1_ColumnName),
                    //                                                new SqlParameter("@PK1VAL", this._PK1_Value),
                    //                                                new SqlParameter("@PK2COL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK2_ColumnName)),
                    //                                                new SqlParameter("@PK2VAL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK2_Value)),
                    //                                                new SqlParameter("@PK3COL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK3_ColumnName)),
                    //                                                new SqlParameter("@PK3VAL", TransportHelperFunctions.convertStringEmptyToDBNULL(this._PK3_Value)),
                    //                                                new SqlParameter("@UNDO", this._setByUndo));

                    //}


                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


                    //get old value by querying
                    //create query using inputted tablename, columnname and primary cols and pkeys
                    if (this._ChangeType == ChangeLog.ChangeLogChangeType.UPDATE)
                    {
                        sqlCmd.CommandText = "SELECT " + this._ColumnName + " FROM " + this._TableName + " WHERE " + this._PK1_ColumnName + "= @PK1VAL";
                        if (!string.IsNullOrEmpty(this._PK2_ColumnName))
                        {
                            sqlCmd.CommandText = sqlCmd.CommandText + " AND " + this._PK2_ColumnName + "= @PK2VAL";
                        }
                        if (!string.IsNullOrEmpty(this._PK3_ColumnName))
                        {
                            sqlCmd.CommandText = sqlCmd.CommandText + " AND " + this._PK3_ColumnName + " = @PK3VAL";
                        }
                        object oldVal = sqlCmd.ExecuteScalar();
                        paramValueOld.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(oldVal);
                        sqlCmd.Parameters.Add(paramValueOld);

                    }
                    else
                    {

                        paramValueOld.Value = TransportHelperFunctions.convertStringEmptyToDBNULL(string.Empty); ;
                        sqlCmd.Parameters.Add(paramValueOld);
                    }

                    var needsNewLog = false;
                    //check if new log needed

                    if (this._ChangeType == ChangeLogChangeType.UPDATE)
                    {
                        //Check if values are different. If different, create log
                        //if date type, parse before compare
                        if (this._DataType == ChangeLog.ChangeLogDataType.DATE || this._DataType == ChangeLog.ChangeLogDataType.DATETIME)
                        {

                            if (DBNull.Value.Equals(paramValueOld.Value))
                            {
                                needsNewLog = true;
                            }
                            else
                            {
                                DateTime oldDate = DateTime.Parse(paramValueOld.Value.ToString());
                                DateTime newDate = DateTime.Parse(this._Value_New);
                                if (oldDate.CompareTo(newDate) != 0)
                                {
                                    needsNewLog = true;
                                }
                            }
                        }
                        else if (!string.Equals(paramValueOld.Value.ToString(), this._Value_New)) //all other non date/datetime type
                        {
                            needsNewLog = true;
                        }

                    }
                    else
                    {
                        needsNewLog = true;
                    }


                    if (needsNewLog || this._writeLogEvenIfNotNewValue)
                    {
                        sqlCmd.CommandText = "INSERT INTO dbo.ChangeLog VALUES (@CHANGETYPE, @TABLE, @COLNAME, @TIME, @CHANGEBY, @DATA, @OLDVAL, @NEWVAL, @EID, @PK1COL, @PK1VAL, @PK2COL, @PK2VAL, @PK3COL, @PK3VAL, @UNDO)";
                        sqlCmd.ExecuteNonQuery();

                    }
                    scope.Complete();
                }
                        
            }
            catch (SqlException excep)
            {
                string strErr = " SQLException Error in ChangeLog CreateChangeLogEntry(). Details: " + excep.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 2;
                ErrorLogging.sendtoErrorPage(2);
                rethrow = true;
                ExToRethrow = excep;

            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in ChangeLog CreateChangeLogEntry(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
                rethrow = true;
                ExToRethrow = ex;
            }
            finally
            {
                if (rethrow) {
                    throw ExToRethrow;
                }
                if (this._closeConnectionAfter && sqlConn != null && sqlConn.State != ConnectionState.Closed)
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                }
            }
        }
    }
}