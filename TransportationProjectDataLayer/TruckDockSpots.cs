using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace TransportationProjectDataLayer
{
    public class TruckDockSpots
    {
        public TruckDockSpots()
        {
        }

        public int SpotID { get; set; }
        public string SpotDescription { get; set; }
        public string SpotType { get; set; }
        public float HoursInTimeBlock { get; set; }
        public bool isDisabled { get; set; }


        public static TruckDockSpots adaptToTruckDockSpot(IDataRecord record)
        {
            
            TruckDockSpots spot = new TruckDockSpots();
            
                spot.SpotID = (int) record["SpotID"];
                spot.SpotDescription = record["SpotDescription"].ToString();
                spot.SpotType = record["SpotType"].ToString();
                spot.HoursInTimeBlock = (float) record["HoursInTimeBlock"];
                spot.isDisabled = (bool) record["isDisabled"];
            
            return spot;
        }
    }
}
