using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data.SqlTypes;

namespace TransportationProject
{
    public static class DBReaderHelper
    {

        public static DateTime? GetNullableDateTime(this SqlDataReader sReader, string colName)
        {
            var col = sReader.GetOrdinal(colName);
            return sReader.IsDBNull(col) ?
                        (DateTime?)null :
                        (DateTime?)sReader.GetDateTime(col);
        }

     


        public static T Def<T>(this SqlDataReader r, string colName)
        {
            var t = r.GetSqlValue(r.GetOrdinal(colName));
            if (t == DBNull.Value) return default(T);
            T someDefault = default(T);
            T someOtherVal = (T)t;

            return ((INullable)t).IsNull ? default(T) : (T)t;
        }


        public static T GetValueOrDefault<T>(this SqlDataReader r, string colName)
        {
            int ord = r.GetOrdinal(colName);
            //object val = r.GetSqlValue(ord);
            try
            {
                // if (!(null == val || val is DBNull))
                if (!r.IsDBNull(ord))
                {
                    return (r.GetFieldValue<T>(r.GetOrdinal(colName)));
                }
            }
            catch (Exception ex)
            {
                ex.ToString();

            }
            
            return default(T);
        }

        public static T? Val<T>(this SqlDataReader r, string colName) where T : struct
        {
            var t = r.GetSqlValue(r.GetOrdinal(colName));
            if (t == DBNull.Value) return null;
            return ((INullable)t).IsNull ? (T?)null : (T)t;
        }

        public static T Ref<T>(this SqlDataReader r, string colName) where T : class
        {
            var t = r.GetSqlValue(r.GetOrdinal(colName));
            if (t == DBNull.Value) return null;
            return ((INullable)t).IsNull ? null : (T)t;


        }
    }
}