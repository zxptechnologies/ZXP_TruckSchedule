using System;
using System.Data.SqlClient;

namespace TransportationProjectDataLayer
{
    public static class DBHelper
    {

        public static DateTime? getNullableDateTime(this SqlDataReader sReader, string colName)
        {
            var col = sReader.GetOrdinal(colName);
            return sReader.IsDBNull(col) ?
                        (DateTime?)null :
                        (DateTime?)sReader.GetDateTime(col);
        }




        public static T GetValueOrDefault<T>(SqlDataReader dataReader, int columnIndex)
        {
            int index = Convert.ToInt32(columnIndex);

            return !dataReader.IsDBNull(index) ? (T)dataReader.GetValue(index) : default(T);
        }


    }
}
