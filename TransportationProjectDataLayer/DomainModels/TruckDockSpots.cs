using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class vm_dd_TruckDockSpots
    {
        public vm_dd_TruckDockSpots()
        { }

        public vm_dd_TruckDockSpots(int id)
        {
            SpotId = id;
        }

        public vm_dd_TruckDockSpots(int id, string desc, string sType, double blockHours, bool isdisabled)
        {
            SpotId = id;
            SpotDescription = desc;
            SpotType = sType;
            HoursInTimeBlock = blockHours;
            IsDisabled = isdisabled;
        }

        public int SpotId { get; private set; }
        public string SpotDescription { get; set; }
        public string SpotType { get; set; }
        public double HoursInTimeBlock { get; set; }
        public bool IsDisabled { get; set; }

    }
}
