using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

namespace TransportationProject
{
    public class ScheduledTruck
    {
        public int MSID { get; private set; }
        public List<InspectionList> currentInspectionLists; 


        public ScheduledTruck() {
           
        
        }
        public void setMSID(int MSID)
        {
            this.MSID = MSID; 
        }


        public bool createNewMSInspectionList(int InspectionListID)
        {
            bool didSucceed = false;
            try
            {
                throw new Exception("Method not implemented");
            }
            catch (Exception ex)
            {
                ex.ToString();
            }

            return didSucceed;
        }
        public bool deleteMSInspectionListID()
        {
            return this.hideMSInspectionList();
        }
        private bool hideMSInspectionList()
        {
            bool didSucceed = false;
            try
            {
                throw new Exception("Method not implemented");
            }
            catch (Exception ex)
            {
                ex.ToString();
            }

            return didSucceed;
        }



         public List<InspectionList> getMainscheduleInspectionLists()
        {
            List<InspectionList> inspList = new List<InspectionList>();
            SQLDataConnectionHelper sqlConnHelper = new SQLDataConnectionHelper();
            try
            {
                sqlConnHelper.setSqlConnectionStringUsingConfiguration();
                sqlConnHelper.openConnection();
                SqlCommand sqlCmd = new SqlCommand("sp_truckschedapp_getMainScheduleInspectionListsForMSID", sqlConnHelper.getConnection());
                sqlCmd.CommandType = CommandType.StoredProcedure;

                SqlParameter pHidden = new SqlParameter("@pIsHidden", SqlDbType.Bit);
                SqlParameter pMSID = new SqlParameter("@pMSID", SqlDbType.Int);
                pHidden.Value = 0;
                sqlCmd.Parameters.Add(pHidden);

                DataSet dsMSILists = new DataSet();
                DataTable tblMSILists = new DataTable();
                System.Data.SqlClient.SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                dsMSILists.Tables.Add(tblMSILists);
                dsMSILists.Load(sqlReader, LoadOption.OverwriteChanges, tblMSILists);
                //populate return object
                foreach (System.Data.DataRow row in dsMSILists.Tables[0].Rows)
                {
                    //InspectionList nIL = new InspectionList();
                    //nIL.setMSInspectionListID(Convert.ToInt32(row["MSInspectionListID"]));
                    //nIL.setMSID(Convert.ToInt32(row["MSID"]));
                    //nIL.setInspectionListID(Convert.ToInt32(row["InspectionListID"]));
                    //nIL.setInspectionListName(row["InspectionListName"].ToString());
                    //nIL.setProductID_CMS(row["ProductID_CMS"].ToString());
                    //nIL.setRunNumber(Convert.ToInt32(row["RunNumber"]));

                    //inspList.Add(nIL);
                }

            }

            catch (Exception ex)
            {
                string strErr = " Exception Error in ScheduledTruck getMainscheduleInspectionLists(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                throw ex;
            }


            return inspList;
        }
    }
}