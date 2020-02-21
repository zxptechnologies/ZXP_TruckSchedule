using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    public class TankStrapping
    {
        public TankStrapping()
        {
            TankStrapID = 0;
        }
        public TankStrapping( int id)
        {
            TankStrapID = id;
        }

        public TankStrapping(int id, bool isbeforestrap)
        {
            TankStrapID = id;
            isBefore = isbeforestrap;
        }
        public int TankStrapID { get; private set; }
        public bool isBefore { get; private set; }
        public double? TemperatureF { get; set; }
        public int? Feet { get; set; }
        public int? Inches { get; set; }
        public double? GalFromFtandIn { get; set; }
        public string Fraction { get; set; }
        public double? GalFromFraction { get; set; }
        public string Conv { get; set; }
        public string XGAL { get; set; }

    }
}
