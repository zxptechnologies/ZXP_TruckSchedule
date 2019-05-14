using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace TransportationProjectDataLayer
{
    public class TruckScheduleGridData
    {

        public TruckScheduleGridData()
        {
            this.TruckScheduleGrid = new List<TruckScheduleGridEntry>();
        }
    
        public List<TruckScheduleGridEntry> TruckScheduleGrid;
    }

    public class TruckScheduleGridEntry
    {
        //SELECT TDST.SpotID, TDST.FromTime, TDST.ToTime, TDST.isOpen, ST.SpotTypeShort, TDS.isDisabled, TDST.DayOfWeekID,
        //0 AS isAppointment, TDS.HoursInTimeBlock, NULL AS PONumber " +
        //"FROM dbo.TruckDockSpotTimeslots TDST " +
        //"INNER JOIN dbo.TruckDockSpots TDS ON TDST.SpotID = TDS.SpotID " +
        //"INNER JOIN dbo.SpotType ST ON TDS.SpotType = ST.SpotTypeShort " +

        public TruckScheduleGridEntry()
        {
        }

        public int SpotID { get; set; }
        public string SpotDescription { get; set; }
        public string SpotType { get; set; }
        public string FromTime { get; set; }
        public string ToTime { get; set; }
        public bool? isOpen { get; set; }
        public string SpotTypeShort { get; set; }
        public string DayOfWeekID { get; set; }
        public bool isAppointment { get; set; }
        public float HoursInTimeBlock { get; set; }
        public int PONumber { get; set; }

        public static TruckScheduleGridEntry adaptToTruckScheduleGridEntry(IDataRecord record) {

            TruckScheduleGridEntry tsGridEntry = new TruckScheduleGridEntry();
            
            tsGridEntry.SpotID = (int)record["SpotID"];
            tsGridEntry.SpotDescription = record["SpotDescription"].ToString();
            tsGridEntry.SpotType = record["SpotType"].ToString();
            tsGridEntry.FromTime = record["FromTime"].ToString();
            tsGridEntry.ToTime = record["ToTime"].ToString();
            tsGridEntry.isOpen = (bool?)record["isOpen"];
            tsGridEntry.SpotTypeShort = record["SpotTypeShort"].ToString();
            tsGridEntry.DayOfWeekID = record["DayOfWeekID"].ToString();
            tsGridEntry.isAppointment = (bool)record["isAppointment"];
            tsGridEntry.HoursInTimeBlock = (float)record["HoursInTimeBlock"];

            return tsGridEntry;
        }



    }
}
