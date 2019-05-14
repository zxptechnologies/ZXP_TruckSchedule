using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace TransportationProjectDataLayer
{
    public class TruckDockSpotTimeslots
    {
        public TruckDockSpotTimeslots()
        { }

        public int spotID { get; set; }
        public string DayOfWeekID { get; set; }
        public string FromTime { get; set; }
        public string ToTime { get; set; }
        public bool? isOpen { get; set; }

        public static TruckDockSpotTimeslots adaptToTruckDockSpotTimeslot(IDataRecord record)
        {
            TruckDockSpotTimeslots tdsTimeslot = new TruckDockSpotTimeslots();
            tdsTimeslot.spotID = (int)record["SpotID"];
            tdsTimeslot.DayOfWeekID = record["DayOfWeekID"].ToString();
            tdsTimeslot.FromTime = record["FromTime"].ToString();
            tdsTimeslot.ToTime = record["ToTime"].ToString();
            tdsTimeslot.isOpen = (bool?)record["isOpen"];

            return tdsTimeslot;
        }

    }
}
